"""Create the original Train Miner low-poly model library.

Run with:
  blender --background --python Assets/Blender/build_asset_library.py

The exported FBX files are grouped by model and use an origin at the bottom
centre so Roblox can clone and position them on a tile grid.
"""

import bpy
import math
import os
import random
from mathutils import Vector

random.seed(23)
ROOT = os.path.dirname(os.path.abspath(__file__))
EXPORT_DIR = os.path.join(ROOT, "fbx")
PREVIEW_PATH = os.path.join(ROOT, "train_miner_asset_preview.png")
BLEND_PATH = os.path.join(ROOT, "train_miner_asset_library.blend")
os.makedirs(EXPORT_DIR, exist_ok=True)

bpy.ops.object.select_all(action="SELECT")
bpy.ops.object.delete(use_global=False)
for collection in list(bpy.data.collections):
    if collection.name != "Collection":
        bpy.data.collections.remove(collection)

MAT = {}

def material(name, color, roughness=0.78, metallic=0.0, emission=0.0):
    if name in MAT:
        return MAT[name]
    m = bpy.data.materials.new(name)
    m.diffuse_color = (*color, 1.0)
    m.use_nodes = True
    p = m.node_tree.nodes.get("Principled BSDF")
    p.inputs["Base Color"].default_value = (*color, 1.0)
    p.inputs["Roughness"].default_value = roughness
    p.inputs["Metallic"].default_value = metallic
    if emission:
        p.inputs["Emission Color"].default_value = (*color, 1.0)
        p.inputs["Emission Strength"].default_value = emission
    MAT[name] = m
    return m

M = {
    "grass": material("Grass | fresh clover", (0.18, 0.73, 0.29)),
    "grass2": material("Grass | lime tips", (0.32, 0.86, 0.30)),
    "grassDark": material("Grass | forest", (0.06, 0.42, 0.19)),
    "soil": material("Soil | warm cocoa", (0.31, 0.17, 0.10)),
    "soil2": material("Soil | cut edge", (0.47, 0.27, 0.13)),
    "wood": material("Wood | honey pine", (0.59, 0.31, 0.12)),
    "wood2": material("Wood | pale cut", (0.88, 0.62, 0.29)),
    "woodDark": material("Wood | deep grain", (0.28, 0.12, 0.07)),
    "leaf1": material("Foliage | emerald", (0.06, 0.48, 0.22)),
    "leaf2": material("Foliage | spring", (0.19, 0.72, 0.27)),
    "leaf3": material("Foliage | bright tips", (0.39, 0.87, 0.29)),
    "leafSparse": material("Foliage | sparse", (0.35, 0.73, 0.28)),
    "stone": material("Stone | slate", (0.28, 0.36, 0.43)),
    "stoneLight": material("Stone | sunlit face", (0.48, 0.56, 0.60)),
    "stoneDark": material("Stone | shadow face", (0.18, 0.24, 0.30)),
    "ore": material("Ore | copper", (0.92, 0.38, 0.12), metallic=0.22),
    "crystal": material("Crystal | lagoon", (0.05, 0.76, 0.92), roughness=0.26, metallic=0.1, emission=0.12),
    "crystal2": material("Crystal | ice", (0.40, 0.91, 1.0), roughness=0.24, emission=0.08),
    "crystalDark": material("Crystal | deep blue", (0.08, 0.36, 0.86), roughness=0.30, metallic=0.1),
    "teal": material("Paint | railway teal", (0.02, 0.54, 0.61), roughness=0.38, metallic=0.08),
    "tealLight": material("Paint | seafoam", (0.20, 0.83, 0.78), roughness=0.4),
    "coral": material("Paint | candy coral", (0.95, 0.20, 0.16), roughness=0.4),
    "cream": material("Paint | warm cream", (1.0, 0.86, 0.56), roughness=0.5),
    "gold": material("Metal | polished brass", (1.0, 0.61, 0.10), roughness=0.30, metallic=0.62),
    "iron": material("Metal | blue iron", (0.17, 0.23, 0.31), roughness=0.34, metallic=0.62),
    "rubber": material("Wheels | charcoal", (0.07, 0.09, 0.12), roughness=0.8),
    "glass": material("Glass | sky blue", (0.19, 0.77, 0.96), roughness=0.2, metallic=0.05, emission=0.06),
    "red": material("Signal | ruby", (0.97, 0.09, 0.13), roughness=0.35, emission=0.04),
    "purple": material("Paint | berry violet", (0.42, 0.18, 0.66), roughness=0.42),
    "pink": material("Paint | rose", (1.0, 0.32, 0.49), roughness=0.4),
    "white": material("Paint | porcelain", (0.94, 0.96, 0.88), roughness=0.52),
}

