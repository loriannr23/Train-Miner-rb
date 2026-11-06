# Spielkonzept: Projekt Minenzug

**Stand:** Entwurf 0.2 · 6. November 2026  
**Arbeitstitel:** noch offen  
**Genre:** gemütlicher Zug-Tycoon mit Rohstoffketten, Bauen und gemeinsamer Spielwelt

## 1. Kurzpitch

Der Spieler besitzt einen kleinen Bahnhof mit einer Rundstrecke. Ein Zug fährt automatisch, sammelt Holz und Erze ein und liefert sie im Bahnhof ab. Rohstoffe können verkauft oder in Gebäuden verarbeitet werden. Aus Brettern, Steinblöcken und Metallteilen entstehen neue Fabriken, Häuser, Bahnhöfe, Gleise und bessere Zugwagen. Mit jeder Ausbaustufe wächst aus einem leeren Bahngelände ein sichtbarer Industrieort.

Die Runde aus **Rohstoffe holen → verarbeiten → bauen → Zug verbessern → neue Gegend öffnen** ist das Herzstück. Die Vorlagen zeigen die fröhliche Zug- und Ressourcenoptik sowie eine Stadt, die durch neue Gebäude wächst. Wir übernehmen diese groben Genre-Ideen, aber geben dem Spiel eigene Gebäude, Zugformen, Oberflächen, UI und Fortschrittsregeln.

## 2. Designziele

1. **Fortschritt ist im Gelände sichtbar.** Neue Fabriken, Häuser, Gleise und Wagons erscheinen tatsächlich auf dem Grundstück.
2. **Immer eine nächste sinnvolle Aufgabe.** Ein voller Zug, eine stockende Fabrik oder ein Bauauftrag zeigt, worauf man als Nächstes hinarbeiten kann.
3. **Zug und Stadt brauchen einander.** Der Zug liefert Rohmaterial; Fabriken machen daraus Bauteile; Bauteile öffnen neue Strecken und Gebäude.
4. **Entspannt statt hektisch.** Kein PvP und keine Strafe, wenn der Spieler kurz weggeht. Optimieren ist optional, Fortschritt bleibt verständlich.
5. **Ohne Werbung.** Keine Werbeeinblendungen und keine Belohnung, die an ein Werbevideo gebunden ist. Monetarisierung wird für den ersten spielbaren Stand weggelassen.
6. **Auf Handy, PC und Controller bedienbar.** Große, klare Tasten und ein UI, das sich an Bildschirm und Eingabegerät anpasst.

## 3. Die Spielschleife

### Zugschleife

- Der Zug fährt automatisch auf der freigeschalteten Strecke.
- Vorne befindet sich ein Sammelmodul, zum Beispiel eine Säge oder ein Bohrer. Ressourcen neben dem Gleis werden beim Vorbeifahren geerntet.
- Wagen haben begrenzte Kapazität. Eine Ladungsanzeige zeigt, wie voll sie sind.
- Im Bahnhof wird die Ladung entladen und an das Lager übergeben.
- Der Spieler entscheidet, ob Rohstoffüberschüsse verkauft oder für Aufträge und Fabriken zurückgehalten werden.
- Münzen verbessern Zugtempo, Sammelleistung, Lagerraum und Wagons.

### Fabrik- und Bauschleife

- Ein Lager versorgt freigeschaltete Fabriken mit passenden Rohstoffen.
- Fabriken stellen Waren automatisch her, solange Material und Lagerplatz vorhanden sind.
- Ein Bauplan am schwarzen Brett fordert bestimmte Mengen an Waren.
- Der Spieler liefert die Waren ab und schaltet dadurch ein Gebäude, einen Streckenabschnitt oder ein Zugteil frei.
- Eine kurze Bauanimation verwandelt den Bauplatz in das fertige Gebäude.
- Neue Gegenden bringen weitere Rohstoffe und eröffnen zusätzliche Produktionsketten.

Die Produktionsautomatik soll wenig Mikromanagement brauchen. Im ersten Spielstand reichen ein Lager und ein einfacher Auftragsschalter. Später können Spieler Rohstoffe gezielter auf Fabriken verteilen.

## 4. Einstieg: die ersten zehn Minuten

