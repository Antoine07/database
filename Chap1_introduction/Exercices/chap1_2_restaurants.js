// ## 1. Exercice compter le nombre de restaurants

const resBrookling = db.restaurants.find( {
    borough: "Brooklyn"
}, {"name" : 1} )

let count = 0 ;

// on utilise le curseur 
resBrookling.forEach(() => {
    count++;
});

print(count);

// Comparaison avec la méthode count
print(resBrookling.count())


// ### 2. Exercices sur la notion de filtrage

/*
1. Combien y a t il de restaurants qui font de la cuisine italienne et qui ont eu un score de 10 ou moins ?
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
2. Quels sont les restaurants qui ont un grade A avec un score supérieur ou égal à 20 ? Affichez les noms et ordonnez les 
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

// 3. Différents quartiers de NY
db.restaurants.distinct("borough")

db.restaurants.find({
    "borough" : "Bronx"
}, {"name":1, _id:0, "cuisine" : 1})


// 4. A l'aide de la méthode distinct trouvez tous les quartiers distincts de NY.
db.restaurants.distinct("cuisine", {"borough" : "Bronx"})

// $in
db.restaurants.find({ 
    "grades.score" : { $in : [10, 20] } }, 
    { "_id" : 0, "name" : 1} 
)

// 5. Sélectionnez les restaurants dont le grade est A ou B dans le Bronx.
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
// 6. Même question mais, on aimerait que les restaurants qui on eu à la dernière inspection un A ou B. 

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
7. Sélectionnez maintenant tous les restaurants qui ont le mot "Coffee" ou "coffee" dans la propriété name du document. 
Puis uniquement dans le quartier du Bronx
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

//8. Trouvez tous les restaurants avec les mots Coffee ou Restaurant et qui ne contiennent pas le mot Starbucks.

db.restaurants.find({
    $and : [
        {  "name" : { $in : [/Coffee/i, /Restaurant/] } },
        {  "name" : { $nin : [/Starbucks/i] } }
    ]
}, { "_id" : 0, "name" : 1, "borough" : 1} )

// Puis uniquement dans le quartier du Bronx

db.restaurants.find({
    $and : [
        {  "name" : { $in : [/Coffee/i, /Restaurant/] } },
        {  "name" : { $nin : [/Starbucks/i] } },
        {  "borough" : "Bronx" }
    ]
}, { "_id" : 0, "name" : 1, "borough" : 1} )

//9. Trouvez tous les restaurants avec les mots Coffee ou Restaurant et qui ne contiennent pas le mot Starbucks dans le Bronx.

db.restaurants.find({
    $and : [
        {  "name" : /Coffee/i },
        {  "name" : /Restaurant/i },
        {  "borough" : "Bronx" }
    ]
}, { "_id" : 0, "name" : 1, "borough" : 1} )