/*

Calculez la moyenne des vols pour chaque compagnie.

*/

SELECT AVG(numFlying), compagny FROM pilots
GROUP BY compagny;


/*

Calculez la moyenne des heures de vols des pilots dont le bonus est de 500,
par compagnie

*/

SELECT compagny, AVG(numFlying) FROM pilots
WHERE bonus = 500
GROUP BY compagny;

/*

Sélectionnez les compagnies et leur nombre de pilote(s), ayant plus d'un pilote.

*/
SELECT compagny, COUNT(certificate)
FROM pilots 
GROUP BY compagny 
HAVING COUNT(certificate) > 1;

/*
Nombre de pilotes par compagnie et par nombre d'heure de vols.
*/
SELECT compagny, plane, COUNT(certificate) 
FROM pilots 
GROUP BY compagny, plane;

/*
Exercice ajout d'une colonne
si ce n'est pas déjà fait (dans les exercices)
*/

ALTER TABLE pilots 
ADD COLUMN plane 
ENUM('A380', 'A320', 'A340') AFTER name;

UPDATE pilots
SET plane = 'A380'
WHERE name in ('Alan', 'Sophie', 'Albert', 'Benoit');

UPDATE pilots
SET plane = 'A320'
WHERE name in ('Tom', 'Jhon', 'Pierre');

UPDATE pilots
SET plane = 'A340'
WHERE name in ('Yan', 'Yi');

/*
Sélectionnez le nombre de pilote(s) par compagnie et par type d'avion.

*/

SELECT compagny, plane, COUNT(certificate)
FROM pilots
GROUP BY compagny, plane;

/*

Sélectionnez le noms des pilotes par bonus.

Sélectionnez le noms et la compagnie des pilotes par bonus.
*/

SELECT bonus, GROUP_CONCAT(`name`) 
FROM pilots GROUP BY bonus;

SELECT compagny, bonus, GROUP_CONCAT(`name`) 
FROM pilots GROUP BY compagny, bonus;

/*

Calculez l'étendue du nombre d'heure de vol par compagnie.

*/

SELECT compagny, MAX(numFlying) - MIN(numFlying)  
FROM pilots GROUP BY compagny;

/*

- Faites la somme du nombre de jours de vols par compagnie 
dont la somme est supérieur à 30.

*/

SELECT sum(num_jobs), compagny 
FROM pilots GROUP BY compagny 
HAVING sum(num_jobs) > 30;
