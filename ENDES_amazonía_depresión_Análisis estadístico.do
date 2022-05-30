****Abrir la dirección que contiene todas las bases de datos******
cd "C:\Users\User\Google Drive\4. TBD\Inequidad SM\ENDES\Data"

************************************
   /** Análisis estadístico **/
************************************
use "2014_21_amazonia_TABOUT.dta",clear
svyset suppsu[pweight=vwg_denorm], strata(supstrata) singleunit(scaled)

keep if inclusion==1

*****Análisis descriptivo
*********Tabla 1
tabout QSSEXO agegroup educ_adul marital wealthnewq resid SHREGION year using tablas_amazonia.xlsx, replace c(col ci) svy per format(1) mult(100) cisep( - ) clab(P [IC95%]) nnoc ptotal(none) style(xlsx) oneway location(2 4) sheet(Tab1)
tabout QSSEXO agegroup educ_adul marital wealthnewq resid SHREGION year using tablas_amazonia.xlsx, append c(freq col) format(0 1) clab(n %) font(bold) nnoc ptotal(none) style(xlsx) oneway location(2 2) sheet(Tab1) 

******Análisis bivariado
*********Tabla 2
tabout QSSEXO agegroup educ_adul marital wealthnewq resid SHREGION year phq9cat1 using tablas_amazonia.xlsx, append c(row ci) svy per format(1) mult(100) font(bold) cisep(-) nnoc clab(P [IC95%]) stats(chi2) stpos(col) ppos(only) plab(P valor) ptotal(none) stform(3) style(xlsx) location(2 2) sheet(Tab2)

*********Figura 1
tabout region phq9cat1 using mapa_graf_amazonia.xlsx, replace c(row) svy per format(2) mult(100) clab(total) ptotal(none) style(xlsx) location(1 1) sheet(phq9cat1)

******Análisis multivariado
*********Seleccion de variables
lasso poisson phq9cat1 i.marital i.QSSEXO i.agegroup i.resid i.educ_adul, rseed(10)
cvplot
estimates store cv
lassoknots, display(nonzero bic)
lassoselect id=2
cvplot
estimates store minBIC
lassocoef cv minBIC, sort(coef, standardized) nofvlabel
**NOTA: variables seleccionadas i.QSSEXO i.marital i.wealthnewq i.resid i.educ_adul
recode phq9cat1 (0=2)
lab def sino2 1"Si" 0"No"
lab val phq9cat1 sino2

*********Modelo crudo
foreach var of varlist QSSEXO agegroup educ_adul marital resid {
	svy: glm phq9cat1 i.`var', family (poisson) cformat(%9.2f) pformat(%5.4f) sformat(%8.3f) eform
}

*********Modelo ajustado
svy: glm phq9cat1 i.QSSEXO i.agegroup i.educ_adul i.marital i.resid, family (poisson) cformat(%9.2f) pformat(%5.4f) sformat(%8.3f) eform

	