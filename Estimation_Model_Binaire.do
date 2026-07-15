/*******************************************************************************
 *  LOGIT & PROBIT - MODÈLE DE RÉGRESSION BINAIRE
 *  
 *  Auteur  : Edmond TAWELESSI
 *  Date    : 15/07/2026
 *  Objectif: Estimer un modèle de choix discret (Logit / Probit),
 *            comparer les modèles, interpréter les effets, et vérifier
 *            la qualité de l'ajustement (tests et graphiques).
 *******************************************************************************/

clear all               // Nettoie la mémoire
set more off            // Désactive les pauses dans la sortie Stata

/*******************************************************************************
 *  1. DÉFINITION DE L'ENVIRONNEMENT DE TRAVAIL
 *******************************************************************************/

* Chemin vers votre dossier de données 
global D "C:/Users/VotreNom/Documents/MesDonnees" 

* Nom de la variable dépendante (binaire : 0 ou 1)
global ylist "depvar" 

* Liste des variables explicatives (indépendantes)   	
global xlist_def "indep1 indep2 indep3 i.indep4" // Les variables catégorielles peuvent être préfixées par "i."

* Chargement de la base de données
use "$D/mon_fichier.dta", clear

/*******************************************************************************
 *  2. ESTIMATION DES MODÈLES
 *******************************************************************************/

* 2.1 Modèle Logit
logit $ylist $xlist_def
estimates store logit_model

* 2.2 Modèle Probit
probit $ylist $xlist_def
estimates store probit_model

/*******************************************************************************
 *  3. COMPARAISON DES MODÈLES (LOGIT vs PROBIT)
 *******************************************************************************/

* Affichage des coefficients, AIC, BIC, R² de McFadden, et Log-vraisemblance
estimates table probit_model logit_model, stats(aic bic r2_p ll) b(%6.3f)
* Interprétation : Le modèle avec les AIC/BIC les plus faibles est généralement préféré.

/*******************************************************************************
 *  4. INTERPRÉTATION DES ODDS RATIOS (UNIQUEMENT POUR LE LOGIT)
 *******************************************************************************/

* Les Odds Ratios (exp(bêta)) sont plus intuitifs que les coefficients bruts.
logit $ylist $xlist_def, or

/*******************************************************************************
 *  5. CRITÈRES D'INFORMATION (AFFICHAGE DÉTAILLÉ)
 *******************************************************************************/

* On peut aussi les afficher séparément après chaque estimation
logit $ylist $xlist_def
estat ic

probit $ylist $xlist_def 
estat ic

/*******************************************************************************
 *  6. EFFETS MARGINAUX (PENTES MOYENNES)
 *******************************************************************************/

* Calcule l'impact d'une augmentation d'une unité de X sur la probabilité prédite,
* en maintenant toutes les autres variables à leur moyenne (atmeans).
logit $ylist $xlist_def
margins , dydx(*) atmeans

/*******************************************************************************
 *  7. TESTS DE SPÉCIFICATION (LINKTEST)
 *******************************************************************************/

* Linktest vérifie si le modèle est correctement spécifié.
* H0 : Le modèle est bien spécifié.
* Si la variable '_hatsq' est significative (p-value < 0.05), cela indique
* une erreur de spécification (ex : omission de variables ou mauvaise forme fonctionnelle).
logit $ylist $xlist_def
linktest

/*******************************************************************************
 *  8. TESTS DE WALD (CONTRAINTES LINÉAIRES)
 *******************************************************************************/

* Teste si les coefficients de deux variables sont égaux (exemple).
* Remplacez "indep1" et "indep2" par vos propres variables.
test _b[indep1] = _b[indep2]

* Pour des contraintes non-linéaires (ex : b1 * b2 = 1), on utilise testnl.
* testnl _b[indep1] * _b[indep2] = 1

/*******************************************************************************
 *  9. TEST D'AJUSTEMENT DE HOSMER-LEMESHOW
 *******************************************************************************/

* Ce test compare les valeurs prédites aux valeurs observées par groupes de risque.
* H0 : Le modèle s'ajuste bien aux données (pas de différence significative).
* On espère une p-value > 0.05.
logit $ylist $xlist_def
estat gof, group(10) table

/*******************************************************************************
 *  10. MATRICE DE CLASSIFICATION (POUVOIR PRÉDICTIF)
 *******************************************************************************/

* Calcule le pourcentage de bonnes classifications, la sensibilité et la spécificité.
* Seuil par défaut = 0.5.
logit $ylist $xlist_def
estat classification

/*******************************************************************************
 *  11. GRAPHIQUES : COURBE ROC ET SENSIBILITÉ/SPÉCIFICITÉ
 *******************************************************************************/

* Courbe ROC (Receiver Operating Characteristic) : Aire sous la courbe (AUC).
* AUC proche de 1 = excellent pouvoir discriminant.
logit $ylist $xlist_def
lroc, graphregion(color(white)) // Ajout d'un fond blanc pour lisibilité

* Graphique de la sensibilité vs spécificité pour tous les seuils possibles.
lsens, graphregion(color(white))

/*******************************************************************************
 *  OPTIONNEL : STATISTIQUES COMPLÉMENTAIRES (R² DE MCFADDEN, etc.)
 *******************************************************************************/

* La commande 'fitstat' n'est PAS native dans Stata. 
* Elle nécessite une installation préalable : ssc install fitstat
* fitstat 
*/ 
