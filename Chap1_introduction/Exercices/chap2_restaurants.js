// Exercice correction Compter le nombre de restaurants dans le quartier de Brookling

const resBrookling = db.restaurants.find( {
    borough: "Brooklyn"
}, {"name" : 1} )

let count = 0 ;

resBrookling.forEach(() => {
    count++;
});

print(count);

// Comparaison avec la méthode count
print(resBrookling.count())


// Exercices complémentaires

/*
Combien y a t il de restaurants qui font de la cuisine italienne et qui ont eu un score de 10 ou moins ?
Affichez également le nom, les scores et les coordonnées GPS de ces restaurents, ordonnez les résultats
par ordre décroissant sur les noms des restaurants
*/

// Tout seul $lt veut dire au moins une valeur qui vérifie la condition

// pensez à taper it dans la console pour afficher le reste, max 20 items affichés

db.restaurants.find({
    "cuisine" : "Italian",
    "grades.score" : {
        $lt : 10,
        $not : {$gt : 10}
    }
}, {"name":1, _id:0,  "grades.score" : 1}).sort({
    "name" : 1
})

/*
Quels sont les restaurants qui ont un grade A avec un score supérieur ou égal à 20 ? Affichez les noms et ordonnez les 
par ordre décroissant. Et donnez le nombre de résultat.
*/

db.restaurants.find({
    "grades" : {
        $elemMatch : {
            "grade" : "A",
            "score" : { $gt : 20 }
        }
    }
}, {"name":1, _id:0, "grades.grade" : 1, "grades.score" : 1}).sort({
    "name" : 1
})

// Différents quartiers de NY
db.restaurants.distinct("borough")

db.restaurants.find({
    "borough" : "Bronx"
}, {"name":1, _id:0, "cuisine" : 1})


// A l'aide de la méthode distinct trouvez tous les quartiers distincts de NY.
db.restaurants.distinct("cuisine", {"borough" : "Bronx"})

// $in
db.restaurants.find({ 
    "grades.score" : { $in : [10, 20] } }, 
    { "_id" : 0, "name" : 1} 
)

// $or, $and
db.restaurants.find({
    $and : [
        {
            $or : [ { "grades.grade" : "A" }, { "grades.grade" : "B" } ]
        },
        {
            "borough" : "Bronx"
        }
    ]
    },
    { "_id" : 0, "name" : 1} 
)
        
// Indice en plus

db.restaurants.find({
    $and : [
        {
            $or : [ { "grades.0.grade" : "A" }, { "grades.0.grade" : "B" } ]
        },
        {
            "borough" : "Bronx"
        }
    ]
    },
    { "_id" : 0, "name" : 1} 
)

/* 
Sélectionnez maintenant tous les noms des restaurants
qui ont dans leur nom le mot "Coffee" ou "coffee". De même on aimerait savoir si il y en a uniquement dans le Bronx.
*/

db.restaurants.find({
    "name" : /coffee/i
}, { "_id" : 0, "name" : 1, "borough" : 1} )

db.restaurants.find({
    $and : [
        {  "name" : /coffee/i },
        {  "borough" : "Bronx" }
    ]
}, { "_id" : 0, "name" : 1, "borough" : 1} )

// Trouvez tous les restaurants avec les mots Coffee ou Restaurant et qui ne contienne pas
// le mot Starbucks
db.restaurants.find({
    $and : [
        {  "name" : { $in : [/Coffee/i, /Restaurant/] } },
        {  "name" : { $nin : [/Starbucks/i] } },
        {  "borough" : "Bronx" }
    ]
}, { "_id" : 0, "name" : 1, "borough" : 1} )

// Trouvez tous les restaurants avec les mots Coffee ou Restaurant et qui ne contienne pas
// le mot Starbucks dans le Bronx
db.restaurants.find({
    $and : [
        {  "name" : /Coffee/i },
        {  "name" : /Restaurant/i },
        {  "borough" : "Bronx" }
    ]
}, { "_id" : 0, "name" : 1, "borough" : 1} )