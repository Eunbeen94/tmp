library(tidyverse)
#> ── Attaching packages ────────────────────────────────── tidyverse 1.2.1 ──
#> ??? ggplot2 3.1.0.9000     ??? purrr   0.2.5     
#> ??? tibble  2.0.0          ??? dplyr   0.7.8     
#> ??? tidyr   0.8.2          ??? stringr 1.3.1     
#> ??? readr   1.3.1          ??? forcats 0.3.0
#> ── Conflicts ───────────────────────────────────── tidyverse_conflicts() ──
#> ??? dplyr::filter() masks stats::filter()
#> ??? dplyr::lag()    masks stats::lag()

mpg

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy))


#3.2.4 Exercises

# 1.Run  ggplot(data = mpg) . What do you see? 
ggplot(data = mpg) 

# RE : ggplot()의 첫 번째 인수는 그래프에 사용할 데이터 집합이다. 그렇기 때문에 
#      ggplot(data=mpg)의 경우 빈 plot을 보여주고, 제대로 plot을 그리고자 할 때는 
#      하나이상의 레이어를 추가해 주어야 한다. 
#      Nothing plotted, but a canvas for a plot is shown.


# 2.How many rows are in  mpg ? How many columns?
length(mpg)
class(mpg)
mpg[,1]
length(mpg$year)
##########
dim(mpg)
##########
nrow(mpg)

ncol(mpg)


# 3.What does the  drv  variable describe? Read the help for  ?mpg  to find out.
?mpg

# manufacturer	string	car manufacturer	15 manufacturers
# model	string	model name	38 models
# displ	numeric	engine displacement in liters	1.6 - 7.0, median: 3.3
# year	integer	year of manufacturing	1999, 2008
# cyl		number of cylinders	4, 5, 6, 8
# trans	string	type of transmission	automatic, manual (many sub types)
# drv	string	drive type	f, r, 4, f=front wheel, r=rear wheel, 4=4 wheel
# cty	integer	city mileage	miles per gallon
# hwy	integer	highway mileage	miles per gallon
# fl	string	fuel type	5 fuel types (diesel, petrol, electric, etc.)
# class	string	vehicle class	7 types (compact, SUV, minivan etc.)


## i.e. drv => f = 전륜 구동, r = 후륜 구동, 4 = 4wd
mpg$drv


# 4.Make a scatterplot of  hwy  vs  cyl .
ggplot(data = mpg) + geom_point(mapping = aes(x = displ, y = hwy))

##################
ggplot(mpg, aes(x = hwy, y = cyl)) +
  geom_point()

# 5.What happens if you make a scatterplot of class vs drv. Why is the plot not useful?

# RE : 클래스와 drv 속성은 범주형이다. 따라서 이 그림은 이러한 범주 간의 매핑을 보여준다.
ggplot(data = mpg) + geom_point(mapping = aes(x = class, y = drv))

###################

ggplot(mpg, aes(x = class, y = drv)) +
  geom_point()
# RE : 분산도는 drv와 클래스가 모두 범주형 변수이기 때문에 
#      이러한 변수의 유용한 표시는 아니다. 
#      범주형 변수는 일반적으로 작은 수의 값을 가지므로 
#      표시할 수 있는 (x, y) 값의 고유 조합 수가 제한된다. 
#      이 데이터에서 drv는 3개의 값을 취하고 클래스는 7개의 값을 취하는데, 
#      이는 drv 대 클래스 산점도에 표시할 수 있는 값이 21개뿐이라는 것을 의미한다. 
#      이 데이터에는 (drv, class)의 12개 값이 관찰된다.
count(mpg, drv, class)

# RE : 단순 산점도는 각 (x, y) 값에 대한 관측치 수를 나타내지 않는다. 
#      이와 같이 산점도는 모든 (x, y) 값이 고유할 때 연속 x 및 연속 y 변수를 
#      플로팅하는 데 가장 적합하다.

