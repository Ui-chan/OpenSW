# 🔥 오픈소스 과제
#### ❌ 밑에 글자가 깨지는 부분있습니다. 
처음에 1~9까지의 입력을 받아 
Case option을 이용하여 입력 번호에 따른 다음 기능들을 실행한다.

1) 
Movie id로 부터 정보 얻기
입력이 1인 경우
Movie id 에 대한 사용자의 입력을 number에 받는다. 
그리고 number을 id라는 변수에 저장하고, 구분자를 ‘|’로 설정한다. 그리고 $1==id인 패턴을 찾아 다음 기능을 실행한다. 
출력에는 $1(movie id), $2(movie title), $3(movie data), $5(IMDb URL)를 출력한 뒤, 
I = 6부터 현재 라인의 마지막 필드까지 반복되는 for문을 만들어 i는 계속 1씩 증가하고 그리고 아래에서 (I == NF ? “\n” : “|”) 부분은 만약에 i가 NF 즉 마지막 필드인 경우에는 \n을 출력하고 마지막 필드가 아닌경우에는 |를 출력한다. 
그리고 위 모든 동작은 u.item 파일 내에 있는 데이터로 진행된다. 


2) 
Action 장르 영화의 목록 10개 출력
사용자의 입력을 ans에 받는다
만약 입력이 y일 경우 다음 기능을 실행한다. 
위와 동일하게 구분자를 ‘|’을 사용하고 $7(Action)== 1 일 경우 print{$1(movie id), $2(movie title)}를 출력한다. 여기서 이것들을 오름차순 정렬을 하기위해 sort -n을 이용하였고, 10개 데이터만 불러오기 위해 head -n 10을 사용하였다. 


3)
Movie id에 대한 rating 평균 
사용자의 입력을 ans에 받는다.
그리고 구분자는 공백, $2(movie id) == ans 일경우에 sum += $3(rating)을 한다. 그리고 동시에 count++ 를 한다. 
만약에 count>0 일경우 우리는 sum/count를 통해 해당 rating의 평균을 알 수 있다.
그렇게 하여 ans, sum/count를 이용해 출력한다. 여기서는 u.data를 이용한다. 
그리고 우리는 다섯번째자리까지 반올림을 하여 출력한다. ( 3.878318 -> 3.87832)


4) 
U.item에서 IMDb URL 지우고 출력하기
사용자의 입력을 ans에 받는다. 
ans가 y일 경우 sed를 통해 http로 시작하고 |로 끝나는 부분을 찾아서 || 로 바꾼다.(치환) 
그리고 상위 10개만 출력한다. (U.item에서)


5)
users에 대한 데이터를 출력
입력을 ans에 받는다. 
ans가 y일 경우 
sed -n ‘1,10  옵션을 통해 1번째 라인부터 10번째 라인까지 처리 범위를 지정. 
S 를 통해 앞과 같이 치환.
그 다음은 패턴이다. 
s/^\([0-9]*\)|\([0-9]*\)|\([MF]\)|\(.*\)|.*
이부분을 처음부터 해석하면 라인의 시작을 알리는 ^과 숫자그룹(user id) | 숫자 그룹(age) | M or F(gender) | 기타(occupation) | 나머지 이와 같이 해석할 수 있다. 
 /user \1 is \2 years old \3 \4/; -> user [user id] is [age] year old [gender] [occupation]
으로 볼 수 있다. 하지만 여기서 뒷 부분에 
s/M/male/; s/F/female/; p; }' u.user 을 통해 gender 부분에 M 일 경우 male 로 F 경우에는 female로 치환하여 출력한다. 위 모든 데이터는 u.user에서 얻어 진행된다. 


6)
u.item에 있는 Release data를 수정하여 출력
입력을 ans에 받는다. 
ans가 y인 경우 
sed -n ’1673,1682’까지의 데이터만 이용하여 출력한다.
그 다음은 또 치환이다. 
하나의 예시를 보겠다. 
s/\([0-9][0-9]\)-Jan-\([0-9][0-9][0-9][0-9]\)/\201\1/; -> 숫자2개-Jan-숫자4개(release data)로 이루어진 것을 “숫자4개01숫자2개”와 같이 출력한다.  여기서 주의 할 점은 Jan이라 01을 출력하도록 하였다. Feb는 02, Mar = 03 와 같은 방법으로 모든 달을 그에 맞게 설정하여 출력하도록 하였다.(u.item 데이터 이용)


