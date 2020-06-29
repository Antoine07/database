# Commandes CRUD avec Mongo

## Installation et mise en place des données

Créez la base de données suivante, pensez à lancer votre serveur avant :

```bash
mongo
> use movies
```

Vous pouvez également lancer votre outils graphique Robo 3T.

## Création d'une collection

Création d'une collection authors :

```js
db.createCollection("authors")
```

## Installez les données d'exemple

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

Mongo est un DSL domain-specific language. Mongo n'utilise pas le paradigme SQL.

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
    { "sale" : true, "price" : 0.99, "society" : "Alex", type: "postcard", qty: 19, size: { h: 11, w: 29, uom: "cm" }, status: "A", tags: ["blank", "blank", "blank"], "year" : 2019  },
    { "sale" : false, "price" : 1.99, "society" : "Alan", type: "journal", qty: 25, size: { h: 14, w: 21, uom: "cm" }, status: "A", tags: ["blank", "red", "blank", "blank"], "year" : 2019  },
    { "sale" : true, "price" : 1.5, "society" : "Albert", type: "notebook", qty: 50, size: { h: 8.5, w: 11, uom: "in" }, status: "A",  tags: ["gray"], year : 2019 },
    { "sale" : true, "price" : 7.99, "society" : "Alice", type: "lux paper", qty: 100, size: { h: 8.5, w: 11, uom: "in" }, status: "D", year : 2020 },
    { "sale" : true, "price" : 2.99, "society" : "Sophie", type: "planner", qty: 75, size: { h: 22.85, w: 30, uom: "cm" }, status: "D", tags: ["gel", "blue"], year : 2017 },
    { "sale" : false, "price" : 0.99, "society" : "Phil", type: "postcard", qty: 45, size: { h: 10, w: 15.25, uom: "cm" }, status: "A", tags: ["gray"], year : 2018 },
    { "sale" : true, "price" : 4.99, "society" : "Nel", type: "journal", qty: 19, size: { h: 10, w: 21, uom: "cm" }, status: "B", tags: ["blank", "blank", "blank", "red"], "year" : 2019, level : 100  },
    { "sale" : true, "price" : 4.99, "society" : "Alex", type: "journal", qty: 15, size: { h: 17, w: 20, uom: "cm" }, status: "C", tags: ["blank"], "year" : 2019  },
    { "sale" : false, "price" : 5.99, "society" : "Tony", type: "journal", qty: 100, size: { h: 14, w: 21, uom: "cm" }, status: "B", tags: ["blank","blank", "blank", "red"], "year" : 2020  },
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


## Filtrage

Nous avons déjà rencontré les filtres suivants :

```js
// plus grand que
$gt, $gte

// Plus petit que
$lt, $lte

```

Vous avez également les filtres suivants :

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

## Retourner uniquement certains champs

Vous pouvez également retourner que certains champs du document à l'aide de la syntaxe suivante :

```js
db.students.find(
   { },
   { "type" : 1, "society" : 1 }
)

```

## Modification du curseurs

Vous pouvez également utiliser les méthodes suivantes :

```js
// retourne la collection à partir du 6 documents
db.students.find().skip( 5 )
// limite le nombre de documents
db.students.find().limit( 5 )
```

Les méthodes combinées suivantes modifiants le curseur sont équivalentes :

```js
db.students.find().sort( { name: 1 } ).limit( 5 )
db.students.find().limit( 5 ).sort( { name: 1 } )
```

Une fonction d'agrégation utile également est la méthode count qui retourne le nombre de document dans une collection :

```js
db.students.count()
```

Cette fonction d'aggrégation peut évidemment être combinée à une restriction :
```js
db.restaurants.find({borough :"Brooklyn"}).count()
```

## Projection

Le deuxième paramètre de la fonction find permet de définir une projection. Ici on n'affichera le nom des sociétés, projection qui ont un prix égale à 0.99, restriction.

```js
db.inventory.find({"price" : 0.99}, {"society": 1})
```

Notez que si utilisez la valeur 0 à la place de 1 alors vous excluez ce champ mais vous récupérez alors tous les autres :

```js
db.inventory.find({"price" : 0.99}, {"society": 0})
```

La structure d'une requête avec find ou findOne est donc :

```js
db.collection.findOne(query, projection)
```

Notez que si vous souhaitez un affichage plus élégant en console vous pouvez utiliser l'option pretty à votre recherche :

