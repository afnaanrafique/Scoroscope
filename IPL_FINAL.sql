--CREATE TRAINING DATA

DROP VIEW IF EXISTS ipl_view_demo_2015;

CREATE VIEW ipl_view_demo_2015 AS
select foo.batsman, foo.bowling_skill, no_of_balls,total_runs,nvl(wicket_taken,0) as wic, foo.venue_name, total_runs/nvl(wicket_taken,1)::FLOAT as average_variant_wise
from
(select p1.player_name as batsman, bowling_style.bowling_skill,count(*) no_of_balls, venue.venue_name, sum(batsman_scored.runs_scored) as total_runs
from ball_by_ball
join batsman_scored on ball_by_ball.match_id=batsman_scored.match_id and ball_by_ball.over_id=batsman_scored.over_id and ball_by_ball.ball_id=batsman_scored.ball_id and ball_by_ball.innings_no=batsman_scored.innings_no
join player as p1 on ball_by_ball.striker=p1.player_id
join player as p2 on ball_by_ball.bowler = p2.player_id
join bowling_style on p2.bowling_skill=bowling_style.bowling_id
join match_ on ball_by_ball.match_id=match_.match_id
join venue on match_.venue_id=venue.venue_id
where match_.season_id<=8
group by p1.player_name, Bowling_Style.Bowling_skill, venue.venue_name order by 1)foo
left join
(select p1.player_name as batsman, bowling_style.bowling_skill, venue.venue_name, count(*) as wicket_taken
from ball_by_ball
join wicket_taken on ball_by_ball.match_id=wicket_taken.match_id and ball_by_ball.over_id=wicket_taken.over_id and ball_by_ball.ball_id=wicket_taken.ball_id and ball_by_ball.striker=wicket_taken.player_out
join player as p1 on wicket_taken.player_out=p1.player_id
join player as p2 on ball_by_ball.bowler = p2.player_id
join bowling_style on p2.bowling_skill=bowling_style.bowling_id
join match_ on ball_by_ball.match_id=match_.match_id
join venue on match_.venue_id=venue.venue_id
where match_.season_id<=8
group by p1.player_name, Bowling_Style.Bowling_skill, venue.venue_name order by 1)foo1
on foo.batsman = foo1.batsman and foo.bowling_skill = foo1.bowling_skill and foo.venue_name=foo1.venue_name;




--CREATE MODEL
DROP MODEL IF EXISTS ipl_model_demo_2015;
SELECT rf_regressor('ipl_model_demo_2015','ipl_view_demo_2015', 'average_variant_wise',
'batsman, bowling_skill, no_of_balls, total_runs, wic, venue_name'
USING PARAMETERS ntree=200, mtry=2, sampling_size=0.8, max_depth=35, max_breadth=100, 
min_leaf_size=1, min_info_gain=0, nbins=32 );






--TEST MODEL
DROP VIEW IF EXISTS ipl_view_demo_2016;

CREATE OR REPLACE VIEW ipl_view_demo_2016 AS
select foo.batsman, foo.bowling_skill, no_of_balls,total_runs,nvl(wicket_taken,0) as wic, foo.venue_name, total_runs/nvl(wicket_taken,1)::FLOAT as average_variant_wise
from
(select p1.player_name as batsman, bowling_style.bowling_skill, venue.venue_name, count(*) no_of_balls, sum(batsman_scored.runs_scored) as total_runs
from ball_by_ball
join batsman_scored on ball_by_ball.match_id=batsman_scored.match_id and ball_by_ball.over_id=batsman_scored.over_id and ball_by_ball.ball_id=batsman_scored.ball_id and ball_by_ball.innings_no=batsman_scored.innings_no
join player as p1 on ball_by_ball.striker=p1.player_id
join player as p2 on ball_by_ball.bowler = p2.player_id
join bowling_style on p2.bowling_skill=bowling_style.bowling_id
join match_ on ball_by_ball.match_id=match_.match_id
join venue on match_.venue_id=venue.venue_id
where match_.season_id=9
group by p1.player_name, Bowling_Style.Bowling_skill, venue.venue_name order by 1)foo
left join
(select p1.player_name as batsman, bowling_style.bowling_skill, venue.venue_name , count(*) as wicket_taken
from ball_by_ball
join wicket_taken on ball_by_ball.match_id=wicket_taken.match_id and ball_by_ball.over_id=wicket_taken.over_id and ball_by_ball.ball_id=wicket_taken.ball_id and ball_by_ball.striker=wicket_taken.player_out
join player as p1 on wicket_taken.player_out=p1.player_id
join player as p2 on ball_by_ball.bowler = p2.player_id
join bowling_style on p2.bowling_skill=bowling_style.bowling_id
join match_ on ball_by_ball.match_id=match_.match_id
join venue on match_.venue_id=venue.venue_id
where match_.season_id=9 
group by p1.player_name, Bowling_Style.Bowling_skill, venue.venue_name order by 1)foo1
on foo.batsman = foo1.batsman and foo.bowling_skill = foo1.bowling_skill and foo.venue_name=foo1.venue_name;