# 경고: 다음 코드는 이후 섹션에 소개된 기능을 사용한다. 
#       두 개의 범주형 변수를 플로팅하는 방법을 소개하는 섹션 7.5.2를 읽고 
#       다시 이 문제로 돌아오십시오. 첫 번째는 geom_count()로 산점도와 유사하지만 
#       점의 크기를 사용하여 (x, y) 점의 관측치 수를 보여준다.
ggplot(mpg, aes(x = class, y = drv)) +
  geom_count()
# 두 번째는 geom_tile()이며, 색상 척도를 사용하여 각 (x, y) 값으로 관측치의 수를 보여준다.

mpg %>%
  count(class, drv) %>%
  ggplot(aes(x = class, y = drv)) +
  geom_tile(mapping = aes(fill = n))

# 앞의 줄거리에는 없어진 타일이 많다. 
# 이 누락된 타일은 클래스 값과 drv 값의 관찰되지 않는 조합을 나타낸다. 
# 이러한 누락된 값은 알 수 없지만 n = 0인 (class, drv)의 값을 나타낸다. 
# claimr 패키지의 전체() 함수는 결측된 열의 조합을 위해 데이터 프레임에 새 행을 추가한다.
# 다음 코드는 결측된 클래스와 drv의 조합에 대한 행을 추가하고 
# 채우기 인수를 사용하여 해당 새 행에 대해 n = 0을 설정한다.

mpg %>%
  count(class, drv) %>%
  complete(class, drv, fill = list(n = 0L)) %>%
  ggplot(aes(x = class, y = drv)) +
  geom_tile(mapping = aes(fill = n))


# 3.3.1 Exercises

# 1.What’s gone wrong with this code? Why are the points not blue?

ggplot(data = mpg) + geom_point(mapping = aes(x = displ, y = hwy, color = "blue"))

# RE : 색층이 aes 매핑 내에 지정되어 있기 때문에 점들은 파란색이 아니다. 
#      그러므로 프레임워크는 "파란색" 속성에 대한 색도를 표시하려고 하지만, 
#      이것은 데이터 내에 존재하지 않는다. 
#      geom_point 방법에서 색상을 수동으로 설정하는 것이 올바른 코드일 것이다.

ggplot(data = mpg) + geom_point(mapping = aes(x = displ, y = hwy), color = "blue")

# 연속변수는 이산색 대신 빛에서 진한 청색으로 변하는 눈금을 사용한다.


# 2.Which variables in  mpg  are categorical? Which variables are continuous? (Hint: type  ?mpg  to read the documentation for the dataset). How can you see this information when you run  mpg ?
head(mpg, 1)
# 정보는 칼럼 이름 바로 아래에 나타나 있는데, 
# <chr> [문자]는 범주형일 가능성이 있는 반면, 
# <dbl> [double]와 <int] [int]는 연속적일 가능성이 있다.

#############  
# The following list contains the categorical variables in mpg.
# RE : model , trans , drv , fl , class
# The following list contains the continuous variables in mpg.
# RE : displ , year , cyl , cty , hwy

# 인쇄된 데이터 프레임에서, 
# 각 열의 맨 위에 있는 각형 브래킷은 각 변수의 유형을 제공한다.
mpg

# <chr>가 칼럼 위에 있는 사람은 범주형이고, 
# <dbl>이나 <int>가 있는 사람은 연속형이다. 
# 이러한 유형의 정확한 의미는 벡터 장에서 논의될 것이다.

# 또는 각 열의 유형을 표시한다.
glimpse(mpg)


# 3.Map a continuous variable to  color ,  size , and  shape . How do these aesthetics behave differently for categorical vs. continuous variables?
ggplot(data = mpg) + geom_point(mapping = aes(x = displ, y = hwy, color = cyl, size = hwy, shape = drv))  

##################
# 갤런 당 도시 고속도로 마일인 가변 cty는 연속적인 변수다.
ggplot(mpg, aes(x = displ, y = hwy, colour = cty)) +
  geom_point()

# 연속변수는 이산색 대신 빛에서 진한 청색으로 변하는 눈금을 사용한다.

ggplot(mpg, aes(x = displ, y = hwy, size = cty)) +
  geom_point()
