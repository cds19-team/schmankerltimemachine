<p style="text-align: center;">
  <img src="Dokumentation/Bilder/empty.png" width="25%" />
  <img alt="Schmankerl Time Machine Logo" src="Dokumentation/Bilder/logo_with_cdv.png" width="50%" />
</p>

# Schmankerl Time Machine

Das Projekt ist im Rahmen des Kultur-Hackathons für offene Kulturdaten [Coding da Vinci Süd 2019](https://codingdavinci.de/events/sued/) entstanden. 

## Projektbeschreibung

> Kommt bei Ihnen zu Hause immer nur das Gleiche auf den Tisch? Sind Sie auf der Suche nach kulinarischer Vielfalt in Ihrem Alltag? Noch ist nicht Hopfen und Malz verloren!<br /><br />Die „Schmankerl Time Machine“ lädt Sie zu einem lukullischen Streifzug durch die traditionsreiche Münchner Wirtshausgeschichte der vergangenen 150 Jahre ein. Verschaffen Sie sich einen Überblick über die Legenden am Münchner Gastrohimmel, über verglühte Sterne und nie verblühende Evergreens. Stellen Sie sich aus einem Portfolio von über 380 Speisekarten und den damit verlinkten Rezepturen Ihr unvergessliches Menü von Morgen zusammen. Wie wäre es mit einem Hummercocktail, gefolgt vom Hasen in der Terrine und Rehnüsschen, Fürst Pückler als krönendem Abschluss? Lassen Sie sich bei Ihrer Menükreation von den Vorschlägen anderer Nutzer inspirieren. Laden Sie die Speisekarte Ihres favorisierten Münchner Genusstempels hoch, um das Angebot noch zu erweitern.<br /><br />Let’s Schmankerl!

Eine ausführliche Projektbeschreibung kann unter [PROJEKTBESCHREIBUNG.md](PROJEKTBESCHREIBUNG.md) eingesehen werden.

## Daten

Ein Snapshot der extrahierten Daten ist im Ordner [Daten](Daten/) zu finden.

* **addresses** Adressen, die in den Speisekarten annotiert wurden.
* **categories** Kategorien der Speisen und Getränke (Vorspeisen, Hauptgerichte etc.).
* **entries** Verknüpfung der Speisen und Getränken zu den Speisekarten, inkl. Preis und Mengenangaben.
* **items** Beschreibung der Speisen und Getränke.
* **menus** Metadaten zu den Speisekarten.
* **owners** Inhaber der Lokalitäten, die in den Speisekarten annotiert wurden.
* **recipies** Verknüpfung der Speisen und Getränken zu [Chefkoch.de](https://chefkoch.de/) (verfügbar unter: https://chefkoch.de/rezepte/{recipy_id}/).
* **restaurants** Metadaten zu den Lokalitäten.
* **zones** Einträge auf Speisekarten und deren Koordinaten (*Bounding Boxes*).

## Realisierung

### Jupyter Notebooks

Im Ordner [Notebooks](Notebooks/) befinden sich einige Beispiel-Notebooks zur Auswertung.

<p style="max-width: 850px;">
  <img alt="Speisekarten Wordcloud" src="Dokumentation/Bilder/wordcloud.png" width="88%" />
</p>

### Shiny Web-Applikation

Im Ordner [Webanwendung](Webanwendung/) befindet sich der gesamte Code für die Shiny Web-Applikation, die unter https://www.dhvlab.gwi.uni-muenchen.de/schmankerltimemachine/ aktuell bei der [IT-Gruppe Geisteswissenschaften](https://www.itg.uni-muenchen.de/index.html) gehostet wird.

<p float="left" style="max-width: 850px;">
  <img alt="Screenshot 1" src="Dokumentation/Bilder/screenshot-1.png" width="22%" />
  <img alt="Screenshot 2" src="Dokumentation/Bilder/screenshot-2.png" width="22%" /> 
  <img alt="Screenshot 3" src="Dokumentation/Bilder/screenshot-3.png" width="22%" />
  <img alt="Screenshot 4" src="Dokumentation/Bilder/screenshot-4.png" width="22%" />
  <img alt="Screenshot 5" src="Dokumentation/Bilder/screenshot-5.png" width="22%" />
  <img alt="Screenshot 6" src="Dokumentation/Bilder/screenshot-6.png" width="22%" /> 
  <img alt="Screenshot 7" src="Dokumentation/Bilder/screenshot-7.png" width="22%" />
  <img alt="Screenshot 8" src="Dokumentation/Bilder/screenshot-8.png" width="22%" />
</p>

## Skripte

### Extrahieren der Daten aus der TEI-Datei

Für das Extrahieren der Daten aus der aus Transkribus exportierten TEI-Datei (Koordinaten in Form von *Bounding Boxes*) liegt das folgende Python-basierte Skript bereit. Es erzeugt CSV-Dateien für die einzelnen Speisen und Getränke, Einträge auf Karten, Besitzer und Adressen etc. 

	# python >= 3.6
    pip install --user -r requirements.txt
    python3 extract.py TEI.xml

## Werkzeuge

* [Transkribus](https://transkribus.eu/Transkribus/): *OCR*-Erfassung der Speisekarten und Werkzeug für die Annotation der Speisen und Getränke.
* [RStudio Shiny-Server](https://www.rstudio.com/products/shiny/shiny-server): Plattform für die Web-Applikation, die auf der Open-Source-Umgebung R basiert.
* [Jupyter Notebooks](https://jupyter.org/): Python-Funktionen, die die Daten importieren, bereinigen und einige exemplarische Statistiken enthalten.
* [Leaflet](https://leafletjs.com/): JavaScript-Bibliothek für die Darstellung der interaktiven Karte(n) in der Web-Applikation.

## Zitation und Nachnutzung

Sämtliche Abbildungen der Speisekarten sowie die im Projekt entstandenen Daten werden im Forschungsdatenrepositorium der LMU München ([Open Data LMU](https://data.ub.uni-muenchen.de/)) dauerhaft und mittels einer *DOI* eindeutig referenzierbar abgelegt: https://doi.org/10.5282/ubm/data.146.

Für die Zitation des Projekts oder Teilen daraus, empfehlen wir folgende Angabe:
> Cakir, Osman / Kohl, Linus / Multerer, Clara / Reisser, Alexandra / Schneider, Stefanie / Schulz, Julian: Schmankerl Time Machine: Eine kulinarische Zeitreise durch die Speisekarten traditionsreicher Münchner Gaststätten. 18. Mai 2019. Open Data LMU: https://doi.org/10.5282/ubm/data.146.

Eine Spezifikation der Daten im Metadatenschema [DataCite 4.2](https://schema.datacite.org/meta/kernel-4/) steht zur Nachnutzung bereit: [Codav DataCite](https://gitlab.com/cds19-team/cds19/raw/master/codav_datacite.xml). Die Spezifikation folgt der DataCite Best-Practice-Policy, die derzeit im Rahmen des Projekts [eHumanities – interdisziplinär](https://www.fdm-bayern.org/) ausgearbeitet wird.

## Mitwirken

Wir freuen uns über Ihre Unterstützung bei der Annotation weiterer Speisekarten mit Transkribus. Hierfür haben wir ein [Crowdsourcing Projekt](https://transkribus.eu/r/read/projects/) angelegt. Beiträge in Form von Programmen oder Verbesserungen sind sehr willkommen: Öffnen Sie in diesem Fall bitte einen Pull-Request. 

## Team

* **Osman Cakir** ([Website](https://osmancakir.io/), [ORCID](https://orcid.org/0000-0002-4828-0748), [Twitter](https://twitter.com/osmancakirio))
* **Linus Kohl** ([Website](https://munichresearch.com), [ORCID](https://orcid.org/000-0003-3400-837X), [LinkedIn](https://www.linkedin.com/in/linuskohl), [Twitter](https://twitter.com/LinusKohl))
* **Clara Multerer**
* **Alexandra Reisser** ([ORCID](https://orcid.org/0000-0001-5560-1901), [LinkedIn](https://www.linkedin.com/in/alexandra-rei%C3%9Fer-379aa7180/), [Twitter](https://twitter.com/alexreisser))
* **Stefanie Schneider** ([Website](https://www.kunstgeschichte.uni-muenchen.de/personen/wiss_ma/schneider/index.html), [ORCID](https://orcid.org/0000-0003-4915-6949), [Twitter](https://twitter.com/_stschneider))
* **Julian Schulz** ([Website](https://www.hgw.geschichte.uni-muenchen.de/personen/mitarbeiter/schulz), [ORCID](https://orcid.org/0000-0003-4374-2680), [Twitter](https://twitter.com/SchJulzian))

## Lizenzen

* Abbildungen der Speisekarten wurden unter der Lizenz [CC BY-SA 4.0](https://creativecommons.org/licenses/by-sa/4.0) von der Münchner Stadtbibliothek / Monacensia im Hildebrandhaus bereitgestellt.
* Daten, die im Rahmen des Projekts entstanden sind, unterliegen ebenfalls der Lizenz [CC BY-SA 4.0](https://creativecommons.org/licenses/by-sa/4.0).
* Quelltext unterliegt der [GNU GPL v3](https://www.gnu.org/licenses/gpl-3.0.de.html)-Lizenz.

## Danksagung

Wir bedanken uns sehr herzlich bei den Organisatoren des diesjährigen Wettbewerbs und der Projektkoordination von [Coding da Vinci](https://codingdavinci.de/about/index-de.html).