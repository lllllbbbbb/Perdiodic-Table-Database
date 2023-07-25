#! /bin/bash
PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"
ARG1=$1
EXIT(){
  exit 0
}
CHECK_EXIST(){
  local query_result=$($PSQL "SELECT 1 FROM properties FULL JOIN elements USING (atomic_number) FULL JOIN types USING (type_id) WHERE name = '$1' LIMIT 1" )
  if [[ -z "$query_result" ]]; then
    echo "I could not find that element in the database."
    EXIT
  else
    :
  fi
}
CHECK_EXIST1(){
  local query_result1=$($PSQL "SELECT 1 FROM properties FULL JOIN elements USING (atomic_number) FULL JOIN types USING (type_id) WHERE atomic_number = '$1' LIMIT 1" )
  if [[ -z "$query_result1" ]]; then
    echo "I could not find that element in the database."
    EXIT
  else
    :
  fi
}
CHECK_EXIST2(){
  local query_result2=$($PSQL "SELECT 1 FROM properties FULL JOIN elements USING (atomic_number) FULL JOIN types USING (type_id) WHERE symbol = '$1' LIMIT 1" )
  if [[ -z "$query_result2" ]]; then
    echo "I could not find that element in the database."
    EXIT
  else
    :
  fi
}

MAIN_FUNCTION(){
  ## get all information
  #COMPLETE_DATABASE_QUERY=$($PSQL "SELECT * FROM properties FULL JOIN elements USING (atomic_number) FULL JOIN types USING (type_id) ORDER BY atomic_number")
  if [[ "$ARG1" ]]; then
    
    if [[ $ARG1 =~ ^[0-9]+$ ]]; then
      CHECK_EXIST1 "$ARG1"
      echo $($PSQL "SELECT * FROM properties FULL JOIN elements USING (atomic_number) FULL JOIN types USING (type_id) WHERE atomic_number = '$ARG1' ORDER BY atomic_number")| while read TYPE_ID BAR ATOMIC_NUMBER BAR ATOMIC_MASS BAR MELTING_POINT_CELSIUS BAR BOILING_POINT_CELSIUS BAR SYMBOL BAR NAME BAR TYPE
      do
        echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT_CELSIUS celsius and a boiling point of $BOILING_POINT_CELSIUS celsius."
      done

    elif [[ $ARG1 =~ ^[a-zA-Z]{3,}$ ]]; then
      CHECK_EXIST "$ARG1"
      echo $($PSQL "SELECT * FROM properties FULL JOIN elements USING (atomic_number) FULL JOIN types USING (type_id) WHERE name = '$ARG1' ORDER BY atomic_number")| while read TYPE_ID BAR ATOMIC_NUMBER BAR ATOMIC_MASS BAR MELTING_POINT_CELSIUS BAR BOILING_POINT_CELSIUS BAR SYMBOL BAR NAME BAR TYPE      
      do
        echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT_CELSIUS celsius and a boiling point of $BOILING_POINT_CELSIUS celsius."
      done

    elif [[ $ARG1 =~ ^[A-Za-z]{1,2}$ ]]; then
      CHECK_EXIST2 "$ARG1"
      echo $($PSQL "SELECT * FROM properties FULL JOIN elements USING (atomic_number) FULL JOIN types USING (type_id) WHERE symbol = '$ARG1' ORDER BY atomic_number")| while read TYPE_ID BAR ATOMIC_NUMBER BAR ATOMIC_MASS BAR MELTING_POINT_CELSIUS BAR BOILING_POINT_CELSIUS BAR SYMBOL BAR NAME BAR TYPE      
      do
        echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT_CELSIUS celsius and a boiling point of $BOILING_POINT_CELSIUS celsius."
      done

    else
      #MAIN_FUNCTION "Please provide a valid argument"
      EXIT
    fi

  else
    echo "Please provide an element as an argument."
    EXIT
  fi
}

MAIN_FUNCTION