ASSETS = {}
CURRENT = None

def asset(name):
    global CURRENT
    c = bpy.data.collections.new(name)
    bpy.context.scene.collection.children.link(c)
    ASSETS[name] = c
    CURRENT = c
    return c

def own(obj, name, mat=None, bevel=0.0):
    for c in list(obj.users_collection):
        c.objects.unlink(obj)
    CURRENT.objects.link(obj)
    obj.name = name
    if mat:
        obj.data.materials.clear()
        obj.data.materials.append(mat)
    if bevel and obj.type == "MESH":
        mod = obj.modifiers.new("Soft toy edges", "BEVEL")
        mod.width = bevel
        mod.segments = 2
        mod.limit_method = "ANGLE"
        mod.harden_normals = True
        try:
            bpy.context.view_layer.objects.active = obj
            bpy.ops.object.modifier_apply(modifier=mod.name)
        except Exception:
            pass
    if obj.type == "MESH":
        for poly in obj.data.polygons:
            poly.use_smooth = False
    obj["TrainMinerAsset"] = CURRENT.name
    return obj

def cube(name, loc, scale, mat, bevel=0.12):
    bpy.ops.mesh.primitive_cube_add(size=1, location=loc)
    o = bpy.context.object
    o.dimensions = scale
    bpy.ops.object.transform_apply(location=False, rotation=False, scale=True)
    return own(o, name, mat, min(bevel, min(scale) * 0.24))

def cylinder(name, loc, radius, depth, mat, vertices=12, rotation=(0, 0, 0), bevel=0.05):
    bpy.ops.mesh.primitive_cylinder_add(vertices=vertices, radius=radius, depth=depth, location=loc, rotation=rotation)
    return own(bpy.context.object, name, mat, bevel)

def ico(name, loc, scale, mat, subdivisions=2, jitter=0.0):
    bpy.ops.mesh.primitive_ico_sphere_add(subdivisions=subdivisions, radius=1, location=loc)
    o = bpy.context.object
    o.scale = scale
    if jitter:
        for v in o.data.vertices:
            f = random.uniform(1.0 - jitter, 1.0 + jitter)
            v.co *= f
    bpy.ops.object.transform_apply(location=False, rotation=False, scale=True)
    return own(o, name, mat, 0.0)

def cone(name, loc, radius_bottom, radius_top, depth, mat, vertices=9):
    bpy.ops.mesh.primitive_cone_add(vertices=vertices, radius1=radius_bottom, radius2=radius_top, depth=depth, location=loc)
    return own(bpy.context.object, name, mat, 0.045)

def beam(name, a, b, width, mat, depth=None):
    a, b = Vector(a), Vector(b)
    mid = (a + b) * 0.5
    length = (b - a).length
    o = cube(name, mid, (width, depth or width, length), mat, width * 0.18)
    o.rotation_euler = (b - a).to_track_quat("Z", "Y").to_euler()
    return o

def custom_mesh(name, verts, faces, mat, material_by_face=None):
    me = bpy.data.meshes.new(name + " mesh")
    me.from_pydata(verts, [], faces)
    me.materials.append(mat)
    if material_by_face:
        for m in material_by_face:
            if all(existing.name != m.name for existing in me.materials):
                me.materials.append(m)
        for poly, index in zip(me.polygons, material_by_face):
            poly.material_index = next(i for i, existing in enumerate(me.materials) if existing.name == index.name)
    me.update()
    o = bpy.data.objects.new(name, me)
    CURRENT.objects.link(o)
    return own(o, name)

