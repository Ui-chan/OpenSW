#!/bin/bash

echo "--------------------------"
echo User Name: 안의찬
echo Student Number: 12201755
echo "[ MENU ]"
echo "1. Get the data of the movie identified by a specific 'movie id' from 'u.item'"
echo "2. Get the data of action genre movies from 'u.item'"
echo "3. Get the average 'rating' of the movie identified by specific 'movie id' from 'u.data'"
echo "4. Delete the 'IMDb URL' from 'u.item"
echo "5. Get the data about users from 'u.user'"
echo "6. Modify the format of 'release date' in 'u.item'"
echo "7. Get the data of movies rated by a specific 'user id' from 'u.data'"
echo "8. Get the average 'rating' of movies rated by users with 'age' between 20 and 29 and 'occupation' as 'programmer'"
echo "9. Exit"
echo "--------------------------"

while true; do
    read -p "Enter your choice [1-9] " option
    case $option in
        1)
      	echo 
        echo -n "Please enter 'movie id' (1~1682): "
        read number
	echo
	awk -v id="$number" -F '|' '$1 == id { printf "%s|%s|%s||%s|", $1, $2, $3, $5; for (i = 6; i <= NF; i++) { printf "%s%s", $i, (i == NF ? "\n" : "|"); } }' u.item
	echo
            ;;


        2)
echo
echo -n "Do you want to get the data of 'action' genre movies from 'u.item'? (y/n):" 
 	read ans
	echo
if [ "$ans" = "y" ]; then
            awk -F '|' '$7 == 1 { print $1, $2}' u.item | sort -n | head -n 10
	echo
        fi            ;;

        3) 

  echo
  echo -n "Please enter the 'movie id'(1~1682):"
  read ans
  echo
awk -v ans="$ans" -F ' ' '$2 == ans { sum += $3; count++ } END { if (count > 0) printf("average rating of %d: %.5f\n", ans, sum / count); }' u.data
echo 
            ;;


        4)
        echo
        echo -n "Do you want to delete the ‘IMDb URL’ from ‘u.item’? (y/n):"
        read ans
        echo
        if [ "$ans" == "y" ]; then
        sed 's/|http[^|]*|/||/' u.item | head -n 10
fi
	echo 
            ;;



        5)
		echo
            echo -n "Do you want to get the data about users from ‘u.user’?(y/n):"
		read ans
	echo
if [ "$ans" == "y" ]; then
  sed -n '1,10 { s/^\([0-9]*\)|\([0-9]*\)|\([MF]\)|\(.*\)|.*/user \1 is \2 years old \3 \4/; s/M/male/; s/F/female/; p; }' u.user
fi
echo 
            ;;



        6)
        echo
        echo -n "Do you want to Modify the format of ‘release data’ in ‘u.item’?(y/n):"
        read ans
	echo
if [ "$ans" == "y" ]; then
  sed -n '1673,1682 {
    s/\([0-9][0-9]\)-Jan-\([0-9][0-9][0-9][0-9]\)/\201\1/;
     s/\([0-9][0-9]\)-Feb-\([0-9][0-9][0-9][0-9]\)/\202\1/;
     s/\([0-9][0-9]\)-Mar-\([0-9][0-9][0-9][0-9]\)/\203\1/;
     s/\([0-9][0-9]\)-Apr-\([0-9][0-9][0-9][0-9]\)/\204\1/;
     s/\([0-9][0-9]\)-May-\([0-9][0-9][0-9][0-9]\)/\205\1/;
	 s/\([0-9][0-9]\)-Jun-\([0-9][0-9][0-9][0-9]\)/\206\1/;
 s/\([0-9][0-9]\)-Jul-\([0-9][0-9][0-9][0-9]\)/\207\1/;
 s/\([0-9][0-9]\)-Aug-\([0-9][0-9][0-9][0-9]\)/\208\1/;
 s/\([0-9][0-9]\)-Sep-\([0-9][0-9][0-9][0-9]\)/\209\1/;
 s/\([0-9][0-9]\)-Oct-\([0-9][0-9][0-9][0-9]\)/\210\1/;
 s/\([0-9][0-9]\)-Nov-\([0-9][0-9][0-9][0-9]\)/\211\1/;
 s/\([0-9][0-9]\)-Dec-\([0-9][0-9][0-9][0-9]\)/\212\1/;
    p;
  }' u.item
fi
echo
            ;;



        7)
echo
echo -n "Please enter the 'user id' (1~943): "
read ans
movies=$(awk -v id="$ans" -F ' ' '$1 == id { print $2 }' u.data | sort -n)

echo "$movies" | awk '{printf "%s%s", sep, $0; sep="|"}'

echo
echo
count=0
echo "$movies" | while read movie_id; do
    movie_title=$(awk -F '|' -v id="$movie_id" '$1 == id { print $2 }' u.item)
    echo "$movie_id|$movie_title"
    count=$((count + 1))
    if [ $count -eq 10 ]; then
        break
    fi
done
echo

            ;;
        8)
echo
echo -n "Do you want to get the average 'rating' of movies rated by users with 'age' between 20 and 29 and 'occupation' as 'programmer'?(y/n): "
read ans
echo

if [ "$ans" == "y" ]; then
    user_ids=$(awk -F '|' '$2 >= 20 && $2 <= 29 && $4 == "programmer" { print $1 }' u.user | tr '\n' ' ')

    movies=()

    while read -r userid movieid rating timestamp; do
        for user_id in $user_ids; do
            if [ "$userid" -eq "$user_id" ]; then
                if [[ ! " ${movies[*]} " =~ " $movieid " ]]; then
                    movies+=("$movieid")
                fi
            fi
        done
    done < u.data

    sorted_movies=($(echo "${movies[*]}" | tr ' ' '\n' | sort -n))

    for movie_id in "${sorted_movies[@]}"; do
        total_rating=0
        count=0

        while read -r userid movieid rating timestamp; do
            if [ "$movieid" -eq "$movie_id" ] && [[ " $user_ids " =~ " $userid " ]]; then
                total_rating=$((total_rating + rating))
                ((count++))
            fi
        done < u.data
if [ "$count" -gt 0 ]; then
    average_rating=$(echo "scale=6; $total_rating / $count" | bc)
    average_rating=$(printf "%.6g" "$average_rating")
    printf "%d %s\n" "$movie_id" "$average_rating"
fi
    done
fi
            ;;
        9)
            echo Bye!
            exit 0
	echo
    esac
done

