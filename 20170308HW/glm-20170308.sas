*建立永久資料夾glm;
libname glm 'C:\Users\r05849023\Desktop\GLM';
*(A)匯入csv資料;
proc import OUT= glm.a1 DATAFILE= "C:\Users\r05849023\Desktop\GLM\a1.csv"
 DBMS=csv replace;
 GETNAMES=yes;
run;
*(B)內建資料;
data glm.a2;
input No weight @@;
cards;
 1 50 2 65 3 87 4 66 5 49 6 45 7 66 8 68 9 84 10 48 11 75 12 63 13 73 14 46 15 42 16 76 17 69 18 52 19 63 20 53 21 72
;
run;

*(C)合併資料;
proc sort data = glm.a1;by No;run;
proc sort data = glm.a2;by No;run;
data glm.a12;
merge glm.a1 glm.a2;
by No;
run;

*(D)依年月日建立三個新變項;
data glm.a12_E;set glm.a12;
year = Substr(Birth,5,4);
month = Substr(Birth,9,2);
day = Substr(Birth,11,2);
run;
*(F)依身分證建立年齡新變項;
data glm.a12_f;set glm.a12_e;
if Substr(ID,2,1)='1' then sex = 'M';
if Substr(ID,2,1)='2' then sex = 'F';
run;
*(G)新的變項名稱為agegroup  ( <30歲為"1", 30-50為"2", >50為"3");
data glm.a12_g;set glm.a12_f;
if 2017-year*1 < 30 then agegroup = '1';
if 30 <= 2017-year*1 <=50 then agegroup = '2';
if 2017-year*1 > 50 then agegroup = '3';
run;

*(H)學考試成績之敘述統計 (包括：平均值/中位數/標準差/變異係數CV);
proc means data = glm.a12_g mean median std cv maxdec=2;
var Test;
run;
*(I)agegroup*sex的二維列聯表;
proc freq data = glm.a12_g; table agegroup*sex;run;
*(J-1)goodness of fit;
proc genmod data = glm.a12_g;
class agegroup / param = ref ref=first;
model Test = weight  agegroup/ dist = normal link = identity lrci;
run;

*(J-2)變異數分析(weight);
proc genmod data = glm.a12_g;
class agegroup / param = ref ref=first;
model Test = weight  agegroup/ dist = normal link = identity lrci type3 dscale;
run;