--PREDICTION VIEW

DROP VIEW IF EXISTS ipl_view_total_2016;

CREATE OR REPLACE VIEW ipl_view_total_2016 AS

select foo.batsman, foo.bowling_skill, no_of_balls,total_runs,nvl(wicket_taken,0) as wic, foo.venue_name, total_runs/nvl(wicket_taken,1)::FLOAT as average_variant_wise
from
(select p1.player_name as batsman, bowling_style.bowling_skill, venue.venue_name, count(*) no_of_balls, sum(batsman_scored.runs_scored) as total_runs
from ball_by_ball
join batsman_scored on ball_by_ball.match_id=batsman_scored.match_id and ball_by_ball.over_id=batsman_scored.over_id and ball_by_ball.ball_id=batsman_scored.ball_id and ball_by_ball.innings_no=batsman_scored.innings_no
join player as p1 on ball_by_ball.striker=p1.player_id
join player as p2 on ball_by_ball.bowler = p2.player_id
join bowling_style on p2.bowling_skill=bowling_style.bowling_id
join match_ on ball_by_ball.match_id=match_.match_id
join venue on match_.venue_id=venue.venue_id
group by p1.player_name, Bowling_Style.Bowling_skill, venue.venue_name order by 1)foo
left join
(select p1.player_name as batsman, bowling_style.bowling_skill, venue.venue_name , count(*) as wicket_taken
from ball_by_ball
join wicket_taken on ball_by_ball.match_id=wicket_taken.match_id and ball_by_ball.over_id=wicket_taken.over_id and ball_by_ball.ball_id=wicket_taken.ball_id and ball_by_ball.striker=wicket_taken.player_out
join player as p1 on wicket_taken.player_out=p1.player_id
join player as p2 on ball_by_ball.bowler = p2.player_id
join bowling_style on p2.bowling_skill=bowling_style.bowling_id
join match_ on ball_by_ball.match_id=match_.match_id
join venue on match_.venue_id=venue.venue_id
group by p1.player_name, Bowling_Style.Bowling_skill, venue.venue_name order by 1)foo1
on foo.batsman = foo1.batsman and foo.bowling_skill = foo1.bowling_skill and foo.venue_name=foo1.venue_name;



--CREATE MODEL
DROP MODEL IF EXISTS ipl_model_2018;
SELECT rf_regressor('ipl_model_2018','ipl_view_total_2018', 'average_variant_wise',
'player, bowling_skill, no_of_balls, total_runs, wic, venue_name'
USING PARAMETERS ntree=200, mtry=2, sampling_size=0.8, max_depth=35, max_breadth=100, 
min_leaf_size=1, min_info_gain=0, nbins=32 );



--MSE TABLE
DROP TABLE IF EXISTS mse_table;
CREATE TABLE mse_table (mse numeric(20,5), Comments VARCHAR);
INSERT INTO mse_table SELECT mse(obs::float, prediction::float) OVER() FROM (SELECT average_variant_wise::FLOAT AS obs,
PREDICT_RF_REGRESSOR (player, bowling_skill, no_of_balls, total_runs, wic, venue_name
USING PARAMETERS model_name='ipl_model_2018')::numeric(20,5) AS prediction FROM ipl_view_total_2018) AS prediction_output;
SELECT * FROM mse_table;



