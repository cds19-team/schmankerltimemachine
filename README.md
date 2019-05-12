![Schmankerl Time Machine Logo](Dokumentation/Bilder/logo.png)

# Schmankerl Time Machine
Das Projekt ist im Rahmen des Kultur-Hackathons  für offene Kulturdaten - [Coding da Vinci Süd 2019](https://codingdavinci.de/events/sued/) - entstanden. 

## Projekt

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes. See deployment for notes on how to deploy the project on a live system.

### Daten


### Realisierung

## Skripte
### Extrahieren der Daten aus der TEI Datei
Für das Extrahieren der Daten aus der aus Transkribus extportierten TEI Datei (Koordinaten in Form von Bounding Boxes) liegt das folgende Python basierte Skript bereit. Es erzeugt CSV Dateien für die einzelnen Speisen, Einträge auf Karten, Besitzer, Adressen etc. 

	# python >= 3.6
    pip install --user -r requirements.txt
    python3 extract.py TEI.xml
 

## Werkzeuge

* [Transkribus](https://transkribus.eu/Transkribus/) - OCR Erfassung der Speisekarten sowie Werkzeug für die Annotation
* [RStudio Shiny-Server](https://www.rstudio.com/products/shiny/shiny-server) - Platform für die Web Anwendung

## Mitwirken

Bitte lesen Sie die [CONTRIBUTING.md](XXX) für Details wie Sie zu dem Projekt beitragen können. 

## Versioning

We use [SemVer](http://semver.org/) for versioning. For the versions available, see the [tags on this repository](https://github.com/your/project/tags). 

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

