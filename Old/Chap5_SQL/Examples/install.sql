SET NAMES UTF8;
-- supprime la base de données si elle existe
DROP DATABASE IF EXISTS `blog`;

-- crée la base de données avec encodage des caractères
CREATE DATABASE `blog` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;

-- log sur la base de données
use `blog`;

-- définition des structures de données (tables relationnels)

CREATE TABLE `users` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `email` VARCHAR(100),
    `password` VARCHAR(100),
    `status` ENUM('administrator', 'visitor', 'author')
    NOT NULL DEFAULT 'visitor',
    PRIMARY KEY (`id`),
    CONSTRAINT `un_email` UNIQUE (`email`)
  ) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

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

-- Insertions

-- enregistrer des lignes dans la table users (structure données)

INSERT INTO `users` 
-- champs 
  (`email`,`password`, `status`)
VALUES
-- les données qui correspondent aux noms des champs
  ('tony@tony.fr', '123', 'administrator'),
  ('alan@alan.fr', '123', 'author');

INSERT INTO `posts` 
  (`title`, `content`, `thematic`, `lesson`,  `status`, `published_at`, `user_id`)
VALUES
("Géométrie dans l'espace chapitre 1",  'blablabla', 'MATH', 'Algèbre Linéaire', 'published',NOW(),2 ),
("Géométrie dans l'espace chaptire 2",  'blablabla', 'MATH', 'algèbre Linéaire', 'published',NOW() + 3,2 ),
("Géométrie dans l'espace chapitre 3",  'blablabla', 'MATH', 'Algèbre linéaire', 'published',NOW() - 4,2 ),
('Algorithm Euclide', 'blablabla', 'ALGO', 'Recherche rapide', 'published', NOW()+1, 2);