--RSquared Table
DROP TABLE IF EXISTS rsq_table;
CREATE TABLE rsq_table (rsq numeric(20,5), Comments VARCHAR);
INSERT INTO rsq_table SELECT rsquared(obs::float, prediction::float) OVER() FROM (SELECT average_variant_wise::FLOAT AS obs,
PREDICT_RF_REGRESSOR (player, bowling_skill, no_of_balls, total_runs, wic, venue_name
USING PARAMETERS model_name='ipl_model_2018')::numeric(20,5) AS prediction FROM ipl_view_total_2018) AS prediction_output;
SELECT * FROM rsq_table;


DROP VIEW IF EXISTS ipl_view_total_2018;

CREATE OR REPLACE VIEW ipl_view_total_2018 AS

select player, Team_name, ipl_view_total_2016.bowling_skill, ipl_view_total_2016.venue_name, ipl_view_total_2016.no_of_balls, ipl_view_total_2016.total_runs,
ipl_view_total_2016.wic, ipl_view_total_2016.average_variant_wise 
from ipl_2018_squad
join ipl_view_total_2016 on ipl_2018_squad.player=ipl_view_total_2016.batsman
group by player, Team_name, ipl_view_total_2016.bowling_skill, ipl_view_total_2016.no_of_balls, ipl_view_total_2016.total_runs, ipl_view_total_2016.wic,
ipl_view_total_2016.venue_name, ipl_view_total_2016.average_variant_wise
order by 1;

DROP TABLE predicted_data;
CREATE TABLE predicted_data AS
SELECT player, bowling_skill, no_of_balls, total_runs, wic, venue_name, average_variant_wise::FLOAT AS actual_average_variant_wise, PREDICT_RF_REGRESSOR (player, bowling_skill, no_of_balls, total_runs, wic, venue_name 
USING PARAMETERS model_name='ipl_model_2018')::numeric(20,5) AS predicted_average_variant_wise FROM ipl_view_total_2018;


select player, sum(predicted_average_variant_wise)/3 from predicted_data where bowling_skill in ('Right-arm medium-fast','Right-arm medium-fast','Right-arm medium-fast','Left-arm fast-medium', 'Legbreak') and venue_name='Wankhede Stadium'  group by player order by 1 ;

select player, sum(predicted_average_variant_wise)/3 from predicted_data where bowling_skill in ('Right-arm medium-fast','Right-arm medium-fast','Right-arm medium-fast','Left-arm fast-medium', 'Legbreak') and venue_name='Eden Gardens'  group by player order by 1 ;

select player, sum(predicted_average_variant_wise)/nullif(sum(wic),0) from predicted_data where bowling_skill in ('Right-arm medium-fast','Right-arm medium-fast','Right-arm medium-fast','Left-arm fast-medium', 'Legbreak') and venue_name='Wankhede Stadium'  group by player order by 1 ;

--By Considering wic=0 as wic=1
select player, sum(predicted_average_variant_wise*(case when wic=0 then 1 else wic end))/sum(case when wic=0 then 1 else wic end) from predicted_data where bowling_skill in ('Right-arm medium-fast','Right-arm medium-fast','Right-arm medium-fast','Left-arm fast-medium', 'Legbreak') and venue_name='Wankhede Stadium'  group by player order by 1 ;

select player, sum(predicted_average_variant_wise*(case when wic=0 then 1 else wic end))/sum(case when wic=0 then 1 else wic end) from predicted_data where bowling_skill in ('Right-arm offbreak','Left-arm fast-medium','Right-arm medium-fast','Legbreak', 'Right-arm medium-fast') and venue_name='Sawai Mansingh Stadium'  group by player order by 1 ;
select player, sum(predicted_average_variant_wise*(case when wic=0 then 1 else wic end))/sum(case when wic=0 then 1 else wic end) from predicted_data where bowling_skill in ('Right-arm offbreak','Slow left-arm chinaman','Right-arm medium-fast','Legbreak', 'Right-arm medium-fast') and venue_name='Sawai Mansingh Stadium'  group by player order by 1 ;

select player, sum(predicted_average_variant_wise*(case when wic=0 then 1 else wic end))/sum(case when wic=0 then 1 else wic end) from predicted_data where bowling_skill in ('Right-arm medium-fast','Right-arm fast','Right-arm medium-fast','Legbreak', 'Legbreak') and venue_name='Punjab Cricket Association Stadium'  group by player order by 1 ;
select player, sum(predicted_average_variant_wise*(case when wic=0 then 1 else wic end))/sum(case when wic=0 then 1 else wic end) from predicted_data where bowling_skill in ('Left-arm fast-medium','Right-arm medium-fast','Right-arm medium-fast','Right-arm offbreak', 'Right-arm offbreak') and venue_name='Punjab Cricket Association Stadium'  group by player order by 1 ;

