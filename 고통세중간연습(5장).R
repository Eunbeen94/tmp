
library("nycflights13")
library("tidyverse")
# 5.2.4 Exercises



# 1.Find all flights that

#   1.Had an arrival delay of two or more hours
# 부정_지연 변수는 분 단위로 측정되므로 도착 지연 시간이 120분 이상인 항공편을 찾으십시오.

filter(flights, arr_delay >= 120)

#   2.Flew to Houston ( IAH  or  HOU )
# 휴스턴으로 날아간 항공편은 목적지(최종)가 "IAH" 또는 "HOU"인 항공편이다.

filter(flights, dest == "IAH" | dest == "HOU")

# 그러나 %in%를 사용하는 것은 더 복잡하며 우리가 관심이 있는 
# 두 개 이상의 공항이 있는 사례로 확장될 것이다.

filter(flights, dest %in% c("IAH", "HOU"))

#   3.Were operated by United, American, or Delta
# 비행 데이터셋에서 컬럼 캐리어는 항공사를 표시하지만, 2자 캐리어 코드를 사용한다. 
# 우리는 항공사 데이터셋에서 항공사의 운송 회사 코드를 찾을 수 있다. 
# 통신사 코드 데이터 세트는 16개 행만 있으며, 해당 데이터 세트의 항공사 이름은 
# 정확히 "United", "American" 또는 "Delta"가 아니기 때문에, 
# 해당 데이터에서 통신사 코드를 수동으로 조회하는 것이 가장 쉽다.

airlines

# 델타의 통신사 코드는 "DL", 미국인은 "AA", 유나이티드에는 "UA"이다. 
# 이 통신사 코드를 이용해서 통신사가 그 중 하나인지 확인한다.

filter(flights, carrier %in% c("AA", "DL", "UA"))

#   4.Departed in summer (July, August, and September)
# 가변월에는 월이 있고, 숫자로 되어 있다. 
# 그래서 여름 항공편은 7개월(7월), 8월(8월), 9월(9월)에 출발한 항공편이다.

filter(flights, month >= 7, month <= 9)

# %in% 연산자가 대안이다. : 연산자를 사용하여 정수 범위를 지정할 경우 
# 표현식은 판독 가능하고 압축된다.

filter(flights, month %in% 7:9)

# 우리는 또한 | 연산자를 사용할 수 있다. 
# 그러나, |는 많은 선택에 달하지 않는다. 세 가지 선택만 있어도 꽤 장황하다.

filter(flights, month == 7 | month == 8 | month == 9)

# 또한 연습 5.2.2와 같이 간 기능을 사용할 수 있다.

#   5.Arrived more than two hours late, but didn’t leave late
# 2시간 이상 늦게 도착했지만 늦게 출발하지 않은 항공편은 도착 지연이 
# 120분 이상(arr_delay > 120)이고, 출발 지연은 양수되지 않는다(dep_delay 0 0).

filter(flights, arr_delay > 120, dep_delay <= 0)

#   6.Were delayed by at least an hour, but made up over 30 minutes in flight
# 최소 1시간 지연됐지만 비행시간은 30분이 넘었다. 
# 비행기가 적어도 한 시간 지연되었다면 de_delay >= 60. 
# 만약 비행이 공중에서 시간을 보충하지 않는다면, 
# 비행이 출발과 동일한 양만큼 도착이 지연될 것이다. 
# 즉, de_delay == fal_delay 0을 의미한다. 
# 또는 dec_delay - pred_delay == 0. 만약 비행이 공중에서 30분 이상을 보충한다면, 
# 도착 지연은 de_de_de라고 언급된 출발 지연보다 적어도 30분 이상 짧아야 한다.
# lay - acr_delay > 30.

filter(flights, dep_delay >= 60, dep_delay - arr_delay > 30)

#   7.Departed between midnight and 6am (inclusive)
# 자정에서 오전 6시 사이에 출발하는 항공편을 찾는 것은 
# 시간들이 데이터에 나타나는 방식으로 복잡하다.
# dep_time에서 자정은 0이 아니라 2400으로 표시된다. 
# dep_time의 최소값과 최대값을 확인하여 확인할 수 있다.

summary(flights$dep_time)

