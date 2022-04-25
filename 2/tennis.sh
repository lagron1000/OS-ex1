#!/bin/bash

# TODO:
# 1. switch case for print_ball
# 2. validate p_choice is between 1 and p_score
 
p1_score=50
p2_score=50

ball_position=0

game_on=true

current_score() {
    echo " Player 1: ${p1_score}         Player 2: ${p2_score} "
}

# print_ball() {
#     if   [ $ball_position == 0 ];  then echo " |       |       O       |       | ";
#     elif [ $ball_position == 1 ];  then echo " |       |       #   O   |       | "; 
#     elif [ $ball_position == -1 ]; then echo " |       |   O   #       |       | ";
#     elif [ $ball_position == 2 ];  then echo " |       |       #       |   O   | ";
#     elif [ $ball_position == -2 ]; then echo " |   O   |       #       |       | ";
#     elif [ $ball_position == 3 ];  then echo " |       |       #       |       |O";
#     elif [ $ball_position == -3 ]; then echo "O|       |       #       |       | ";
#     fi
# }

print_ball() {
    case $ball_position in
        0) echo " |       |       O       |       | ";;
        1) echo " |       |       #   O   |       | ";;
       -1) echo " |       |   O   #       |       | ";;
        2) echo " |       |       #       |   O   | ";;
       -2) echo " |   O   |       #       |       | ";;
        3) echo " |       |       #       |       |O";;
       -3) echo "O|       |       #       |       | ";;
    esac
}

starting_position() {
    echo " --------------------------------- "
    echo " |       |       #       |       | "
    echo " |       |       #       |       | "
    print_ball
    echo " |       |       #       |       | "
    echo " |       |       #       |       | "
    echo " --------------------------------- "
}

p1_prompt() {
    echo "PLAYER 1 PICK A NUMBER: "
}

p2_prompt() {
    echo "PLAYER 2 PICK A NUMBER: "
}

prompt_choice() {
    if [ "$1" == 1 ]; then 
        echo "PLAYER 1 PICK A NUMBER: ";
        read -s p1_choice;
        if [[ ! ($p1_choice =~ ^[0-9]+$) ]] || ((p1_choice < 1 || p1_choice >  p1_score )) ; then
        echo "NOT A VALID MOVE !"
        prompt_choice 1;
        else prompt_choice 2;
        fi
    elif [ "$1" == 2 ]; then
        echo "PLAYER 2 PICK A NUMBER: ";
        read -s p2_choice;
        if [[ ! $p2_choice =~ ^[0-9]+$ ]] || (("$p2_choice" < 1 || "$p2_choice" >  "$p2_score" )); then
        echo "NOT A VALID MOVE !"
        prompt_choice 2;
        fi
    fi
}

play_turn() {
    prompt_choice 1
    ((p1_score = p1_score-p1_choice)) 
    ((p2_score = p2_score-p2_choice))
    if [ "$p1_choice" -gt "$p2_choice" ]; then ball_position=$((ball_position+1));
    elif [ "$p1_choice" -lt "$p2_choice" ]; then ball_position=$((ball_position-1));
    fi
}

victory1() {
    echo "PLAYER 1 WINS !"
}

victory2() {
    echo "PLAYER 2 WINS !"
}

tie() {
    echo "IT'S A DRAW !"
}

check_winner() {
    if [ "$ball_position" == 3 ]; then
        game_on=false;
        victory1;
    elif [ "$ball_position" == -3 ]; then
        game_on=false;
        victory2;
    elif [ "$p1_score" -le 0 ] && [ "$p2_score" -le 0 ]; then
        game_on=false;
        if   ((ball_position < 0)); then victory2;
        elif ((ball_position > 0)); then victory1;
        else tie;
        fi
    elif [ "$p1_score" -le 0 ]; then
        game_on=false;
        victory2;
    elif [ "$p2_score" -le 0 ]; then
        game_on=false;
        victory1;
    fi
}

while $game_on
do
    current_score
    starting_position
    play_turn
    check_winner
done