#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=number_guess -t -c" 


echo "Enter your username:"
read USERNAME;

USER_DATA=$($PSQL "SELECT * FROM users WHERE username = '$USERNAME'")

if [[ -z $USER_DATA ]]
then
  # add user to data base
  INSERT_RESULT=$($PSQL "INSERT INTO users(username) VALUES('$USERNAME')")
  echo "Welcome, $USERNAME! It looks like this is your first time here."
  GAMES=0
  BEST_ROUND=NULL
else
  # display welcome
  echo "$USER_DATA"
  echo "$USER_DATA" | while read USER_ID BAR USERNAME BAR GAMES BAR BEST_ROUND
  do
  echo "Welcome back, $USERNAME! You have played $GAMES games, and your best game took $BEST_ROUND guesses."
  done
fi

GAMES=$((GAMES + 1))

RANDOM_NUMBER=$((1 + RANDOM % 1000))
echo -e "\nGuess the secret number between 1 and 1000:"
read USER_GUESS
ROUNDS=1


while [[ $USER_GUESS != $RANDOM_NUMBER ]]
do
  if [[ ! $USER_GUESS =~ ^[0-9]+$  ]]
  then
    echo -e "\nThat is not an integer, guess again:"
    read USER_GUESS

  elif [[ $USER_GUESS > $RANDOM_NUMBER ]]
  then
    ROUNDS=$((ROUNDS + 1))
    echo -e "\nIt's lower than that, guess again:"
    read USER_GUESS

  elif [[ $USER_GUESS < $RANDOM_NUMBER ]]
  then
    ROUNDS=$((ROUNDS + 1))
    echo -e "\nIt's higher than that, guess again:"
    read USER_GUESS
  fi
done

if [[ $BEST_ROUND > $ROUNDS ]] || [[ -z $BEST_ROUND ]]
then
  INSERT_INTO_DATABASE_RESULT=$($PSQL "UPDATE users SET best_round = $ROUNDS WHERE username = '$USERNAME'")
fi

INSERT_INTO_DATABASE_RESULT=$($PSQL "UPDATE users SET games = $GAMES WHERE username = '$USERNAME'")

echo -e "\nYou guessed it in $ROUNDS tries. The secret number was $RANDOM_NUMBER. Nice job!"