def roof_gable(name, width, depth, eave_z, ridge_z, mats):
    x = width * 0.5
    y = depth * 0.5
    verts = [(-x,-y,eave_z),(x,-y,eave_z),(0,-y,ridge_z),
             (-x,y,eave_z),(x,y,eave_z),(0,y,ridge_z)]
    faces = [(0,1,2),(3,5,4),(0,2,5,3),(2,1,4,5),(0,3,4,1)]
    return custom_mesh(name, verts, faces, mats[0], [mats[0],mats[1],mats[1],mats[0],mats[1]])

def text_mesh(body, name, loc, size, mat, rotation=(math.pi/2,0,0)):
    bpy.ops.object.text_add(location=loc, rotation=rotation)
    obj = bpy.context.object
    obj.data.body = body
    obj.data.size = size
    obj.data.extrude = 0.035
    obj.data.bevel_depth = 0.012
    obj.data.align_x = "CENTER"
    obj.data.align_y = "CENTER"
    bpy.ops.object.convert(target="MESH")
    return own(bpy.context.object, name, mat)

def tree_model(name, stage):
    asset(name)
    if stage <= 2:
        trunk_h = [7.2,6.9,6.8][stage]
        cylinder("Warm sculpted trunk", (0,0,trunk_h/2), 0.62 if stage < 2 else 0.68, trunk_h, M["wood"], 10, bevel=0.08)
        for side in (-1,1):
            beam("Branch", (0,0,4.4), (side*1.8,-0.15,5.8), 0.45, M["wood"])
    if stage == 0:
        for i,(z,r,d,mat) in enumerate([(2.0,3.0,3.4,"leaf1"),(4.1,2.55,3.6,"leaf2"),(6.0,1.9,3.25,"leaf1"),(7.5,1.25,2.8,"leaf3")]):
            cone("Layered pine crown %02d" % i, (0,0,z+d*0.42), r, 0.2, d, M[mat], 10)
        for x,y,z in [(-2.0,-1.3,2.4),(2.0,-0.9,3.8),(-1.4,1.3,5.2),(1.2,1.1,6.1)]:
            ico("Rounded needle tuft", (x,y,z), (0.74,0.66,0.65), M["leaf3"], 1)
    elif stage == 1:
        for i,(x,y,z,r) in enumerate([(-1.25,-0.2,3.0,1.25),(1.2,0.1,4.9,1.05),(-0.7,0.5,6.1,0.8)]):
            ico("Remaining foliage %02d" % i, (x,y,z), (r,r*0.82,r*0.78), M["leafSparse"], 2)
    elif stage == 2:
        for side in (-1,1):
            beam("Bare fork", (0,0,4.7), (side*2.0,0,6.1), 0.34, M["wood2"])
        beam("Top snapped branch", (0,0,5.2), (0.8,0,6.4), 0.31, M["wood"])
    elif stage == 3:
        cylinder("Wide cut stump", (0,0,1.1), 1.18, 2.2, M["wood"], 12, bevel=0.13)
        cylinder("Fresh pale cut", (0,0,2.19), 1.01, 0.12, M["wood2"], 12, bevel=0.02)
        cylinder("Heartwood ring", (0,0,2.27), 0.43, 0.035, M["wood"], 12, bevel=0)
    else:
        cylinder("Tiny final stump", (0,0,0.47), 0.86, 0.94, M["wood"], 12, bevel=0.1)
        cylinder("Pale cut face", (0,0,0.95), 0.76, 0.1, M["wood2"], 12, bevel=0)
    return CURRENT

