# METEOHACK2019_ECOFORCE


Notre premier script permet de télécharger automatiquement des données du datamart dans R en interaggisant avec l'utilisateur. Les données sont transformées vers un format directement utilisable dans R. Nous avons pour l'instant inclut les données annuelles pour TMAX, TMIN, TMEAN et PCP. Nous permettons également à l'utilisateur de télécharger automatiquement des données d'altitude et de vent, ainsi que des données biologiques (pour l'instant il s'agit des données de l'inventaire forestier canadien, disponibles sur open.canada.ca/data

Notre deuxième script est simplement de la manipulation de données en vue de l'illustration d'une utilisation du pont entre R et ECCC/MSC (et open.canada) que nous avons créé.

Notre troisième script comprend du code de modélisation qui utilise les données créées précédemment.

Les deux derniers scripts sont les script server et user interface utilisés pour créer l'application Shiny qui pourra être utiliser sur un serveur: https://ecoforce.shinyapps.io/METEOHACK2019_ECOFORCE/

