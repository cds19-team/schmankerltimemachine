## Zusammenfassung

Kommt bei Ihnen zu Hause immer nur das Gleiche auf den Tisch? Sind Sie auf der 
Suche nach kulinarischer Vielfalt in Ihrem Alltag? Noch ist nicht Hopfen und 
Malz verloren!

Die "Schmankerl Time Machine" lädt Sie zu einem lukullischen Streifzug durch die 
traditionsreiche Münchner Wirtshausgeschichte der vergangenen 150 Jahre ein. 
Verschaffen Sie sich einen Überblick über die Legenden am Münchner Gastrohimmel, 
über verglühte Sterne und nie verblühende Evergreens. Stellen Sie sich aus einem 
Portfolio von über 380 Speisekarten und den damit verlinkten Rezepturen Ihr 
unvergessliches Menü von Morgen zusammen. Wie wäre es mit einem Hummercocktail, 
gefolgt vom Hasen in der Terrine und Rehnüsschen, Fürst Pückler als krönendem 
Abschluss? Lassen Sie sich bei Ihrer Menükreation von den Vorschlägen anderer 
Nutzer inspirieren. Laden Sie die Speisekarte Ihres favorisierten Münchner 
Genusstempels hoch, um das Angebot noch zu erweitern.

Let’s Schmankerl!

## Technische Umsetzung und Funktionalitäten

Technisch realisiert ist die "Schmankerl Time Machine" mit der 
Open-Source-Umgebung R und den auf R basierenden Paketen Shiny und Tidyverse. Um 
eine Anwendung auf Smartphones und Tablets ebenso zu erlauben wie auf 
Desktoprechnern, wird das System auf Clientseite ergänzt durch HTML5, JavaScript 
und das Frontend-CSS-Framework Bootstrap. Eine Lokalität kann entweder über ein 
Dropdown-Menü oder eine dynamische Karte (basierend auf leaflet.js und 
LocationIQ) ausgewählt werden. Zu jeder Lokalität werden weiterführende 
Informationen angeboten. Sofern digital vorhanden, werden auch alte Abbildungen 
der Restaurants aus dem Münchner Stadtarchiv unmittelbar eingebunden.

Jede zu einer Lokalität gehörende Speisekarte kann beliebig gezoomt und 
verschoben werden. Zudem ist jede Annotation, und damit auch jedes Schmankerl, 
direkt via Klick anwählbar. Besonders exquisite Speisen werden algorithmisch 
ausfindig gemacht – und sogar komplette Menüs zusammengestellt; wobei nicht nur 
die lukullischen Präferenzen des jeweiligen Nutzers berücksichtigt werden, 
sondern auch sein Budget. Ein virtueller Warenkorb unterstützt die Exploration 
des Fundus weiterhin: Indem er die Rezeptdatenbank des Webportals Chefkoch.de 
verknüpft, können ausgewählte Gerichte einfach nachgekocht werden; Zutatenliste 
inklusive.

Neben diesem spielerischen Zugang zu den Speisekarten und den darin 
verzeichneten Gerichten, kann die "Schmankerl Time Machine" auch als 
Ausgangspunkt für wissenschaftliche, (im wahrsten Sinne des Wortes) 
lokalgeschichtliche und gesellschaftliche Fragestellungen dienen:

* In welchem Jahr findet sich erstmals ein bestimmtes Gericht auf einem Münchner 
Menüplan?

* In welchen Stadtvierteln finden wir ein besonders großes Angebot an 
Gasthäusern, aber wie viele davon bestehen noch heute?

* Wie verändern sich im Laufe der Zeit die Adjektive, mit denen die Speisen 
angepriesen werden? Ab wann finden sich Zusätze wie „leicht“, also Hinweise auf 
ein sich veränderndes Ernährungsbewusstsein?

Dies sind nur wenige Beispiele, die zeigen, wie vielfältig sich die 
Beschäftigung mit den hier erstmals dargebotenen Münchner Speisekarten gestalten 
kann. Um hierfür einen möglichst niederschwelligen Einstieg zu gewährleisten, 
werden einige Jupyter Notebooks in Python3 zur Verfügung gestellt, die die Daten 
importieren, bereinigen und bereits einige exemplarische Statistiken beinhalten. 
Hierfür werden gängige Bibliotheken im Bereich Data Science verwendet (pandas, 
numpy, matplotlib et al.).

## Datengrundlage und künftige Entwicklungsmöglichkeiten

Die digitalisierten Speisekarten wurden einschließlich Metadaten durch die 
Monacensia der Münchner Stadtbibliothek bereitgestellt. Für die OCR-Erfassung, 
Bild-Text-Verknüpfung und die sich anschließende Annotation ausgewählter 
Speisekarten wurde auf die Plattform Transkribus zurückgegriffen, die im Rahmen 
des H2020 e-Infrastrukturprojekts READ (Recognition and Enrichment of Archival 
Documents) angeboten und weiterentwickelt wird. Für die einheitliche Annotation 
wurde ein eigenes Tagset entworfen. Die Plattform ermöglicht den Export der 
Dokumente im TEI-XML-Format.

Die „Schmankerl Time Machine“ wird aktuell bei der IT-Gruppe 
Geisteswissenschaften gehostet. Ein Transfer zum Webangebot der Monacensia der 
Stadtbibliothek wird derzeit mit den Verantwortlichen abgestimmt. Perspektivisch 
kann das Portfolio

a) um weitere Speisekarten aus dem Bestand der Münchner Stadtbibliothek und dem 
Münchner Stadtarchiv

b) um Speisekarten, die von Münchner Restaurants zur Verfügung gestellt werden

erweitert werden. Sowohl die genannten Institutionen als auch Münchner 
Restaurants, die im Datenbestand vertreten sind und heute noch existieren, 
wurden bereits kontaktiert.

Für die Beantwortung der oben aufgeworfenen Forschungsfragen gilt es künftig, 
die Annotation fortzuführen und um weitere Kategorien (z.B. „Vegetarisches 
Gericht“) zu erweitern. Hierfür erscheint uns der Einbezug der „Crowd“ 
unersetzlich. Um dies zu ermöglichen, werden die Daten auf der 
Transkribus-Plattform für die Bearbeitung öffentlich zugänglich gemacht. Im Zuge 
der Bearbeitung hat das Projektteam bereits weitere Ideen entwickelt: 
Perspektivisch könnten beispielsweise die jeweils aktuellen Wetterdaten für 
München in die Menüvorschläge einbezogen werden („Es ist ein sonniger 
Frühlingstag in München – wie wäre es mit einem ~“).

## Nachhaltigkeitskonzept

Die "Schmankerl Time Machine" ist integriert in das Digital Humanities Virtual 
Laboratory (DHVLab), eine digitale Lehr- und Forschungsinfrastruktur für die 
Geisteswissenschaften der Ludwig-Maximilians-Universität München. Nachhaltigkeit 
ist uns ein besonders wichtiges Anliegen. Sämtliche Abbildungen der Speisekarten 
sowie die im Projekt entstandenen Daten werden im Forschungsdatenrepositorium 
der LMU München (OpenData LMU) dauerhaft und mittels einer DOI eindeutig 
referenzierbar abgelegt: https://doi.org/10.5282/ubm/data.146. Die Beschreibung 
des Projekts im Metadatenschema DataCite ermöglicht künftig die Einbindung in 
übergeordnete Forschungsinfrastrukturen (z.B. GeRDI) und führt zu einer 
leichteren Auffindbarkeit der Daten.