```js
db.collection.findOne(query, projection).pretty()
```

## Mettre à jour un document dans une collection

Repartons de la collection inventory la méthode updateOne permet de mettre le premier document pour lequel le critère de recherche est trouvé à jour.

```js

db.inventory.insertMany( [
    { "sale" : true, "price" : 0.99, "society" : "Alex", type: "postcard", qty: 19, size: { h: 11, w: 29, uom: "cm" }, status: "A", tags: ["blank", "blank", "blank"], "year" : 2019  },
    { "sale" : false, "price" : 1.99, "society" : "Alan", type: "journal", qty: 25, size: { h: 14, w: 21, uom: "cm" }, status: "A", tags: ["blank", "red", "blank", "blank"], "year" : 2019  },
    { "sale" : true, "price" : 1.5, "society" : "Albert", type: "notebook", qty: 50, size: { h: 8.5, w: 11, uom: "in" }, status: "A",  tags: ["gray"], year : 2019 },
    { "sale" : true, "price" : 7.99, "society" : "Alice", type: "lux paper", qty: 100, size: { h: 8.5, w: 11, uom: "in" }, status: "D", year : 2020 },
    { "sale" : true, "price" : 2.99, "society" : "Sophie", type: "planner", qty: 75, size: { h: 22.85, w: 30, uom: "cm" }, status: "D", tags: ["gel", "blue"], year : 2017 },
    { "sale" : false, "price" : 0.99, "society" : "Phil", type: "postcard", qty: 45, size: { h: 10, w: 15.25, uom: "cm" }, status: "A", tags: ["gray"], year : 2018 },
    { "sale" : true, "price" : 4.99, "society" : "Nel", type: "journal", qty: 19, size: { h: 10, w: 21, uom: "cm" }, status: "B", tags: ["blank", "blank", "blank", "red"], "year" : 2019, level : 100  },
    { "sale" : true, "price" : 4.99, "society" : "Alex", type: "journal", qty: 15, size: { h: 17, w: 20, uom: "cm" }, status: "C", tags: ["blank"], "year" : 2019  },
    { "sale" : false, "price" : 5.99, "society" : "Tony", type: "journal", qty: 100, size: { h: 14, w: 21, uom: "cm" }, status: "B", tags: ["blank","blank", "blank", "red"], "year" : 2020  },
]);
```

Remarque si vous souhaitez supprimer les documents vous pouvez tapez la ligne de code suivante :

```js
db.inventory.remove({})
```

- Exemple de modification avec la méthode updateOne

Structure : 

- critère de recherche

- Modification avec l'opérateur set

Supposons que l'on veuille mettre à jour le premier document dont le status est D. Nous changeons dans cet exemple les valeurs pour la propriété size et notifions à Mongo une date de modification pour ce document.

Mongo ne crée pas de document en plus si le critère de recherche ne trouve aucune  correspondance :

```js
db.inventory.updateOne(
   { status: "B" },
   {
     $set: { "size.uom": "cm", status: "X" },
     $currentDate: { lastModified: true }
   }
)
```

Vous pouvez ajouter une option afin de préciser que vous souhaitez ajouter le document si celui-ci n'est pas trouvé :

```js
db.inventory.updateOne(
   { status: "XXX" },
   {
     $set: { "size.uom": "cm", status: "SUPER" },
     $currentDate: { lastModified: true }
   },
    {"upsert": true}
)
```

Un nouveau document sera alors ajouté :

```js
db.inventory.find({}, { status : 1 })
 // { "_id" : ObjectId("5ef43c659c3a4c119caf7ef5"), "status" : "SUPER" }
```

Vous pouvez également mettre à jour un document à l'aide des méthodes suivantes :

collection.updateMany()

Voici un dernier exemple qui vous permettra d'écrire de l'algorithmique dans une requête plus facilement :

```js
const query = {status : "A"};
const update = { "$mul": { "qty": 10 } };
const options = { "upsert": false }

const updateInventory = (query, update, options) => db.inventory.updateMany(query, update, options) ;

updateInventory(query, update, options);

```

## Exercice avec forEach

Rappelons la structure du forEach de Mongo que vous pouvez appliquer à un find :

```js
db.collection.find().forEach(<function>)
```

1. En utilisant la fonction forEach et la fonction find augmentez de 50% la quantité de chaque document qui a un status C ou D.