# 크기에 따라 매핑되면 점의 크기가 크기에 따라 연속적으로 달라진다.
# 연속값이 형상으로 매핑되면 오류를 발생시킨다. 
# 비록 연속 변수를 별개의 범주로 나누고 형태 미학을 사용할 수 있지만, 
# 이것은 개념적으로 말이 되지 않을 것이다. 
# 숫자 변수에 순서가 있지만 모양은 그렇지 않다. 
# 더 작은 점은 더 작은 값에 해당하거나, 색 눈금이 주어지면 
# 더 큰 값과 더 작은 값에 해당하는 색이 된다는 것은 분명하다. 
# 그러나 정사각형이 원보다 큰지 작은지는 확실하지 않다.

 
# 4.What happens if you map the same variable to multiple aesthetics?
ggplot(data = mpg) + geom_point(mapping = aes(x = displ, y = hwy, color = cyl, size = cyl))  

#########################

ggplot(mpg, aes(x = displ, y = hwy, colour = hwy, size = displ)) +
  geom_point()
# 위 그림에서 hwy는 y축의 양쪽 위치와 컬러에 매핑되며, 
# displ은 x축과 크기의 양쪽 위치에 매핑된다. 
# 그 코드는 나쁜 줄거리일지라도 작동하여 줄거리를 만들어 낸다. 
# 하나의 변수를 여러 개의 미학에 매핑하는 것은 불필요하다. 
# 중복된 정보이기 때문에 대부분의 경우 단일 변수를 다중 미학에 매핑하는 것을 피한다.

  
# 5.What does the  stroke  aesthetic do? What shapes does it work with? (Hint: use  ?geom_point )

# RE : stroke aesthetic은 표시된 물체의 두께를 조정하는 것처럼 보인다.

########################

# 스트로크는 도형에 대한 테두리 크기(21~25)를 변경한다. 
# 이것들은 테두리의 색과 크기가 도형의 채워진 내부와 다를 수 있는 채워진 형태들이다.

# 예를들면
ggplot(mtcars, aes(wt, mpg)) +
  geom_point(shape = 21, colour = "black", fill = "white", size = 5, stroke = 5)


# 6.What happens if you map an aesthetic to something other than a variable name, like  aes(colour = displ < 5) ? Note, you’ll also need to specify x and y.
ggplot(data = mpg) + geom_point(mapping = aes(x = displ, y = hwy, colour = displ < 5))

###################
ggplot(mpg, aes(x = displ, y = hwy, colour = displ < 5)) +
  geom_point()

# 미학은 또한 displ < 5와 같은 표현에 매핑될 수 있다. 
# ggplot() 함수는 표현식의 결과와 동일한 값을 갖는 데이터에 
# 임시 변수가 추가된 것처럼 동작한다. 
# 이 경우, dis 5의 결과는 TRUE 또는 FALSE 값을 갖는 논리적 변수다.

# 이것은 또한 연습 3.3.1에서 색상 = "파란색"이라는 표현이 
# 하나의 범주만 가진 범주형 변수를 만든 이유를 설명한다.



# 3.5.1 Exercises

# 1.What happens if you facet on a continuous variable?

# RE : 각 값마다 하나의 면(facet)이 있다. 예를 들어, displ에 면(facet on displ)이 있다.
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = cyl, y = hwy)) +
  facet_wrap(~ displ)
########################
ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point() +
  facet_grid(. ~ cty)
# 연속 변수는 범주형 변수로 변환되며, 
# 그림에는 각 구별되는 값에 대한 측면이 포함되어 있다.


# 2.What do the empty cells in plot with  facet_grid(drv ~ cyl)  mean? How do they relate to this plot?
# RE : 예를 들어 4 또는 5 실린더가 장착된 리어 휠 구동(r)이 
#      나열되지 않은 경우 전면은 비어 있다. 7기통 사실은 완전히 빗나갔다.
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_grid(drv ~ cyl)


ggplot(data = mpg) + 
  geom_point(mapping = aes(x = drv, y = cyl))

####################################

ggplot(data = mpg) +
  geom_point(mapping = aes(x = drv, y = cyl))

