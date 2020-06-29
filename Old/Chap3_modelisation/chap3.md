# Modélisation 

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

Par contre, il faut avoir conscience que dans les données structurées, comme les bases de données relationnelles, les données sont contraintes et structurées.

Les données semi-structurées sont appropriées pour des données complexes et qui ont besoin de souplesse.

Avec les données semi-structurées on peut imbriquer les structures pour éviter les jointures du modèle relationel.

```js
{
    "title" : "Pulp fiction",
    "genre" : ["Action", "Thriller", "Violent"],
    "director" : {
        "last_name" : "Tarantino",
        "birth_date" : "1963"
    }
}
```

Un autre intérêt du NoSQL est le passage à l'échelle par distribution.

## One-to-One Relationships

Dans ce modèle on a une collection qui est en relation avec une au plus collection.

On peut refactoriser ce qui suit en une collection, voir plus loin :

```js

// users
{
   _id: "joe",
   name: "Joe Bookreader"
}

// address
{
   patron_id: "joe", // relation id FK PK 
   street: "123 Fake Street",
   city: "Faketon",
   state: "MA",
   zip: "12345"
}

```

Regroupement d'une collection dans une collection :

```js
{
   _id: "joe",
   name: "Joe Bookreader",
   address: {
              street: "123 Fake Street",
              city: "Faketon",
              state: "MA",
              zip: "12345"
            }
}
```

## One-to-Many Relationships

Là encore on peut imbriquer les documents :

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

Comme les choses en MongoDB sont souples, on peut également avoir une approche clé primaire/clé secondaire. L'intérêt est de ne pas avoir un document trop lourd à charger dans l'application.

Prenons un exemple d'un produit avec des commentaires associés assez nombreux. L'approche qui consiste à avoir deux collections pour gérer ce cas est plus intéressante si le volumes des données est important :

```js
// un produit dans la collection product

{
  "_id": 1,
  "name": "Super Widget",
  "description": "This is the most useful item in your toolbox.",
  "price": { "value": NumberDecimal("119.99"), "currency": "USD" }
}

// ses commentaires dans la collection review
{
  "review_id": 786,
  "product_id": 1,
  "review_author": "Kristina",
  "review_text": "This is indeed an amazing widget.",
  "published_date": ISODate("2019-02-18")
}
{
  "review_id": 785,
  "product_id": 1,
  "review_author": "Trina",
  "review_text": "Nice product. Slow shipping.",
  "published_date": ISODate("2019-02-17")
}

```