7)
User id를 통해 평가한 영화번호 정렬과 영화번호와 영화이름 10개 출력
입력을 ans에 받는다.
movies=$(awk -v id="$ans" -F ' ' '$1 == id { print $2 }' u.data | sort -n) -> 구분자가 공백이고 $1(user id)와 id(and)가 같은 경우 $2(movie id)를 정렬하여 movies에 저장한다. (u.data에서)
echo "$movies" | awk '{printf "%s%s", sep, $0; sep="|"}' -> movies에 저장된 것들을 “|” 문자로 연결하고 sep을 “|”로 설정하여 출력한다. 
echo "$movies" | while read movie_id; do -> movies의 목록을 movie_id변수에 할당. 그 후 블럭 실행 
movie_title=$(awk -F '|' -v id="$movie_id" '$1 == id { print $2 }' u.item) -> $1(movie id)과 id(movie_id)가 같은 경우 $2(movie title) 를 movie_title에 저장(u.item에서) 
echo "$movie_id|$movie_title" -> movie_id와 movie_title를 출력한다. 
count는 계속 count + 1을 진행한다. 
그리고 count가 10 일경우 break를 통해 탈출한다.(10줄만 출력) 


8)
20대면서 직업이 programmer인 사람들이 평가한 영화들의 리스트와 평점의 평균 출력
입력을 ans에 받는다.
ans가 y인 경우
user_ids=$(awk -F '|' '$2 >= 20 && $2 <= 29 && $4 == "programmer" { print $1 }' u.user | tr '\n' ' ')
-> 구분자가 | 이면서 $2가 20~ 29인 즉 20대이면서 $4(occupation)이 programmer인 사람의 $1을 user_ids에 저장하는데 이때 tr ’n’ ‘ ‘ 을 통해 한 줄에 모든 id를 나열하여 user_ids에 저장한다. 
while read -r userid movieid rating timestamp; do -> u.data파일에서 데이터를 불러와 각 줄을 userid movieid rating timestamp변수에 저장한다. 그리고 블럭을 실행한다. 
그 후 안에 내용은 user_ids배열에 있는 원소들을 user_id에 저장하여 반복문을 실행한다. 
만약 user_id와 userid와 같다면 실행한다. 
                if [[ ! " ${movies[*]} " =~ " $movieid " ]]; then
                    movies+=("$movieid")
                fi -> 위에 movies라는 배열에 movieid가 들어있지 않다면 movies배열에 movieid를 추가하는 작업이다. 이를 통해 movies에는 저장된 원소들은 중복되지 않는다. 

sorted_movies=($(echo "${movies[*]}" | tr ' ' '\n' | sort -n)) -> movies 배열에 저장되어 있는 값들을 정렬하여 sorted_movies에 저장한다.

for movie_id in "${sorted_movies[@]}"; do -> sorted_movies배열에 들어있는 모든 원소들을 movie_id에 저장하면서 for문을 진행한다. 
total_rating과 count는 0으로 설정하여 평균을 구하는데 사용한다. 
아래 부분은 위와 많이 비슷하다. U.data파일에서 데이터를 불러와 각 줄을 userid moved rating timestamp 변수에 저장한다. 그리고 블럭 실행. 
            if [ "$movieid" -eq "$movie_id" ] && [[ " $user_ids " =~ " $userid " ]]; then
                total_rating=$((total_rating + rating))
                ((count++))
            fi -> movieid와 movie_id가 같고 user_ids와 userid값이 동일한 경우 total_rating에는 rating을 더한다. 그리고 count++를 진행한다.
마지막으로 count가 0보다 크다면
average_rating=$(echo "scale=6; $total_rating / $count" | bc) ->  scale =6 을 통해 소수점 이하 6자리까지 유효한 숫자를 표시하면서 average_rating을 구한다. 
average_rating=$(printf "%.6g" "$average_rating”) -> %.6g를 통해 소수점 이하 6자리까지의 유효한 숫자로 반올림하여 average_rating을 구한다. 
그리고 마지막으로 이를 출력한다. 


9)
종료 
exit 0 
