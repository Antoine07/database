INSERT INTO category (cat_id, cat_EL, cat_ER, name, level)       VALUES (4, 1, 44, 'Transport',0);
INSERT INTO category (cat_id, cat_EL, cat_ER, name, level)       VALUES (7, 2, 21, 'Aérien',1);
INSERT INTO category (cat_id, cat_EL, cat_ER, name, level)       VALUES (11, 3, 4, 'Planeur',2);
INSERT INTO category (cat_id, cat_EL, cat_ER, name, level)       VALUES (14, 5, 6, 'Parachute',2);
INSERT INTO category (cat_id, cat_EL, cat_ER, name, level)       VALUES (8, 7, 8, 'Hélico',2);
INSERT INTO category (cat_id, cat_EL, cat_ER, name, level)       VALUES (5, 9, 10, 'Fusée',2);
INSERT INTO category (cat_id, cat_EL, cat_ER, name, level)       VALUES (3, 11, 12, 'ULM',2);
INSERT INTO category (cat_id, cat_EL, cat_ER, name, level)       VALUES (28, 13, 20, 'Avion',2);
INSERT INTO category (cat_id, cat_EL, cat_ER, name, level)       VALUES (33, 14, 15, 'Militaire',3);
INSERT INTO category (cat_id, cat_EL, cat_ER, name, level)       VALUES (25, 16, 17, 'Tourisme',3);
INSERT INTO category (cat_id, cat_EL, cat_ER, name, level)       VALUES (2, 18, 19, 'Civil',3);
INSERT INTO category (cat_id, cat_EL, cat_ER, name, level)       VALUES (1, 22, 35, 'Terrestre',1);
INSERT INTO category (cat_id, cat_EL, cat_ER, name, level)       VALUES (30, 23, 24, 'Vélo',2);
INSERT INTO category (cat_id, cat_EL, cat_ER, name, level)       VALUES (17, 25, 26, 'Voiture',2);
INSERT INTO category (cat_id, cat_EL, cat_ER, name, level)       VALUES (9, 27, 28, 'Camion',2);
INSERT INTO category (cat_id, cat_EL, cat_ER, name, level)       VALUES (10, 29, 34, 'Moto',2);
INSERT INTO category (cat_id, cat_EL, cat_ER, name, level)       VALUES (71, 30, 31, 'Side-car',3);
INSERT INTO category (cat_id, cat_EL, cat_ER, name, level)       VALUES (32, 32, 33, 'Trail',3);
INSERT INTO category (cat_id, cat_EL, cat_ER, name, level)       VALUES (16, 36, 43, 'Marin',1);
INSERT INTO category (cat_id, cat_EL, cat_ER, name, level)       VALUES (180, 37, 38, 'Planche à voile',2);
INSERT INTO category (cat_id, cat_EL, cat_ER, name, level)       VALUES (100, 39, 40, 'Paquebot',2);
INSERT INTO category (cat_id, cat_EL, cat_ER, name, level)       VALUES (39, 41, 42, 'Voilier',2);



-- sous arbres, facile

SELECT *
FROM   category
WHERE  cat_EL > 22
   AND cat_ER < 35

-- tous les pères de trail (permet de faire facilement un fil d'ariane)

SELECT *
FROM   category
WHERE  cat_EL < 32
AND cat_ER > 33
ORDER BY level

-- tous les noeuds sous un élément de référence

SELECT *
FROM   category
WHERE cat_ER - cat_EL > 1 AND cat_EL > 1 AND cat_ER < 44


-- trier l'arbre (par le bord gauche) puis calculer le nombre de sous arbres 

SELECT c1.name, c1.cat_id, c1.level, c1.cat_EL, c1.cat_ER,
(SELECT count(*) FROM category as c2 WHERE c2.cat_EL > c1.cat_EL AND  c2.cat_ER < c1.cat_ER) as elem
FROM   category as c1
order by cat_EL