# 이것은 데이터의 요약 통계를 확인하는 것이 항상 좋은 이유를 보여주는 예다. 
# 불행하게도, 이것은 우리가 단지 그 dem_time < 600을 
# 단순히 확인할 수 없다는 것을 의미한다. 
# 왜냐하면 우리는 또한 자정이라는 특별한 경우를 고려해야 하기 때문이다.

filter(flights, dep_time <= 600 | dep_time == 2400)

# 또는 모듈로 연산자 %%를 사용할 수 있다. 
# 모듈로 운영자는 분할의 나머지를 반환한다. 
# 이것이 우리 시대에 어떤 영향을 미치는지 보자.

c(600, 1200, 2400) %% 2400

# 2400% 2400 == 0과 다른 모든 시간은 변경되지 않으므로, 
# 우리는 모듈로 작동의 결과를 600과 비교할 수 있다.

filter(flights, dep_time %% 2400 <= 600)

# 2400% 2400 == 0과 다른 모든 시간은 변경되지 않으므로, 
# 우리는 모듈로 작동의 결과를 600과 비교할 수 있다.


# 2.Another useful dplyr filtering helper is  between() . What does it do? Can you use it to simplify the code needed to answer the previous challenges?
# (x, 왼쪽, 오른쪽) 사이의 표현은 x >= 왼쪽 & x <= 오른쪽과 같다.
# 앞의 질문의 답변 중, 간() 함수를 이용하여 여름에 출발하는 
# 진술(월 >= 7 & 월 depart 9)을 간소화할 수 있었다.  

filter(flights, between(month, 7, 9))
  


# 3.How many flights have a missing  dep_time ? What other variables are missing? What might these rows represent?
# is.na() 기능을 사용하여 출발 시간(dep_time)이 누락된 비행 행을 찾으십시오.

filter(flights, is.na(dep_time))
  
# 특히 이러한 행에 대해서는 도착 시간(arr_time)도 누락되어 있다. 이 비행기들은 취소된 것 같다.


# 4.Why is  NA ^ 0  not missing? Why is  NA | TRUE  not missing? Why is  FALSE & NA  not missing? Can you figure out the general rule? ( NA * 0  is a tricky counterexample!)
# NA ^ 0 == 1 since for all numeric values x0=  1.

NA^0

# NA | TRUE is TRUE because the value of the missing TRUE or FALSE,  
# xor TRUE is TRUE for all values of  x.

NA | TRUE

# Likewise, anything and FALSE is always FALSE

NA & FALSE

# Because the value of the missing element matters 
# in NA | FALSE and NA & TRUE, these are missing:

NA | FALSE

NA & TRUE

# Since x???0=0 for all finite, numeric x, we might expect NA*0 == 0, 
# but that’s not the case.

NA * 0

Inf * 0
-Inf * 0




# 5.3.1 Exercises

# 1.How could you use  arrange()  to sort all missing values to the start? (Hint: use  is.na() ).

arrange(flights, dep_time) %>%
  tail()

arrange(flights, desc(dep_time))

# NA 값을 우선시하기 위해 해당 컬럼에 결측값이 있는지 여부를 
# 나타내는 지표를 추가할 수 있다. 그런 다음 누락된 표시기 열과 
# 관심 열을 기준으로 분류한다. 예를 들어 데이터 프레임을 
# 출발 시간(dep_time)별로 오름차순으로 정렬하되 NA 값을 먼저 
# 지정하려면 다음을 실행하십시오.

arrange(flights, desc(is.na(dep_time)), dep_time)

# 항공편은 우선 desc(is.na(dep_time)).으로 분류될 것이다. 
# desc(is.na(dep_time))은 dep_time이 없을 때 TRUE이거나, 
# 그렇지 않을 경우 dep_time의 누락 값이 있는 행이 TRUE > FALSE 이후 먼저 온다.


# 2.Sort  flights  to find the most delayed flights. Find the flights that left earliest.
# 출발 지연, de_delay, 내림차순으로 표를 분류하여 가장 지연된 항공편을 찾으십시오.

arrange(flights, desc(dep_delay))

# 가장 지연된 항공편은 2013년 1월 9일 출발 예정이었던 HA 51, JFK to HNL이었다. 
# 출발 시간은 641로 되어 있어 예정된 출발 시간보다 적은 것 같다. 
# 그러나 출발이 1,301분 지연되었는데, 21시간 41분이다. 
# 출발 시간은 예정된 출발 시간 다음날이다. 
# 네가 그 비행기에 타지 않은 것을 기뻐하고, 만약 네가 우연히 그 비행기에 
# 탑승해서 이 글을 읽고 있다면, 나는 너에게 미안하다.