1. Spieler erscheint auf einem kleinen Grundstück mit Bahnhof, Zug, kurzer Rundstrecke und zwei leeren Bauplätzen.
2. Ein kurzer Hinweis zeigt, dass der Zug Holz und Stein einsammelt.
3. Am Bahnhof werden die ersten Rohstoffe entladen. Ein Teil wird als Münzen verkauft.
4. Der erste Bauauftrag verlangt Holz und Stein für eine **Sägerei**.
5. Die Sägerei verarbeitet Holz zu Brettern. Der Spieler sieht Bretter, Fortschritt und Lagerstand direkt am Gebäude.
6. Bretter und Stein schalten ein **Lagerhaus** oder eine **Werkstatt** frei.
7. Die Werkstatt stellt einfache Schienenbauteile her. Mit ihnen wächst die Rundstrecke zur nächsten Ressourcenfläche.
8. Ein neuer Wagon wird freigeschaltet, damit mehr Material in einer Zugrunde mitkommt.

Zielhypothese für den Einstieg: Der erste neue Bau soll in wenigen Minuten erreichbar sein; bis dahin soll die Zugschleife schon verständlich und unterhaltsam sein. Die konkreten Preise und Zeiten werden später beim Spielen angepasst.

## 5. Rohstoffe und Verarbeitung

### Rohstoffe für den ersten Abschnitt

| Rohstoff | Quelle | Erste Verwendung |
|---|---|---|
| Holzstämme | Bäume entlang des Gleises | Bretter, Häuser, Kisten |
| Stein | Felsbrocken entlang des Gleises | Fundamente, Steinblöcke, Gleisbau |
| Kupfererz | späteres Gebiet | Kupferbarren und Maschinenteile |

Rohstoffe bekommen klare Formen und Farben. Ein Symbol und eine kurze Bezeichnung helfen zusätzlich, damit die Oberfläche allein nicht die einzige Information ist.

### Erste Produktionsketten

| Kette | Gebäude | Ergebnis | Wofür es gebraucht wird |
|---|---|---|---|
| Holzstämme → Bretter | Sägerei | Bretter | Häuser, Lager, Wagons |
| Stein → Steinblöcke | Steinwerk | Steinblöcke | Fundamente, Bahnhof, Brücke |
| Kupfererz → Kupferbarren | Schmelze | Barren | Werkstatt und bessere Zugtechnik |
| Bretter + Steinblöcke → Schienenbauteile | Werkstatt | Schienenbauteile | Streckenerweiterungen |
| Kupferbarren + Bretter → Motorteile | Zugwerkstatt | Motorteile | stärkere Lokomotive und neue Module |

Das ist die geplante Richtung, keine fertige Balance. Für den ersten Prototyp bauen wir nur die Holz- und Stein-Kette sowie eine daraus entstehende Werkstatt. Kupfer kommt dazu, sobald der erste Ablauf funktioniert.

### Regeln für Produktionsgebäude

- Jedes Gebäude zeigt Eingang, Ausgang, Fortschrittsbalken und Lagerkapazität.
- Eine Produktion beginnt automatisch, wenn alle benötigten Materialien vorhanden sind.
- Wenn das Ausgabelager voll ist, pausiert die Fabrik und erklärt kurz warum.
- Gebäude können mit Münzen oder Baumaterialien verbessert werden: schneller produzieren, mehr lagern oder ein neues Produkt herstellen.
- Gebäude-Upgrades verändern auch das Modell: mehr Maschinen, ein Stockwerk, ein größeres Dach oder sichtbarer Rauch.
- Die ersten Bauplätze sind ein einfaches Raster. Freies, präzises Platzieren kann später ergänzt werden.
- Lieferwagen und Förderbänder dürfen die Warenbewegung illustrieren, müssen aber keine komplexe Physik oder echte Logistik simulieren.

## 6. Gebäude und Stadtwachstum

### Gebäudegruppen

- **Bahnhof und Lager:** Entladen, verkaufen und Waren für Fabriken oder Bauaufträge aufbewahren.
- **Produktion:** Sägerei, Steinwerk, Schmelze, Werkstatt und später spezialisierte Fabriken.
- **Zugentwicklung:** Zugwerkstatt zum Verbessern der Lok und zum Freischalten neuer Wagon-Module.
- **Ortsbild:** Wohnhäuser, kleiner Laden, Brücke, Wasserturm und andere sichtbare Meilensteine.

Nicht jedes Gebäude muss Rohstoffe herstellen. Wohnhäuser und besondere Bauwerke sind vor allem sichtbare Belohnungen, die neue Aufträge, Bauflächen oder Komfort-Upgrades freischalten.

