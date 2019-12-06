
-- Mapping the bowling_skill with player name
select bowling_style.Bowling_skill from bowling_style
join player on bowling_style.Bowling_Id=player.Bowling_skill
where player.Player_Name='Javon Searless';

select bowling_style.Bowling_skill from bowling_style
join player on bowling_style.Bowling_Id=player.Bowling_skill
where player.Player_Name='Sandeep Sharma';


select player, sum(predicted_average_variant_wise*(case when wic=0 then 1 else wic end))/sum(case when wic=0 then 1 else wic end) as predicted_runs from predicted_data where bowling_skill in ('Legbreak','Right-arm offbreak','Slow left-arm chinaman','Right-arm medium-fast', 'Right-arm medium-fast') and venue_name='Eden Gardens'  group by player order by 1 ;

-- Predicting the runs scored by a particular batsmen
select sum(predicted_average_variant_wise*(case when wic=0 then 1 else wic end))/sum(case when wic=0 then 1 else wic end) as predicted_runs from predicted_data where bowling_skill in ('Legbreak','Right-arm offbreak','Slow left-arm chinaman','Right-arm medium-fast', 'Right-arm fast') and venue_name='Eden Gardens' and player='A Mishra' group by player order by 1 ;


select player, sum(predicted_average_variant_wise*(case when wic=0 then 1 else wic end))/sum(case when wic=0 then 1 else wic end) as prediction from predicted_data where bowling_skill in ('Slow left-arm chinaman','Right-arm fast','Legbreak','Right-arm offbreak', 'Right-arm offbreak') and venue_name='M Chinnaswamy Stadium' group by player order by 1 ;



select sum(predicted_average_variant_wise*(case when wic=0 then 1 else wic end))/sum(case when wic=0 then 1 else wic end) as predicted_runs from predicted_data
where bowling_skill in (select bowling_style.Bowling_skill from bowling_style join player on bowling_style.Bowling_Id=player.Bowling_skill
where player.Player_Name in ('$bowler1','$bowler2','$bowler3', '$bowler4', '$bowler5')) and venue_name='$venue' and player='$batter' group by player order by 1



select round(sum(predicted_average_variant_wise*(case when wic=0 then 1 else wic end))/sum(case when wic=0 then 1 else wic end), 0.0) as predicted_runs, player from predicted_data
where bowling_skill in (select bowling_style.Bowling_skill from bowling_style join player on bowling_style.Bowling_Id=player.Bowling_skill
where player.Player_Name in ('SP Narine','Kuldeep Yadav','PP Chawla', 'AD Russell', 'Shivam Mavi'))
and venue_name='Eden Gardens' and player in (select PLAYER from IPL_2018_SQUAD where Team_Name='V Kohli') group by player order by 1;


select round(sum(predicted_average_variant_wise*(case when wic=0 then 1 else wic end))/sum(case when wic=0 then 1 else wic end), 0.0) as predicted_runs, player from predicted_data
where bowling_skill in (select bowling_style.Bowling_skill from bowling_style join player on bowling_style.Bowling_Id=player.Bowling_skill
where player.Player_Name in ('$bowler1','$bowler2','$bowler3', '$bowler4', '$bowler5'))
and venue_name='$venue' and player in (select PLAYER from IPL_2018_SQUAD where Team_Name='$batter') group by player order by 1;





select round(sum(predicted_average_variant_wise*(case when wic=0 then 1 else wic end))/sum(case when wic=0 then 1 else wic end), 0.0) as predicted_runs, player from predicted_data
where bowling_skill in (select Bowling_Style.bowling_skill from Bowling_Style
join player on bowling_style.bowling_id=player.bowling_skill
join main_bowlers on player.player_name=main_bowlers.bowler_name where main_bowlers.team_name='Kolkata Knight Riders')
and venue_name='Eden Gardens' and player in (select PLAYER from IPL_2018_SQUAD where Team_Name='Mumbai Indians') group by player order by 1;



select round(sum(predicted_average_variant_wise*(case when wic=0 then 1 else wic end))/sum(case when wic=0 then 1 else wic end), 0.0) as predicted_runs, player from predicted_data
where bowling_skill in (select Bowling_Style.bowling_skill from Bowling_Style
join player on bowling_style.bowling_id=player.bowling_skill
join main_bowlers on player.player_name=main_bowlers.bowler_name where main_bowlers.team_name='$bowler1')
and venue_name='$venue' and player in (select PLAYER from IPL_2018_SQUAD where Team_Name='$batter') group by player order by 1;




select round(sum(predicted_average_variant_wise*(case when wic=0 then 1 else wic end))/sum(case when wic=0 then 1 else wic end), 0.0) as predicted_runs, player from predicted_data
where bowling_skill in (select Bowling_Style.bowling_skill from Bowling_Style
join player on bowling_style.bowling_id=player.bowling_skill
join main_bowlers on player.player_name=main_bowlers.bowler_name where main_bowlers.team_name='Kolkata Knight Riders')
and venue_name='Eden Gardens' and player in (select PLAYER from IPL_2018_SQUAD where Team_Name='Royal Challengers Bangalore') group by player order by 1;



select Bowling_Style.bowling_skill from Bowling_Style
join player on bowling_style.bowling_id=player.bowling_skill
join main_bowlers on player.player_name=main_bowlers.bowler_name where main_bowlers.team_name='Kolkata Knight Riders'; 



select (sum(predicted_average_variant_wise*(case when wic=0 then 1 else wic end))/sum(case when wic=0 then 1 else wic end))::int as prediction from predicted_data
where bowling_skill in ('Slow left-arm chinaman','Right-arm offbreak','Legbreak','Right-arm medium-fast', 'Right-arm offbreak') and venue_name='M Chinnaswamy Stadium' and player='V Kohli'
group by player order by 1 ;