# 마찬가지로 de_delay를 오름차순으로 정렬하면 가장 빠른 출발 항공편을 찾을 수 있다.

arrange(flights, dep_delay)

# 2013년 12월 7일 21시 23분에 출발하기로 예정된 B6 97편(JFK to DEN)은 43분 일찍 출발했다.


# 3.Sort  flights  to find the fastest flights.
# 가장 빠른 비행은 평균 지상속도를 가진 것으로 비행거리와 지속시간으로 계산할 수 있다. 
# 지상 속도는 데이터에 포함되지 않으므로 먼저 지상 속도를 포함하는 
# 비행에서 시속 마일 단위로 새 열을 생성한다.

fastest_flights <- mutate(flights, mph = distance / air_time * 60)
fastest_flights <- select(
  fastest_flights, mph, distance, air_time,
  flight, origin, dest, year, month, day
)

# 이제 가장 빠른 항공편을 찾으려면 mph로 항공편을 분류하십시오

head(arrange(fastest_flights, desc(mph)))


# 4.Which flights travelled the longest? Which travelled the shortest?
# 가장 긴 항공편을 찾으려면 거리 열을 기준으로 내림차순으로 항공편을 정렬하십시오.

arrange(flights, desc(distance))

# 가장 긴 비행은 HA 51, JFK to HNL로 4,983 마일이다.
# 최단거리 비행을 찾으려면 거리를 기본 정렬 순서인 오름차순으로 정렬하십시오.

arrange(flights, distance)

# 가장 짧은 비행은 US 1632, EWR에서 LGA까지 17마일 밖에 안 된다. 
# 이것은 뉴욕 지역 공항들 사이의 비행이다. 그러나, 이 비행은 출발 시간이 
# 없기 때문에 실제로 비행하지 않았거나 데이터에 문제가 있다.

# "가장 긴"과 "가장 짧은"이라는 용어는 또한 거리 대신에 비행 시간을 나타낼 수 있다. 
# 이제 Air_time column을 기준으로 분류하면 가장 길고 짧은 비행편을 발견할 수 있다. 
# 항공기에 의한 가장 긴 비행은 다음과 같다.

arrange(flights, desc(air_time))

# 항공기로 가장 짧은 비행은 다음과 같다.

arrange(flights, air_time)



# 5.4.1 Exercises


# 1.Brainstorm as many ways as possible to select  dep_time ,  dep_delay ,  arr_time , and  arr_delay  from  flights .
# 이것들은 열을 선택하는 몇 가지 방법이다.
# 열 이름을 인용되지 않은 변수 이름으로 지정하십시오.

select(flights, dep_time, dep_delay, arr_time, arr_delay)

# 열 이름을 문자열로 지정하십시오.

select(flights, "dep_time", "dep_delay", "arr_time", "arr_delay")

# 변수의 열 번호를 지정하십시오.

select(flights, 4, 6, 7, 9)

# 이것은 효과가 있지만, 두 가지 이유로 좋은 관행은 아니다. 
# 첫째, 변수의 열 위치가 변경되어 오류 없이 계속 실행될 수 있는 코드가 
# 생성될 수 있으나 틀린 답을 만들어 낼 수 있다. 두 번째 코드는 어떤 변수가 
# 선택되고 있는지 코드에서 명확하지 않기 때문에 난독화된다. 
# 6번 열은 어떤 변 방금 코드를 썼는데, 벌써 잊어버렸어.

# 문자 벡터와 one_of()()가 있는 변수의 이름을 지정하십시오.

select(flights, one_of(c("dep_time", "dep_delay", "arr_time", "arr_delay")))

# 변수의 이름을 변수에 저장하여 one_of()로 전달할 수 있기 때문에 유용하다.

variables <- c("dep_time", "dep_delay", "arr_time", "arr_delay")
select(flights, one_of(variables))

# starts_with()를 사용하여 이름 시작과 일치시켜 변수 선택

select(flights, starts_with("dep_"), starts_with("arr_"))

# 일치()가 있는 정규식을 사용하여 변수 선택 정규식은 문자열 패턴을 
# 유연하게 일치시키는 방법을 제공하며 문자열 장에서 논의된다.

