

CREATE DATABASE IF NOT EXISTS `db_aviation2`
DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;

USE `db_aviation2`;

--  Exercice modifier
CREATE TABLE `compagnies` (
    `comp` CHAR(4),
    `street` VARCHAR(20),
    `city` VARCHAR(20) NULL,
    `name` VARCHAR(20) NOT NULL,
    CONSTRAINT pk_compagny PRIMARY KEY (`comp`)
)ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- alter table

ALTER TABLE `compagnies` 
ADD COLUMN `status` ENUM('published', 'unpublished', 'draft')
DEFAULT 'draft';

ALTER TABLE `compagnies`
DROP COLUMN `numStreet`;

ALTER TABLE `compagnies` 
ADD COLUMN `numStreet` TINYINT UNSIGNED AFTER `name`;

--  Exercice créer la table pilots

CREATE TABLE `pilots` (
    `certificate` VARCHAR(6),
    `numFlying` DECIMAL(7,1),
    `compagny` CHAR(4),
    `name` VARCHAR(20) NOT NULL,
    CONSTRAINT pk_pilots PRIMARY KEY (`certificate`),
    CONSTRAINT un_name UNIQUE(`name`),
    CONSTRAINT fk_pilots_compagny FOREIGN KEY (`compagny`) REFERENCES compagnies(`comp`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- definition de nouvelles colonnes

ALTER TABLE `pilots` 
ADD COLUMN `created` DATETIME DEFAULT CURRENT_TIMESTAMP ;

-- Exercice ajout d'une colonne et mise à jour

ALTER TABLE `pilots` 
    ADD COLUMN `birth_date` DATETIME AFTER `name`,
    ADD COLUMN `next_flight` DATETIME AFTER `name`,
    ADD COLUMN `num_jobs` TINYINT UNSIGNED AFTER `name`
;

-- code d'insertion des données pilots



UPDATE `pilots`
SET 
`birth_date` = '1978-02-04 00:00:00',
`next_flight` = '2020-12-04 09:50:52',
`num_jobs` = 10
WHERE `name` = 'Yi';
​
UPDATE `pilots`
SET `birth_date` = '1978-10-17 00:00:00',
`next_flight` = '2020-06-11 12:00:52',
`num_jobs` = 50
WHERE `name` = 'Sophie';
​
UPDATE `pilots`
SET `birth_date` = '1990-04-04 00:00:00',
`next_flight` = '2020-05-08 12:50:52',
`num_jobs` = 10
WHERE `name` = 'Albert';
​
UPDATE `pilots`
SET `birth_date` = '1998-01-04 00:00:00',
`next_flight` = '2020-05-08 12:50:52',
`num_jobs` = 30
WHERE `name` = 'Yan';
​
UPDATE `pilots`
SET `birth_date` = '2000-01-04 00:00:00',
`next_flight` = '2020-02-04 12:50:52',
`num_jobs` = 7
WHERE `name` = 'Benoit';
​
UPDATE `pilots`
SET `birth_date` = '2000-01-04 00:00:00',
`next_flight` = '2020-12-04 12:50:52',
`num_jobs` = 13
WHERE `name` = 'Jhon';
​
UPDATE `pilots`
SET `birth_date` = '1977-01-04 00:00:00',
`next_flight` = '2020-05-04 12:50:52',
`num_jobs` = 8
WHERE `name` = 'Pierre';
​
UPDATE `pilots`
SET `birth_date` = '2001-03-04 00:00:00',
`next_flight` = '2020-04-04 07:50:52',
`num_jobs` = 30
WHERE `name` = 'Alan';
​
UPDATE `pilots`
SET `birth_date` = '1978-02-04 00:00:00',
`next_flight` = '2020-12-04 09:50:52',
`num_jobs` = 10
WHERE `name` = 'Tom';

INSERT INTO `compagnies` VALUES 
('AUS','sidney','Australie','AUSTRA Air',19,'draft'),('CHI','chi','Chine','CHINA Air',NULL,'draft'),('FRE1','beaubourg','France','Air France',17,'draft'),('FRE2','paris','France','Air Electric',22,'draft'),('ITA','mapoli','Rome','Italia Air',20,'draft'),('PILL',NULL,NULL,'pillili',NULL,'draft'),('SIN','pasir','Singapour','SIN A',15,'draft');

INSERT INTO `pilots`
(`certificate`,`numFlying`,`compagny` ,`name`)
VALUES
    ('ct-1', 90, 'AUS', 'Alan' ),
    ('ct-12', 190, 'AUS', 'Albert' ),
    ('ct-7', 80, 'CHI', 'Pierre' ),
    ('ct-11', 200, 'AUS', 'Sophie' ),
    ('ct-6', 20, 'FRE1', 'Jhon' ),
    ('ct-10', 90, 'FRE1', 'Tom' ),
    ('ct-100', 200, 'SIN', 'Yi' ),
    ('ct-16', 190, 'SIN', 'Yan' ),
    ('ct-56', 300, 'AUS', 'Benoit' )
    ;


/*
Ajoutez une colonne bonus à la table pilots, puis ajoutez le bonus 1000
pour les certificats 'ct-1', 'ct-11', 'ct-12' et les autres 500.
*/

ALTER TABLE pilots ADD COLUMN bonus DECIMAL(5,1) AFTER name;

UPDATE pilots
SET bonus = 1000
WHERE certificate IN ('ct-1', 'ct-11', 'ct-12');

UPDATE pilots
SET bonus = 500
WHERE certificate NOT IN ('ct-1', 'ct-11', 'ct-12', 'ct-56');

UPDATE pilots
SET bonus = 2000
WHERE certificate = 'ct-56';