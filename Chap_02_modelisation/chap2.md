# Introduction à la Modélisation 

Le modèle semi-structuré n'est pas soumis aux contraintes de normalisation.

Par exemple un attribut peut avoir plusieurs valeurs avec un tableau :

```js
{
    "title" : "Pulp fiction",
    "genre" : ["Action", "Thriller", "Violent"]
}
```

On peut également représenter des données régulières :

```js
const artists = [
   artist : { "id" : 1, "name" : "De Niro" },
   artist : { "id" : 2, "name" : "Dujardin" },
   artist : { "id" : 3, "name" : "Chaplin" },
]
```

Les données semi-structurées sont appropriées pour des données complexes et qui ont besoin de souplesse.

Avec les données semi-structurées on peut imbriquer les structures pour éviter les jointures du modèle relationel. 

Lorsque vous avez à structurer vos entitées en NoSQL il faudra choisir entre les imbriquer ou utiliser une clé de référence.

## One-to-Many Relationships

Si on a des authors qui ont une ou plusieurs adresses, alors nous avons une relation entre author et address de type OneToMany. En NoSQL vous avez deux approches pour gérer ce cas :

- Soit vous faites deux documents reliés avec une clé "primaire" et "secondaire". Cette approche sera nécessaire si vous avez beaucoup de documents à récupérer.

- Soit vous utilisez l'approche du document imbriqué. Ce cas est particulièrement intéressant si vous avez fréquemment besoin d'interroger ces deux entitées. Cette relation est appelée : Embedded Document Pattern

### Exemple Embedded Document Pattern (OneToMany)

```js
{
   "_id": "joe",
   "name": "Joe Bookreader",
   "addresses": [
        {
            "street": "123 Fake Street",
            "city": "Faketon",
            "state": "MA",
            "zip": "12345"
        },
        {
            "street": "1 Some Other Street",
            "city": "Boston",
            "state": "MA",
            "zip": "12345"
        }
    ]
 }
```

Mais vous pouvez également avoir une approche clé primaire/clé secondaire :

```js
// authors
{
   _id: ObjectId("5ef74d993d4deb402daff427"),
   name: "Joe Bookreader"
}

// addresses
{
   author_id: ObjectId("5ef74d993d4deb402daff427"), 
   street: "123 Fake Street",
   city: "Faketon",
   state: "MA",
   zip: "12345"
}

{
   author_id: ObjectId("5ef74d993d4deb402daff427"),
   street: "1 Some Other Street",
   city: "Boston",
   state: "MA",
   zip: "12345"
}

```

## Exercice notion de jointure

Créez une nouvelle base de données bookstore.

Créez une collection **categories** et une collection **books** :

- categories

```js
const categories = 
[
    { name : "Programmation"},
    { name : "SQL"},
    { name : "NoSQL"}
];
```

- books

```js
const books = [
    { title : "Python"}, // programmation
    { title : "JS" }, // programmation
    {title : "PosgreSQL"}, // SQL
    {title : "MySQL"}, // SQL
    {title : "MongoDB"} // NoSQL
]
```

1. Faites un script JS afin d'associer chaque livre à sa catégorie en utilisant l'id de la catégorie, créez une propriété **categoryId** dans la collection books.

2. Puis faites une requête pour récupérer les livres dans la catégorie programmation.

3. Combien de livre y a t il dans la catégorie NoSQL ? Faites une requête pour répondre à cette question.

4. Nous ajoutons maintenant des nouveaux livres dans la collection books. Ces derniers peuvent être associés à aucune ou plusieurs catégories :

```js
const newBooks = [
    { title : "Python & SQL"}, // Python & SQL
    { title : "JS SQL ou NoSQL" }, // programmation
    {title : "Pandas & SQL & NoSQL"}, // SQL, NoSQL et Python
    { title : "Modélisation des données"} // aucune catégorie
]
```

Trouvez un moyen d'associer ces livres aux catégories du projet.


En ce qui concerne la relation oneToOne elle est simple à mettre en place. Par contre la relation ManyToMany 


## Exercice tree structure Algorithmique recherche **

Dans la base de données **bookstore**.

Soit la collection categoriestree suivante.

1. Ecrire un algorithme qui ajoute une propriété ancesstors à la collection afin d'énumérer les catégories parentes. Vous utiliserez l'opérateur **addToSet** pour ajouter le/les parent(s) de chaque document.

Par exemple la catégorie MongoDB aurait la propriété ancesstors suivante :

```js
db.categoriestree.find({ _id : "MongoDB"}, {ancesstors : 1} )
{ "_id" : "MongoDB", "ancesstors" : [ { "_id" : "Database" }, { "_id" : "Programming" }, { "_id" : "Books" } ] }
```

Vous pouvez créer un index sur la propriété parent. Celui-ci permettra d'accélérer la recherche :

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