select(flights, matches("^(dep|arr)_(time|delay)$"))

# 효과가 없는 것도 있다.

# end_with()를 사용하여 이름 끝을 일치시키면 다른 변수가 잘못 포함될 수 있다. 예를들면

select(flights, ends_with("arr_time"), ends_with("dep_time"))

# 다른 변수를 잘못 포함하지 않고 이 모든 변수를 포함할 수 있는 패턴이 
# 없기 때문에 이름을 사용하여 일치하는 것은()를 포함한다.

select(flights, contains("_time"), contains("arr_"))


# 2.What happens if you include the name of a variable multiple times in a  select()  call?
# 선택() 호는 복제를 무시한다. 중복된 변수는 첫 번째 위치에 한 번만 포함된다. 
# select() 함수는 중복 변수가 있을 경우 오류나 경고를 발생시키거나
# 메시지를 인쇄하지 않는다.  
  
select(flights, year, month, day, year, year)

# 이 행동은 모든 열의 이름을 명시할 필요 없이 칼럼의 순서를 쉽게 
# 변경할 수 있도록 모든 것()과 함께 선택()을 사용할 수 있다는 것을 
# 의미하기 때문에 유용하다.

select(flights, arr_delay, everything())


# 3.What does the  one_of()  function do? Why might it be helpful in conjunction with this vector?

vars <- c("year", "month", "day", "dep_delay", "arr_delay")

# one_of() 함수는 인용되지 않은 변수 이름 인수 대신 문자 벡터가 있는 변수를 선택한다. 
# 이 함수는 입력하기 쉬운 인용되지 않은 변수 이름을 생성하는 것보다 
# 변수 이름을 가진 문자 벡터를 프로그래밍적으로 생성하는 것이 더 쉽기 때문에 유용하다.

vars <- c("year", "month", "day", "dep_delay", "arr_delay")
select(flights, one_of(vars))

# dplyr의 최신 버전(R4DS가 원래 게시된 후)에서는 
# 선택할 변수 이름을 포함하는 벡터의 이름을 제공할 수 있다.

select(flights, vars)

# 그러나 이것에는 문제가 있다. vars가 열 이름인지 변수인지 명확하지 않다. 
# 코드가 평가되는 방법은 비행 중에 기둥이 칼럼인지 여부에 따라 달라진다. 
# 기둥이 비행 중 칼럼이라면, 그 코드는 기둥이 있는 기둥만 선택할 것이다. 
# 기둥이 비행 중 기둥이 아닌 경우, 기둥이 그 값으로 대체되고, 기둥이 선택된다. 
# 이름이 같거나 데이터 프레임의 열 이름과 충돌하지 않도록 하려면 !!! 
# (bang-bang-bang) operator.

select(flights, !!!vars)

# 많은 정돈된 기능에 의해 사용되는 이 행동은 R에서 NSE(비표준 평가)라고 
# 불리는 것의 한 예다. 이 항목에 대한 자세한 내용은 
# dplyr vignette, Programming with dplyr을 참조하십시오.


# 4.Does the result of running the following code surprise you? How do the select helpers deal with case by default? How can you change that default?

select(flights, contains("TIME"))

#  contains()에 대한 기본 동작은 사례를 무시하는 것이다. 
# 이것은 너를 놀라게 할 수도 있고 그렇지 않을 수도 있다. 
# 만약 이 행동이 여러분을 놀라게 하지 않는다면, 그것이 디폴트인 이유일 수 있다. 
# 변수 이름을 검색하는 사용자는 아마도 대문자보다 변수에서 문자를 
# 더 잘 이해할 수 있을 것이다. 두 번째, 기술적 이유는 dplyr이 R 데이터 프레임 이상에서 
# 작동하기 때문이다. 그것은 또한 다양한 데이터베이스와 함께 작동할 수 있다. 
# 이러한 데이터베이스 엔진 중 일부는 대/소문자를 구분하지 않는 열 이름을 
# 가지고 있으므로, 기본적으로 변수 이름에 일치하는 기능을 무감각하게 만들면 
# 테이블이 R 데이터 프레임으로 저장되든, 데이터베이스에 저장되든 상관없이 
# select()의 동작을 일관되게 할 것이다.

# 동작을 변경하려면 unit.case = FALSE 인수를 추가하십시오.