select player, sum(predicted_average_variant_wise*(case when wic=0 then 1 else wic end))/sum(case when wic=0 then 1 else wic end) from predicted_data where bowling_skill in ('Right-arm offbreak','Left-arm fast-medium','Right-arm medium-fast','Legbreak', 'Right-arm medium-fast') and venue_name='Maharashtra Cricket Association Stadium'  group by player order by 1 ;

select player, sum(predicted_average_variant_wise*(case when wic=0 then 1 else wic end))/sum(case when wic=0 then 1 else wic end) from predicted_data where bowling_skill in ('Right-arm medium-fast','Right-arm offbreak','Right-arm medium-fast','Legbreak', 'Right-arm medium-fast') and venue_name='Maharashtra Cricket Association Stadium'  group by player order by 1 ;

select player, sum(predicted_average_variant_wise*(case when wic=0 then 1 else wic end))/sum(case when wic=0 then 1 else wic end) from predicted_data where bowling_skill in ('Right-arm medium-fast','Left-arm fast-medium','Right-arm medium-fast','Right-arm offbreak', 'Right-arm offbreak') and venue_name='Feroz Shah Kotla'  group by player order by 1 ;

select player, sum(predicted_average_variant_wise*(case when wic=0 then 1 else wic end))/sum(case when wic=0 then 1 else wic end) from predicted_data where bowling_skill in ('Left-arm fast-medium','Right-arm medium-fast','Right-arm fast','Right-arm medium-fast', 'Legbreak') and venue_name='Feroz Shah Kotla'  group by player order by 1 ;

select player, sum(predicted_average_variant_wise*(case when wic=0 then 1 else wic end))/sum(case when wic=0 then 1 else wic end) from predicted_data where bowling_skill in ('Slow left-arm orthodox','Right-arm medium-fast','Legbreak','Right-arm offbreak', 'Left-arm fast-medium') and venue_name='M Chinnaswamy Stadium'  group by player order by 1 ;

select player, sum(predicted_average_variant_wise*(case when wic=0 then 1 else wic end))/sum(case when wic=0 then 1 else wic end) from predicted_data where bowling_skill in ('Left-arm fast','Right-arm medium-fast','Legbreak','Right-arm offbreak', 'Right-arm medium-fast') and venue_name='M Chinnaswamy Stadium'  group by player order by 1 ;

select player, sum(predicted_average_variant_wise*(case when wic=0 then 1 else wic end))/sum(case when wic=0 then 1 else wic end) from predicted_data where bowling_skill in ('Right-arm medium-fast','Right-arm medium-fast','Legbreak','Legbreak', 'Right-arm medium-fast') and venue_name='M Chinnaswamy Stadium'  group by player order by 1 ;

select player, sum(predicted_average_variant_wise*(case when wic=0 then 1 else wic end))/sum(case when wic=0 then 1 else wic end) from predicted_data where bowling_skill in ('Right-arm medium-fast','Right-arm medium-fast','Legbreak','Legbreak', 'Right-arm medium-fast') and venue_name='Feroz Shah Kotla'  group by player order by 1 ;
select player, sum(predicted_average_variant_wise*(case when wic=0 then 1 else wic end))/sum(case when wic=0 then 1 else wic end) from predicted_data where bowling_skill in ('Right-arm medium-fast','Right-arm medium-fast','Left-arm fast-medium','Right-arm offbreak', 'Right-arm medium-fast') and venue_name='Feroz Shah Kotla'  group by player order by 1 ;

select player, sum(predicted_average_variant_wise*(case when wic=0 then 1 else wic end))/sum(case when wic=0 then 1 else wic end) from predicted_data where bowling_skill in ('Left-arm fast-medium','Right-arm medium-fast','Right-arm fast','Legbreak', 'Slow left-arm orthodox') and venue_name='Feroz Shah Kotla'  group by player order by 1 ;

select player, sum(predicted_average_variant_wise*(case when wic=0 then 1 else wic end))/sum(case when wic=0 then 1 else wic end) from predicted_data where bowling_skill in ('Right-arm medium-fast','Right-arm medium-fast','Right-arm offbreak','Legbreak', 'Right-arm medium-fast') and venue_name='Eden Gardens'  group by player order by 1 ;

