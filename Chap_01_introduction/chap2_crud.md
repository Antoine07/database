# Commandes CRUD avec Mongo

## Installation et mise en place des données

Créez la base de données suivante, pensez à lancer votre serveur avant :

```bash
mongo
> use movies
```

## Création d'une collection

Création d'une collection authors :

```js
db.createCollection("authors")
```

## Installez les données d'exemple

Récupérez la source des données dans un dossier sources :

https://raw.githubusercontent.com/mongodb/docs-assets/primer-dataset/primer-dataset.json


Dans le dossier source dans une console tapez la ligne de commande suivante :

```bash
# Import de données csv dans une base de données que l'on va créer train
mongoimport --db ny --collection restaurants --file primer-dataset.json --drop

```

Vérifiez que vos données sont bien importez :

```bash
show dbs

use ny

show collections
restaurants
```

## Insertion de données

La méthode permet l'insertion d'un document ou plusieurs :

```js
// Un seul document
db.authors.insert(
   {
    "name": "Alan",
    "grade": "master 5",
     "notes": [11, 20,18,19],
      "status": "A++"
    }
)

// Plusieurs dans un tableau
db.authors.insert([
   {
    "name": "Alan",
    "grade": "master 5",
     "notes": [11, 20,18,19],
      "status": "A++"
    },
    {
    "name": "Alice",
    "grade": "master 4",
     "notes": [11, 17,19, 13],
      "status": "A+"
    },
]
)
```

Remarques : si on ne précise pas de propriété _id dans le document alors Mongo la crée et un ObjectId est créé (hash unique pour identifier le document dans la collection). De plus si la collection n'extiste pas elle est créée.

Les méthodes **insertMany** et **insertOne** permettent respectivement d'insérer un document unique ou plusieurs.

Vous pouvez également spécifier la propriété _id lors de la création mais, attention elle doit être unique sinon Mongo vous empêchera d'écraser l'ancien document :

```js
db.authors.insert(
    { "_id" : ObjectId("5063114bd386d8fadbd6b004"), "name" : "Naoudi", "grade" : "master 5" }
)
```

Vous pouvez créer votre propre _id avec une valeur de type scalaire. Nous rappelons que les variables scalaires sont celles qui contiennent des numériques, des chaînes de caractères ou des booléens. Attention les types array, object et resource ne sont pas scalaires, ils sont mutables. Un identifiant doit être unique et non mutable.

- Précisions sur l'objet ObjectId de Mongo.

ObjectId est codé sur 12 bytes

- 4 bytes représentant le timestamp courant (nombre de secondes depuis epoch).
- 3 bytes pour idenfitication de la machine
- 2 bytes pour représenter l’identifiant du processus
- 3 bytes qui représentent un compteur qui démarre à un numéro aléatoire

Essayez dans la console de tapez la ligne de code suivante :

```js
const _id = ObjectId()
print(_id)
// ObjectId("5eef0c14591a8edc333898dd")
print(_id.getTimestamp())
// Sun Jun 21 2020 09:28:20 GMT+0200 (CEST)
```

La méthode insertMany :

```js
try {
   db.authors.insertMany( [
     {
    "name": "Alan",
    "grade": "master 5",
     "notes": [11, 20,18,19],
      "status": "A++"
    },
    {
    "name": "Alice",
    "grade": "master 3",
     "notes": [20, 18, 11, 13],
      "status": "A+"
    }
   ] );
} catch (e) {
   print(e);
}
```

Méthode insertOne :

```js
   db.authors.insertOne( { name: "Bernard", grade: "professor" } );
} catch (e) {
   print (e);
};
```

## Méthode find lecture des données

Pour les exemples suivants connectez-vous à la base de données ny que nous avons créée au début du chapitre :

```js
use ny
```

La méthode find permet de lire les documents dans une collection, elle ne vous retournera que 20 documents au maximun par défaut :

```js
db.restaurants.find()
```

Pour lire un document vous pouvez utiliser le curseur de la méthode find :

```js
const resCursor1 = db.restaurants.find();

while (resCursor1.hasNext()) {
   print(tojson(resCursor1.next()));
}
```

Avec la méthode foreEach :

```js

const resCursor2 =  db.restaurants.find(  );

resCursor2.forEach(printjson);

```

Vous pouvez également récupérez l'ensemble des documents dans un array :

```js
const resCursor3 = db.restaurants.find(   );
const resArray = resCursor3.toArray();
print( resArray[3].name );
```

## Sélectionner des données

L'instruction suivante correspond à un SELECT * FROM restaurants en SQL :

```js
db.restaurants.find( {} )
```

En SQL on peut faire des sélections :

```sql
SELECT * FROM restaurants WHERE cuisine = "Delicatessen"
```

En Mongo cela donnerait :

```js
db.inventory.find( { cuisine: "Delicatessen" } )

```

### Opérateur IN

Vous pouvez également utiliser les query operators comme dans l'exemple suivant, ici on chercher a sélectionner les types de cuisines Delicatessen ou American :

```js
db.inventory.find( { cuisine: { $in [ "Delicatessen", "American" ] } } )

```

Cet opérateur est équivalent à l'opérateur IN de SQL.

### Opérateurs AND et OR

On peut également utiliser un opérateur logique ET comme suit :

```js
db.restaurants.find( { "borough" : "Brooklyn", "cuisine" : "Hamburgers" } )

```