select(flights, contains("TIME", ignore.case = FALSE))


# 5.5.2 Exercises


# 1.Currently  dep_time  and  sched_dep_time  are convenient to look at, but hard to compute with because they’re not really continuous numbers. Convert them to a more convenient representation of number of minutes since midnight.


# 2.Compare  air_time  with  arr_time - dep_time . What do you expect to see? What do you see? What do you need to do to fix it?
  
  
# 3.Compare  dep_time ,  sched_dep_time , and  dep_delay . How would you expect those three numbers to be related?
  
  
# 4.Find the 10 most delayed flights using a ranking function. How do you want to handle ties? Carefully read the documentation for  min_rank() .


# 5.What does  1:3 + 1:10  return? Why?
  
1:3 + 1:10
  
c(1 + 1, 2 + 2, 3 + 3, 1 + 4, 2 + 5, 3 + 6, 1 + 7, 2 + 8, 3 + 9, 1 + 10)

# 6.What trigonometric functions does R provide?
  

# 5.6.7 Exercises


# 1.Brainstorm at least 5 different ways to assess the typical delay characteristics of a group of flights. Consider the following scenarios:
  
#   A flight is 15 minutes early 50% of the time, and 15 minutes late 50% of the time.
#   A flight is always 10 minutes late.
#   A flight is 30 minutes early 50% of the time, and 30 minutes late 50% of the time.
#   99% of the time a flight is on time. 1% of the time it’s 2 hours late.

# Which is more important: arrival delay or departure delay?
  
  
# 2.Come up with another approach that will give you the same output as  not_cancelled %>% count(dest)  and  not_cancelled %>% count(tailnum, wt = distance)  (without using  count() ).


# 3.Our definition of cancelled flights ( is.na(dep_delay) | is.na(arr_delay)  ) is slightly suboptimal. Why? Which is the most important column?
# 비행기가 떠나지 않으면, 도착하지 않을 것이다. 
# 비행기가 추락하거나, 목적지가 아닌 다른 공항에 착륙할 경우, 
# 비행기도 출발하여 도착하지 않을 수 있다. 
# 그래서 가장 중요한 칼럼은 도착 지연량을 나타내는 frag_delay이다.  
  
filter(flights, !is.na(dep_delay), is.na(arr_delay)) %>%
  select(dep_time, arr_time, sched_arr_time, dep_delay, arr_delay)

# 좋아, 이 데이터에서 무슨 일이 일어나고 있는지 잘 모르겠어. 
# dec_time은 누락되지 않고 부정_delay는 누락되지 않지만 부정_time은 누락되지 않아. 
# 서로 다른 비행편을 조합하고 있는 것 같아?


# 4.Look at the number of cancelled flights per day. Is there a pattern? Is the proportion of cancelled flights related to the average delay?
  
  
# 5.Which carrier has the worst delays? Challenge: can you disentangle the effects of bad airports vs. bad carriers? Why/why not? (Hint: think about  flights %>% group_by(carrier, dest) %>% summarise(n()) )

flights %>%
  group_by(carrier) %>%
  summarise(arr_delay = mean(arr_delay, na.rm = TRUE)) %>%
  arrange(desc(arr_delay))

filter(airlines, carrier == "F9")

# 각 항공사의 평균 지연을 노선 내 비행의 평균 지연
# (동일한 출발지에서 동일한 목적지까지의 비행)과 비교함으로써 
# 공항 대 악항운송업체의 영향을 해소하는 방법의 일부를 얻을 수 있다. 
# 통신사 간 및 각 경로 내에서 지연을 비교하는 것은 운송사와 공항의 영향을 구분한다. 
# 더 나은 분석은 항공사의 비행의 평균 지연을 경로 내의 다른 모든 항공사의 비행의 
# 평균 지연과 비교할 수 있다.