select player, sum(predicted_average_variant_wise*(case when wic=0 then 1 else wic end))/sum(case when wic=0 then 1 else wic end) from predicted_data where bowling_skill in ('Legbreak','Right-arm offbreak','Slow left-arm chinaman','Right-arm medium-fast', 'Right-arm medium-fast') and venue_name='Eden Gardens'  group by player order by 1 ;

select sum(predicted_average_variant_wise*(case when wic=0 then 1 else wic end))/sum(case when wic=0 then 1 else wic end) as prediction from predicted_data where bowling_skill in ('Slow left-arm chinaman','Right-arm medium-fast','Legbreak','Right-arm offbreak', 'Right-arm offbreak') and venue_name='M Chinnaswamy Stadium' and player='V Kohli' group by player order by 1 ;




select ball_by_ball.match_id, ball_by_ball.innings_no, ball_by_ball.over_id, ball_by_ball.ball_id, player_name from player 
join wicket_taken on player.player_id=wicket_taken.player_out
join ball_by_ball on ball_by_ball.match_id=wicket_taken.match_id and ball_by_ball.over_id=wicket_taken.over_id and ball_by_ball.ball_id=wicket_taken.ball_id and ball_by_ball.innings_no=wicket_taken.innings_no
group by ball_by_ball.match_id, player_name, ball_by_ball.over_id, ball_by_ball.ball_id, ball_by_ball.innings_no
order by 1,2;

where wicket_taken.match_id=335987
where ball_by_ball.match_id=335987

select player.player_name, ball_by_ball.match_id, ball_by_ball.innings_no, ball_by_ball.over_id, ball_by_ball.ball_id from player
join ball_by_ball on ball_by_ball.striker=player.player_id
where ball_by_ball.match_id=335987
group by player.player_name, ball_by_ball.match_id, ball_by_ball.over_id, ball_by_ball.ball_id, ball_by_ball.innings_no
order by 2,3,4,5;


--Category at which the batsmen comes in to bat.
select player.player_name, ball_by_ball.match_id, ball_by_ball.innings_no, min(ball_by_ball.over_id) as min_over,
case
WHEN min(ball_by_ball.over_id) >= 1 and min(ball_by_ball.over_id) <= 5 THEN 'Beg'
WHEN min(ball_by_ball.over_id) >= 6 and min(ball_by_ball.over_id) <= 10 THEN 'First_mid'
WHEN min(ball_by_ball.over_id) >= 11 and min(ball_by_ball.over_id) <= 15 THEN 'Penultimate'
WHEN min(ball_by_ball.over_id) >= 16 THEN 'Depth'
ELSE 'The quantity is something else'
END as Category
from player
join ball_by_ball on ball_by_ball.striker=player.player_id
group by player.player_name, ball_by_ball.match_id, ball_by_ball.innings_no
order by 2,3,4,5;


--2nd Model Containing Match, Venue, Opposition_Team, Bowling_Pattern..




--SAMPLE


select player_name, ball_by_ball.Innings_No, venue_name, team.team_name, ball_by_ball.match_id, sum(runs_scored)  as total_runs_scored
from ball_by_ball  join batsman_scored on ball_by_ball.match_id = batsman_scored.match_id and ball_by_ball.Innings_No = batsman_scored.Innings_No and ball_by_ball.over_id = batsman_scored.over_id and ball_by_ball.ball_id = batsman_scored.ball_id 
join player on player.player_id = ball_by_ball.striker join match_ on match_.match_id = ball_by_ball.match_id join venue on venue.venue_id = match_.venue_id  join team on ball_by_ball.team_bowling = team.team_id 
group by ball_by_ball.Innings_No, Striker,player_name, player_id,venue_name,team.team_name, ball_by_ball.match_id
order by 1,5;

select Umpire_Country, agg_concatenate(Umpire_Name) over(partition by Umpire_Country) as pattern from test group by Umpire_Country, Umpire_Name;

agg_concatenate(bowling_style.initials) over(partition by ball_by_ball.match_id)

