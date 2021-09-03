
USE immo_sample;

-- 1. Nombre total d’appartements vendus au 1er semestre 2020

SELECT count(key_T) FROM transactions 
WHERE (date_ < '2020-06-03') 
AND key_B IN (SELECT key_B FROM bien WHERE type_local LIKE '%Appartement%');

-- 2. Proportion des ventes d’appartements par le nombre de pièces

SELECT bien.nb_pieces,
count(key_T) AS quantities,
(count(key_T)/ (SELECT count(key_T) FROM transactions 
WHERE key_B IN (SELECT key_B FROM bien WHERE type_local LIKE '%Appartement%'))) AS proportion,
(count(key_T) * 100 / (SELECT count(key_T) FROM transactions 
WHERE key_B IN (SELECT key_B FROM bien WHERE type_local LIKE '%Appartement%'))) AS percent

FROM transactions JOIN bien ON transactions.key_B = bien.key_B 
WHERE (bien.type_local LIKE '%Appartement%') GROUP BY nb_pieces  ;

-- 3. Liste des 10 départements où le prix du mètre carré est le plus élevé

SELECT code_departement ,ROUND(AVG(valeur / surface_carrez_lot1) ,2) AS square_meter_price
FROM transactions 
JOIN bien ON transactions.key_B = bien.key_B 
JOIN adresse ON bien.key_A = adresse.key_A
JOIN departement ON adresse.code_postal = departement.code_postal
GROUP BY code_departement
ORDER BY square_meter_price DESC
LIMIT 10;

-- 4. Prix moyen du mètre carré d’une maison en Île-de-France
-- list_dep = ( 75 , 77 , 78 , 91 , 92 , 93 , 95 )

SELECT ROUND(AVG(valeur / surface_carrez_lot1),2) AS square_meter_price_on_Ile_de_France
FROM transactions 
JOIN bien ON transactions.key_B = bien.key_B 
JOIN adresse ON bien.key_A = adresse.key_A
JOIN departement ON adresse.code_postal = departement.code_postal
WHERE code_departement IN ( 75 , 77 , 78 , 91 , 92 , 93 , 95 );

-- 5. Liste des 10 appartements les plus chers avec le département et le nombre de mètres carrés

SELECT key_T,CONCAT(b_t_q,' ',no_voie,' ',type_voie,' ',voie,' ',adresse.code_postal,' ',commune) AS adresse,
surface_carrez_lot1 AS surface,
code_departement
FROM transactions 
JOIN bien ON transactions.key_B = bien.key_B 
JOIN adresse ON bien.key_A = adresse.key_A
JOIN departement ON adresse.code_postal = departement.code_postal
ORDER BY valeur DESC
LIMIT 10;

-- 6. Taux d’évolution du nombre de ventes entre le premier et le second trimestre de 2020

SET @stuff2 = (SELECT COUNT(key_T)
FROM transactions 
JOIN bien ON transactions.key_B = bien.key_B 
JOIN adresse ON bien.key_A = adresse.key_A
JOIN departement ON adresse.code_postal = departement.code_postal
WHERE (date_ BETWEEN '2020-04-01' AND '2020-06-30'));

SET @stuff1 = (SELECT COUNT(key_T)
FROM transactions 
JOIN bien ON transactions.key_B = bien.key_B 
JOIN adresse ON bien.key_A = adresse.key_A
JOIN departement ON adresse.code_postal = departement.code_postal
WHERE (date_ < '2020-04-01'));

SELECT (@stuff2 - @stuff1)/@stuff1 AS taux_evolution

-- 7. Liste des communes où le nombre de ventes a augmenté d'au moins 20% entre le premier et le second trimestre de 2020 
SELECT t1.commune, ROUND((100*(nb_sales_t2 - nb_sales_t1)/nb_sales_t1),1) AS increase_sales_percentage_between_t1_and_t2
FROM
(SELECT commune,COUNT(key_T) AS nb_sales_t1
FROM transactions 
JOIN adresse ON transactions.key_A = adresse.key_A
WHERE (date_ < '2020-04-01')
GROUP BY commune) AS t1
JOIN
(SELECT commune,COUNT(key_T) AS nb_sales_t2
FROM transactions 
JOIN adresse ON transactions.key_A = adresse.key_A
WHERE (date_ BETWEEN '2020-04-01' AND '2020-06-30')
GROUP BY commune) AS t2 
ON t1.commune= t2.commune
WHERE 0.2 < ((nb_sales_t2 - nb_sales_t1)/nb_sales_t1)



-- 8. Différence en pourcentage du prix au mètre carré entre un appartement de 2 pièces et un appartement de 3 pièces

SET @price2rooms = SELECT ROUND(AVG(valeur / surface_carrez_lot1),2) AS square_meter_price_2_rooms
FROM transactions
JOIN bien ON transactions.key_B = bien.key_B 
JOIN adresse ON bien.key_A = adresse.key_A
JOIN departement ON adresse.code_postal = departement.code_postal
WHERE nb_pieces = 2 AND (type_local LIKE '%Appartement%');

SET @price3rooms = SELECT ROUND(AVG(valeur / surface_carrez_lot1),2) AS square_meter_price_2_rooms
FROM transactions
JOIN bien ON transactions.key_B = bien.key_B 
JOIN adresse ON bien.key_A = adresse.key_A
JOIN departement ON adresse.code_postal = departement.code_postal
WHERE nb_pieces = 3 AND (type_local LIKE '%Appartement%');

SELECT  100 * (@price3rooms - @price2rooms)/@price2rooms AS variation_from_2_to_3_rooms_in_percents ;




-- 9. Les moyennes de valeurs foncières pour le top 3 des communes des départements 6, 13, 33, 59 et 69

(SELECT commune,code_departement, AVG(valeur)
FROM transactions
JOIN adresse ON transactions.key_A = adresse.key_A
JOIN departement ON adresse.code_postal = departement.code_postal
WHERE code_departement = 6
GROUP BY commune
ORDER BY AVG(valeur) DESC
LIMIT 3)
UNION
(SELECT commune,code_departement, AVG(valeur)
FROM transactions
JOIN adresse ON transactions.key_A = adresse.key_A
JOIN departement ON adresse.code_postal = departement.code_postal
WHERE code_departement = 13
GROUP BY commune
ORDER BY AVG(valeur) DESC
LIMIT 3)
UNION
(SELECT commune,code_departement, AVG(valeur)
FROM transactions
JOIN adresse ON transactions.key_A = adresse.key_A
JOIN departement ON adresse.code_postal = departement.code_postal
WHERE code_departement = 33
GROUP BY commune
ORDER BY AVG(valeur) DESC
LIMIT 3)
UNION
(SELECT commune,code_departement, AVG(valeur)
FROM transactions
JOIN adresse ON transactions.key_A = adresse.key_A
JOIN departement ON adresse.code_postal = departement.code_postal
WHERE code_departement = 59
GROUP BY commune
ORDER BY AVG(valeur) DESC
LIMIT 3)
UNION
(SELECT commune,code_departement, AVG(valeur)
FROM transactions
JOIN adresse ON transactions.key_A = adresse.key_A
JOIN departement ON adresse.code_postal = departement.code_postal
WHERE code_departement = 69
GROUP BY commune
ORDER BY AVG(valeur) DESC
LIMIT 3)
;