### Bauablauf

1. Ein freier Bauplatz zeigt eine Silhouette oder ein Schild mit der nächsten Anforderung.
2. Beim Antippen öffnet sich eine Karte: benötigte Waren, aktueller Lagerstand und Belohnung.
3. Abgelieferte Waren füllen den Baufortschritt.
4. Wenn alles gesammelt ist, startet eine kurze Bauanimation mit Gerüst, Arbeitern und Lieferwagen.
5. Das fertige Gebäude bleibt dauerhaft sichtbar und erhält eine passende Funktion.

Für den Einstieg werden Gebäude nicht dutzendweise als Menü gekauft. Der Spieler sieht konkrete Bauplätze in seiner Stadt und versteht, warum das nächste Gebäude nützlich ist.

## 7. Zug, Gleise und Aufwertungen

### Zugteile

- **Lokomotive:** Geschwindigkeit und Zugkraft.
- **Säge- oder Bohrmodul:** welche Ressourcen der Zug einsammeln kann und wie schnell.
- **Transportwagen:** Kapazität und sichtbare Ladung.
- **Spezialwagen:** später Boni für Holz, Stein oder Metall.
- **Optik:** Lackierungen, Pfeife und kleine Effekte sind spätere kosmetische Ergänzungen.

Zwei identische Wagen können später zusammengeführt werden, um einen stärkeren Wagon-Slot zu erhalten. Das ist optional und soll Kapazitätsausbau nicht ersetzen. Wir prüfen es erst, wenn der Grundfortschritt bereits klar ist.

### Gleise

- Der erste Zug fährt auf einer einfachen Rundstrecke; man muss keine physikalisch korrekten Schienen legen.
- Der Spieler schaltet neue Streckenstücke über Bauaufträge frei.
- Ein neuer Abschnitt bringt andere Ressourcen und erweitert das Grundstück sichtbar.
- Später können Weichen zwei Routenvarianten öffnen: etwa kurze Runde mit häufigem Verkauf oder längere Runde mit selteneren Rohstoffen.

## 8. Gebiete und Langzeitfortschritt

Vorgeschlagene Reihenfolge:

1. **Kiefernwald:** Holz und Stein; Sägerei, Steinwerk, erste Wohnhäuser.
2. **Kupferschlucht:** Kupfererz; Schmelze und Zugwerkstatt.
3. **Frostpass:** Eisige Kristalle oder seltenes Erz; bessere Spezialwagen.
4. **Vulkankessel:** Kohle und Obsidian; fortgeschrittene Fabriken und größere Lokteile.

Jedes Gebiet sollte die Palette, Bäume, Felsen, Hintergrund und Ressourcenform ändern. Das neue Gebiet muss sich spielerisch anders anfühlen, nicht nur andere Farben haben. Ein Gebiet nach dem anderen reicht für den Anfang; erst die ersten beiden brauchen frühe Detailplanung.

## 9. Oberfläche und Menüs

### Haupt-HUD

- Oben links: Gebietsname und Gebietsfortschritt.
- Oben rechts: Münzen, Lagerhinweis und Einstellungen.
- Am Zug oder neben der Strecke: Wagon-Füllstand und Entladehinweis.
- Unten: vier große Schnellaktionen, zum Beispiel **Wagon**, **Sammelmodul**, **Tempo**, **Kapazität**.
- Gut erreichbar: Bauaufträge, Gebäudeübersicht und Kamerawahl.
- Wenn ein Gebäude ausgewählt ist: eigenes kleines Panel mit Rezept, Lager, Produktion und Ausbau.

Das HUD übernimmt nicht exakt die Anordnung des Beispiels. Der Zug und die Gebäude müssen sichtbar bleiben, und auf Handy dürfen wichtige Tasten nicht mit Roblox-Steuerknöpfen oder Geräteausschnitten kollidieren.

### Menüs

- **Bauaufträge:** nächste Gebäude, Gleisabschnitte und Zugteile.
- **Gebäudeübersicht:** alle laufenden Produktionsketten und Engpässe.
- **Zugschein:** Wagen, Module, Geschwindigkeit und Optik.
- **Karte:** eigene Rundstrecke und bereits erkundete Gebiete.
- **Einstellungen:** Kamera, Ton, Sprache, UI-Größe.

### Erste Hilfen

