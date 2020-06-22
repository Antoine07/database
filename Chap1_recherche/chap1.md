# Mongo

## Installation

Pour une installation sur Mac

```bash

brew tap mongodb/brew
brew install mongodb-community

sudo mkdir -p /data/db

# permissions pour utiliser Mongo
sudo chown -R `id -un` /data/db

# version
mongo --version

# start mongo
mongod
```

## Ajouter un item

En console, puis pour voir quelles sont les bases de données présentent dans Mongo

```bash
mongo

>db
test

# affiche toutes les bases de données
> show dbs
```

## Création d'une base de données

```bash
use movies
```

Dans une base de données on a des collections dans lesquelles il y a des JSON.

### Insertion de données dans une base de données

```bash
db.authors.insert({ name : "Alan"})
show collections
# affiche les données d'une collection
db.authors.find()
```

Et même faire des recherches spécifiques :

```bash
myCursor = db.inventory.find( { status: "D" } )
```

Notez que par défaut MongoDB vous affichera 20 items. Pour afficher tous les items d'une collection vous pouvez par exemple en JS écrire le code suivant :

```js
while (myCursor.hasNext()) {
    print(tojson(myCursor.next()));
}

```

Vous pouvez également importer un ensemble de données :

```bash
db.inventory.insertMany( [
   { "item": "journal", "qty": 25, "size": { "h": 14, "w": 21, "uom": "cm" }, "status": "A" },
   { "item": "notebook", "qty": 50, "size": { "h": 8.5, "w": 11, "uom": "in" }, "status": "A" },
   { "item": "paper", "qty": 100, "size": { "h": 8.5, "w": 11, "uom": "in" }, "status": "D" },
   { "item": "planner", "qty": 75, "size": { "h": 22.85, "w": 30, "uom": "cm" }, "status": "D" },
   { "item": "postcard", "qty": 45, "size": { "h": 10, "w": 15.25, "uom": "cm" }, "status": "A" }
]);

```

### Suppression d'une données

On peut supprimer une collection et même une base de données dans laquelle on se trouve :

```bash
db.authors.drop()
db.dropDatabase()
```

Les données sont des documents JSON dans une base de données Mongo. Le modèle est basé sur un système de clé/valeur. Une valeur peut être un type scalaire : entier, numérique, string, boolean, null, des listes de valeurs, ...

## Binary JSON

MongoDB représente ses JSON sous forme de binaire, ce n'est pas une question de place mais une question d'efficacité pour transverser les collections. Ils sont plus rapides à parser.

## ObjectId

C'est un type de données complexe unique : 4 octets timestamps, 3 octets identifiant machine 2 octets process id et 3 octets compteur propre à Mongo.

```bash
# Récupérer un seul élément
db.authors.findOne()._id

# sous forme d'un string
db.authors.findOne()._id.toString()

# On peut récupérer la date
db.authors.findOne()._id.getTimestamp().toString()

```

## Définir une structure de données pour Mongo

Mongo est une base de données sans schéma. Lorsqu'on crée un document on crée un JSON. Ce dont a besoin Mongo c'est un _id dans son document uniquement. Si on ne le spécifie pas alors MongoDb le créera automatiquement.

Mongo maintiendra l'unicité des identifiants _id.

 - Si vous insérez une nouveau document dans la collection à l'aide de la commande **insert** Mongo vérifiera l'unicité des identifiants.

 - Sinon une autre méthode existe pour mettre à jour upsert et qui insert ou met à jour un document dans une collection, c'est la méthode **save**.

 - Remove :

 ```bash

# La méthode remove permet de supprimer un document spécifique en fonction de son _id ou d'une clé.
db.authors.remove({_id : "...."})

db.authors.remove({name : "Alan"})

# Supprime tous les documents de la collection authors
db.authors.remove({})
 ```

 ## Importer des données d'exemple

 Récupérez à l'adresse suivante les données d'exemple "restaurents" : https://raw.githubusercontent.com/mongodb/docs-assets/primer-dataset/primer-dataset.json

 Dans une console tapez la ligne de commande suivante :

```bash
# Import de données csv dans une base de données que l'on va créer train
mongoimport --db ny --collection restaurants --file primer-dataset.json --drop

```

## Opérations de filtrage

La méthode find permet de faire une recherche dans une collection. Vous pouvez passer un littérale pour spécifier une requête particulière.

Par exemple vous pouvez rechercher les restaurants qui font de la cuisine Italienne dont le code postal est zipcode est 10075 à New York :

```js
db.restaurants.find( { "cuisine": "Italian", "address.zipcode": "10075" })
```

On peut même ajouter la méthode count pour compter le nombre de restaurants :

```js
db.restaurants.find( { "cuisine": "Italian", "address.zipcode": "10075" }).count()
```