def rock_model(name, stage):
    asset(name)
    if stage == 0:
        ico("Main blue slate boulder", (0,0,2.0), (3.0,2.65,2.6), M["stone"], 2, 0.18)
        ico("Pale rear shoulder", (-1.35,0.7,2.5), (1.5,1.7,1.5), M["stoneLight"], 1, 0.1)
        ico("Dark lower lobe", (1.4,-0.1,1.1), (1.85,2.1,1.1), M["stoneDark"], 1, 0.08)
        for i,(x,z) in enumerate([(-1.4,2.6),(0.8,3.1),(1.9,1.7)]):
            ico("Copper ore fleck %d"%i, (x,-2.0,z), (0.58,0.18,0.4), M["ore"], 1)
    elif stage == 1:
        ico("Cracked boulder", (0,0,1.65), (2.5,2.3,2.05), M["stone"], 2, 0.16)
        for i,(x,z) in enumerate([(-1.1,2.2),(0.8,2.7)]):
            ico("Exposed copper vein %d"%i, (x,-1.84,z), (0.6,0.16,0.35), M["ore"], 1)
        beam("Deep fracture", (-0.45,-2.0,1.1), (0.35,-2.0,2.6), 0.12, M["stoneDark"])
    else:
        for i,(x,y,z,r) in enumerate([(-1.5,0.1,0.7,0.8),(0.3,0.4,0.5,0.9),(1.5,-0.2,0.45,0.65)]):
            ico("Loose rubble %d"%i, (x,y,z), (r,r*0.8,r*0.65), M["stoneLight"] if i==1 else M["stone"], 1, 0.1)
    return CURRENT

def crystal_mesh(name, loc, radius, height, mat):
    x,y,z = loc
    verts=[]
    ring_levels=[(0.0,0.82),(height*0.18,1.0),(height*0.74,0.84)]
    sides=6
    for level, mult in ring_levels:
        for i in range(sides):
            ang=2*math.pi*i/sides + 0.12
            verts.append((x+math.cos(ang)*radius*mult,y+math.sin(ang)*radius*mult,z+level))
    tip=len(verts)
    verts.append((x+0.07*radius,y-0.05*radius,z+height))
    faces=[]
    faces.append(tuple(range(sides-1,-1,-1)))
    for ring in range(len(ring_levels)-1):
        a=ring*sides
        b=(ring+1)*sides
        for i in range(sides):
            ni=(i+1)%sides
            faces.append((a+i,a+ni,b+ni,b+i))
    base=(len(ring_levels)-1)*sides
    for i in range(sides):
        faces.append((base+i,base+(i+1)%sides,tip))
    return custom_mesh(name,verts,faces,mat)

def crystal_model(name, stage):
    asset(name)
    ico("Dark mineral base", (0,0,0.5), (3.2,2.65,0.85), M["stoneDark"], 1, 0.08)
    if stage == 0:
        specs=[(-1.35,0.1,0.65,1.15,4.3,M["crystalDark"]),
               (-0.45,-0.2,0.65,1.05,5.5,M["crystal"]),
               (0.65,0.1,0.65,0.96,4.5,M["crystal2"]),
               (1.55,0.25,0.65,0.78,3.3,M["crystal"]),
               (0.1,1.0,0.65,0.65,3.2,M["crystalDark"])]
    else:
        specs=[(-0.9,0.0,0.65,0.8,2.2,M["crystalDark"]),
               (0.6,-0.1,0.65,0.86,2.8,M["crystal"]),
               (1.5,0.25,0.65,0.5,1.6,M["crystal2"])]
    for i,(x,y,z,r,h,mat) in enumerate(specs):
        crystal_mesh("Faceted crystal shard %02d"%i,(x,y,z),r,h,mat)

