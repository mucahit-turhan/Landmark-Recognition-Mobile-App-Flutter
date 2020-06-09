# -*- coding: utf-8 -*-

import sys
import numpy as np
import pandas as pd
from keras.preprocessing.image import ImageDataGenerator
from keras.models import load_model
from PIL import Image
import mysql.connector
import os

def main(argv):
    imageName = sys.argv[1]
    script_dir = os.path.dirname(__file__)
    
    subimage_path = "savedimages/"+imageName
    image_path = os.path.join(script_dir, subimage_path)
    
    submodel_path = "model/test3.h5"
    model_path = os.path.join(script_dir, submodel_path)
    
    model = load_model(model_path)
    img = Image.open(image_path)
    img = img.resize((128,128))
    img = np.array(img)
    img = img / 255.0
    img = img.reshape(1,128,128,3)
    pred_probab=model.predict(img)
    result = np.argmax(pred_probab, axis=1)
    
    name = ""
    city = ""
    info = ""
    url = ""
    id = 0

    if(result == 0):
        name = ""
        city = ""
        info = ""
        url = ""
        id = 10026
    elif(result == 1):
        name = "Quay of the Rosary (Rozenhoedkaai)"
        city = "Brugge"
        info = "Quay of the Rosary is one of the most beautiful sights of this Belgian city with its canals and classic buildings. For centuries, this street along the reie carried the name Zoutdijk. In 1390 it was mentioned that the salt estuary at Eechoutte. So it was perhaps there that a jetty lay where the ships that supplied salt were unloaded. The Rozenhoedkaai was not used as a name until the 18th century. The reason was that there were stalls selling rosaries on that spot. Why in some cases 'quay' or 'dyke' was chosen over the more commonly used word 'rei' has not been investigated by the linguists. It is along Rozenhoedkaai that Georges Rodenbach made the main character live in his story in his Bruges-la-Morte. The Rozenhoedkaai runs from the Dijver to the Braambergstraat. The Rozenhoedkaai is also the most photographed point in Bruges"
        url = "https://visit-bruges.be/see/places-interest/quay-rosary-rozenhoedkaai"
        id = 10045
    elif(result == 2):
        name = "Itsukushima Shrine"
        city = "Itsukushima"
        info = "Itsukushima Shrine (厳島神社, Itsukushima-jinja) is a Shinto shrine on the island of Itsukushima (popularly known as Miyajima), best known for its floating torii gate.[1] It is in the city of Hatsukaichi in Hiroshima Prefecture in Japan. The shrine complex is listed as a UNESCO World Heritage Site, and the Japanese government has designated several buildings and possessions as National Treasures. The Itsukushima shrine is one of Japan's most popular tourist attractions. It is most famous for its dramatic gate, or torii on the outskirts of the shrine,[2] the sacred peaks of Mount Misen, extensive forests, and its aesthetic ocean view.[1][3] The shrine complex itself consists of two main buildings: the Honsha shrine and the Sessha Marodo-jinja, as well as 17 other different buildings and structures that help to distinguish it.[3] The complex is also listed as a UNESCO World Heritage Site, and six of its buildings and possessions have been designated by the Japanese government as National Treasures."
        url = "https://en.wikipedia.org/wiki/Itsukushima_Shrine"
        id = 10184
    elif(result == 3):
        name = "Falkirk Wheel"
        city = "Falkirk"
        info = "The Falkirk Wheel is a rotating boat lift in central Scotland, connecting the Forth and Clyde Canal with the Union Canal. The lift is named after Falkirk, the town in which it is located. It reconnects the two canals for the first time since the 1930s. It opened in 2002 as part of the Millennium Link project. The plan to regenerate central Scotland's canals and reconnect Glasgow with Edinburgh was led by British Waterways with support and funding from seven local authorities, the Scottish Enterprise Network, the European Regional Development Fund, and the Millennium Commission. Planners decided early on to create a dramatic 21st-century landmark structure to reconnect the canals, instead of simply recreating the historic lock flight. "
        url = "https://en.wikipedia.org/wiki/Falkirk_Wheel"
        id = 10932
    elif(result == 4):
        name = "Cabo de Gata-Níjar Natural Park"
        city = "Almería"
        info = "Cabo de Gata-Níjar Natural Park in the southeastern corner of Spain is Andalusia's largest coastal protected area, a wild and isolated landscape with some of Europe's oldest geological features. Spain's southeast coast, where the park is situated, is the only region in mainland Europe with a true hot desert climate (Köppen climate classification: BWh). The eponymous mountain range of the Sierra del Cabo de Gata, with its highest peak El Fraile, form Spain's largest volcanic rock formation with sharp peaks and crags in red and ochre hues. It falls steeply to the Mediterranean Sea, creating jagged 100-metre (330 ft) high cliffs riven by gullies, creating hidden coves and white, sandy beaches."
        url = "https://en.wikipedia.org/wiki/Cabo_de_Gata-Níjar_Natural_Park"
        id = 11249
    elif(result == 5):
        name = ""
        city = ""
        info = ""
        url = ""
        id = 12172
    elif(result == 6):
        name = ""
        city = ""
        info = ""
        url = ""
        id = 12718
    elif(result == 7):
        name = "Luxor Las Vegas"
        city = "Las Vegas"
        info = "Luxor Las Vegas is a 30-story hotel and casino situated on the southern end of the Las Vegas Strip in Paradise, Nevada. The hotel is owned and operated by MGM Resorts International and has a 120,000-square-foot (11,000 m2) casino with over 2,000 slot machines and 87 table games. The casino opened in 1993 and was renovated and expanded several times.[3] The 1998 renovation work modernized the design of the property and raised the hotel's capacity to 4,407 rooms, including 442 suites. The hotel's rooms line the interior walls of the main tower, which has a pyramid shape, and other recent 22-story twin ziggurat towers. The hotel is named for the city of Luxor (ancient Thebes) in Egypt. "
        url = "https://en.wikipedia.org/wiki/Luxor_Las_Vegas"
        id = 13170
    elif(result == 8):
        name = "Pont au Change - Paris bridge"
        city = "Paris"
        info = "The Pont au Change is a bridge over the Seine River in Paris, France. The bridge is located at the border between the first and fourth arrondissements. It connects the Île de la Cité from the Palais de Justice and the Conciergerie, to the Right Bank, at the Place du Châtelet."
        url = "https://www.travelfranceonline.com/pont-au-change-paris-bridge-facts/"
        id = 13653
    elif(result == 9):
        name = "Karnak Temple "
        city = "Luxor"
        info = "The temple of Karnak was known as Ipet-isu—or “most select of places”—by the ancient Egyptians. It is a city of temples built over 2,000 years and dedicated to the Theban triad of Amun, Mut, and Khonsu. This derelict place is still capable of overshadowing many wonders of the modern world and in its day must have been awe-inspiring. The complex of temples is near Luxor on the Nile in Egypt About thirty pharaohs contributed to the buildings"
        url = "https://en.wikipedia.org/wiki/Karnak"
        id = 1878
    elif(result == 10):
        name = "Krakow Square"
        city = "Lesser"
        info = "The main square of the Old Town of Kraków, Lesser Poland, is the principal urban space located at the center of the city. It dates back to the 13th century, and at 3.79 ha (9.4 acres) is the largest medieval town square in Europe.The Project for Public Spaces (PPS) lists the square as the best public space in Europe due to its lively street life, and it was a major factor in the inclusion of Kraków as one of the top off-the-beaten-path destinations in the world in 2016."
        url = "https://en.wikipedia.org/wiki/Main_Square,_Kraków"
        id = 2044
    elif(result == 11):
        id = 2338
    elif(result == 12):
        name = "Louise Lake"
        city = "Louise"
        info = "Lake Louise is named after the Princess Louise Caroline Alberta (1848–1939), the fourth daughter of Queen Victoria and the wife of the Marquess of Lorne, who was the Governor General of Canada from 1878 to 1883. The turquoise colour of the water comes from rock flour carried into the lake by melt-water from the glaciers that overlook the lake. The lake has a surface of 0.8 km2 (0.31 sq mi) and is drained through the 3 km long Louise Creek into the Bow River."
        url = "https://en.wikipedia.org/wiki/Lake_Louise_(Alberta)"
        id = 2870
    elif(result == 13):
        name = "Oslo City Hall"
        city = "Oslo"
        info = "Oslo City Hall is a municipal building in Oslo, the capital of Norway. It houses the city council, the city's administration and various other municipal organisations. The building as it stands today was constructed between 1931 and 1950, with an interruption during the Second World War."
        url = "https://en.wikipedia.org/wiki/Oslo_City_Hall"
        id = 3283
    elif(result == 14):
        name = "Rockefeller Center"
        city = "New York City"
        info = "Rockefeller Center is a large complex consisting of 19 commercial buildings covering 22 acres (89,000 m2) between 48th Street and 51st Street in Midtown Manhattan, New York City. The 14 original Art Deco buildings, commissioned by the Rockefeller family, span the area between Fifth Avenue and Sixth Avenue, split by a large sunken square and a private street called Rockefeller Plaza. Later additions include 75 Rockefeller Plaza across 51st Street at the north end of Rockefeller Plaza, and four International Style buildings located on the west side of Sixth Avenue."
        url = "https://en.wikipedia.org/wiki/Rockefeller_Center"
        id = 3497
    elif(result == 15):
        name = "St. Stephen’s Cathedral"
        city = "Vienna"
        info = "St. Stephen's Cathedra is the mother church of the Roman Catholic Archdiocese of Vienna and the seat of the Archbishop of Vienna, Christoph Cardinal Schönborn, OP. The current Romanesque and Gothic form of the cathedral, seen today in the Stephansplatz, was largely initiated by Duke Rudolf IV (1339–1365) and stands on the ruins of two earlier churches, the first a parish church consecrated in 1147. The most important religious building in Vienna, St. Stephen's Cathedral has borne witness to many important events in Habsburg and Austrian history and has, with its multi-coloured tile roof, become one of the city's most recognizable symbols."
        url = "https://en.wikipedia.org/wiki/St._Stephen%27s_Cathedral,_Vienna"
        id = 3804
    elif(result == 16):
        name = "Brisbane"
        city = "Brisbane"
        info = "Brisbane was founded in 1824. It was formerly a criminal colony, and in 1834 the governor of South Wales was named Lord Brisbane. The city, which was a free colonial center in 1842, developed rapidly as a result of the operation of İpswich coal deposits and the transition to agricultural production in the region. The trade center, which was established in a twist of the city's Brisbane river, is surrounded by residential communities and suburbs that can be seen. Various industrial events (food industry, machine building, etc.) are gathered especially on the shore of the estuary. The traffic of the port is around 10 megatons."
        url = "https://en.wikipedia.org/wiki/Brisbane"
        id = 3924
    elif(result == 17):
        name = "Shanghai Tower"
        city = "Shanghai"
        info = "Shanghai Tower is a 632-meter tall 127-story skyscraper in Shanghai, China. With this feature, it is the second tallest building in the world and the third tallest structure. It also has the world's fastest elevator with the highest surveillance deck in a building or building in the world."
        url = "https://en.wikipedia.org/wiki/Shanghai_Tower"
        id = 428
    elif(result == 18):
        name = "Liberty Bell"
        city = "Philadelphia"
        info = "The Liberty Bell, previously called the State House Bell or Old State House Bell, is an iconic symbol of American independence, located in Philadelphia, Pennsylvania. Once placed in the steeple of the Pennsylvania State House, the bell today is located in the Liberty Bell Center in Independence National Historical Park. The bell was commissioned in 1752 by the Pennsylvania Provincial Assembly from the London firm of Lester and Pack (known subsequently as the Whitechapel Bell Foundry), and was cast with the lettering \"Proclaim LIBERTY Throughout all the Land unto all the Inhabitants Thereof\", a Biblical reference from the Book of Leviticus. The bell first cracked when rung after its arrival in Philadelphia, and was twice recast by local workmen John Pass and John Stow, whose last names appear on the bell. In its early years, the bell was used to summon lawmakers to legislative sessions and to alert citizens about public meetings and proclamations."
        url = "https://en.wikipedia.org/wiki/Liberty_Bell"
        id = 5367
    elif(result == 19):
        name = "Peace Palace"
        city = "Den Haag"
        info = "The Peace Palace is an international law administrative building in The Hague, the Netherlands. It houses the International Court of Justice, the Permanent Court of Arbitration, The Hague Academy of International Law and the Peace Palace Library."
        url = "https://en.wikipedia.org/wiki/Peace_Palace"
        id = 6231
    elif(result == 20):
        name = "Tallinn ESTONIA"
        city = "Tallinn"
        info = "Tallinn is the capital, primate and the most populous city of Estonia. Located in the northern part of the country, on the shore of the Gulf of Finland of the Baltic Sea, it has a population of 437,619 in 2020. Administratively a part of Harju maakond (county), Tallinn is the main financial, industrial, cultural, educational and research centre of Estonia. Tallinn is located 80 kilometres (50 mi) south of Helsinki, Finland, 320 kilometres (200 mi) west of Saint Petersburg, Russia, 300 kilometres (190 mi) north of Riga, Latvia, and 380 kilometres (240 mi) east of Stockholm, Sweden. It has close historical ties with these four cities. From the 13th century until the first half of the 20th century Tallinn was known in most of the world by its historical German name Reval."
        url = "https://en.wikipedia.org/wiki/Tallinn"
        id = 7092
    elif(result == 21):
        name = "Town Hall Tower , Krakow"
        city = "Krakow"
        info = "Town Hall Tower in Kraków, Poland  is one of the main focal points of the Main Market Square in the Old Town district of Kraków. The Tower is the only remaining part of the old Kraków Town Hall  demolished in 1820 as part of the city plan to open up the Main Square. Its cellars once housed a city prison with a Medieval torture chamber. In 1967, after a complex conservation which underlined its gothic ancestry, object was given to the Historical Museum in Cracow for management of it."
        url = "https://en.wikipedia.org/wiki/Town_Hall_Tower,_Kraków"
        id = 7172
    elif(result == 22):
        name = "Santa Maria de Montserrat Abbey"
        city = "Barcelona"
        info = "Montserrat, whose name means 'serrated mountain', is ideally located to play an important role in the cultural and spiritual life of Catalonia. It is Catalonia's most important religious retreat and groups of young people from Barcelona and all over Catalonia make overnight hikes at least once in their lives to watch the sunrise from the heights of Montserrat. The Virgin of Montserrat is Catalonia's favourite saint, and is located in the sanctuary of the Mare de Déu de Montserrat, next to the Benedictine monastery nestling in the towers and crags of the mountain. The Escolania, Montserrat’s Boys’ Choir, is one of the oldest in Europe, and performs during religious ceremonies and communal prayers in the basilica."
        url = "https://en.wikipedia.org/wiki/Santa_Maria_de_Montserrat_Abbey"
        id = 7661
    elif(result == 23):
        name = "Stockholm City Hall"
        city = "Stockholm"
        info = "The Stockholm City Hall (Swedish: Stockholms stadshus or Stadshuset locally) is the building of the Municipal Council for the City of Stockholm in Sweden. It stands on the eastern tip of Kungsholmen island, next to Riddarfjärden's northern shore and facing the islands of Riddarholmen and Södermalm. It houses offices and conference rooms as well as ceremonial halls, and the luxury restaurant Stadshuskällaren. It is the venue of the Nobel Prize banquet and is one of Stockholm's major tourist attractions."
        url = "https://en.wikipedia.org/wiki/Stockholm_City_Hall"
        id = 9029
    elif(result == 24):
        name = "Isla de Pascua"
        city = "Hanga Roa"
        info = "Easter Island (Rapa Nui: Rapa Nui, Spanish: Isla de Pascua) is an island and special territory of Chile in the southeastern Pacific Ocean, at the southeasternmost point of the Polynesian Triangle in Oceania. Easter Island is most famous for its nearly 1,000 extant monumental statues, called moai, created by the early Rapa Nui people. In 1995, UNESCO named Easter Island a World Heritage Site, with much of the island protected within Rapa Nui National Park."
        url = "https://es.wikipedia.org/wiki/Isla_de_Pascua"
        id = 9434
    
    print(str(id)+"##"+name+"##"+city+"##"+info+"##"+url)
if __name__ == "__main__":
    main(sys.argv[1:])