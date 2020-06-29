
-- Exercice created Ajout d'une colonne

ALTER TABLE `pilots` 
ADD COLUMN `created` DATETIME DEFAULT CURRENT_TIMESTAMP ;


-- Exercice ajout d'une colonne et mise à jour

ALTER TABLE `pilots` 
    ADD COLUMN `birth_date` DATETIME AFTER `name`,
    ADD COLUMN `next_flight` DATETIME AFTER `name`,
    ADD COLUMN `num_jobs` TINYINT UNSIGNED AFTER `name`
;


-- Sauvegarde et suppression

CREATE TABLE new_pilots (SELECT * FROM pilots);

-- suppression des données dans la table pilots

DELETE FROM `pilots`; 

-- Récupération des données depuis la table new_pilots dans la table pilots

INSERT INTO
	`pilots` (
	`certificate`,
	`numFlying`,
	`compagny`,
	`name`,
	`num_jobs`,
	`next_flight`,
	`birth_date`,
	`created`
	) 
SELECT * FROM `new_pilots`;


