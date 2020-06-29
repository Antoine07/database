# Introduction & Présentation

MongoDB est une base de données NoSQL orientée documents qui est mature et qui existe depuis 2007. NoSQL signifie Not Only SQL.

Pour le stockage de données massives qui varient dans le temps. Lorsque la structure des données est connues au préalable et ne bouge pas dans le temps on utilisera de préférence du SQL.

Dans un projet vous serez amener à utiliser les deux SQL et NoSQL.

Notons également que MongoDB propose un ensemble important de drivers pour pouvoir l'utiliser avec des langage de programmation comme PHP, Python, NodeJS, ...

## Collection

Dans une base de données MongoDB vous manipulerez des **documents**, fichiers **semi-structurés JSON**. Ces derniers sont stockés dans une collection donnée. Pour faire une analogie avec SQL le document ou la collection représenterait une table qui est rangée dans une base de données.

## Modélisation des données

MongoDB ne gère aucun schéma de données (complète flexibilité ), les collections n'ont donc pas de structure pré-déterminée ou fixe.

Un document est un élément d'une collection.

Dans un document, des champs peuvent être ajoutés, supprimés, modifiés et renommés à tout moment...

Le modèle est basé sur un système de **clé/valeur**.

Chaque valeur peut être de type sclaraire, c'est-à-dire des entiers,numériques, chaîne de caractères, boléens ou la valeur particulière null.

Ces valeurs peuvent également comporter des listes de valeurs ou même des documents imbriqués.

Mongo possède un langage d'interrogation original et spécifique.

Résumons ces types pour les valeurs des clés :

null, boolean, numeric, string, array et object.

```json
{
  "students" : [
      {
          "_id" : 1,
          "name" : "Alan",
          "address" : {
            "street" : "London",
            "city" : "London",
            "zip" : " 31413"
        },
          "grade" :  "master 5",
          "notes" : [14,17,19,20],
          "relationship" : null
      },
       {
          "_id" : 2,
          "name" : "Alice",
          "address" : "Paris",
          "grade" : "master 4",
          "notes" : [19, 11, 20],
          "relationship" : [1]
      }
  ]
}
```

Remarque : chaque document Mongo possède une clé unique **_id**, le type de  valeur par défaut est **ObjectId**, mais peut être de n'importe quel type. La valeur de ce champ doit cependant être unique.

Nous verrons plus tard comment à partir de données relationnelles nous pouvons les implémenter dans un modèle NoSQL de type document comme dans MongoDB.

## Installation

Nous pouvons utiliser un interpréteur graphique comme par exemple [Studio3T](https://studio3t.com/).

### Windows

Ou utilisez Mongo sur sa machine en ligne de commande, voir dans ce cas la page suivante : [Mongo install](https://docs.mongodb.com/manual/installation/)

Vous devriez avoir un installer à l'adresse suivante : [installer](https://www.mongodb.com/try/download/community)

Suivez les étapes de l'installation et précisez le dossier data pour vos bases de données sur votre machine.

Puis lancez le serveur dans votre console comme suit, vous pouvez également modifier vos variables d'environnement pour accèder à Mongo plus rapidement :

Démarrez le serveur et connectez vous au serveur :

```bash
# démarrer le serveur
"C:\Program Files\MongoDB\Server\4.2\bin\mongod.exe"

# se connecter au serveur
"C:\Program Files\MongoDB\Server\4.2\bin\mongo.exe"
```

### Mac

Vous devez d'abord installer brew. Puis à l'aide de cet outils tapez les lignes de commandes suivantes dans un terminal :

```bash

brew tap mongodb/brew
brew install mongodb-community

# Créer le dossier pour les bases de données Mongo
sudo mkdir -p /data/db

# permissions pour travailler avec le dossier des bases de données
sudo chown -R `id -un` /data/db

# start mongo (serveur)
mongod

# version
mongo --version

# se connecter au serveur
mongo
```
Le fichier de configuration de Mongo se trouve à l'adresse suivante :

```txt
/usr/local/etc/mongod.conf
```

Le contenu de ce fichier vous renseignera sur la configuration de Mongo sur votre machine :

```txt
systemLog:
  destination: file
  path: /usr/local/var/log/mongodb/mongo.log
  logAppend: true
storage:
  dbPath: /usr/local/var/mongodb
net:
  bindIp: 127.0.0.1
```


### Linux

Installez dans un premier temps MongoDB sur votre machine et connectez vous au serveur de base de données en ligne de commande. Dans un terminal tapez :

D'abord il faut démarrer le serveur Mongo, sous Linux il faut tapez la ligne de commande suivante :

```bash
sudo systemctl start mongod
```

Puis tapez la ligne de commande suivante pour rentrer sur le serveur Mongo. Vous aurez ainsi accès à l'interpréteur JS de MongoDB pour lancer vos commandes. Vous pourrez donc écrire du JS et des commandes Mongo :

```bash
mongo
>
```

Mongo possède une base de données par défaut : test. Nous allons voir comment se connecter et créer une base de données.

## Commandes MongoDB

Une fois connecter sur votre serveur MongoDB. Vous avez accès aux commandes CLI. Notez que pour se déconnecter il faudra tapez la ligne de commande suivante :

```bash
quit()
```

### Commandes de base

```js
//Affichez les bases de données dans le serveur
show dbs

// Connexion ou création d'une base de données restaurants
use restaurants

// Connaitre le nom de la base de données
db

// Une fois dans une base de données voir les collections JSON
show collections

// renommer une collection addresses en address
db.addresses.renameCollection("address")

// supprime une collection
db.address.drop()

// supprime la base de données actuelle (use restaurants)
db.dropDatabase()
```

## Outils graphique Robo 3T

Vous pouvez également installer un outils graphique Robo 3T : https://robomongo.org/download. Attention, Robo 3T est gratuit pas studio 3T. 

Cet outils est intéressant mais, nous pouvons cependant travailler directement dans la console avec mongo. Ce dernier intègre toutes les commandes MongoDB et un interpréteur Javascript.