def tile_model(name, topmat, edge=M["soil"]):
    asset(name)
    cube("Rounded soil edge", (0,0,0.52), (9.4,9.4,1.05), edge, 0.35)
    cube("Soft grass surface", (0,0,1.08), (9.1,9.1,0.2), topmat, 0.18)
    # A few low relief stones and tufts make the tile read as hand-made terrain.
    for i,(x,y,s) in enumerate([(-3.6,-3.5,0.26),(3.5,3.0,0.22),(-3.2,3.4,0.18)]):
        ico("Terrain pebble %d"%i,(x,y,1.18),(s,s*0.7,s*0.42),M["soil2"],1)
    for i,(x,y) in enumerate([(-3.4,1.9),(3.4,-2.2)]):
        cone("Tiny grass tuft %d"%i,(x,y,1.34),0.18,0.0,0.55,M["grass2"],6)

def window(name, x, y, z, w=1.0, h=1.5):
    cube(name+" cream frame",(x,y,z),(w+0.3,0.22,h+0.3),M["cream"],0.08)
    cube(name+" blue glass",(x,y-0.13,z),(w,0.1,h),M["glass"],0.06)
    cube(name+" middle bar",(x,y-0.2,z),(0.09,0.06,h),M["white"],0.02)

def building(name, theme):
    asset(name)
    accent, trim, roof = theme
    cube("Raised stone foundation",(0,0,0.65),(12,10,1.3),M["stoneLight"],0.3)
    cube("Main painted walls",(0,0,4.0),(10.7,8.6,6.0),M["cream"] if name=="TownBank" else accent,0.35)
    roof_gable("Bold pitched roof",12,9,6.8,9.2,[roof,trim])
    # roof eaves and warm fascia
    beam("Front roof fascia left",(-6,-4.6,6.85),(0,-4.6,9.25),0.34,trim)
    beam("Front roof fascia right",(0,-4.6,9.25),(6,-4.6,6.85),0.34,trim)
    for x in (-3.6,0,3.6):
        if name == "TownBank" and x == 0:
            cube("Front oak door",(x,-4.45,2.6),(1.7,0.35,3.5),M["wood"],0.15)
            cylinder("Brass door knob",(x+0.48,-4.68,2.4),0.11,0.07,M["gold"],12,(math.pi/2,0,0),0.01)
        else:
            window("Front window",x,-4.45,4.3,1.45,1.85)
    cube("Sign board",(0,-4.72,6.0),(6.3,0.35,1.15),trim,0.16)
    if name=="TownBank":
        text_mesh("BANK","Bank sign",(0,-4.96,6.02),0.72,M["white"])
        # brass coin crest
        cylinder("Coin crest",(0,-4.98,8.15),0.9,0.35,M["gold"],16,(math.pi/2,0,0),0.08)
        cylinder("Coin centre",(0,-5.19,8.15),0.55,0.08,M["cream"],16,(math.pi/2,0,0),0.02)
        beam("Coin mark vertical",(0,-5.25,7.75),(0,-5.25,8.55),0.12,M["gold"])
        beam("Bank column left",(-5,-4.1,1.4),(-5,-4.1,5.8),0.45,M["white"])
        beam("Bank column right",(5,-4.1,1.4),(5,-4.1,5.8),0.45,M["white"])
    elif name=="TownGym":
        text_mesh("GYM","Gym sign",(0,-4.96,6.02),0.72,M["white"])
        beam("Dumbbell bar",(-2.4,-5.15,8.0),(2.4,-5.15,8.0),0.24,M["iron"])
        for x in (-2.5,-2.0,2.0,2.5):
            cylinder("Dumbbell weight",(x,-5.15,8.0),0.55,0.35,M["coral"],10,(0,math.pi/2,0),0.04)
    elif name=="LuckyCasino":
        text_mesh("LUCKY","Casino sign",(0,-4.96,6.02),0.58,M["white"])
        ico("Lucky star",(0,-5.0,8.15),(1.0,0.3,1.0),M["gold"],1)
        for x in (-4.3,-2.7,2.7,4.3):
            ico("Marquee bulb",(x,-4.95,6.0),(0.17,0.12,0.17),M["cream"],1)
    for x in (-4.9,4.9):
        cube("Side pilaster",(x,0,4.0),(0.35,8.0,5.8),trim,0.12)
    # A small roof vent adds silhouette and life.
    cylinder("Roof vent",(0,1.2,8.65),0.65,2.0,M["iron"],10,bevel=0.08)
    cone("Roof vent cap",(0,1.2,9.8),0.86,0.12,0.65,M["coral"],8)
    return CURRENT

