-- Webpage link for the challenge : - https://www.steeldata.org.uk/sql2.html


-- Q1) What are the names of the players whose salary is greater than 100,000?

-- Answer)

select player_name , salary from players where salary > 100000; 

 -- Q2) What is the team name of the player with player_id = 3?

-- Answer)

 select t.team_id , t.team_name, pl.player_id from teams t inner join players pl on t.team_id = pl.team_id 
 where pl.player_id = 3; 

-- Q3) What is the total number of players in each team ?

-- Answer)

-- Method 1

select team_id as "Team ID", count(player_id) as "Number of Players" from players group by team_id ; 

-- Method 2

select team_id , team_name , count(player_id) as "Number of Players" from
			   ( select tm.team_id , tm.team_name , pl.player_id from teams tm 
                  inner join players pl on tm.team_id = pl.team_id ) table1
group by team_id , team_name ; 

-- Q4) What is the team name and captain name of the team with team_id = 2 ?

-- Answer)

-- Assumed Captain ID is same as Player ID

-- Method 1

select team_name as "Teams Name", captain_id as "Captain ID", player_name as "Captain Name" 
from ( select t.team_name , t.captain_id , pl.player_id , pl.player_name 
from teams t inner join players pl on t.captain_id = pl.player_id ) table1 ; 

-- Method 2

with table1 as
      ( select t.team_id , t.team_name , t.captain_id , pl.player_id , pl.player_name 
        from teams t inner join players pl on t.captain_id = pl.player_id ) ,
	    team_name_with_captain as
      ( select team_id , team_name as "Teams Name", player_name as "Captain Name" 
        from table1 )
select * from team_name_with_captain where team_id = 2 ; 

-- Q5) What are the player names and their roles in the team with team_id = 1 ?

-- Answer)

select player_name , role from players where team_id = 1 ; 

-- Q6) What are the team names and the number of matches they have won?

-- Answer)

-- Assumed Winner ID is same as Team ID.

-- Method 1

with table1 as
     ( select winner_id , count(*) as "Matches Won" from matches group by winner_id )
select tm.team_name "Team Name", t1.`Matches Won`
 from table1 t1 inner join teams tm on t1.winner_id = tm.team_id ;

-- Method 2

select winner_id as "Winner's Team ID", team_name , count(*) as "Matches Won" from  
							 ( select * from teams tm inner join matches mat 
                               on tm.team_id = mat.winner_id ) table1
group by winner_id , team_name ; 


-- Q7) What is the average salary of players in the teams with country 'USA'?

-- Answer)

with table1 as
     ( select pl.player_name , pl.salary , t.country from teams t right join players pl on t.team_id = pl.team_id )
select avg(salary) as "Average Salary of Players (USA)" from table1 where country = 'usa' ;

-- or

select round( avg(salary) , 2) as "Average Salary of Players (USA)" from 
     ( select pl.player_name , pl.salary , t.country from teams t right join players pl on t.team_id = pl.team_id )table1
where country = 'usa' ;

-- Q8) Which team won the most matches ?

-- Answer)

with table1 as 
      ( select winner_id , count(*) from matches group by winner_id order by count(*) desc limit 1 ) ,
	 table2 as
      ( select t.team_name as "Highest Matches Won Team" , t1.`count(*)` as "Matches Won" 
        from table1 t1 inner join teams t on t.team_id = t1.winner_id )
select * from table2 ; 

-- Q9) What are the team names and the number of players in each team whose salary is greater than 100,000 ?

-- Answer)

-- Method 1

select team_id , team_name , sum(case when salary >100000 then 1 else 0 end) as "Count of Players with Salary > 100000" from
                         ( select t.team_id , t.team_name , pl.player_id , pl.salary
						  from teams t right join players pl on t.team_id = pl.team_id ) table1
group by team_id , team_name ; 

-- Method 2

select team_id , team_name , count(case when salary >100000 then 1 end) as "Count of Players with Salary > 100000" from
                         ( select t.team_id , t.team_name , pl.player_id , pl.salary
						  from teams t right join players pl on t.team_id = pl.team_id ) table1
group by team_id , team_name ; 

-- Method 3

select team_name , count(player_id) as "Players Count" from
                        ( select t.team_name , pl.player_id , pl.salary
						  from teams t right join players pl on t.team_id = pl.team_id ) table1
where salary > 100000 group by team_name ; 

-- Q10) What is the date and the score of the match with match_id = 3 ?

-- Answer)

select match_id , match_date , score_team1 , score_team2 from matches where match_id = 3 ;
