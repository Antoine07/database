const store = [
    {
        "name": "Data",
        "_id": "store"
    },
    {
        "_id": "Languages",
        "parent": "store",
        "books" : [
            ""
        ]
    },
    ,
    {
        "_id": "Languages",
        "parent": "store",
        "books" : [
            ""
        ]
    },
    {
        "_id": "Database",
        "parent": "store"
    },
            {
                "name": "House of Representatives",
                "_id": "house",
                "parent": "congress"
            },
            {
                "name": "Senate",
                "_id": "senate",
                "parent": "congress"
            },
        {
            "name": "Executive",
            "_id": "exec",
            "parent": "root"
        },
            {
                "name": "Pres_ident",
                "_id": "pres",
                "parent": "exec"
            },
            {
                "name": "Vice Pres_ident",
                "_id": "vice-pres",
                "parent": "exec"
            },
            {
                "name": "Secretary of State",
                "_id": "state",
                "parent": "exec"
            },
            {
                "name": "Cabinet",
                "_id": "cabinet",
                "parent": "exec"
            },
                {
                    "name": "National Security Council",
                    "_id": "security",
                    "parent": "cabinet"
                },
                {
                    "name": "Council of Economic Advisers",
                    "_id": "economic",
                    "parent": "cabinet"
                },
                {
                    "name": "Office of Management and Budget",
                    "_id": "budget",
                    "parent": "cabinet"
                },
        {
            "name": "Judicial",
            "_id": "judicial",
            "parent": "root"
        }
]