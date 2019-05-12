
![Schmankerl Time Machine Logo](Dokumentation/Bilder/logo.png)

# Schmankerl Time Machine
Das Projekt ist im Rahmen des Kultur-Hackathons  für offene Kulturdaten - [Coding da Vinci Süd 2019](https://codingdavinci.de/events/sued/) - entstanden. 


## Projekt


> Kommt bei Ihnen zu Hause immer nur das Gleiche auf den Tisch? Sind Sie auf der Suche nach kulinarischer Vielfalt in Ihrem Alltag? Noch ist nicht Hopfen und Malz verloren! Die „Schmankerl Time Machine“ lädt Sie zu einem lukullischen Streifzug durch die traditionsreiche Münchner Wirtshausgeschichte der vergangenen 150 Jahre ein. Verschaffen Sie sich einen Überblick über die Legenden am Münchner Gastrohimmel, über verglühte Sterne und nie verblühende Evergreens. Stellen Sie sich aus einem Portfolio von über 380 annotierten Speise-karten und den damit verlinkten Rezepturen Ihr unvergessliches Menü von Morgen zusammen. Wie wäre es mit einem Hummercocktail, gefolgt vom Hasen in der Terrine und Rehnüsschen, Fürst Pückler als krönendem Abschluss? Lassen Sie sich bei Ihrer Menükreation von den Vorschlägen anderer Nutzer inspirieren. Laden Sie die Speisekarte Ihres favorisierten Münchner Genusstempels hoch, um das Angebot noch zu erweitern. 

\- Let’s Schmankerl!

### Daten
Ein Snapshot der extrahierten Daten kann in dem Ordner [Daten](Daten/) gefunden werden.
* **addresses** Extrahierte Adressen die in den Speisekarten annotiert wurden
* **categories** Speisekarten Kategorien (Vorspeisen, Hauptgerichte, ...)
* **entries** Verknüfung von Speisen/Getränken zu Speisekarten, inkl. Preis und Mengenangaben
* **items** Beschreibung der Speisen/Getränke
* **menus** Metadaten zu den Speisekarten
* **owners** Inhaber die annotiert wurden
* **recipies** Verknüpfung von Speise/Getränken zu Chefkoch. (Verfügbar unter https://chefkoch.de/rezepte/{recipy_id}/)
* **restaurants** Meta Informationen zu den Restaurants
* **zones** Einträge auf Speisekarten und deren Region (Bounding Boxes)


### Realisierung
#### JupyterNotebooks
Im Ordner [Notebooks](Notebooks/) befinden sich einige Beispiel Notebooks zur Auswertung.
![Speisekarten Wordcloud](Dokumentation/Bilder/wordcloud.png)

## Skripte
### Extrahieren der Daten aus der TEI Datei
Für das Extrahieren der Daten aus der aus Transkribus extportierten TEI Datei (Koordinaten in Form von Bounding Boxes) liegt das folgende Python basierte Skript bereit. Es erzeugt CSV Dateien für die einzelnen Speisen, Einträge auf Karten, Besitzer, Adressen etc. 

	# python >= 3.6
    pip install --user -r requirements.txt
    python3 extract.py TEI.xml

## Werkzeuge

* [Transkribus](https://transkribus.eu/Transkribus/) - OCR Erfassung der Speisekarten sowie Werkzeug für die Annotation
* [RStudio Shiny-Server](https://www.rstudio.com/products/shiny/shiny-server) - Platform für die Web Anwendung
* Python / JupyterNotebooks

## Zitieren und Forschungsdatenmanagement
Um Teile dieses Projekts zu zitieren, verwenden Sie bitte folgende Angaben: *XXXX*
Eine Spezifikation der Daten finden Sie in der entsprechenden [DataCite Datei](XXX).


## Mitwirken

Zum einen können Sie weitere Speisekarten mit Transkribus annotieren - hierfür haben wir ein [Crowdsourcing Projekt](https://transkribus.eu/r/read/projects/) gestartet. Beiträge in Form von Programmen oder Verbesserungen sind sehr willkommen, öffnen Sie in diesem Fall bitte einen Pull-Request. 


## TEAM
* **Julian Schulz** - [Website](https://www.hgw.geschichte.uni-muenchen.de/personen/mitarbeiter/schulz), [ORCID](https://orcid.org/0000-0003-4374-2680), [Twitter](https://twitter.com/SchJulzian)
* **Linus Kohl** - [Website](https://munichresearch.com), [ORCID](https://orcid.org/000-0003-3400-837X), [LinkedIn](https://www.linkedin.com/in/linuskohl), [Twitter](https://twitter.com/LinusKohl)
* **Stefanie Schneider** - [Website](https://www.kunstgeschichte.uni-muenchen.de/personen/wiss_ma/schneider/index.html), [ORCID](https://orcid.org/0000-0003-4915-6949), [Twitter](https://twitter.com/_stschneider)
* **Alexandra Reisser** - [ORCID](https://orcid.org/0000-0001-5560-1901), [LinkedIn](https://www.linkedin.com/in/alexandra-rei%C3%9Fer-379aa7180/), [Twitter](https://twitter.com/alexreisser)
* **Osman Cakir** - [Website](https://osmancakir.io/), [ORCID](https://orcid.org/0000-0002-4828-0748), [Twitter](https://twitter.com/osmancakirio)
Eine erweiterte Liste der Beitragenden zu diesem Projekt finden Sie unter [Beitragende](XX).

## Lizenzen
* Abbildungen der Speisekarten wurden unter der Lizenz [CC BY-SA 4.0](https://creativecommons.org/licenses/by-sa/4.0) von der Münchner Stadtbibliothek / Monacensia im Hildebrandhaus bereitgestellt.
* Daten, die im Rahmen des Projektes entstanden sind unterliegen ebenfalls der Lizenz [CC BY-SA 4.0](https://creativecommons.org/licenses/by-sa/4.0).
* Quelltext unterliegt der GNU GPL v3 Lizenz.

## Danksagung
Wir bedanken uns bei den Organisatoren des Wettbewerbs 


