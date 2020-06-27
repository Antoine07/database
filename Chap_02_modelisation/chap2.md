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