2. Augmentez maintenant de 150% les documents ayant un status A ou B et au moins 3 blanks dans leurs tags.

## Méthode unset

Vous pouvez également supprimer un champ d'un document à l'aide de l'opérateur unset, ci-dessous on supprime les champs qty et status du premier document qui match avec status recherché :

```js
db.inventory.updateOne(
   { status: "XXX" },
   { $unset: { qty: "", status: "" } },
    {"upsert": true}
)
```

Notez que vous pouvez également ajouter un champ avec l'opérateur set :

```js


db.inventory.updateMany(
    { tags : { $exists : true }} ,
    { $set: { super : "super" } }
 )

 ```

## Exercice suppression d'un champ

Dans la collection inventory il y a un champ level qu'il faut supprimer, aidez-vous de l'opérateur unset pour effectuer cette mise à jour.

Vérifiez avec Mongo que le champ est bien supprimé.


## Opérateur switch

Vous pouvez avec Mongo utiliser un opérateur switch afin de modifier un document :

```js
   $switch: {
      branches: [
         { case: { $eq: [ 0, 5 ] }, then: "equals" },
         { case: { $gt: [ 0, 5 ] }, then: "greater than" },
         { case: { $gt: [ { $size :  "$notes" } , 2  ], then: "less than" }
      ],
      default : "nothing"
   }
}
```

Attention cependant au fait suivant : Dès que Mongo rentre dans un cas pour modifier une propriété le switch case s'arrête.

## Exercice switch

Vous pouvez sur un champ particulier compter le nombre d'élément(s) à l'aide de l'opérateur **size**, dans ce cas le champ sur lequel vous compterez sera pré-fixé par un dollar. Ci-dessous en supposant que tags soit un tableau on compte son nombre d'élément(s).

```js
{ $size :  "$tags" }
```

Ajoutez une propriété **grade** au document inventory pour les documents ayant la propriété tags uniquement. Cette propriété prendra les valeurs suivantes selon le nombre de tags présents :

- si le nombre de tags est strictement supérieur à 2 : A
- si le nombre de tags est strictement supérieur à 3 : AA
- Et B sinon.

Pensez également au fait qu'à chaque fois que Mongo "match" avec une condition il sort du switch/case.


## db.collection.deleteOne

La méthode suivante permet de supprimer un document :

```js
 db.orders.deleteOne( { "_id" : ObjectId("563237a41a4d68582c2509da") } );
```

Vous pouvez également supprimer des documents selon des conditions précises. Dans l'exemple qui suit on supprime le premier document.

### Exercice d'application

```js

db.inventory.insertOne( {
   name : "Test sur les dates",
   creationts: ISODate("2020-06-27T08:41:57.114Z"),
   expiryts: ISODate("2020-08-27T08:41:57.114Z")
})
```

Pour récupérez le dernier document insérer tapez la ligne de commande suivante :

```js
db.inventory.find().sort({_id: -1}).limit(1);
```

Maintenant supprimez ce document en fonction de sa date d'expiration :

```js
db.inventory.deleteOne( { "expiryts" : { $lte: ISODate("2020-08-27T08:41:57.114Z") } } );
```

Vérifiez que ce document est bien supprimé de la collection.

## db.collection.deleteMany

Cette méthode est structurée de la même manière que la précédente et permet de supprimer tous les documents répondant au critère.

## Exercice synthèse

1. Créez un champ **created_at** et **expired_at** pour chaque document de la collection inventory. 

Vous utiliserez la méthode ISODate de Mongo et Date de JS pour générer des dates aléatoires.

Notez que ISODate est basée sur l'UTC, si vous écrivez new Date() ou ISODate Mongo affichera dans tous les cas une ISODate. Le décallage de date peut s'effectuer à l'aide de la méthode getTime :

```js
// Pour un jour 
// 1 x 24 hours x 60 minutes x 60 seconds x 1000 milliseconds
let day = 1*24*60*60*1000 

// Ajoute un jour à la date actuel
new Date( ISODate().getTime() + day )
```

2. Ajoutez un champ qui calcule le nombre de jours qui reste avant la suppression du document.

Vous utiliserez les opérateurs suivants, notez que la différence sera données en millième de secondes.

```js
// Pour faire une différence entre les dates
$subtract

// Pour calculer le nombre de jour
$divide 

```