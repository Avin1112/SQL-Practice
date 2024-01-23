use practice2 ; 

-- What are the names of the players whose salary is greater than 100,000?

select player_name , salary from players where salary > 100000; 

 -- What is the team name of the player with player_id = 3?
 
 select t.team_id , t.team_name, pl.player_id from teams t inner join players pl on t.team_id = pl.team_id 
 where pl.player_id = 3; 

-- What is the total number of players in each team ?

select team_id as "Team ID", count(player_id) as "Number of Players" from players group by team_id ; 

-- What is the team name and captain name of the team with team_id = 2 ?

select team_name as "Teams Name", captain_id as "Captain ID", player_name as "Captain Name" 
from ( select t.team_name , t.captain_id , pl.player_id , pl.player_name 
from teams t inner join players pl on t.captain_id = pl.player_id ) table1 ; 

-- What are the player names and their roles in the team with team_id = 1 ?

select player_name , role from players where team_id = 1 ; 

-- What are the team names and the number of matches they have won?

with table1 as
     ( select winner_id , count(*) as "Matches Won" from matches group by winner_id )
select tm.team_name "Team Name", t1.`Matches Won`
 from table1 t1 inner join teams tm on t1.winner_id = tm.team_id ;

-- What is the average salary of players in the teams with country 'USA'?

with table1 as
     ( select pl.player_name , pl.salary , t.country from teams t right join players pl on t.team_id = pl.team_id )
select avg(salary) as "Average Salary of Players (USA)" from table1 where country = 'usa' ;

-- Which team won the most matches ?

with table1 as 
      ( select winner_id , count(*) from matches group by winner_id order by count(*) desc limit 1 ) ,
	 table2 as
      ( select t.team_name as "Highest Matches won Team's name" , t1.`count(*)` as "Matches Won" 
        from table1 t1 inner join teams t on t.team_id = t1.winner_id )
select * from table2 ; 

-- What are the team names and the number of players in each team whose salary is greater than 100,000 ?

-- Method 1

with table1 as
     ( select t.team_name , pl.player_id , pl.player_name , pl.salary from teams t right join players pl on t.team_id = pl.team_id )
select team_name , sum(case when salary > 100000 then 1 else 0 end ) as "Player count whose salary > 100000" from table1 group by team_name ;

-- Method 2

with table1 as
     ( select t.team_name , pl.player_id , pl.player_name , pl.salary from teams t right join players pl on t.team_id = pl.team_id )
select team_name , count(case when salary > 100000 then 1 end) as "Player count whose salary > 100000" from table1 group by team_name ;


-- What is the date and the score of the match with match_id = 3 ?

select match_id , match_date , score_team1 , score_team2 from matches where match_id = 3 ;






















