- Maximal drei kurze Hinweise: Zug beobachten, Ladung entladen, erste Sägerei bauen.
- Hinweise verschwinden, sobald der Spieler die Aktion ausführt.
- Fortschritt wird über Symbole, Füllstände und sichtbare Weltobjekte gezeigt, nicht über lange Textfenster.

## 10. Kamera, Bildschirm und Steuerung

### Kameramodi

1. **Von oben / Diorama:** Standardansicht, leicht schräg von oben, damit Zug, Schienen und Bauplätze zugleich sichtbar sind. Zoom und begrenztes Drehen.
2. **Third Person:** Roblox-Ansicht hinter dem Avatar; zum Herumlaufen, Gebäude ansehen und andere Grundstücke besuchen.
3. **First Person:** immersive Ansicht beim Erkunden des eigenen Geländes. Für Bau und Management ist sie weniger praktisch, deshalb jederzeit leicht zurückschaltbar.

Ein Kameraknopf öffnet eine gut lesbare Auswahl. Die gewählte Kamera wird lokal gespeichert. Die Zugfahrt läuft in jedem Modus unverändert weiter. Roblox hat eine eingebaute First- und Third-Person-Kamera; für die Diorama-Ansicht braucht es eine eigene Kamerasteuerung.

### Querformat und Eingaben

- Mobile erhält Querformat als Ziel; dafür wird die Roblox-Einstellung `LandscapeSensor` verwendet.
- PC, Tablet und Controller bekommen responsive UI statt fester Pixelpositionen.
- **Touch:** Tippen auf Zugupgrades, Gebäude und Aufträge; Kamera-Schwenk/Zoom über Gesten.
- **PC:** Maus für UI, WASD zum Erkunden, Mausrad für Zoom, Tasten 1–4 für Schnellupgrades.
- **Controller:** Fokusnavigation durch Menüs, Auswahl über A/Cross und Zurück über B/Circle.
- In der Diorama-Ansicht ist Bewegung optional. Der Spieler soll das Management auch ohne Avatar-Bewegung komplett bedienen können.

## 11. Stil, Klang und Modelle

### Visuelle Richtung

- Fröhliche Miniatur-Eisenbahn und Spielzeugstadt: klare Silhouetten, satte aber kontrollierte Farben, weiche Kanten und lesbare Formen.
- Die Screenshots sind Anhaltspunkte für dichte grüne Natur, farbenfrohe Ressourcen und eine gut erkennbare Strecke. Das genaue Design von Lok, UI und Stadt bleibt eigenständig.
- Im Wald dominieren Tannengrün, Himmelstürkis und warmes Holz. Gebäude bekommen eigene Akzentfarben nach Funktion.
- Fabriken brauchen eine erkennbare Bewegung: Sägeblatt dreht, Ofen glüht, Förderband bewegt Kisten. Animationen kurz und sparsam.
- Bei vollem Wagon wird die Ladung als Modell sichtbar; bei einer Lieferung wandern Waren ins Lager.

### Eigene Modellbibliothek und erster Spielstand

- Lokomotive mit eigenem Frontmodul.
- Transportwagen, Holz-Wagon und Stein-Wagon.
- Gerade und gebogene Schienen, Bahnhof und Weiche.
- Drei Varianten von Ressourcenobjekten: Baum, Stein, Erz.
- Lager, Sägerei, Steinwerk und kleine Werkstatt.
- Zwei bis drei Hausmodelle sowie Baugerüst und Baustellenschild.
- Symbole für Holz, Stein, Bretter, Münzen und jeden Upgrade-Typ.

Für den ersten Stand gibt es eine eigene Blender-Bibliothek mit 19 exportierten FBX-Modellen: drei Bodenkacheln, fünf Baumstadien, drei Felsstadien, zwei Kristallstadien, Sägewerk, Bank, Fitnessstudio, Casino, Lok und Güterwagen. `src/studio/build_starter_scene.luau` skaliert die importierten Modelle auf das 10-Stud-Raster, weist ihre Farbpalette zu und baut daraus die Startlandschaft. Die Blender-Quelldatei und das Exportskript bleiben versioniert, damit Formen und Proportionen überarbeitet werden können.

Jede Kachel kann ein Ressourcenobjekt tragen. Der erste Weltabschnitt setzt 16 aktive Holz-, Stein- und Kristallknoten entlang der Strecke ein; zusätzliche Waldobjekte füllen den Rand der Fläche. Die aktive Ressource speichert Tile-Koordinate, Typ, Gesundheit und Schadensstufe. Weitere Kacheln lassen sich über dieselbe Node-Vorlage ergänzen.