La syntaxe de l'opérateur OR s'écrira :

```js
// { $or: [ { <expression1> }, { <expression2> }, ... , { <expressionN> } ] }

// Exemple sur la table authors
db.authors.find( { $or: [ { name: "Alan" }, { name: "Alice" } ] } )
```

Voici un exemple de condition logique en utilisant OR et AND. Remarquez le deuxième argument de la méthode find, il permet de faire une projection, c'est-à-dire de sélectionner uniquement certaine(s) propriété(s) du document :

```js

db.restaurants.find( {
     borough: "Brooklyn",
     $or: [ { name: /^B/ }, { name : /^W/} ]
}, {"name" : 1, "borough" : 1} )

```

Cela correspondrait en SQL à la requête suivante :

```sql
SELECT
`name`,
borough
FROM restaurants
WHERE borough = "Brooklyn" AND ( `name` LIKE '/^B/' OR `name` LIKE '/^W/')
```

Mongo permet de construire facilement des requêtes pour extraire des données.

## Exercice compter le nombre de restaurants

Sans utiliser la méthode count dans un premier temps comptez le nombre de restaurants dans le quartier de Brooklyn. Puis comparez le résultat avec la méthode count.

## Exercices répondre aux questions suivantes

Pour les exercices suivants créer un fonction de type curseur :

```js
const myCursor = args => db.collection.find(args)
```

Utilisez également la méthode sort quand c'est nécessaire pour trier vos résultats :

```js
const myCursor = args => db.collection.find(args).sort({key : 1})
```

Créez une base de données **shop** et insérez les données suivantes :

```js
db.inventory.insertMany( [
    { "sale" : true, "price" : 0.99, "society" : "Alex", type: "postcard", qty: 19, size: { h: 11, w: 29, uom: "cm" }, status: "A", tags: ["blank"], "year" : 2019  },
    { "sale" : false, "price" : 1.99, "society" : "Alan", type: "journal", qty: 25, size: { h: 14, w: 21, uom: "cm" }, status: "A", tags: ["blank", "red"], "year" : 2019  },
    { "sale" : true, "price" : 1.5, "society" : "Albert", type: "notebook", qty: 50, size: { h: 8.5, w: 11, uom: "in" }, status: "A",  tags: ["gray"], year : 2019 },
    { "sale" : true, "price" : 7.99, "society" : "Alice", type: "lux paper", qty: 100, size: { h: 8.5, w: 11, uom: "in" }, status: "D", year : 2020 },
    { "sale" : true, "price" : 2.99, "society" : "Sophie", type: "planner", qty: 75, size: { h: 22.85, w: 30, uom: "cm" }, status: "D", tags: ["gel", "blue"], year : 2017 },
    { "sale" : false, "price" : 0.99, "society" : "Phil", type: "postcard", qty: 45, size: { h: 10, w: 15.25, uom: "cm" }, status: "A", tags: ["gray"], year : 2018 },
    { "sale" : true, "price" : 4.99, "society" : "Nel", type: "journal", qty: 19, size: { h: 10, w: 21, uom: "cm" }, status: "B", tags: [, "red"], "year" : 2019  },
    { "sale" : true, "price" : 4.99, "society" : "Alex", type: "journal", qty: 15, size: { h: 17, w: 20, uom: "cm" }, status: "C", tags: ["blank"], "year" : 2019  },
    { "sale" : false, "price" : 5.99, "society" : "Tony", type: "journal", qty: 100, size: { h: 14, w: 21, uom: "cm" }, status: "B", tags: ["blank", "red"], "year" : 2020  },
]);

```

1. Affichez tous les articles de type journal. Et donnez la quantité total de ces articles (propriété qty).

2. Affichez les noms de sociétés depuis 2018 ainsi que leur quantité.

3. Affichez les types des articles pour les sociétés dont le nom commence par A.

Vous utiliserez une expression régulière classique : /^A/

4. Affichez le nom des sociétés dont la quantité d'article est supérieur à 45.

Utilisez les opérateurs supérieur ou inférieur :

```js
// supérieur >=
// {field: {$gte: value} }

// supérieur
// {field: {$gt: value} }

// inférieur <=
// {field: {$lte: value} }

// inférieur <
// {field: {$lt: value} }

```

5. Affichez le nom des sociétés dont la quantité d'article est strictement supérieur à 45 et inférieur à 90.

6. Affichez le nom des sociétés dont le statut est A ou le type est journal.

7. Affichez le nom des sociétés dont le statut est A ou le type est journal et la quantité inférieur strictement à 100.

8. Affichez le type des articles qui ont un prix de 0.99 ou 1.99 et qui sont true pour la propriété sale ou ont une quantité strictement inférieur à 45.

9. Affichez le nom des scociétés et leur(s) tag(s) lorsque ces dernières possèdent des tags.

Vous pouvez utiliser l'opérateur d'existance de Mongo sur une propriété, il permet de sélectionner ou non des documents :

```js
{ field: { $exists: <boolean> } }
```

10. Affichez le nom des sociétés qui ont le tag blank.

## Projection

Le deuxième paramètre définie une projection, ici on souhaite n'afficher que le nom des sociétés qui ont un prix égale à 0.99

```js
db.inventory.find({"price" : 0.99}, {"society": 1})
```