ggplot(data = mpg) +
  geom_point(mapping = aes(x = hwy, y = cty)) +
  facet_grid(drv ~ cyl)
# 이 그림의 빈 셀(패킷)은 관측치가 없는 drv와 cyl의 조합이다. 
# 이것들은 drv와 cyl의 산포도에서 플롯이 없는 동일한 위치들이다.
ggplot(data = mpg) +
  geom_point(mapping = aes(x = drv, y = cyl))


# 3.What plots does the following code make? What does  .  do?
# RE : "attribe ~ dot" 표기법은 열 속성이 없는 속성 값을 표시하므로 
#      각 속성 값에 대해 여러 행의 그래프를 보여준다. y축이 반복된다. "
#      dot ~ constitute"를 사용하면 행 속성이 누락되어 열로 표시된다. 
#      그런 다음 x축을 반복한다.

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_grid(drv ~ .)

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_grid(. ~ cyl)

################################
# 심볼 .는 그 차원을 무시한다. 예를 들어, y축의 drv 값을 기준으로 한 drv ~ . facet.
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_grid(drv ~ .)

# 반면, ~ cyl는 x축의 cyl 값을 기준으로 정면을 이룬다.

ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_grid(. ~ cyl)


# 4.Take the first faceted plot in this section:
# RE : 겉만 번지르르하면, 비종교계층을 조사하기가 더 쉽다. 
#      색칠을 하면 수업이 전체적으로 어떻게 집적되어 있는지 쉽게 알 수 있다. 
#      대규모 데이터셋을 사용하면 개별 포인트 클라우드 대신 전체 클러스터링을 볼 수 있다.

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy, color = class))

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) + 
  facet_wrap(~ class, nrow = 2)

###################################
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_wrap(~class, nrow = 2)

# 색미적 색채 대신 패시팅을 사용할 때 얻을 수 있는 이점은 무엇인가? 단점은 무엇인가? 
# 데이터 세트가 더 큰 경우 밸런스가 어떻게 변경될 수 있는가?

# 다음 그림에서 클래스 변수는 색상으로 매핑된다.
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy, color = class))



# 5.Read  ?facet_wrap . What does  nrow  do? What does  ncol  do? What other options control the layout of the individual panels? Why doesn’t  facet_grid()  have  nrow  and  ncol  arguments?
# RE : 행과 열은 지정된 속성에 의해 결정되기 때문에 
#      Facet 그리드는 이러한 구성을 가지고 있지 않다.  
?facet_wrap  


# 6.When using  facet_grid()  you should usually put the variable with more unique levels in the columns. Why?
# RE : 행 축에 더 많은 레벨을 배치할 때 y축이 축소되어 그림에서와 같이 
#      점의 실제 값을 보다 쉽게 볼 수 있다.  
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) + 
  facet_grid(class ~ drv)
  


# 3.6.1 Exercises

# 1.What geom would you use to draw a line chart? A boxplot? A histogram? An area chart?
ggplot(data = mpg) +
  geom_line(mapping = aes(x = displ, y = hwy)) +
  geom_point(mapping = aes(x = displ, y = hwy))  
  
#########################
# line chart: geom_line()
# boxplot: geom_boxplot()
# histogram: geom_histogram()
# area chart: geom_area()

# 2.Run this code in your head and predict what the output will look like. Then, run the code in R and check your predictions.
ggplot(data = mpg, mapping = aes(x = displ, y = hwy, color = drv)) + 
  geom_point() + 
  geom_smooth(se = FALSE)
# 이 코드는 x축에 displ, y축에 hwy, drv에 의해 색칠된 점이 있는 산점도를 생성한다. 
# 표준 오차 없이 각 drv 그룹에 맞는 매끄러운 선이 있을 것이다.

ggplot(data = mpg, mapping = aes(x = displ, y = hwy, color = drv)) + 
  geom_point() + 
  geom_smooth(se = FALSE)


# 3.What does  show.legend = FALSE  do? What happens if you remove it?
# Why do you think I used it earlier in the chapter?

# RE : Actually, never used before, but in 3.9 coordinate systems.

#############################