# ---------------------------- terrain tiles ----------------------------
tile_model("Tile_Grass",M["grass"])
tile_model("Tile_Woodland",M["grass2"],M["soil2"])
tile_model("Tile_Crystal",M["crystalDark"],M["stoneDark"])

# -------------------------- resource progression -----------------------
tree_model("Tree_Full",0)
tree_model("Tree_Sparse",1)
tree_model("Tree_Bare",2)
tree_model("Tree_Stump_Large",3)
tree_model("Tree_Stump_Small",4)
rock_model("Rock_Full",0)
rock_model("Rock_Cracked",1)
rock_model("Rock_Rubble",2)
crystal_model("Crystal_Full",0)
crystal_model("Crystal_Damaged",1)

# ------------------------------- industry ------------------------------
building("Sawmill", (M["wood2"],M["teal"],M["teal"]))
cube("Mill chimney",(4.4,2.8,8.2),(1.35,1.35,5.2),M["coral"],0.18)
cylinder("Chimney rim",(4.4,2.8,10.8),0.82,0.3,M["gold"],10,bevel=0.06)
for z in (7.6,8.6):
    beam("Chimney stripe",(3.72,2.1,z),(5.08,2.1,z),0.12,M["cream"])
beam("Conveyor frame",(-2.8,-6.0,1.3),(3.6,-6.0,3.0),0.48,M["iron"])
for i in range(6):
    y=-6.5+i*0.2
    cube("Conveyor slat %d"%i,(-0.3,y,2.1),(5.8,0.12,0.12),M["gold"],0.025)
for i in range(3):
    cylinder("Conveyor log %d"%i,(-1.6+i*1.5,-6.3,2.8),0.45,2.1,M["wood"],10,(0,math.pi/2,0),0.06)
    cylinder("Log cut ring %d"%i,(-1.6+i*1.5,-7.37,2.8),0.37,0.08,M["wood2"],10,(0,math.pi/2,0),0.01)
cylinder("Circular saw blade",(5.5,-1.8,3.4),1.8,0.18,M["iron"],20,(0,math.pi/2,0),0.03)
cylinder("Saw blade brass hub",(5.64,-1.8,3.4),0.43,0.14,M["gold"],16,(0,math.pi/2,0),0.02)
for i in range(12):
    ang=2*math.pi*i/12
    ico("Saw tooth %02d"%i,(5.63,-1.8+math.cos(ang)*1.76,3.4+math.sin(ang)*1.76),(0.16,0.22,0.22),M["white"],1)

building("TownBank",(M["cream"],M["gold"],M["teal"]))
building("TownGym",(M["coral"],M["cream"],M["teal"]))
building("LuckyCasino",(M["purple"],M["gold"],M["coral"]))

