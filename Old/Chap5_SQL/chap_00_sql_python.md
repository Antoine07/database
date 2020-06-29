# Création d'une table avec Python

Nous devons si on souhaite utiliser MySQL avec Python installer un connecteur entre MySQL et Python. Tapez la ligne de commande suivante permettant d'installer le connecteur :

```python
pip install mysql-connector-python
```

Pour se connecter à une base de données vous devez connaître le login/password :

```python
db = mysql.connector.connect(
  host="localhost",
  user="root",
  passwd="pass"
)

# connecteur
cursor = db.cursor()
print(cursor)

```

## Lancer une commande SQL

Une fois que vous avez créer le connecteur entre Python et MySQL vous pouvez exécuter des commandes SQL :

```python

DB_NAME='db_boston'

# Par exemple on peut créer une base de données
cursor.execute(
  "CREATE DATABASE {} DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;".format(DB_NAME)
)
```

## Se connecter à une base de données

En Python avec le module mysql-connector-python l'exécution du script suivant permet de se connecter à la base de données DB_NAME. Bien sûr, il faut au préalable avoir une connexion au serveur de base de données.

```python
cursor.execute("USE {}".format(DB_NAME))
```

## Exemple de création d'une table dans une base de données

Vous pouvez parfaitement créer des tables dans votre base de données.

Ci-dessous on met la définition SQL dans un dictionnaire, puis on exécutera un script Python pour implémenter celle-ci dans la base de données :

```python

TABLES = {}

TABLES['statistic'] = (
    "CREATE TABLE `statistic` ("
    "  `id` int(11) NOT NULL AUTO_INCREMENT,"
    "  `title` varchar(16) NOT NULL,"
    "  `num_jobs` TINYINT UNSIGNED,"
    "  `certificate` VARCHAR(6),"
    "  PRIMARY KEY (`id`)"
    ")ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci")

```

```python

# fermeture du curseur
cursor.close()
# fermeture de la connexion
cnx.close()
```
