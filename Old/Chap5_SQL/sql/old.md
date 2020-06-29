# SQL

Le SQL (Structured Query Lnaguage) est une norme définie depuis 1986.

Le modèle de données est la table de données ou si vous préférez la structure de données.

## SGBD

Nous allons travailler avec MySQL ou MariaDB et surtout avec le modèle relationnel InnoDB.

Il existe plusieurs moteurs de base de données, pour MySQL vous avez : MyISAM, Innodb, Archive, Memory par exemple.

**MyISAM** est un moteur qui ne supporte pas les transactions, mais possède des fonctionnalités de recherche de texte.

**InnoDB** est le moteur qui est le plus utilisé. Il supporte le mode transactionnel et les contraintes référentielles (clés étrangères).

**Memory** est un moteur de stockage dans la mémoire vive : RAM de l'ordinateur. On peut l'utiliser par exemple pour des systèmes de cache pour une application.

## Modèle de données

### Table de données

Le modèle de données relationnel repose sur des principes théoriques rigoureux (algèbre relationnel). La **table relationnelle** est la structure de données qui contient des lignes (rows) et des colonnes (columns) qui décrivent les enregistrements.

### Les clés

La clé primaire (Primary Key) d'une table est l'ensemble minimal de colonnes qui permet d'identifier **de manière unique** chaque enregistrement. Dans une table il faut trouver les clés candidates pouvant remplir ce rôle et sinon utiliser un identifiant numérique de type entier auto-incrémenté.

Attention, il ne peut y avoir qu'une seule clé primaire dans une table relationnel.

La clé étrangère (Foreign Key), elle référence dans la majorité des cas une clé primaire d'une autre table. Il peut y avoir plusieurs clés étrangères dans une même table.

## Base de données

C'est un regroupement logique d'objets comme les tables, index, vues, procédures, ... Stockés sur le disque dur. MySQL définit la notion d'hôte (host) c'est la machine qui héberge le SGDB.

Clairement votre base de données hébergera vos tables, l'accès à votre base de données sera également conditionné par un login/password et une adresse ou host.

Pour se connecter avec votre mot de passe à la base de données books :

```bash
mysql -u root -p
use myDataBase
```

Plus rapidement vous pouvez également taper la ligne suivante dans votre terminale :

```bash
mysql -u root -p --database myDataBase
```

Pour quitter la base de données :

```bash
mysql> quit
```

Pour afficher les commandes disponibles dans MySQL tapez une fois sur le serveur la commande suivante :

```bash
mysql>?
```

**Memory** possède le stockage des données et index en RAM.

## LMD langage de manipulation 

Pour manipuler les donner SQL propose trois instructions :

- Insertion d'enregistrement : INSERT

- Modification de données : UPDATE

- Suppression d'enregistrement : DELETE et TRUNCATE

Pour les besoins du cours nous allons créer des tables SQL, on vous donne le code de ces tables dans le cours. Comme nous utilisons le modèle relationnel, nous utilisons des clés secondaires (FK) pour mettre en relation les structures de données (tables relationnelles).

Dans un premier temps créer la base de données et les tables dans cette base.

## Création de la base de données & des tables

```sql
CREATE DATABASE blog DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
```
Pour la supprimer vous n'aurez qu'à taper la ligne :

```sql
drop database blog
```

### Définition des tables

Table des utilisateurs users, notez les cotes couchées échappent les caractères dans MySQL :

```sql

CREATE TABLE `users` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `email` VARCHAR(100),
    `password` VARCHAR(100),
    `status` ENUM('administrator', 'visitor', 'author')
    NOT NULL DEFAULT 'visitor',
    PRIMARY KEY (`id`),
    CONSTRAINT `un_email` UNIQUE (`email`)
  ) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

```

Table des posts, un post est écrit par au plus un auteur et un auteur peut avoir écrit plusieurs posts.