select p1.player_name as batsman, agg_concatenate(bowling_style.initials) over(partition by ball_by_ball.match_id), ball_by_ball.match_id, bowling_style.bowling_skill, bowling_style.initials, count(*) no_of_balls, sum(batsman_scored.runs_scored) as total_runs
from ball_by_ball
join batsman_scored on ball_by_ball.match_id=batsman_scored.match_id and ball_by_ball.over_id=batsman_scored.over_id and ball_by_ball.ball_id=batsman_scored.ball_id and ball_by_ball.innings_no=batsman_scored.innings_no
join player as p1 on ball_by_ball.striker=p1.player_id
join player as p2 on ball_by_ball.bowler = p2.player_id
join bowling_style on p2.bowling_skill=bowling_style.bowling_id
join match_ on ball_by_ball.match_id=match_.match_id
join venue on match_.venue_id=venue.venue_id
where ball_by_ball.match_id=335987 and p1.player_name='BB McCullum'
group by p1.player_name, Bowling_Style.Bowling_skill, venue.venue_name, ball_by_ball.match_id, bowling_style.initials 
order by 2;





select p1.player_name as batsman, count(*) no_of_balls, sum(batsman_scored.runs_scored) as total_runs
from ball_by_ball
join batsman_scored on ball_by_ball.match_id=batsman_scored.match_id and ball_by_ball.over_id=batsman_scored.over_id and ball_by_ball.ball_id=batsman_scored.ball_id and ball_by_ball.innings_no=batsman_scored.innings_no
join player as p1 on ball_by_ball.striker=p1.player_id
where ball_by_ball.match_id=335987 and p1.player_name='BB McCullum'
group by p1.player_name, Bowling_Style.Bowling_skill, venue.venue_name, ball_by_ball.match_id, bowling_style.initials 
order by 2;


select foo.batsman, foo.innings_no, foo.bowling_skill, no_of_balls,total_runs,nvl(wicket_taken,0) as wic, foo.venue_name, total_runs/nvl(wicket_taken,1)::FLOAT as average_variant_wise
from
(select p1.player_name as batsman, ball_by_ball.innings_no, bowling_style.bowling_skill, venue.venue_name, count(*) no_of_balls, sum(batsman_scored.runs_scored) as total_runs
from ball_by_ball
join batsman_scored on ball_by_ball.match_id=batsman_scored.match_id and ball_by_ball.over_id=batsman_scored.over_id and ball_by_ball.ball_id=batsman_scored.ball_id and ball_by_ball.innings_no=batsman_scored.innings_no
join player as p1 on ball_by_ball.striker=p1.player_id
join player as p2 on ball_by_ball.bowler = p2.player_id
join bowling_style on p2.bowling_skill=bowling_style.bowling_id
join match_ on ball_by_ball.match_id=match_.match_id
join venue on match_.venue_id=venue.venue_id
group by p1.player_name, Bowling_Style.Bowling_skill, venue.venue_name, ball_by_ball.innings_no order by 1)foo
left join
(select p1.player_name as batsman, ball_by_ball.innings_no, bowling_style.bowling_skill, venue.venue_name , count(*) as wicket_taken
from ball_by_ball
join wicket_taken on ball_by_ball.match_id=wicket_taken.match_id and ball_by_ball.over_id=wicket_taken.over_id and ball_by_ball.ball_id=wicket_taken.ball_id and ball_by_ball.striker=wicket_taken.player_out
join player as p1 on wicket_taken.player_out=p1.player_id
join player as p2 on ball_by_ball.bowler = p2.player_id
join bowling_style on p2.bowling_skill=bowling_style.bowling_id
join match_ on ball_by_ball.match_id=match_.match_id
join venue on match_.venue_id=venue.venue_id
group by p1.player_name, Bowling_Style.Bowling_skill, venue.venue_name, ball_by_ball.innings_no order by 1)foo1
on foo.batsman = foo1.batsman and foo.bowling_skill = foo1.bowling_skill and foo.venue_name=foo1.venue_name and foo.innings_no=foo1.innings_no;




-To CALCULATE THE FIFTH HIGHEST RUNS

select a1.*
from
(SELECT a.*
from
(SELECT player, SUM(total_runs) AS sum
FROM predicted_data
GROUP BY player
ORDER BY sum desc
LIMIT 10)a
order by a.sum asc)a1
limit 1;




select a1.*
from
(SELECT a.*
from
(SELECT player, SUM(total_runs) AS sum
FROM predicted_data
GROUP BY player
ORDER BY sum desc
LIMIT 10)a
order by a.sum asc)a1
limit 1;
