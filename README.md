# Projet d'économétrie : Modèles Logit / Probit

Ce dépôt contient un script Stata complet pour l'estimation d'un modèle de choix binaire.

## Contenu
- `Estimation_Model_Binaire.do` : Script principal contenant :
  - Estimation Logit et Probit
  - Comparaison des modèles (AIC, BIC)
  - Calcul des effets marginaux
  - Tests de spécification (Hosmer-Lemeshow, Linktest)
  - Courbe ROC et graphiques de sensibilité

## Prérequis
- Stata 14 ou supérieur.
- Une base de données avec une variable dépendante binaire (0/1).

## Utilisation
1. Modifiez les macros `D`, `ylist` et `xlist_def` en haut du fichier.
2. Exécutez le script dans Stata.