flights %>%
  filter(!is.na(arr_delay)) %>%
  # Total delay by carrier within each origin, dest
  group_by(origin, dest, carrier) %>%
  summarise(
    arr_delay = sum(arr_delay),
    flights = n()
  ) %>%
  # Total delay within each origin dest
  group_by(origin, dest) %>%
  mutate(
    arr_delay_total = sum(arr_delay),
    flights_total = sum(flights)
  ) %>%
  # average delay of each carrier - average delay of other carriers
  ungroup() %>%
  mutate(
    arr_delay_others = (arr_delay_total - arr_delay) /
      (flights_total - flights),
    arr_delay_mean = arr_delay / flights,
    arr_delay_diff = arr_delay_mean - arr_delay_others
  ) %>%
  # remove NaN values (when there is only one carrier)
  filter(is.finite(arr_delay_diff)) %>%
  # average over all airports it flies to
  group_by(carrier) %>%
  summarise(arr_delay_diff = mean(arr_delay_diff)) %>%
  arrange(desc(arr_delay_diff))

# 이러한 분석을 수행하는 더 정교한 방법들이 있지만, 
# 각 노선 내에서 비행의 지연을 비교하는 것은 공항과 항공사의 
# 영향을 분리하는 데 많은 도움이 된다. 이 분석의 더 완벽한 예를 보려면 
# 이 530시 30분 피스를 참조하십시오.


# 6.What does the  sort  argument to  count()  do. When might you use it?

# RE : 계산할 정렬 인수는 n의 순서로 결과를 분류한다. 
# 당신은 이것을 실행한 다음에 배열()을 할 때 언제든지 사용할 수 있다.  
  

# 5.7.1 Exercises


# 1.Refer back to the lists of useful mutate and filtering functions. Describe how each operation changes when you combine it with grouping.


# 2.Which plane ( tailnum ) has the worst on-time record?
  
  
# 3.What time of day should you fly if you want to avoid delays as much as possible?
# 비행시간대로 집합합시다. 비행 일정이 빠를수록 예상 지연은 낮아진다. 
# 지연이 후발 항공편에 영향을 줄 것이기 때문에 이것은 직관적이다. 
# 아침 비행은 지연될 수 있는 이전 비행이 적다.

flights %>%
  group_by(hour) %>%
  summarise(arr_delay = mean(arr_delay, na.rm = TRUE)) %>%
  arrange(arr_delay)

  
# 4.For each destination, compute the total minutes of delay. For each flight, compute the proportion of the total delay for its destination.
# 이 질문에 대답할 수 있는 열쇠는 총 지연 시간과 
# 지연 비율을 계산할 때 지연 비행만 포함하는 것이다.

flights %>%
  filter(arr_delay > 0) %>%
  group_by(dest) %>%
  mutate(
    arr_delay_total = sum(arr_delay),
    arr_delay_prop = arr_delay / arr_delay_total
  ) %>%
  select(
    dest, month, day, dep_time, carrier, flight,
    arr_delay, arr_delay_prop
  ) %>%
  arrange(dest, desc(arr_delay_prop))

# 그 문제에서 비행의 의미에는 다소 모호한 점이 있다. 
# 첫 번째 예는 항공편을 비행표의 행, 특정 항공기에 의한 특정 여행으로 정의했다. 
# 그러나 항공편은 항공사가 노선의 항공사 서비스에 사용하는 코드인 
# 비행 번호를 언급할 수도 있다. 예를 들어, AA1은 JFK와 LAX 사이의 
# 09:00 아메리칸 에어라인 항공편의 항공편 번호다. 
# 비행 번호는 flights$flight를 포함하지만 flights$carrier와 flights$flights의 조합으로 
# 불린다.

flights %>%
  filter(arr_delay > 0) %>%
  group_by(dest, origin, carrier, flight) %>%
  summarise(arr_delay = sum(arr_delay)) %>%
  group_by(dest) %>%
  mutate(
    arr_delay_prop = arr_delay / sum(arr_delay)
  ) %>%
  arrange(dest, desc(arr_delay_prop)) %>%
  select(carrier, flight, origin, dest, arr_delay_prop)


# 5.Delays are typically temporally correlated: even once the problem that caused the initial delay has been resolved, later flights are delayed to allow earlier flights to leave. Using  lag() , explore how the delay of a flight is related to the delay of the immediately preceding flight.
# 이것은 같은 공항에서 전편 비행기의 출발 지연을 계산한다.

lagged_delays <- flights %>%
  arrange(origin, month, day, dep_time) %>%
  group_by(origin) %>%
  mutate(dep_delay_lag = lag(dep_delay)) %>%
  filter(!is.na(dep_delay), !is.na(dep_delay_lag))

