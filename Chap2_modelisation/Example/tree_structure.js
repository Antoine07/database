const bookStore = [
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
]