### Klang

- Zug: rhythmisches Rollen, Pfeife und leises Dampfgeräusch.
- Sammeln: kurze Säge- oder Bohrgeräusche je Material.
- Fabriken: leise, unterscheidbare Produktionsgeräusche.
- Bauabschluss: kurze positive Melodie, nicht bei jedem einzelnen Materialstück.

## 12. Mehrspieler und Fairness

- Mehrere Spieler bekommen im selben Server getrennte, nebeneinanderliegende Grundstücke.
- Zug, Geld, Rezepte und Gebäude gehören jeweils dem Grundstücksbesitzer.
- Andere dürfen Grundstücke besuchen und ansehen.
- Ein späteres Helfersystem kann einmal pro Besuch beim Bau helfen und beiden Spielern einen kleinen Bonus geben.
- Handel und PvP gehören nicht in den ersten Stand; sie würden das entspannte Fortschrittssystem komplizierter machen.

## 13. Speichern und technische Regeln

- Der Server prüft Münzen, Kosten, Baufortschritt und Produktionsresultate. Der Client darf keine Waren oder Münzen selbst vergeben.
- Gespeichert werden Münzen, freigeschaltete Gebiete, Gebäudestufen, Zugupgrades und bereits gebaute Gebäude.
- Zugposition und reine Animationen müssen nicht gespeichert werden; beim Wiedereinstieg werden sie aus dem Fortschritt rekonstruiert.
- Produktionszeiten sollen im ersten Prototyp nur laufen, während der Spieler online ist. Begrenzte Offline-Produktion kann später dazukommen.
- Für den ersten Mehrspieler-Stand bleibt die Simulation pro Grundstück einfach und sparsam.

## 14. Entwicklungsweg: Studio, MCP, Rojo und GitHub

Die Werkzeuge ergänzen sich:

- **Roblox Studio:** 3D-Welt, Bauplätze, Beleuchtung, Animationen und visuelles Spielen/Prüfen.
- **Rojo:** lokale `.luau`-Quelldateien synchronisieren und aus einer Projektstruktur ein Roblox-Projekt bauen.
- **GitHub:** private Versionsgeschichte und Sicherung für Code, Konfiguration und Spielplan.
- **Codex plus Roblox Studio MCP:** Roblox-Instanzen inspizieren, Luau direkt ausführen und bei offener Verbindung Änderungen im Studio unterstützen.

Empfohlener Ablauf: Studio bleibt das Werkzeug fürs Bauen und fürs Spielen. Code und Konfiguration liegen lokal in Git und werden mit Rojo zu Studio synchronisiert. Große Szenen und Assets werden bewusst in Studio gepflegt, statt jedes Detail zwanghaft als Code abzubilden. MCP ergänzt diesen Ablauf, ersetzt aber weder Studio noch die Git-Historie.

**Aktueller Projektzustand:** Das Repository enthält `default.project.json`, aktuelle Luau-Quellen für Server, Client und gemeinsame Konfiguration, eine Blender-Quelldatei mit 19 exportierten Modellen sowie ausgewählte OGG-Dateien. `Train-Miner.rbxl` enthält den ersten generierten Weltabschnitt mit 99 Bodenkacheln, Rundgleis, 16 aktiven Ressourcen, Walddeko, Verkaufsdepot, vier Bauplätzen und importierten Modellen. Der Builder enthält bereits die jüngste Beschriftungsbereinigung und das animierte Säge-Modul; diese Updates sowie die aktuellen Gameplay-Skripte müssen bei der nächsten Studio-Sitzung noch synchronisiert werden. Die Audio-Asset-IDs müssen ebenfalls noch eingetragen werden.

### Grobe Code-Aufteilung

```text
Assets/
  Blender/                             Blender-Projekt, Exportskript, FBX und Vorschau
  Audio/Kenney/                        CC0-OGG-Clips plus Lizenzdateien
src/
  shared/GameConfig.luau               Ressourcen, Saw-Tiers, Preise und Gebäude
  server/TrainMinerServer.server.luau  Speichern, Ernten, Verkauf, RNG, Bauen
  server/TrainLoop.server.luau         Serverzug, Wegpunkte und Sägeanimation
  client/TrainMinerClient.client.luau  HUD, Kameras, Trefferpartikel und Sound
  studio/                              Weltaufbau und Audio-ID-Setup
default.project.json                   Rojo-Mapping
GAME_PLAN.md                           Gamedesign und aktueller Stand
```

