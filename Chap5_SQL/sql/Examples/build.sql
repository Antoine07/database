

DROP DATABASE IF EXISTS `blog`;

CREATE DATABASE `blog` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;

use `blog`;

CREATE TABLE `users` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `email` VARCHAR(100),
    `password` VARCHAR(100),
    `status` ENUM('administrator', 'visitor', 'author')
    NOT NULL DEFAULT 'visitor',
    PRIMARY KEY (`id`),
    CONSTRAINT `un_email` UNIQUE (`email`)
  ) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

  CREATE TABLE `posts` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `title` VARCHAR(100),
    `thematic` CHAR(6) DEFAULT NULL,
    `lesson` VARCHAR(30) DEFAULT NULL,
    `user_id` INT UNSIGNED DEFAULT NULL,
    `content` TEXT,
    `status` ENUM('published', 'unpublished', 'draft') NOT NULL DEFAULT 'unpublished',
    published_at DATETIME NOT NULL,
    PRIMARY KEY (`id`),
    CONSTRAINT `posts_users_id_foreign` FOREIGN KEY (`user_id`) REFERENCES users ( `id`) ON DELETE SET NULL
  ) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

  CREATE TABLE `categories` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `title` VARCHAR(100),
    PRIMARY KEY (`id`)
  ) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

  CREATE TABLE `category_post` (
    `post_id` INT UNSIGNED,
    `category_id` INT UNSIGNED,
    CONSTRAINT `category_post_posts_post_id_foreign` FOREIGN KEY(`post_id`) REFERENCES posts(`id`) ON DELETE CASCADE,
    CONSTRAINT `category_post_categories_post_id_foreign` FOREIGN KEY(`category_id`) REFERENCES categories(`id`) ON DELETE CASCADE,
    CONSTRAINT `un_post_id_category_id` UNIQUE KEY (`post_id`, `category_id` )
  ) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


INSERT INTO `users` 
  (`email`,`password`, `status`)
VALUES
  ('tony@tony.fr', '123', 'administrator'),
  ('alan@alan.fr', '123', 'author');


INSERT INTO `posts`
(`title`, `content`, `thematic`, `lesson`, `status`, `published_at`, `user_id`)
VALUES
("Géométrie dans l'espace chapitre 1",  'blablabla', 'MATH', 'Algèbre Linéaire', 'published',NOW(),2 ),
("Géométrie dans l'espace chaptire 2",  'blablabla', 'MATH', 'algèbre Linéaire', 'published',NOW()+ 3,2 ),
("Géométrie dans l'espace chapitre 3",  'blablabla', 'MATH', 'Algèbre linéaire', 'published',NOW()+4,2 ),
("Géométrie dans l'espace chapitre 4",  'blablabla', 'MATH', 'algèbre linéaire', 'published',NOW()+4,2 ),
('Algorithm Euclide', 'blablabla', 'ALGO', 'PGCD',  'published',NOW()+1,2);

INSERT INTO `categories` (`title`)
VALUES
  ('Programming' ),
  ('Algorithm' ),
  ('Mathématiques'),
  ('Framework')
  ;

INSERT INTO `category_post` (`post_id`, `category_id`)
  VALUES
    (1,3 ),
    (2,3),
    (3,3),
    (4, 2)
  ;

-- corrections

CREATE TABLE `old_posts` LIKE `posts`;

SET @idAlan = ( SELECT id FROM `users` WHERE email='alan@alan.fr' ) ;

INSERT INTO `old_posts`
  (`title`, `content`, `thematic`, `lesson`,  `status`, `published_at`, `user_id`)
VALUES
  ("Théorème de Pythagore", "Un super texte", "MATH", "Géométrie", "draft", "2009-02-09 11:55:51",  @idAlan ),
  ("Quick sort", "Un super texte", "ALGO", "Algorithme rapide", "draft", "2010-02-09 11:55:51",  @idAlan ),
  ("Laravel", "Un super texte", "FRAM", "Framework PHP", "draft", "2009-02-09 10:55:51",  @idAlan),
  ("Inversion de matrice", "Un super texte", "MATH", "Matrix inverse", "draft", "1998-11-09 10:55:51", @idAlan ),
  ("Bezout", "Un super texte", "MATH", "Arithmétique", "draft", "1998-02-09 11:55:51", @idAlan )
;

INSERT INTO `posts`
  (`title`, `content`, `thematic`, `lesson`,  `status`, `published_at`, `user_id`)
  (SELECT `title`, `content`, `thematic`, `lesson`,  `status`, `published_at`, `user_id`
  FROM `old_posts` )