#ggplot(data = mpg) +
#  geom_smooth(
#    mapping = aes(x = displ, y = hwy, colour = drv),
#    show.legend = FALSE)

  
# 4.What does the  se  argument to  geom_smooth()  do?
# RE : Shows the confidence interval around the line. (the grey area)  
ggplot(data = mpg, mapping = aes(x = displ, y = hwy, colour = drv)) +
  geom_point() +
  geom_smooth(se = TRUE)
  
ggplot(data = mpg, mapping = aes(x = displ, y = hwy, colour = drv)) +
  geom_point() +
  geom_smooth()


# 5.Will these two graphs look different? Why/why not?
ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) + 
  geom_point() + 
  geom_smooth()

ggplot() + 
  geom_point(data = mpg, mapping = aes(x = displ, y = hwy)) + 
  geom_smooth(data = mpg, mapping = aes(x = displ, y = hwy))

# 아니오. geom_point()와 geom_smooth() 모두 동일한 데이터와 매핑을 사용하기 때문이다. 
# 그들은 ggplot() 개체에서 이러한 옵션을 상속하므로 매핑을 다시 지정할 필요가 없다.

ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) +
  geom_point() +
  geom_smooth()

ggplot() +
  geom_point(data = mpg, mapping = aes(x = displ, y = hwy)) +
  geom_smooth(data = mpg, mapping = aes(x = displ, y = hwy))


# 6.Recreate the R code necessary to generate the following graphs.
#install.packages("gridExtra")
#install.packages("cowplot")
install.packages("cowplot")
library(gridExtra)
library(cowplot)

p1 <- ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) + 
  geom_point() +
  geom_smooth(se = FALSE)
p2 <- ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) + 
  geom_point() +
  geom_smooth(mapping = aes(group = drv), se = FALSE)
p3 <- ggplot(data = mpg, mapping = aes(x = displ, y = hwy, color=drv)) + 
  geom_point() +
  geom_smooth(se = FALSE)
p4 <- ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) + 
  geom_point(mapping = aes(color=drv)) +
  geom_smooth(se = FALSE)
p5 <- ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) + 
  geom_point(mapping = aes(color=drv)) +
  geom_smooth(se = FALSE, mapping = aes(linetype = drv))
p6 <- ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) + 
  geom_point(mapping = aes(color=drv)) + 
  geom_point(shape = 21, color = "white", stroke = 1)
theme_set(theme_gray())
plot_grid(p1, p2, p3, p4, p5, p6, labels=c("1","2","3", "4","5","6"), ncol=2, nrow = 3)


ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) + 
  geom_point(mapping = aes(color=drv)) +
  geom_point(shape = 21, color = "white", stroke = 2)

#########################
ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point() +
  geom_smooth(se = FALSE)


ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_smooth(mapping = aes(group = drv), se = FALSE) +
  geom_point()


ggplot(mpg, aes(x = displ, y = hwy, colour = drv)) +
  geom_point() +
  geom_smooth(se = FALSE)


ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point(aes(colour = drv)) +
  geom_smooth(se = FALSE)


ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point(aes(colour = drv)) +
  geom_smooth(aes(linetype = drv), se = FALSE)



# 3.7.1 Exercises

# 1.What is the default geom associated with  stat_summary() ? How could you rewrite the previous plot to use that geom function instead of the stat function?
ggplot(data = diamonds) +
  stat_summary(
    mapping = aes(x = cut, y = depth),
    fun.ymin = min,
    fun.ymax = max,
    fun.y = median
  )  
  
# stat_summary()의 기본 지름은 geom_pointrange()이다. 
# geom_pointrange()의 기본 stat은 ID()이지만 stat_identity() 대신 
# stat_summary()를 사용하도록 인수 stat = "summary"를 추가할 수 있다.

ggplot(data = diamonds) +
  geom_pointrange(
    mapping = aes(x = cut, y = depth),
    stat = "summary"
  )

# 결과 메시지에는 stat_summary()가 선의 중간점과 끝점을 계산하기 위해 
# 평균과 sd를 사용한다고 한다. 그러나 원래 그림에서는 끝점에 최소값과 최대값을 사용했다. 
# 원래 플롯을 다시 만들려면 fun.ymin, fun.ymax 및 fun.y의 값을 지정해야 한다.

