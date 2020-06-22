
-- update

ALTER TABLE `pilots` 
ADD COLUMN `lead_pl` VARCHAR(6) AFTER `certificate`;

ALTER TABLE `pilots` 
ADD CONSTRAINT `fk_pilots_lead_pl` 
FOREIGN KEY (`lead_pl`) REFERENCES `pilots`(`certificate`);

UPDATE `pilots`
SET `lead_pl` = 'ct-7'
WHERE `certificate` IN ('ct-1', 'ct-100', 'ct-10');

UPDATE `pilots`
SET `lead_pl` = 'ct-6'
WHERE `certificate` IN ('ct-11', 'ct-12', 'ct-16');

-- sélectionne tous les pilotes n'ayant pas de chef

SELECT `name`
FROM `pilots`
WHERE `lead_pl` IS NULL;

-- sélectionne tous les pilotes ayant un chef

SELECT `name`
FROM `pilots`
WHERE `lead_pl` IS NULL
AND  `lead_pl` NOT IN (SELECT `lead_pl` FROM `pilots` WHERE `lead_pl` IS NOT NULL );

/*
Sélectionnez les certificats et les noms des compagnies de la compagnie 
'Air France' ayant fait plus de 60 heures de vol.
*/

-- On sélectionne les noms et les certificats

SELECT `p`.`certificate`, `c`.`name`
FROM `compagnies` as `c`
JOIN `pilots` as `p` ON `p`.`compagny`  =  `c`.`comp`;

-- Ici on utilise la clause WHERE qui permet de faire une restriction

SELECT `p`.`certificate`, `c`.`name`
FROM `compagnies` as `c`
JOIN `pilots` as `p` ON `p`.`compagny`  =  `c`.`comp`
WHERE `c`.`name` = 'Air France'
AND `p`.`numFlying` > 60;


/*
Faites la somme des heures de vols
de tous les pilotes de la compagnie 
dont le nom est AUSTRA Air.
*/

SELECT SUM(p.numFlying)
FROM pilots as p
JOIN compagnies as c
ON p.compagny = c.comp
WHERE c.name = 'AUSTRA Air';

/*
Faites maintenant la somme des nombres des heures de vol par compagnie.
*/

-- Ci-dessous on fait la somme par nom de compagnie
-- à l'aide d'un group by le groupement peut se faire sur l'une ou l'autre table

SELECT c.name, SUM(p.numFlying)
FROM pilots as p
JOIN compagnies as c
ON p.compagny = c.comp
GROUP BY c.name;

/*
Sélectionnez le nom de la compagnie, le certificat du pilote et le nom du pilote 
même si la compagnie n'emploie pas de pilote.
*/

SELECT c.name, p.certificate, p.name 
FROM compagnies AS c 
LEFT OUTER JOIN pilots as p 
ON p.compagny = c.comp ;

/*

Insérez maintenant le pilote suivant, il ne sera pas rattaché à une compagnie.

- Harry à le certificat ct-19 n'a aucun leader pilot à fait 0 heure de vol, 
n'est rattaché à aucune compagnie, à un bonus de 100, à fait 0 jour de travail n'a aucun vol planifié et à pour date de naissance : '2000-01-01 12:00:00'.

- Sélectionnez le nom de la compagnie, le certificat du pilote et le nom du 
pilote même si le pilote n'est pas rattaché à une compagnie.
*/

INSERT INTO `pilots`
(`certificate`, `name`, `numFlying`, `bonus`, `num_jobs`, `birth_date`)
VALUES
('ct-19', 'Harry', 0, 100, 0, '2000-01-01 12:00:00');

SELECT c.name, p.certificate, p.name 
FROM compagnies as c 
RIGHT OUTER JOIN pilots as p 
ON p.compagny = c.comp ;

/*

Sélectionnez les compagnies n'ayant pas de pilote.
Notez que l'on doit préciser : p.compagny IS NULL dans la restriction.
Ce qui parait logique car les pilotes n'ayant pas de référence
avec la table compagnies ne sont pas rattachés à une compagnie...
*/

SELECT c.name, p.certificate, p.name 
FROM compagnies as c 
LEFT OUTER JOIN pilots as p 
ON p.compagny = c.comp
WHERE p.compagny IS NULL;

/*
Si on change la dominance de la table on obtiendra les pilotes n'ayant pas de compagnie.
Bien sûr dans ce cas on aurait pu le faire sans jointure voyez (deuxième requête)
*/

SELECT c.name, p.certificate, p.name 
FROM compagnies as c 
RIGHT OUTER JOIN pilots as p 
ON p.compagny = c.comp
WHERE p.compagny IS NULL;

-- requête plus simple
SELECT p.name
FROM pilots as p
WHERE p.compagny IS NULL;

/*
Sélectionnez les compagnies et leurs pilotes incluant les compagnies 
n'ayant pas de pilote et les pilotes n'ayant pas de compagnie.

Indication : utilisez la clause UNION pour faire la requête FULL OUTER JOIN.
*/

SELECT c.name, p.certificate, p.name
FROM pilots as p
RIGHT OUTER JOIN compagnies as c
ON p.compagny = c.comp
UNION
SELECT NULL, `certificate`, `name`
FROM pilots
WHERE compagny is NULL;


