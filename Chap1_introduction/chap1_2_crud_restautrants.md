# Commandes CRUD avec Mongo

## Création d'une base de données

Pour créer une nouvelle base de données taper la ligne de commande suivante :

```bash
mongo
> use school
```

Si vous avez installé Robo 3T vous pouvez également créer la base de données à l'aide de cet outils.

## Insertion de données

Création la collection authors dans la base de données movies

```js
db.createCollection("authors")
```

Insérer une donnée ou plusieurs données en même temps à l'aide de la méthode **insert** :

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

### Installez les données d'exemple

Pour la suite du cours nous installons les données suivante.

Récupérez la source des données dans un dossier DataExamples :

https://raw.githubusercontent.com/mongodb/docs-assets/primer-dataset/primer-dataset.json

Dans le dossier DataExamples lancez dans la console mongo puis tapez la ligne de commande qui suit :

--db pour donner un nom à votre base de données.
--collection indique le nom de votre collection
--file indique le nom du fichier à intégrer dans la base de données
--drop supprimera au préalable les collections existantes.

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

Un document Mongo est un **BJSON** c'est un JSON avec en plus des types pré-définis par Mongo. De plus chaque document Mongo possède une propriété _id dont la valeur est unique.

Pour faire une sauvegarde d'une collection au format BJSON vous tapez la ligne de commande suivante, la sauvegarde sera faite dans un dossier dump :

```bash
mongodump --collection restaurants --db ny
```

### Filtrage

Exemple de filtres classiques :

```js
// plus grand que
$gt, $gte

// Plus petit que
$lt, $lte

```

D'autres filtres :

```js
// différent de
$ne
"number" : {"$ne" : 10}

// fait partie de 
$in, $nin 
"notes" : {"$in" : [10, 12, 15, 18] }
"notes" : {"$nin" : [10, 12, 15, 18] }

// Ou
$or
"notes : { "$or": [{"$gt" : 10}, {"$lt" : 5} ] }
// and
$and

"notes : { "$and": [{"$gt" : 10}, {"$lt" : 5} ] }

// négation
$not
"notes" : {"$not" : {"$lt" : 10} }

// existe
$exists
"notes" : {"$exists" : 1}

// test sur la taille d'une liste
$size
"notes" : {"$size" : 4}

// element match

/*
{
                           
    "content" : [
        { "name" : <string>, year: <number>, by: <string> } 
        ...
    ]
}
*/


{ "content": { $elemMatch: { "name": "Turing Award", "year": { $gt: 1980 } } } }

// recherche avec une Regex 
$regex
{ "name": { $regex: /^A/ } }

```

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
WHERE borough = "Brooklyn" 
AND ( `name` LIKE '/^B/' OR `name` LIKE '/^W/')
```

Mongo permet de construire facilement des requêtes pour extraire des données.

## Exercice compter le nombre de restaurants

Sans utiliser la méthode count dans un premier temps comptez le nombre de restaurants dans le quartier de Brooklyn. Puis comparez le résultat avec la méthode count.
