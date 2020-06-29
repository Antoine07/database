# Aggrégation

Opérations de pipeline d'agrégation. La méthode aggregate prend une liste d'opérateurs.

```js
// filtre les contenus ~ find
{ $match : {}}

// le second paramètre du find projection
{ $project : {}}

// sort
{ $sort : {}}

// group opérateur d'aggrégation
{ $group : {}}

```

Attention, à l'ordre des opérations vous devez faire la projection après le filtrage.

On peut à titre d'exemple montrer que la méthode aggregate est pour certains opérateurs identiques à la méthode find :

```js
db.restaurants.aggregate([
    { $match : {
        "grades.grade" : "A"
    }},
    {
        $project : {
            "name" : 1, "_id" : 0
        }
    }
])

```

Nous allons donner un exemple de groupement simple, nous allons compter le nombre de restaurants qui font de la cuisine italienne par quartier. Notez bien que la clé désignant le quartier doit commencer par un dollar, en effet pour MongoDB c'est un paramètre variable :

```js
db.restaurants.aggregate([
    {   $match : {
            "cuisine" : "Italian"
        }
    },
    { $group : {"_id" : "$borough", "total" : {$sum : 1}}},
])

/*
{ "_id" : "Queens", "total" : 131 }
{ "_id" : "Bronx", "total" : 52 }
{ "_id" : "Brooklyn", "total" : 192 }
{ "_id" : "Manhattan", "total" : 621 }
{ "_id" : "Staten Island", "total" : 73 }
*/
```

Nous pouvons également organiser la requête en JS de manière plus lisible.

```js
const match = {   $match : {
            "cuisine" : "Italian"
        }
};

const group = { 
    $group : {"_id" : "$borough", "total" : {$sum : 1}}
} ;

db.restaurants.aggregate([
    match,
    group
])
```

## Aggrégation de somme et création d'un nouveau document

Créez une collection **sales** dans MongoDB dans la base de données restaurants.

La syntaxe pour créer une collection est la suivante :

```js
db.createCollection(name, options)

```

Voici à titre d'exemple des prix que l'on souhaite associés à certain de nos restaurants qui seraient à vendre. On définit une collection avec certaines options et un validator qui utilise un schéma pour spécifier le type des champs et les champs éventuellement requis :

```js

db.createCollection("sales", 
    { capped : true, size : 5242880, max : 5000, autoIndexId : true },
    {
        validator : {
            $jsonSchema : {
                bsonType : "object",
                required : ["price"],
                properties : {
                    agency : "string",
                    price : {
                        bsonType : "decimal",
                        description : "must be a number and is required"
                    },
                    date : {
                        bsonType : "date",
                    },
                    restaurant_id : {
                        bsontype : "string"
                    }
                }
            }
        }
    }
)

// Insertion

db.sales.insertMany([
  {  "restaurant_id" : "5e79995fee344ac7b3cde77d", "agency" : "abc" , "price" : NumberDecimal("100000"),  "date" : ISODate("2014-03-01T08:00:00Z") },
  {  "restaurant_id" : "5e79995fee344ac7b3cde784", "agency" : "xyz" , "price" : NumberDecimal("200000"),  "date" : ISODate("2014-03-01T09:00:00Z") },
  { "restaurant_id" : "5e79995fee344ac7b3cde77f", "agency" : "abc" , "price" : NumberDecimal("5000000"),  "date" : ISODate("2014-03-15T09:00:00Z") },
  {  "restaurant_id" : "5e79995fee344ac7b3cde785", "agency" : "uvw" , "price" : NumberDecimal("5000000"),  "date" : ISODate("2014-04-04T11:21:39.736Z") },
  {  "restaurant_id" : "5e79995fee344ac7b3cde788", "agency" : "uvw" , "price" : NumberDecimal("10000000"),  "date" : ISODate("2014-04-04T21:23:13.331Z") },
  {  "restaurant_id" : "5e79995fee344ac7b3cde790", "agency" : "abc" , "price" : NumberDecimal("700000.5"),  "date" : ISODate("2015-06-04T05:08:13Z") },
  {  "restaurant_id" : "5e79995fee344ac7b3cde78a", "agency" : "xyz" , "price" : NumberDecimal("700000.5"),  "date" : ISODate("2015-09-10T08:43:00Z") },
  {  "restaurant_id" : "5e79995fee344ac7b3cde781", "agency" : "abc" , "price" : NumberDecimal("1000000") , "date" : ISODate("2016-02-06T20:20:13Z") },
])

```

Voici comment on peut faire une requête SQL qui compterait le nombre d'items dans la collection ci-dessus :

En SQL :

```sql
SELECT COUNT(*) FROM sales;
```

En MongoDB

```js
db.sales.aggregate( [
  {
    $group: {
       _id: null,
       count: { $sum: 1 }
    }
  }
] )
// affichera
{ "_id" : null, "count" : 8 }
```

## Exercice calculer la somme par agence

- A partir des données ci-dessus calculer le total des prix des restaurants par agence.

- Quelles sont les totaux dans ce regroupement qui sont supérieurs à 950000 ?

Remarques : vous pouvez également appliquer une condition de recherche par regroupement (HAVING) en utilisant l'opérateur suivant après l'opérateur de regroupement :

```js

 { $match : {} }

```

- On aimerait maintenant avoir tous les noms et id des restaurants par type de cuisine et quartier. Limitez l'affichage à deux résultats.

- 1. Affichez maintenant tous les restaurants italiens par quartier. Attention match doit être fait avant votre group.

- 2. Affichez également pour chaque restaurant la moyenne de ses scores. Et ordonnez vos résultats par ordre de moyenne décroissante.

Vous pouvez utiliser l'opérateur suivant pour enregistrer une nouvelle collection à partir d'une recherche données :

```js
{ $out : "top5" }
```

- Faites une requête qui récupère les 5 derniers restaurants par quartier les mieux notés et placez cette recherche dans une collection top5.


## Exercice avec unwind

Cet opérateur permet de récupérer chacune des valeurs d'une clé et d'appliquer un traitement sur celles-ci.


```js
const unwindCuisine = { $unwind : "$grades" } 
```

Calculez la moyenne des scores par type de cuisine.

## Exercice tree structure Algorithmique 

Dans la base de données **bookstore**.

Soit la collection categoriestree suivante.

1. Framework d'aggregation ajoutez une propriété total qui calcul le nombre de livres par document

On vous redonne les données déjà utiliser dans cette base de données :

```js

const categoriestree =
[
   {
      _id: "Books",
      parent: null,
      name: "Informatique"
   },
   {
      _id: "Programming",
      parent: "Books",
      books: [
            "Python apprendre",
            "Pandas & Python",
            "async/await JS & Python"
      ]
   },
   {
      _id: "Database",
      parent: "Programming",
      books: [
            "NoSQL & devenir expert avec la console",
            "NoSQL drivers",
            "SQL"
      ]
   },
   {
      _id: "MongoDB",
      parent: "Database",
      books: [
            "Introduction à MongoDB",
            "MongoDB aggrégation"
      ]
   }
];

db.categoriestree.insertMany(categoriestree);
db.categoriestree.createIndex( { parent: 1 } );
```