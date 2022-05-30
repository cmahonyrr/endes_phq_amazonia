****Abrir la dirección que contiene todas las bases de datos******
cd "C:\Users\User\Google Drive\4. TBD\Inequidad SM\ENDES\Data"

************************************
   /** Edición de variables **/
***********************************
use "2014_21_H_ADULTO.dta",clear

******Creando variable: Depresión para 2 semanas
generate phq9 = QS700A+QS700B+QS700C+QS700D+QS700E+QS700F+QS700G+QS700H+QS700I
la var phq9 "PHQ-9 score (2 weeks)"

generate phq9cat1 = 0 if phq9<10 | phq9==0
replace phq9cat1 = 1 if phq9>=10 & phq9!=.
la var phq9cat1 "PHQ-9 (2 weeks: cutoff 10)"
la define phq9cat1 0"No depression" 1"Depression", modify
la values phq9cat1 phq9cat1

******Editando variables sociodemográficas
lab val wealthnewq HV270

lab def sexo 1 masculino 2 femenino
lab val QSSEXO sexo

gen marital = HV115
recode marital(1/2=1) (3/5=2) 
lab define marital 0 "Soltero" 1 "Casado/conviviente" 2 "Separado/viudo"
lab val marital marital

gen agegroup = QS23
recode agegroup (15/24=1) (25/34=2) (35/44=3) (45/54=4) (55/100=5)
lab define agegroup 1 "15 a 24" 2 "25 a 34" 3 "35 a 44" 4 "45 a 54" 5 "más de 55" 
lab val agegroup agegroup

keep agegroup QSSEXO lengua2 SHREGION wealthnewq phq9cat1 phq9cat2 year HV024 HV025 HV022 HV023 HV021 vwg_denorm QS700H QS704H HV106 QS707 phq9_12mesescat1 QS25BB marital

egen supstrata = concat(year HV022 HV023)
egen suppsu = concat(year HV021)
gen wg_adulto = vwg_denorm/1000000

lab var agegroup "Grupo etario"

lab var QSSEXO "Sexo"
lab def sexo 1"Masculino" 2"Femenino",modify
lab val QSSEXO sexo

gen educ_adul=HV106
recode educ_adul (8/9=.)
lab var educ_adul "Nivel educativo"
lab def educacion 0 "Sin educación" 1 "Primaria" 2 "Secundaria" 3 "Superior" 
lab val educ_adul educacion

lab var SHREGION "Región natural"
lab def regnat 1"Lima metropolitana" 2"Resto de la costa" 3"Sierra" 4"Selva" 
lab val SHREGION regnat

gen region=HV024
lab var region "Región"
lab val region HV024

gen resid=HV025
lab var resid "Área de residencia"
lab def resid 1 "Urbano" 2 "Rural"
lab val resid resid

lab var marital "Estado civil"

lab var wealthnewq "Índice de riqueza"
lab def quintil 1"Más pobre" 2"Pobre" 3"Medio" 4"Rico" 5"Más rico"
lab val wealthnewq quintil

lab var year "Año"

lab var lengua2 "Lengua materna"
lab def lengua 1"Castellano" 2"Lenguas andinas" 3"Lenguas amazónicas"
lab val lengua2 lengua

lab var phq9cat1 "Depresión (PHQ-9>10)"
recode phq9cat1 (0=2)
lab def phq 2"No" 1"Sí",modify
lab val phq9cat1 phq

lab var phq9cat1 "Síntomas depresivos últimas 2 semanas"
recode phq9cat1 (0=2)
lab def phq 2"No" 1"Sí",modify
lab val phq9cat1 phq

lab var phq9_12mesescat1 "Síntomas depresivos últimos 12 meses"
recode phq9_12mesescat1 (0=2)
lab val phq9_12mesescat1 phq

gen tto=QS707
recode tto (8=.)
lab def tto 1"Si" 2"No"
lab var tto "Uso de servicios de salud mental"
lab val tto tto

gen inclusion=0
replace inclusion=1 if phq9cat1!=. & QS25BB==3
 
save "2014_21_amazonia_TABOUT.dta",replace