CREATE DATABASE ipl;
USE ipl;

/*List all players who have scored more than 400 runs.*/
SELECT Player,Runs
FROM batting
WHERE Runs>400;

/*Find top 5 batsmen by highest batting average.*/
SELECT Player,Avg
From batting
ORDER BY AVG DESC
LIMIT 5;

/*List bowlers with more than 15 wickets.*/
SELECT Player,Wkts
FROM bollowing
WHERE Wkts>15;

/*Display players who scored at least one century.*/
SELECT Player,century
FROM batting
WHERE century >0;

/*Get all bowlers who have taken at least one 5-wicket haul.*/
SELECT Player,5w
FROM bollowing
WHERE 5w >0;


/*Find players who have both 10+ sixes and a strike rate greater than 150.*/
SELECT Player,6s,SR
FROM batting
WHERE 6s >10 AND SR >150; 

/*List all batsmen who have a higher strike rate than 
the average strike rate of all batsmen.*/

SELECT Player,SR
FROM batting
WHERE HS >(SELECT AVG(SR) FROM batting);

/*Find the top 3 bowlers with the best economy rate (lowest).*/
SELECT Player,Econ
FROM bollowing
ORDER BY Econ ASC
LIMIT 3;

/*Get the players who have played at least 10 matches and have an average above 40 (batting).*/

SELECT Player,Mat,Avg
FROM batting
WHERE Mat >=10 AND Avg>40;

/*Get players who have bowled more than 20 overs and conceded less than 300 runs.*/
SELECT Player,overs,Runs
FROM bollowing
WHERE overs >20 AND Runs<300;

/*Find all-rounders — players who are present in both batting and bollowing tables.*/
SELECT b.Player
FROM batting b join bollowing bo ON b.Player=bo.Player;

/*Rank top 5 all-rounders by a custom 'impact score':
(Runs + Wickets × 25 - Economy × 10)*/
SELECT b.Player, b.Runs, bo.Wkts, bo.Econ,
       (b.Runs + bo.Wkts * 25 - bo.Econ * 10) AS ImpactScore
FROM batting b
JOIN bollowing bo ON b.Player = bo.Player
ORDER BY ImpactScore DESC
LIMIT 5;

/*Get the player with the highest number of boundaries (4s + 6s).*/

SELECT Player, (4s+6s) AS boundaries
FROM batting
ORDER by boundaries DESC
LIMIT 1;

/*List bowlers whose economy rate is better than the average economy of all bowlers.*/
SELECT Player,Econ
FROM bollowing
WHERE Econ <(SELECT avg(Econ) FROM bollowing);

/*Find the top 5 all-rounders based on total impact, where impact is calculated as:
Impact = batting.Runs + bollowing.Wkts * 20 
Only include players who have played at least 5 matches in both tables..*/

WITH allrounder AS
(SELECT
b.Player,bo.Wkts,b.Runs,
 (b.Runs + bo.Wkts * 20 ) as impact
FROM batting b JOIN bollowing bo ON b.Player=bo.Player
WHERE b.Mat >=5 AND bo.Mat>=5)
SELECT *
FROM allrounder
Order by impact DESC
LIMIT 5;

/*Rank batsmen by total runs and display only those in the top 10.*/

WITH Rankedbatsman AS
(SELECT Player,Runs,
RANK()OVER (ORDER BY Runs DESC) as runrank
FROM batting)
SELECT *
FROM Rankedbatsman
WHERE runrank<=10;

/*Find all-rounders who have played at least 5 matches and calculate a “performance score” as:
Score = (Runs + 25 * Wkts + (4s + 6s) * 2)
Also show their rank based on the score using DENSE_RANK.*/

WITH allrounder AS 
(SELECT b.Player,b.Runs,bo.Wkts,(b.Runs + 25 * bo.Wkts + (4s + 6s) * 2) AS Score
FROM batting b JOIN bollowing bo ON b.Player=bo.Player
WHERE b.Mat>=5 AND bo.Mat>=5)
,rankscore AS
(SELECT *,DENSE_RANK() OVER (ORDER BY Score DESC) AS scoreranked
FROM allrounder)
SELECT *
FROM rankscore
ORDER BY scoreranked ASC
LIMIT 10;























