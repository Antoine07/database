
UPDATE `pilots`
SET `lead_pl` = 'ct-7'
WHERE `certificate` IN ('ct-1', 'ct-100', 'ct-10');

UPDATE `pilots`
SET `lead_pl` = 'ct-6'
WHERE `certificate` IN ('ct-11', 'ct-12', 'ct-16');

SELECT `name`
FROM `pilots`
WHERE `lead_pl` IS NULL;

SELECT `name`
FROM `pilots`
WHERE `lead_pl` IS NULL
AND  `lead_pl` NOT IN (SELECT `lead_pl` FROM `pilots` WHERE `lead_pl` IS NOT NULL );