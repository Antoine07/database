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


// 1. Affichez tous les articles de type journal. Et donnez la quantité total de ces articles (propriété qty).
 
const cursorInventor = args => db.inventory.find( args );

let qty = 0 ;

cursorInventor({ type : "journal" }).forEach( invent => {
    qty += invent.qty;
});

print(`total quantity journal : ${qty}`);

// 2. Affichez les noms de sociétés depuis 2018 ainsi que leur quantité

cursorInventor({ year : {$gte : 2017 } }).forEach( invent => {     print(invent.society, invent.qty) });

// 3. Affichez les types des articles pour les sociétés dont le nom commence par A

cursorInventor({ society: /^A/ },).forEach( invent => {    
    const { type, society } = invent; 
    print(`Type : ${type}, Société : ${society}`) ;
});

//4. Affichez le nom des sociétés dont la quantité d'articles est supérieur à 45.

cursorInventor({ qty : {$gte : 45 } }).sort({qty:1}).forEach( invent => { print(invent.society, invent.qty) });

//5. Affichez le nom des sociétés dont la quantité d'article est strictement supérieur à 45 et inférieur à 90.

cursorInventor({ qty : {$gt : 45 } }, { qty : {$lte : 100 } } ).sort({qty:1}).forEach( invent => { print(invent.society, invent.qty) });

//6. Affichez le nom des sociétés dont le statut est A ou le type est journal.

cursorInventor( { $or: [ { status: "A" }, { type: "journal" } ] } ).sort({society:1}).forEach( invent => { print(invent.society, invent.qty) });

// 7. Affichez le nom des sociétés dont le statut est A ou le type est journal et la quantité inférieur strictement à 100.

cursorInventor( {
    qty: { $lt : 100 },
    $or: [ { status : "A" }, { type : "journal" } ]
} ).sort({society:1}).forEach( invent => { print(invent.society, invent.qty) });


// 8. Affichez le type des articles qui ont un prix de 0.99 ou 1.99 et qui sont true pour la propriété sale ou ont une quantité strictement inférieur à 100.

cursorInventor( {
    $and : [
        { $or : [ { price : 0.99 }, { price : 1.99 } ] },
        { $or : [ { sale : true }, { qty : { $lt : 100 } } ] }
    ]
}, { society : 1 } ).sort({ society : 1}).sort({society : 1}).forEach( invent => {
    const { society, price, qty } = invent;

    print(`Society : ${society} price :${price}, quantity : ${qty}`)
})

//9. Affichez le nom des scociétés qui ont des tags.

cursorInventor( { tags : { $exists : true }}).sort({ society : 1}).sort({society : 1}).forEach( invent => {
    const { tags, society } = invent;

    print(`Society : ${society} tags :${tags.join(" ")}`)
})

//10. Affichez le nom des sociétés qui ont le tag blank.

cursorInventor( { tags : "blank"} ).sort({ society : 1}).sort({society : 1}).forEach( invent => {
    const { tags, society } = invent;

    print(`Society : ${society} tags :${tags.join(" ")}`)
})