ggplot(data = diamonds) +
  geom_pointrange(
    mapping = aes(x = cut, y = depth),
    stat = "summary",
    fun.ymin = min,
    fun.ymax = max,
    fun.y = median
  )


# 2.What does  geom_col()  do? How is it different to  geom_bar() ?

# RE : geom_col() 함수는 geom_bar()와 기본 stat이 다르다. 
# geom_col()의 기본 stat은 stat_identity()이며, 이는 데이터를 그대로 둔다. 
# geom_col() 함수는 데이터에 막대 높이를 나타내는 x 값과 y 값이 포함될 것으로 예상한다.

# geom_bar()의 기본 stat은 stat_bin()이다. geom_bar() 함수는 x 변수만 예상한다. 
# stat_bin()인 stat는 x의 각 값에 대한 관측치 수를 세어 입력 데이터를 처리한다. 
# y 미학은 이 계수의 값을 사용한다.  
  

# 3.Most geoms and stats come in pairs that are almost always used in concert. 
# Read through the documentation and make a list of all the pairs. 
# What do they have in common?
  
  
# 4.What variables does  stat_smooth()  compute? What parameters control its behaviour?
  
  
# 5.In our proportion bar chart, we need to set  group = 1 . Why? In other words what is the problem with these two graphs?
  
# RE : 그룹 = 1이 포함되지 않은 경우, 그림의 모든 막대는 높이가 1이 된다. 
# geom_bar() 함수는 stat가 그룹 내의 계수를 계산하기 때문에 
# 그룹이 x 값과 같다고 가정한다.  
ggplot(data = diamonds) +
  geom_bar(mapping = aes(x = cut, y = ..prop..))
ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point(size = 4, color = "white") +
  geom_point(aes(colour = drv))

# 이 두 줄거리의 문제는 그 비율이 그룹 내에서 계산된다는 것이다.

ggplot(data = diamonds) +
  geom_bar(mapping = aes(x = cut, y = ..prop..))

ggplot(data = diamonds) +
  geom_bar(mapping = aes(x = cut, fill = color, y = ..prop..))

# 다음 코드는 사례에 대한 의도된 누적 막대형 차트를 채우지 않고 생성한다.

ggplot(data = diamonds) +
  geom_bar(mapping = aes(x = cut, y = ..prop.., group = 1))

# 채우기 미학으로 철근의 높이를 정상화할 필요가 있다.

ggplot(data = diamonds) +
  geom_bar(aes(x = cut, y = ..count.. / sum(..count..), fill = color))


# 3.8.1 Exercises

# 1.What is the problem with this plot? How could you improve it?

ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) + 
  geom_point()

# cty 값과 hwy 값의 각 조합에 대한 다중 관측치가 있기 때문에 오버플로팅이 있다.
# 나는 과도한 도금을 줄이기 위해 지터 위치 조정을 사용하여 그림을 개선할 것이다.

ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) +
  geom_point(position = "jitter")

# cty와 hwy의 관계는 점을 지적하지 않아도 명확하지만 
# jittering은 더 많은 관찰이 있는 위치를 보여준다.


# 2.What parameters to  geom_jitter()  control the amount of jittering?

# From the geom_jitter() documentation, there are two arguments to jitter:
  
#  width controls the amount of vertical displacement, and
#  height controls the amount of horizontal displacement.

# The defaults values of width and height will introduce noise in both directions. 
# Here is what the plot looks like with the default values of height and width.  

ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) +
  geom_point(position = position_jitter())  

# 하지만, 우리는 그것들을 조정할 수 있다. 
# 여기 이러한 매개변수가 지터링에 어떻게 영향을 미치는지 
# 이해하기 위한 몇 가지 예가 있다. 너비 = 0이면 수평 지터가 없다.

ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) +
  geom_jitter(width = 0)

# 폭이 20이면 수평 지터가 너무 많다.

ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) +
  geom_jitter(width = 20)

