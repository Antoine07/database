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
db.inventory.find({ status: { $in: ["C", "D"] } }).forEach(
    doc => {
        db.inventory.updateOne({ _id: doc._id }, { $mul: { "qty": 1.5 } })

    }
)

// 2.
db.inventory.find({ $and: [{ status: { $in: ["A", "B"] }, tags: "blank" }] }).forEach(
    doc => {
        if (doc.tags.length > 2) {
            db.inventory.updateOne({ _id: doc._id }, { $mul: { "qty": 2.5 } })
        }
    }
)

/*

## Exercice suppression d'un champ

Dans la collection inventory 
il y a un champ level qu'il faut supprimer, 
aidez-vous de l'opérateur unset pour effectuer 
cette mise à jour.
*/

db.inventory.updateOne(
    { level: { $exists: true } },
    { $unset: { level: "" } }
)

// vérification cette commande doit ne rien retourner.
db.inventory.find({ level: { $exists: true } }).pretty()

db.inventory.updateMany(
    { tags: { $exists: true } },
    [
        {
            $set: {
                grade: {
                    $switch: {
                        branches: [
                            { case: { $gt: [{ $size: "$tags" }, 3] }, then: "AA" },
                            { case: { $gt: [{ $size: "$tags" }, 2] }, then: "A" }
                        ],
                        default: "B"
                    }
                }
            }
        }
    ]
)

db.inventory.find({ grade: { $exists: true } }, { tags: 1, grade: 1 })


/*

## Exercice synthèse

1 . Créez un champ **creationts** et **expiryts** pour chaque document de la collection inventory. Faites un script pour réaliser cela en utilisant des dates variables pour la création et la date d'expiration du document. Le script devra prendre en compte la date de création pour générer une date d'expiration.

Vous utiliserez la méthode ISODate de Mongo et Date de JS pour générer des dates aléatoires.

Notez que ISODate est basée sur l'UTC, si vous écrivez new Date() ou ISODate Mongo affichera dans tous les cas une ISODate. Le décallage de date peut s'effectuer à l'aide de la méthode getTime :

```js
// Pour un jour 
// 1 x 24 hours x 60 minutes x 60 seconds x 1000 milliseconds
let day = 1*24*60*60000 

// Ajoute un jour à la date actuel
new Date( ISODate().getTime() + day )
```
*/

db.inventory.find({}, { '_id': 1 }).forEach(doc => {
    const days = Math.floor(Math.random() * 100) * 24*60*60 * 1000 ;

    db.inventory.updateOne(
        { '_id': doc._id },
        [
            { $set: { created_at : new Date() } },
            { $set: { expired_at : new Date( ISODate().getTime() + days )   } }
        ]
    );

})

/* au cas où : supprimer des champs
db.inventory.updateMany(
    { _id : { $exists: true } },
    { $unset: { creationts: "", expiryts: "" } } 
)

*/

db.inventory.updateMany(
    { _id: { $exists: true } },
    [
        { $set: { life: { $divide : [  { $subtract: [ "$expired_at", "$created_at",  ] } , 1000 * 60 * 60 * 24 ] }  } },
    ]
);
