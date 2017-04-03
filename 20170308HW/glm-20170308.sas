*�إߥä[��Ƨ�glm;
libname glm 'C:\Users\r05849023\Desktop\GLM';
*(A)�פJcsv���;
proc import OUT= glm.a1 DATAFILE= "C:\Users\r05849023\Desktop\GLM\a1.csv"
 DBMS=csv replace;
 GETNAMES=yes;
run;
*(B)���ظ��;
data glm.a2;
input No weight @@;
cards;
 1 50 2 65 3 87 4 66 5 49 6 45 7 66 8 68 9 84 10 48 11 75 12 63 13 73 14 46 15 42 16 76 17 69 18 52 19 63 20 53 21 72
;
run;

*(C)�X�ָ��;
proc sort data = glm.a1;by No;run;
proc sort data = glm.a2;by No;run;
data glm.a12;
merge glm.a1 glm.a2;
by No;
run;

*(D)�̦~���إߤT�ӷs�ܶ�;
data glm.a12_E;set glm.a12;
year = Substr(Birth,5,4);
month = Substr(Birth,9,2);
day = Substr(Birth,11,2);
run;
*(F)�̨����ҫإߦ~�ַs�ܶ�;
data glm.a12_f;set glm.a12_e;
if Substr(ID,2,1)='1' then sex = 'M';
if Substr(ID,2,1)='2' then sex = 'F';
run;
*(G)�s���ܶ��W�٬�agegroup  ( <30����"1", 30-50��"2", >50��"3");
data glm.a12_g;set glm.a12_f;
if 2017-year*1 < 30 then agegroup = '1';
if 30 <= 2017-year*1 <=50 then agegroup = '2';
if 2017-year*1 > 50 then agegroup = '3';
run;

*(H)�ǦҸզ��Z���ԭz�έp (�]�A�G������/�����/�зǮt/�ܲ��Y��CV);
proc means data = glm.a12_g mean median std cv maxdec=2;
var Test;
run;
*(I)agegroup*sex���G���C�p��;
proc freq data = glm.a12_g; table agegroup*sex;run;
*(J-1)goodness of fit;
proc genmod data = glm.a12_g;
class agegroup / param = ref ref=first;
model Test = weight  agegroup/ dist = normal link = identity lrci;
run;

*(J-2)�ܲ��Ƥ��R(weight);
proc genmod data = glm.a12_g;
class agegroup / param = ref ref=first;
model Test = weight  agegroup/ dist = normal link = identity lrci type3 dscale;
run;