# 높이가 0이면 수직 지터가 없다.

ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) +
  geom_jitter(height = 0)

# 높이가 15이면 수직 지터가 너무 많다.

ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) +
  geom_jitter(height = 15)

# 폭 = 0 및 높이 = 0이면 수평 또는 수직 지터가 없으며, 
# 생성된 플롯은 geom_point()로 생성된 것과 동일하다.

ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) +
  geom_jitter(height = 0, width = 0)

# 높이와 너비 인수는 데이터 단위에 있다. 
# 따라서 높이 = 1(폭 = 1)은 y(x) 변수의 척도에 따라 다른 상대적인 지터의 양에 해당한다. 
# 높이와 너비의 기본값은 데이터의 분해능()의 80%로 정의되며, 
# 이는 변수의 인접 값 사이의 0이 아닌 가장 작은 거리에 해당한다. 
# x와 y가 별개의 변수일 경우 지터가 양방향과 음방향으로 점을 이동하므로 
# 분해능은 모두 1과 같고, 높이 = 0.4와 폭 = 0.4이다.


# 3.Compare and contrast  geom_jitter()  with  geom_count() .

# Geom geom_jitter()는 그래프의 위치 점에 무작위 변동을 추가한다. 
# 즉, 점의 위치를 약간 '지트'하는 것이다. 
# 이 방법은 위치가 같은 두 점이 같은 랜덤 변동을 가질 가능성이 낮기 때문에 
# 오버플롯을 줄인다.

ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) +
  geom_jitter()

# 그러나 중복되는 점의 감소는 점의 x와 y 값을 약간 변경하는 비용에 따른다.

# Geom geom_count()는 관측치 수를 기준으로 점의 크기를 조정한다. 
# 관측치가 많은 (x, y) 값의 조합은 관측치가 적은 값보다 클 것이다.

ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) +
  geom_count()

# Geom_count() geom은 점의 x 및 y 좌표를 변경하지 않는다. 
# 그러나 포인트가 서로 가깝고 카운트가 크면 일부 포인트의 
# 크기 자체가 오버플롯을 만들 수 있다. 예를 들어, 다음 예에서는 색상으로 
# 매핑된 세 번째 변수가 그림에 추가된다. 
# 이 경우 Geom_count()는 세 번째 변수를 색상 미학으로 추가할 때 
# geom_jitter()()보다 가독성이 떨어진다.

ggplot(data = mpg, mapping = aes(x = cty, y = hwy, color = class)) +
  geom_jitter()

ggplot(data = mpg, mapping = aes(x = cty, y = hwy, color = class)) +
  geom_count()

# 그 예에서 알 수 있듯이 불행하게도, 과잉도장을 위한 보편적인 해결책은 없다. 
# 서로 다른 접근방식의 비용과 이득은 데이터의 구조와 
# 데이터 과학자의 목표에 따라 달라진다.


# 4.What’s the default position adjustment for  geom_boxplot() ? 
# Create a visualisation of the  mpg  dataset that demonstrates it.

# geom_boxplot()의 기본 위치는 position_dodge2의 바로 가기인 "dodge2"이다. 
# 이 위치 조정은 지석의 수직 위치를 바꾸지 않고 다른 지름이 겹치지 않도록 
# 지름을 수평으로 이동시킨다. 작동 방법에 대한 자세한 내용은 position_dodge2()의 
# 설명서를 참조하십시오.

# 색상 = 클래스를 상자 그림에 추가할 때 drv 변수의 서로 다른 레벨이 나란히 배치되며, 
# 즉 피한다.

ggplot(data = mpg, aes(x = drv, y = hwy, colour = class)) +
  geom_boxplot()

# position_identity()를 사용할 경우 상자 그림이 겹친다.

ggplot(data = mpg, aes(x = drv, y = hwy, colour = class)) +
  geom_boxplot(position = "identity")



# 3.9.1 Exercises

# 1.Turn a stacked bar chart into a pie chart using  coord_polar() .

# 원형 도표는 극좌표가 추가된 누적 막대 도표다. 이 누적 막대형 차트를 단일 범주와 함께