```sql
CREATE TABLE posts (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `title` VARCHAR(100),
    `thematic` CHAR(5) DEFAULT NULL, -- 5 octets donc 5 caractères
    `lesson` VARCHAR(30) DEFAULT NULL, -- 30 octets le nom des leçons
    `user_id` INT UNSIGNED DEFAULT NULL,
    `content` TEXT,
    `status` ENUM('published', 'unpublished') NOT NULL DEFAULT 'unpublished',
    published_at DATETIME NOT NULL,
    PRIMARY KEY (id),
    CONSTRAINT `posts_users_id_foreign` FOREIGN KEY (`user_id`) REFERENCES users (`id`) ON DELETE SET NULL
  ) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

  ```

  Table des catégories, une catégorie peut avoir de 0 à N post(s) et un post peut être associé à 0 à N catégorie, dans ce cas la relation est dite N:N :

  ```sql
CREATE TABLE categories (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `title` VARCHAR(100),
    PRIMARY KEY (`id`)
  ) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/* Table de liaison */
CREATE TABLE category_post (
  `post_id` INT UNSIGNED,
  `category_id` INT UNSIGNED,
  CONSTRAINT `category_post_posts_post_id_foreign` FOREIGN KEY(`post_id`) REFERENCES posts(`id`) ON DELETE CASCADE,
  CONSTRAINT `category_post_categories_post_id_foreign` FOREIGN KEY(`category_id`) REFERENCES categories(`id`) ON DELETE CASCADE,
  CONSTRAINT `un_post_id_category_id` UNIQUE KEY (`post_id`, `category_id` )
  ) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
  ```

Nous allons maintenant insérer des données de manière **multiple** depuis la console :

```sql

-- enregistrer des lignes dans la table (structure données)

INSERT INTO `users` 
-- champs 
  (`email`,`password`, `status`)
VALUES
-- les données qui correspondent aux noms des champs
  ('tony@tony.fr', '123', 'administrator'),
  ('alan@alan.fr', '123', 'author');
```

Insertion des posts, recherchez l'identifiant de votre auteur dans la table users puis. On utilise NOW qui est une fonction de MySQL et qui retourne le datetime actuel, pour la tester dans MySQL tapez la ligne de commande suivante :

```sql

mysql> SELECT NOW();
/*
+---------------------+
| NOW()               |
+---------------------+
| 2020-01-09 14:38:48 |
+---------------------+
1 row in set (0,00 sec)
*/

```

```sql

INSERT INTO `posts` 
  (`title`, `content`, `thematic`, `lesson`,  `status`, `published_at`, `user_id`)
VALUES
("Géométrie dans l'espace chapitre 1",  'blablabla', 'MATH', 'Algèbre Linéaire', 'published',NOW(),2 ),
("Géométrie dans l'espace chaptire 2",  'blablabla', 'MATH', 'algèbre Linéaire', 'published',NOW() + 3,2 ),
("Géométrie dans l'espace chapitre 3",  'blablabla', 'MATH', 'Algèbre linéaire', 'published',NOW() - 4,2 ),
('Algorithm Euclide', 'blablabla', 'ALGO', 'Recherche rapide', 'published', NOW()+1, 2);
```

Création des catégories :

```sql
INSERT INTO `categories` (`title`)
  VALUES
  ('Programming' ),
  ('Algorithm' ),
  ('Mathématiques'),
  ('Framework');
```

Maintenant nous allons créer les relations entre les catégories et les posts :

```sql
INSERT INTO category_post (`post_id`, `category_id`)
  VALUES
  (1,3 ),
  (2,3),
  (3,3),
  (4, 2);

```

### 1 Exercice 

Sélectionnez tous les posts dont l'intitulé de la leçon est "Algèbre Linéaire". Puis en utilisant BINARY('monIntitule') sélectionnez uniquement les leçons qui s'écrive(nt) exactement : "algèbre linéaire" en respectant la casse.

### 2 Exercice

Insérez maintenant les posts suivants dans une table que vous allez créer old_posts, vous les associerez à l'auteur alan@alan.fr :

