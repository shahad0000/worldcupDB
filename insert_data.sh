#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

# Insert teams to the teams table.
cut -d',' -f3,4 games.csv | tail -n +2 | tr ',' '\n' | sort | uniq | while read TEAM; do 
  TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$TEAM'")
  if [[ -z $TEAM_ID ]];
  then
    INSERT_TEAM_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$TEAM');")
    echo "Inserting team: " $TEAM
  fi
done

# Insert games data to the games table.
RESET_TABLE=$($PSQL "TRUNCATE games")
tail -n +2 games.csv | while IFS=',' read YEAR ROUND WINNER OPPONENT WINNER_GOAL OPPONENT_GOAL; do 
 WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
 OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
 INSERT_GAMES_DATA=$($PSQL "INSERT INTO games(year, round, winner_goals, opponent_goals, winner_id, opponent_id) 
  VALUES($YEAR, '$ROUND', $WINNER_GOAL, $OPPONENT_GOAL, $WINNER_ID, $OPPONENT_ID)")
done