ggplot(mpg, aes(x = factor(1), fill = drv)) +
  geom_bar()

# 이제 codes_polar(theta="y")를 추가하여 파이 차트를 만드십시오.

ggplot(mpg, aes(x = factor(1), fill = drv)) +
  geom_bar(width = 1) +
  coord_polar(theta = "y")

# theta = "y" 인수는 y를 각 섹션의 각도에 매핑한다. 
# coded_polar()가 theta = "y" 없이 지정된 경우, 결과 그림을 bulls-eye chart라고 한다.

ggplot(mpg, aes(x = factor(1), fill = drv)) +
  geom_bar(width = 1) +
  coord_polar()

# 2.What does  labs()  do? Read the documentation.

# 실험실 기능은 축 제목, 플롯 제목 및 캡션을 플롯에 추가한다.

ggplot(data = mpg, mapping = aes(x = class, y = hwy)) +
  geom_boxplot() +
  coord_flip() +
  labs(
    y = "Highway MPG",
    x = "Class",
    title = "Highway MPG by car class",
    subtitle = "1999-2008",
    caption = "Source: http://fueleconomy.gov"
  )

# 실험실()에 대한 인수는 선택사항이므로 필요한 만큼 또는 적게 추가할 수 있다.

ggplot(data = mpg, mapping = aes(x = class, y = hwy)) +
  geom_boxplot() +
  coord_flip() +
  labs(
    y = "Highway MPG",
    x = "Year",
    title = "Highway MPG by car class"
  )

# 실험() 함수는 플롯에 제목을 추가하는 유일한 함수가 아니다. 
# xlab(), ylab() 및 y-scale 함수는 축 제목을 추가할 수 있다. 
# ggtitle() 함수는 플롯 제목을 추가한다.


# 3.What’s the difference between  coord_quickmap()  and  coord_map() ?

# cod_map() 함수는 지도 투영을 사용하여 3차원 지구를 2차원 평면에 투영한다. 
# 기본적으로 cod_map()는 메르카토르 투영을 사용한다. 
# 이 투영은 줄거리의 모든 지오름에 적용된다. 
# coded_quickmap() 함수는 대략적이지만 더 빠른 지도 투영을 사용한다. 
# 이 근사치는 지구의 곡률을 무시하고 위도/경도 비율에 대한 지도를 조정한다. 
# cod_quickmap() 프로젝트는 둘 다 cod_map()보다 빠르며, 
# cod_map()과는 달리 개별 geom의 좌표를 변환할 필요가 없기 때문이다.

# 이러한 기능과 몇 가지 예제에 대한 자세한 내용은 cod_map() 설명서를 참조하십시오.

  
# 4.What does the plot below tell you about the relationship between city and highway mpg? Why is  coord_fixed()  important? What does  geom_abline()  do?

ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) +
  geom_point() + 
  geom_abline() +
  coord_fixed()  
  
# 함수 cod_fixed()는 geom_abline()에 의해 생성된 라인이 45도 각도에 있도록 한다. 
# 45도 선으로 고속도로와 도시 주행거리를 도시와 고속도로 MPG가 
# 동일했던 경우와 쉽게 비교할 수 있다.

p <- ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) +
  geom_point() +
  geom_abline()
p + coord_fixed()

# 만약 우리가 geom_coord()를 포함하지 않는다면, 
# 그 선은 더 이상 45도의 각도를 가지지 않을 것이다.

# 평균적으로 인간은 45도에 상대적인 각도의 차이를 가장 잘 인식할 수 있다. 
# 플롯의 가로 세로 비율이 그것이 인코딩하는 가치에 대한 인식에 
# 어떻게 영향을 미치는가, 45도가 일반적으로 최적이라는 증거, 
# 그리고 그것을 달성하기 위한 가로 세로 비율을 계산하는 방법은 
# 클리블랜드(1993b), 클리블랜드(1994a), 클리블랜드(1993a), 맥길(1989a), 헤어와 
# 아그라왈라(2006)를 참조하라. 
# 함수 ggthemes:bank_slopes()는 뱅크 슬로프에 대한 최적의 가로 세로 비율을 계산한다.