```txt
- "Théorème de Pythagore", "Un super texte", "MATH", "Géométrie", "draft", "2009-02-09 11:55:51"
- "Quick sort", "Un super texte", "ALGO", "Algorithme rapide", "draft", "2010-02-09 11:55:51"
- "Laravel", "Un super texte", "FRAM", "Framework PHP", "draft", "2009-02-09 10:55:51"
- "Inversion de matrice", "Un super texte", "MATH", "Matrix inverse", "draft", "1998-11-09 10:55:51"
- "Bezout", "Un super texte", "MATH", "Arithmétique", "draft", "1998-02-09 11:55:51"

````

Nous voulons maintenant récupérez les anciens posts et les mettre dans la table posts, écrivez la commande qui vous permettra de les insérer rapidement. Notez que vous pouvez utiliser un SELECT dans un INSERT.

```sql

INSERT INTO maTable (name, ...)
SELECT (name, ...)

```

Pour finir mettez à jour les dates des anciens posts dans la table posts.

### 3 Exercice UPDATE

Ajoutez le champ time_to_write à la table posts ce champ a pour type TIME, il peut être NULL.

Une fois le champ ajouté à la table mettez à jour la table posts en ajoutant des temps de rédaction aléatoire. Attention au format de TIME, voyez ce qui suit :

- TIME : hh:mm:ss où respectivement hh est compris entre 0 et 12 et hh et ss entre 0 et 60 strictement. Ce type est compris par défaut entre les valeurs suivantes -838:59:59 à 838:59:59.

Vous pouvez utiliser les commandes SQL suivante, pour voir comment elles marchent tapez les dans MySQL 

```sql

SELECT CONCAT(10, ':', 56 , ':', 20); 
/*10:56:20*/

SELECT ROUND( RAND() * 59) ;

```

Affichez tous les posts dans la thématique **MATH** qui ont été écrit en moins de 6h.

### 4 Exercice

Ajoutez maintenant un champ score à la table posts. C'est un champ de type décimal sur 3 chiffres : 2 avant la virgule et 1 après la virgule. Il peut être de type NULL.

Ajoutez des données d'exemple pour tous les posts, utilisez la fonction RAND() de MySQL.

### 5 Exercice

Ajoutez dans la table users, un champ name et un champ grade de type ENUM ayant pour valeur : professor emeritus, professor et lecturer. La valeur de ce champ par défaut sera lecturer.

Puis ajoutez les données suivantes à vos tables users et posts :

```sql

INSERT INTO `users` 
  (`name`, `email`,`password`, `grade`, `status`)
VALUES
  ("Luce du Coulon", "luce@luce.fr", "123", "professor", "author"),
  ("Roger Le Voisin", "roger@roger.fr","123",   "professor", "author"),
  ("Jacques Humbert-Roy", "jacques@jacques.fr", "123", "lecturer", "author"),
  ("Gilles Gros-Bodin", "gilles@gilles.fr","123",  "lecturer", "author");

SET @idProfessor1 = (SELECT id FROM users WHERE grade="professor" AND name="Roger Le Voisin");
SET @idProfessor2 = (SELECT id FROM users WHERE grade="professor" AND name="Luce du Coulon" );


INSERT INTO `posts`
 (`title`,`score`, `content`, `thematic`, `lesson`, `time_to_write`,  `status`, `published_at`, `user_id`)
VALUES
("Analyse vectoriel chapitre 1", 8.5, 'blablabla', 'MATH', 'Analyse Linéaire', "10:09:20",  'published',NOW(), @idProfessor1),
("Analyse vectoriel chaptire 2", 10.5, 'blablabla', 'MATH', 'Analyse Linéaire', "11:09:20", 'published',NOW(), @idProfessor2),
("Dichotomie", 10.5, 'blablabla', 'ALGO', 'programmation Linéaire', "9:09:20",'published',NOW(), @idProfessor1) ;

```

Pensez à mettre des noms à vos users qui n'en ont pas encore.

1. Affichez tous les posts des users ayant le grade "professor".

2. Affichez tous les posts des users ayant le grade "professor" et dont le score est compris entre 9 et 11 strictement.

*Remarque : si vous vous êtes trompé sur le nom de votre colonne et que vous souhaitez changer celui-ci vous devez alors faire un ALTER TABLE. Par exemple si vous avez mis badge à la place de grade dans la table users, vous devez taper la ligne de code suivante :*

```sql
ALTER TABLE users CHANGE badge grade ENUM('professor', 'professor emeritus', 'lecturer') NOT NULL DEFAULT 'lecturer' AFTER `email`;
```

De manière générale, vous avez un site qui propose de la documentation type "adide-mémoire" pour vous aider sur SQL : ![sql sh](https://sql.sh)

## Fonction de groupe

Les fonctions de groupe en MySQL sont les suivantes :

- AVG avec une option possible DISTINCT donne la moyenne.

```sql
SELECT AVG( DISTINCT `votes` ) FROM `users`;

