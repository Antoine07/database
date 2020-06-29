
CREATE DATABASE IF NOT EXISTS `db_aviation`
DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;

USE `db_aviation`;

--  Exercice modifier
CREATE TABLE `compagnies` (
    `comp` CHAR(4),
    `street` VARCHAR(20),
    `city` VARCHAR(20) NULL,
    `name` VARCHAR(20) NOT NULL,
    CONSTRAINT pk_compagny PRIMARY KEY (`comp`)
);

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