Wichtige Spielregeln und Preise bleiben in Konfigurationsmodulen, damit wir sie an einer Stelle ändern können. Daten-Speicherung und Käufe bleiben serverseitig.

## 15. Entwicklungsphasen

### Phase A — Rohbau

- Leere Studio-Welt, eine Grundstücksfläche, Spawn und Kamera von oben.
- Rundstrecke mit einfachen Parts.
- Zug fährt auf vorgegebenen Wegpunkten, ohne Schienenphysik.
- Ein Ressourcenobjekt wird erkannt und dem Zug zugerechnet.

**Umgesetzt als Quellstand:** Tile-Raster, eigene Terrain-/Ressourcenmodelle, Rundgleis und Zugmodell. Die Spielschleife ist im Code angelegt; Studio-seitige Modellimporte und ein echter Playtest sind noch offen.

### Phase B — erste vollständige Spielschleife

- Holz und Stein sammeln, entladen, verkaufen und als Lagerbestand anzeigen.
- Vier verständliche Zugupgrades.
- Sägerei verarbeitet Holz zu Brettern.
- Erster Bauauftrag verbraucht Bretter und Stein für ein Lager oder eine Werkstatt.
- Gespeicherter Fortschritt.

**Umgesetzt als Quellstand:** HP-Schadensstufen, zweiter Vorbeifahrts-Sammelvorgang, Verkauf, XP-Level, begrenzte RNG-Sägen, Level-Freischaltungen, Merge, Best-Saw-Equip und Sägewerk (3 Holz → 1 Brett). Gebäudekosten und Boni sind serverseitig hinterlegt.

### Phase C — Gebäude und Gebiete

- Steinwerk und Werkstatt ergänzen.
- Mehr Bauplätze und sichtbare Stadtentwicklung.
- Zweites Gebiet mit Kupfer und Schmelze.
- Bauauftrags- und Fabrikoberfläche vervollständigen.

### Phase D — Präsentation und soziale Funktionen

- First-Person- und Third-Person-Modus ergänzen.
- Mobile/Controller-Eingaben und Querformat-Layout abstimmen.
- Besuchbare Grundstücke und ein einfaches Helferereignis.
- Sound, Effekte und kosmetische Zugoptionen ergänzen.

**Angelegt:** Kameraumschalter für Diorama/Third/First Person, Querformat-Ziel, clientseitige Treffer-/Bruchpartikel und Routing für die Kenney-Clips. Sound-Dateien sind im Repo, benötigen nach dem Import in Roblox noch ihre Audio-Asset-IDs.

## 16. Noch offene gemeinsame Entscheidungen

Diese Punkte können wir ändern, bevor die Details festgelegt werden:

- **Arbeitstitel:** deutsch, englisch oder beides?
- **Bauen:** Bauplätze mit Raster (schnell und übersichtlich) oder später freie Platzierung?
- **Zug:** vollständig automatisch fahren oder eine optionale Taste für einen kurzen Turbo?
- **Mehrspieler:** nur Grundstücke besuchen oder früh kleine Koop-Aufträge?
- **Optik:** entschieden: farbenfrohe Low-Poly-Spielzeugbahn mit weichen Kanten, sattgrüner Landschaft und klaren Akzentfarben.
- **Monetarisierung:** kostenlos ohne Werbung; kosmetische Gamepasses später nur, falls gewünscht.

## Referenzen

- Train Miner, Google Play: https://play.google.com/store/apps/details?id=games.flexus.trainminer&hl=de_CH
- Train Miner, CrazyGames: https://www.crazygames.com/game/train-miner
- Train Miner, App Store: https://apps.apple.com/ch/app/train-miner-eisenbahnspiel/id6472662399
- Roblox-Kameras: https://create.roblox.com/docs/workspace/camera
- Roblox Mobile-Orientierung und Eingaben: https://create.roblox.com/docs/input/mobile
- Roblox adaptive Oberflächen: https://create.roblox.com/docs/production/publishing/adaptive-design
- Roblox Rojo/Externe Werkzeuge: https://create.roblox.com/docs/projects/external-tools
- Roblox Script Sync und Rojo-Auswahl: https://create.roblox.com/docs/scripting/sync
- Roblox Data Stores: https://create.roblox.com/docs/cloud-services/data-stores