# -------------------------------- railway ------------------------------
asset("Locomotive")
# Blender's local -Y is the nose; model is designed as a polished miniature.
cube("Main chassis",(0,0,1.35),(5.1,10.8,1.25),M["iron"],0.32)
cube("Coral footplate",(0,-0.45,1.95),(5.65,10.2,0.55),M["coral"],0.22)
cylinder("Round teal boiler",(0,-1.35,3.8),1.72,6.1,M["teal"],16,(math.pi/2,0,0),0.18)
cylinder("Boiler front ring",(0,-4.45,3.8),1.78,0.34,M["gold"],16,(math.pi/2,0,0),0.06)
cylinder("Smokebox face",(0,-4.66,3.8),1.5,0.16,M["iron"],16,(math.pi/2,0,0),0.04)
cylinder("Front badge",(0,-4.79,3.8),0.75,0.12,M["coral"],16,(math.pi/2,0,0),0.03)
cylinder("Chimney collar",(0,-2.4,5.25),0.82,0.38,M["gold"],12,bevel=0.06)
cylinder("Tall red chimney",(0,-2.4,6.15),0.55,1.55,M["coral"],12,bevel=0.12)
cylinder("Chimney cap",(0,-2.4,6.98),0.85,0.32,M["coral"],12,bevel=0.05)
ico("Steam dome",(0,-0.45,5.42),(0.76,0.82,0.65),M["gold"],2)
cylinder("Dome base",(0,-0.45,5.12),0.83,0.2,M["iron"],12,bevel=0.04)
cube("Cab body",(0,2.55,3.3),(5.2,4.2,3.85),M["coral"],0.35)
cube("Cab teal panels",(0,2.48,3.1),(5.32,3.4,2.55),M["teal"],0.22)
cube("Cab roof",(0,2.52,5.55),(6.1,4.8,0.5),M["purple"],0.23)
for x in (-1.45,1.45):
    cube("Cab sky window",(x,0.3,4.35),(1.6,0.18,1.55),M["glass"],0.12)
    cube("Window sill",(x,0.18,3.55),(1.8,0.3,0.22),M["gold"],0.06)
    for y in (-3.6,-1.35,1.35):
        cylinder("Large brass-rimmed wheel",(x*1.35,y,0.92),1.02,0.42,M["rubber"],16,(0,math.pi/2,0),0.08)
        cylinder("Wheel brass hub",(x*1.35*1.12,y,0.92),0.35,0.12,M["gold"],12,(0,math.pi/2,0),0.03)
    beam("Gold side connecting rod",(x*1.42,-3.6,0.92),(x*1.42,1.35,0.92),0.19,M["gold"])
for i in range(7):
    beam("Cowcatcher bar %d"%i,(-2.0+i*0.67,-5.4,0.75),(0,-6.15,1.2),0.20,M["gold"])
cube("Front buffer beam",(0,-5.38,1.45),(5.2,0.55,0.55),M["coral"],0.18)
cylinder("Headlamp brass",(0,-5.72,2.62),0.58,0.35,M["gold"],14,(math.pi/2,0,0),0.06)
cylinder("Headlamp glow",(0,-5.93,2.62),0.39,0.12,M["cream"],14,(math.pi/2,0,0),0.02)
for x in (-2.3,2.3):
    cylinder("Buffer",(x,-5.65,1.15),0.35,0.7,M["iron"],10,(math.pi/2,0,0),0.06)

asset("FlatbedWagon")
cube("Wagon iron frame",(0,0,1.1),(5.0,9.0,0.8),M["iron"],0.25)
cube("Wooden freight bed",(0,0,1.65),(5.5,9.4,0.45),M["wood2"],0.15)
for side in (-1,1):
    for y in (-3.6,-1.8,0,1.8,3.6):
        cube("Teal side post",(side*2.5,y,2.55),(0.28,0.28,2.0),M["teal"],0.08)
    cube("Side rail low",(side*2.5,0,2.05),(0.28,8.8,0.24),M["coral"],0.08)
    cube("Side rail high",(side*2.5,0,2.9),(0.28,8.8,0.24),M["coral"],0.08)
for i in range(3):
    cylinder("Honey log cargo %d"%i,(-1.2+i*1.2,0,2.65),0.58,7.5,M["wood"],12,(math.pi/2,0,0),0.08)
    for y in (-3.78,3.78):
        cylinder("Light log end %d"%i,(-1.2+i*1.2,y,2.65),0.49,0.08,M["wood2"],12,(math.pi/2,0,0),0.01)
for x in (-2.2,2.2):
    for y in (-2.8,2.8):
        cylinder("Wagon wheel",(x,y,0.72),0.75,0.36,M["rubber"],14,(0,math.pi/2,0),0.05)
        cylinder("Wagon brass hub",(x*1.04,y,0.72),0.25,0.1,M["gold"],12,(0,math.pi/2,0),0.02)