;

UPDATE `posts` SET status='published', `published_at` = NOW() WHERE `status` = 'draft';


-- alter table

ALTER TABLE `posts`
ADD `time_to_write` TIME DEFAULT NULL AFTER `lesson`;

UPDATE `posts` 
  SET time_to_write = CONCAT( ROUND( RAND() * 11 ) , ':', ROUND( RAND() * 59 ) , ':', ROUND( RAND() * 59 )  )
;

--
SELECT * FROM posts WHERE time_to_write < '06:00:00' AND thematic = 'MATH';

-- decimal(3,1) == 2 chiffres avant la virgule et un après la virgule

ALTER TABLE `posts`
ADD `score` DECIMAL(3,1) DEFAULT NULL AFTER `title`;

UPDATE `posts` 
  SET score = RAND() * 100 
;

/*

# dans la table users

- "Luce du Coulon", "luce@luce.fr", "professor", "author"
- "Roger Le Voisin", "roger@roger.fr",  "professor emeritus", "author",
- "Jacques Humbert-Roy", "jacques@jacques.fr", "lecturer", "author"
- "Gilles Gros-Bodin", "gilles@gilles.fr", "lecturer", "author"

# dans la table posts
- "Analyse vectoriel chapitre 1", 8.5, 'blablabla', 'MATH', 'Analyse Linéaire', 'published',NOW(), @idProfessor
- "Analyse vectoriel chaptire 2", 10.5, 'blablabla', 'MATH', 'Analyse Linéaire', 'published',NOW(), @idProfessor
- "Dichotomie", 10.5, 'blablabla', 'MATH', 'Analyse Linéaire', 'published',NOW(), @idProfessor
*/

ALTER TABLE `users`
ADD `name` VARCHAR(100) NOT NULL DEFAULT 'anonymous' AFTER `email`,
ADD  `grade` ENUM('professor', 'professor emeritus', 'lecturer') NOT NULL DEFAULT 'lecturer' AFTER `email`;

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

--- 

SELECT title, user_id, score FROM posts WHERE user_id IN (SELECT id FROM users WHERE grade="professor") ;

SELECT title, user_id, score
FROM posts 
WHERE user_id IN (SELECT id FROM users WHERE grade="professor")
AND score > 9 AND score < 11
;

---

SELECT AVG(score) FROM posts WHERE user_id IN (SELECT id FROM users WHERE grade="professor") ;
SELECT COUNT(*) FROM posts WHERE score > (SELECT AVG(score) FROM posts);
SELECT * FROM users WHERE id = (SELECT user_id FROM posts WHERE score = (SELECT MIN(score) FROM posts));
---

SELECT thematic, AVG(score) FROM posts GROUP BY thematic;
-- attention le having s'applique sur la fonction de regroupement
SELECT thematic, AVG(score) FROM posts GROUP BY thematic HAVING AVG(score) > 33;
SELECT thematic, MAX(time_to_write), MIN(time_to_write) FROM posts GROUP BY thematic;

--- Mise à jour de la table category_post

-- On fixe la valeur 3 qui correspond à l'id de la catégorie Mathématiques
-- On prend les posts supérieur à 4 ceux avant cet id sont déjà associés à
-- une catégorie
INSERT INTO category_post
(post_id, category_id)
(SELECT id, 3 FROM posts WHERE thematic="MATH" );

INSERT INTO category_post
(post_id, category_id)
(SELECT id, 2 FROM posts WHERE thematic="ALGO" );

INSERT INTO category_post
(post_id, category_id)
(SELECT id, 4 FROM posts WHERE thematic="FRAM" );

---

SELECT p.title, u.name
FROM posts as p
INNER JOIN users as u
ON p.user_id = u.id ;

SELECT p.title, u.name
FROM users as u
LEFT JOIN posts as p ON p.user_id = u.id;

SELECT p.title, u.name
FROM users as u
LEFT JOIN posts as p ON p.user_id = u.id
WHERE p.user_id is NULL;

SELECT u.name, SEC_TO_TIME( SUM(p.time_to_write) )
FROM posts as p
INNER JOIN users as u
ON p.user_id = u.id 
GROUP BY u.name;

SELECT u.name
FROM posts as p
INNER JOIN users as u
ON p.user_id = u.id
WHERE p.time_to_write = (SELECT MAX(time_to_write) FROM posts );

ALTER TABLE users
CHANGE grade badge ENUM('professor', 'professor emeritus', 'lecturer') NOT NULL DEFAULT 'lecturer' AFTER `email`;