### Utilisation d'opérateur arithmétiques sur des clés

Il faut préfixer l'opérateur d'un dollar et l'appliquer sur une clé de la collection :

```js
// Au moins un score inférieur strictement à 7
"grade.score" : { "$lt" : 7 }

// Exactement inférieur strictement à 7
// Au moins inférieur à 7 et pas supérieur ou égale à 7
"grade.score" : { 
    "$lt" : 7,
    "not" : {$gte : 7}
    }
```

Notez que l'opérateur large ce note :

```js
$gte
$lte
```

Un autre type d'opérateur très intéressant est l'appartenance à une liste ou collection :

```js
// dans une liste ou array
$in
// aucune valeur ne doit matcher avec ...
$ne
// matche une fois seulement avec une valeur
$nin
```

Les opérateurs de logique sont également très utile pour combiner les recherche :

```js
$and
$or
$not
```

Vous pouvez également utiliser l'opérateur logique or de Mongo 

```js
db.restaurants.find(
 { $or: [ { "cuisine": "Italian" }, { "address.zipcode": "10075" } ] },
 {"name" : 1, "_id" : 0, "cuisine" : 1, "address.zipcode" : 1}
)
```

### Projection

Vous pouvez également spécifier une projection en complétant une recherche :

```js
{ "name" : 1, "_id" : 0}
```

Et également ne sélectionner qu'un champ unique :

```js
db.restaurants.find({}, {cuisine:1, _id:0})

/*
{ "cuisine" : "Hamburgers" }
{ "cuisine" : "Jewish/Kosher" }
{ "cuisine" : "American" }
{ "cuisine" : "Jewish/Kosher" }
{ "cuisine" : "Delicatessen" }
{ "cuisine" : "American" }
{ "cuisine" : "Ice Cream, Gelato, Yogurt, Ices" }
{ "cuisine" : "American" }
{ "cuisine" : "American" }
{ "cuisine" : "Chinese" }
{ "cuisine" : "American" }
{ "cuisine" : "Jewish/Kosher" }
{ "cuisine" : "American" }
{ "cuisine" : "Ice Cream, Gelato, Yogurt, Ices" }
{ "cuisine" : "Delicatessen" }
{ "cuisine" : "American" }
{ "cuisine" : "American" }
{ "cuisine" : "Delicatessen" }
{ "cuisine" : "Bakery" }
{ "cuisine" : "Ice Cream, Gelato, Yogurt, Ices" }
*/
```

### Exercices sur le filtrage

- Combien y a t il de restaurants qui font de la cuisine italienne et qui ont eu un score de 10 ou moins.
Affichez également le nom, les scores et les coordonnées GPS de ces restaurents. Ordonnez les résultats
par ordre décroissant sur les noms des restaurants.

- Quels sont les restaurants qui ont un grade A avec un score supérieur ou égal à 20 ? Affichez les noms et ordonnez les 
par ordre décroissant. Et donnez le nombre de résultat.

- A l'aide de la méthode distinct trouvez tous les quartiers distincts de NY.

- Trouvez tous les types de restaurants dans le quartiers du Bronx. Vous pouvez là encore utiliser distinct et un deuxième paramètre pour préciser sur quel ensemble vous voulez appliquer cette close :

```js
db.restaurants.distinct('field', {"key" : "value" })
```

- Sélectionnez les restaurants dont le grade est A ou B dans le Bronx.

- Même question mais on aimerait que les restaurants qui on eu à la dernière inspection un A ou B. Vous pouvez utilisez la notion d'indice sur la clé grade :

```js
"grades.2.grade"
```

- Sélectionnez maintenant tous les restaurants qui ont dans leur mot "Coffee" ou "coffee". De même on aimerait savoir si il y en a uniquement dans le Bronx.

-  Trouvez tous les restaurants avec les mots Coffee ou Restaurant et qui ne contiennent pas le mot Starbucks.

- Trouvez tous les restaurants avec les mots Coffee ou Restaurant et qui ne contiennent pas le mot Starbucks dans le Bronx.


## Recherche par rapport à la date

Qu'affiche l'exemple suivant ?

```js
db.restaurants.find({
    "grades.0.date" : ISODate("2013-12-30T00:00:00Z")

}, { "_id" : 0, "name" : 1, "borough" : 1, "grades.date" : 1} )
```

## Optimisation

Une requête peut prendre du temps en Mongo. La méthode explain permet d'avoir des informations sur la requête elle-même.

On peut créer un index pour accélérer la recherche sur une clé ou un groupe de clés. Ci-dessous un créé un index sur le champ name. MongoDB crée alors un arbre binaire de recherche.

```js
db.restaurants.createIndex({ "name" : 1})
```

On peut également supprimer l'index :

```js
db.restaurants.dropIndex({ "name" : 1})
```
