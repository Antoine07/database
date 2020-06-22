
// aggrégation
const unwindCuisine = { $unwind : "$grades" } 

const groupCuisine = { 
    $group : {"_id" : "$cuisine", "avg" : {$avg : "$grades.score"}}
} ;

db.restaurants.aggregate([
    unwindCuisine,
    groupCuisine
])

// somme de tous les prix par agence group by

db.sales.aggregate(
    [
        {
        $group :
            {
            _id : "$agency",
            totalPrice: { $sum:  "$price"  } 
            }
        }
    ]
)

// Somme de tous les prix par agence mais qui sont supérieurs à une certaine valeur
db.sales.aggregate(
[
    {
    $group :
        {
        _id : "$agency",
        totalPrice: { $sum:  "$price"  } 
        }
    },
    // Having
    {
        $match: { "totalPrice": { $gte: 950000 } }
    }
    ]
)


/**
 * - On aimerait maintenant avoir tous 
 * les noms et id des restaurants par type 
 * de cuisine et quartier. Limitez l'affichage à deux résultats.
 */
db.restaurants.aggregate([
    { $group : { _id : { 
            "cuisine" : "$cuisine", 
            "borough" : "$borough" 
        }, 
        names: { $push:  {  name : "$name", restaurant_id : "$restaurant_id" }  } },
    },
    { $limit : 2 }
])


/*
- 1. Affichez maintenant tous les restaurants italiens par quartier.
- 2. Affichez également pour chaque restaurant la moyenne de ses scores.
*/

// 1 restaurant Italien par quartier
db.restaurants.aggregate([
    { $match : { cuisine : "Italian"}},
    { $group : { _id : { 
            "cuisine" : "$cuisine", 
            "borough" : "$borough" 
        }
    }}
])

// 2 Moyenne des scores
db.restaurants.aggregate([
    { $unwind : "$grades" } ,
    { $match : { cuisine : "Italian"}},
    { $group : { _id : { 
            "cuisine" : "$cuisine", 
            "borough" : "$borough" 
        },
        avg : {$avg : "$grades.score"}
    }},
    { $sort : {
        avg : -1
    }}
])

/*
- Faites une requête qui récupère les 5 derniers restaurants 
par quartier les mieux notés et placez cette recherche dans 
une collection top5.
*/

db.restaurants.aggregate([
    { $unwind : "$grades" } ,
    { $group : { _id : { 
            "borough" : "$borough" 
        },
        avg : {$avg : "$grades.score"}
    }},
    { $sort : {
        avg : -1
    }},
    { $limit : 5 },
    { $out : "top5"}
])


// 