-- ou sur l'ensemble des votes 
SELECT AVG( `votes` ) FROM `users`;
```

- GROUP_CONCAT composition d'un ensemble de valeurs.

- COUNT avec une option possible DISTINCT nombre de lignes.

- MAX / MIN avec une option possible DISTINCT donne le max/ le min.

- STDDEV donne l'écart type.

- VARIANCE donne la variance.

- SUM avec une option possible DISTINCT donne la somme.

### 6 Exercice 

1. Donnez la moyenne des scores des professeurs.

2. Comptez le nombre de post(s) qui sont au-dessus de la moyenne des scores.

3. Quel est le nom de l'auteur qui a eu un post ayant obtenu le plus petit score. 

## Group et Having

On peut en SQL faire des groupements par ligne. Attention la clause WHERE s'applique à toute la table.

La clause GROUP BY liste des colonnes de groupement. La clause HAVING permet de poser des conditions sur chaque groupement. Vous pouvez utiliser la clause GROUP BY sans la clause HAVING.

```sql
SELECT col1, col2,... , fonctionGroup1, fonctionGroup2, ...
FROM table
 -- s'applique à l'ensemble de la table peut exclure la totalité de regroupement
WHERE condition1 
-- groupement d'enregistrement
GROUP BY col1, col2, ...
-- s'appliquer sur des groupements de lignes
HAVING condition2
```

Attention les colonnes dans le SELECT col1, col2, ... doivent apparaître dans le GROUP BY. Et les alias de colonne ne peuvent être utiliser dans la clause GROUP BY ou HAVING.

### 7 Exercice GROUP BY

1. Affichez la moyenne des scores par thematique.

2. Affichez la moyenne des scores par thématique supérieur à 33.

3. Pour chaque thématique le nombre max d'heure de rédaction et min d'heure de rédaction. 

### 8 Exercice Mettre à jour la table de liaison

Mettez à jour la table de liaison **category_post** avec vos posts en fonction de leur thématique.

## Jointure

On distingue deux types de jointures :

- Les jointures internes (inner joins) : nous avons l'équi-jointure qui utilise l'opérateur d'égalité dans la clause de jointure avec deux tables différentes et l'auto-jointure qui utilise la même table. Attention à cette jointure car, on a potentiellement une perte d'information. Vous n'affichez que l'intersection des deux ensembles.

- La jointure externe (outer join), c'est la plus technique elle favorise une table dite **donimante** par rapport à une autre table dites **subordonnée**. **Les lignes de la table donimante sont retournées même si elles ne satisfont pas aux conditions de jointure.** Pas de perte d'information dans ce cas.

Nous verrons que l'utilisation d'alias, dans certain cas, permet d'expliciter correctement la requête afin qu'elle puisse s'éxécuter. MySQL recommande l'utilisation d'alias pour améliorier les performances.

Jointure interne

```sql
SELECT a.name, b.name
FROM A as a
INNER JOIN B as b ON a.key = b.key
```

Jointure externe avec la table dominante à gauche :

```sql
SELECT *
FROM A as a
LEFT JOIN B as b ON a.key = b.key
```

Jointure externe avec la table dominante à droite :

```sql
SELECT *
FROM A as a
RIGHT JOIN B as b ON a.key = b.key
```

### 9 Exercice jointure

1. Affichez les titres, les noms et grade de chaque auteur de chaque post.

2. Affichez tous les noms de tous les auteurs et les titres de leur(s) post(s) si il existe.

3. Affichez uniquement les noms des auteurs qui n'ont rien publiés.

4. Faire la somme des temps de rédaction de chaque auteur et afficher leurs temps et le nom de l'auteur.

5. Quel est le nom de l'auteur qui a passé le plus de temps à rédiger son post ?