# 이것은 이전 비행의 모든 값에 대한 비행의 평균 지연 사이의 관계를 나타낸다. 
# 2시간 미만의 지연에 대해서는, 선행 비행의 지연과 현재 비행의 지연과의 관계가 
# 거의 선에 가깝다. 그 후 오랫동안 지연된 비행이 정시에 출발하는 비행과 교차함에 
# 따라 관계가 더욱 가변적으로 변하게 된다. 
# 약 8시간 후, 지연된 비행은 제 시간에 출발하는 항공편이 뒤따를 것 같다.

lagged_delays %>%
  group_by(dep_delay_lag) %>%
  summarise(dep_delay_mean = mean(dep_delay)) %>%
  ggplot(aes(y = dep_delay_mean, x = dep_delay_lag)) +
  geom_point() +
  scale_x_continuous(breaks = seq(0, 1500, by = 120)) +
  labs(y = "Departure Delay", x = "Previous Departure Delay")

# 전체적인 관계는 세 공항 모두에서 유사해 보인다.

lagged_delays %>%
  group_by(origin, dep_delay_lag) %>%
  summarise(dep_delay_mean = mean(dep_delay)) %>%
  ggplot(aes(y = dep_delay_mean, x = dep_delay_lag)) +
  geom_point() +
  facet_wrap(~origin, ncol = 1) +
  labs(y = "Departure Delay", x = "Previous Departure Delay")


# 6.Look at each destination. Can you find flights that are suspiciously fast? (i.e. flights that represent a potential data entry error). Compute the air time a flight relative to the shortest flight to that destination. Which flights were most delayed in the air?
  
  
# 7.Find all destinations that are flown by at least two carriers. Use that information to rank the carriers.
# 이 질문을 다시 설명하기 위해, 우리는 두 개 이상의 항공사가 
# 항공편을 이용하는 공항만 고려하여 항공사가 비행하는 목적지 수에 
# 따라 항공사의 순위를 매겨야 한다. 이 순위를 계산하는 데는 두 가지 단계가 있다. 
# 첫째, 두 개 이상의 항공사가 서비스하는 모든 공항을 찾아보십시오. 
# 그리고 나서, 그들이 서비스하는 목적지의 수에 따라 운송업자들의 순위를 매긴다.

flights %>%
  # find all airports with > 1 carrier
  group_by(dest) %>%
  mutate(n_carriers = n_distinct(carrier)) %>%
  filter(n_carriers > 1) %>%
  # rank carriers by numer of destinations
  group_by(carrier) %>%
  summarize(n_dest = n_distinct(dest)) %>%
  arrange(desc(n_dest))

# 항공사 "EV"는 2개 이상의 항공사가 운항하는 공항만 고려하여 
# 가장 많은 목적지로 운항한다. 항공사 "EV" 운송 회사 코드는 무엇에 해당하는가?

filter(airlines, carrier == "EV")

# 당신이 비행기 산업을 알지 않는 한, 당신은 익스프레스를 알아보지 못할 것이다.
# 젯; 나는 확실히 하지 않았다. 대형 항공사와 제휴해 허브(대형 공항)에서 
# 소형 공항으로 운항하는 지역 항공사다. 이는 주요 항공사의 짧은 비행 중 
# 상당수가 ExpressJet에 의해 운항된다는 것을 의미한다. 
# 이 비즈니스 모델은 Express가 왜제트기는 가장 많은 목적지를 제공한다.

# 뉴욕에서 목적지 한 곳으로만 가는 항공사 중에는 알래스카 항공과 하와이 항공이 있다.

filter(airlines, carrier %in% c("AS", "F9", "HA"))


# 8.For each plane, count the number of flights before the first delay of greater than 1 hour.
# 그 질문은 도착이나 출발 지연을 명시하지 않는다. 
# 부정_지연에 유사한 코드가 사용될 수 있지만 이 답변에서 de_delay를 고려한다.

flights %>%
  # sort in increasing order
  select(tailnum, year, month, day, dep_delay) %>%
  filter(!is.na(dep_delay)) %>%
  arrange(tailnum, year, month, day) %>%
  group_by(tailnum) %>%
  # cumulative number of flights delayed over one hour
  mutate(cumulative_hr_delays = cumsum(dep_delay > 60)) %>%
  # count the number of flights == 0
  summarise(total_flights = sum(cumulative_hr_delays < 1)) %>%
  arrange(total_flights)

  






















