/*
## Exercice avec forEach

Rappelons la structure du forEach de Mongo que vous pouvez appliquer à un find :

```js
db.collection.find().forEach(<function>)
```

1. En utilisant la fonction forEach et la fonction find augmentez de 50% la quantité de chaque document qui a un status C ou D.

2. Augmentez maintenant de 150% les documents ayant un status A ou B et au moins 3 blanks dans leurs tags.
*/

// 1.
db.inventory.find({  status : { $in: ["C", "D"] } }).forEach(
    doc => {
            db.inventory.updateOne({ _id : doc._id }, { $mul : { "qty": 1.5 } } )
        
    }
)

// 2.
db.inventory.find({  $and : [ { status : { $in: ["A", "B"] }, tags: "blank" } ] }).forEach(
    doc => {
        if (doc.tags.length > 2) {
            db.inventory.updateOne({ _id : doc._id }, { $mul : { "qty": 2.5 } } )
        }
    }
)