# ------------------------ stage variants and export --------------------
def export_assets():
    for name, coll in ASSETS.items():
        path=os.path.join(EXPORT_DIR,name+".fbx")
        bpy.ops.object.select_all(action="DESELECT")
        objects=list(coll.objects)
        if not objects:
            continue
        for obj in objects:
            obj.select_set(True)
        bpy.context.view_layer.objects.active=objects[0]
        bpy.ops.export_scene.fbx(
            filepath=path,
            use_selection=True,
            apply_unit_scale=True,
            bake_space_transform=True,
            add_leaf_bones=False,
            use_mesh_modifiers=True,
            mesh_smooth_type="FACE",
            path_mode="AUTO",
            axis_forward="-Z",
            axis_up="Y",
        )
    bpy.ops.object.select_all(action="DESELECT")

def make_preview():
    global CURRENT
    preview=bpy.data.collections.new("PREVIEW ONLY | presentation board")
    bpy.context.scene.collection.children.link(preview)
    CURRENT=preview
    order=[
        "Tile_Grass","Tree_Full","Tree_Sparse","Tree_Bare","Tree_Stump_Large","Tree_Stump_Small",
        "Rock_Full","Rock_Cracked","Rock_Rubble","Crystal_Full","Crystal_Damaged",
        "Sawmill","TownBank","TownGym","LuckyCasino","Locomotive","FlatbedWagon"
    ]
    cols=5
    spacing=15.5
    for idx,name in enumerate(order):
        col=ASSETS[name]
        row=idx//cols
        c=idx%cols
        offset=Vector(((c-(cols-1)/2)*spacing, (2-row)*spacing, 0))
        for obj in col.objects:
            cp=obj.copy()
            if obj.data:
                cp.data=obj.data
            preview.objects.link(cp)
            cp.location=obj.location+offset
    # Put readable display plinths behind the miniature assets.
    for idx,name in enumerate(order):
        row=idx//cols
        c=idx%cols
        x=(c-(cols-1)/2)*spacing
        y=(2-row)*spacing
        bpy.ops.mesh.primitive_cube_add(size=1,location=(x,y,-0.65))
        plinth=bpy.context.object
        plinth.dimensions=(12.8,12.8,0.9)
        bpy.ops.object.transform_apply(location=False,rotation=False,scale=True)
        own(plinth,"Preview plinth "+name,M["grass"] if "Tile" not in name else M["grass2"],0.28)
        plinth["PreviewOnly"]=True
    scene=bpy.context.scene
    scene.render.engine="CYCLES"
    scene.cycles.samples=24
    scene.render.resolution_x=1700
    scene.render.resolution_y=1120
    scene.render.resolution_percentage=100
    scene.world.color=(0.12,0.18,0.25)
    bpy.ops.object.camera_add(location=(48,-68,94))
    cam=bpy.context.object
    cam.name="Preview camera"
    cam.rotation_euler=(Vector((0,0,0))-cam.location).to_track_quat("-Z","Y").to_euler()
    cam.data.type="ORTHO"
    cam.data.ortho_scale=96
    scene.camera=cam
    bpy.ops.object.light_add(type="AREA",location=(15,-25,60))
    light=bpy.context.object
    light.data.energy=9500
    light.data.shape="DISK"
    light.data.size=55
    bpy.ops.object.light_add(type="AREA",location=(-42,35,35))
    fill=bpy.context.object
    fill.data.energy=4500
    fill.data.size=40
    scene.view_settings.view_transform="Standard"
    scene.view_settings.look="Medium High Contrast"
    scene.view_settings.exposure=0
    scene.view_settings.gamma=1
    scene.render.image_settings.file_format="PNG"
    scene.render.filepath=PREVIEW_PATH
    bpy.ops.render.render(write_still=True)

export_assets()
make_preview()
bpy.ops.wm.save_as_mainfile(filepath=BLEND_PATH)
print("TRAIN MINER ASSETS",len(ASSETS),"FBX files",EXPORT_DIR)
print("PREVIEW",PREVIEW_PATH)
