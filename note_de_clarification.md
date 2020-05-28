# Note de clarification

## Contexte du projet 
Une bibliothèque municipale souhaite pouvoir gérer ses activités comme le catalogage, les consultations, la gestion des utilisateurs et des prêts, etc. 

## Objectif du projet 
Le projet consistera à la création d’une base de données de gestion d’une bibliothèque. Il faut donc modéliser la base de données, la créer et 
réaliser un système informatique pour l’utilisation de cette base de données.

## Membres du groupe 
-	CHÁVEZ HERREJÓN Andrea
-	MAKHLOUTI Sabri
-	NGUYEN Thi Thu Uyen
-	ROUGERON Luca 

## Données d'entrées
* Dossier avec les spécifications du client

## Livrables du projet
**Livrables documentées**
-	Modèle conceptuel de données (MCD);
-	Modèle logique de données (MLD);

**Livrables informatiques**
-	Base de données ;
-	Système informatique de gestion de base de données ;

## Objectifs du projet
La base de données doit permettre aux adhérents de faciliter:
- La recherche des documents 
- La gestion de leurs emprunts

Et aussi permettre au personnel de la bibliothéque de:
- Modifier et ajouter les ressources documentaires.
- Gestionner les prêts, retards et reservations

De plus: 
- Gestionner les utilisateurs (soit adhérents, soit le personnel)
- Établir des statistiques sur les documents empruntés 
- Etudier le profil des adhérents pour pouvoir leur suggérer des documents.

## Acteurs du projet
- Maître d'ouvrage : M. Alessandro Correa Victorino
- Utilisateurs finaux:
    * Adhérents de la biblothéque.
    * Personnel de la bibliotéque.
- Maître d'ouvre : Membres du groupe.

## Contraintes à respecter

* Délais: 30/03/2020 à 03/04/2020
    - Dates intermedaires: 
        * NCD et README.txt: 30/03/2020
        * MCD, MLD, Base de données: 03/04/2020

## Risques:

* Manque de contact direct entre réalisateurs.
* Mauvaise modélisation
* Manque de connaissances des logiciels spécifiques

## Objets, classes et énumerations
On peut distingues la clasee:
* Ressources: 
	- Code: Text {key}
	- Titre: Text
	- Liste de contributeurs (Géré grâce à l'héritage des objets gérés par ressources et l'association de chaque type de ressource avec les objets gérés par la classe contributeur)
	- Date d'apparition: Date
	- Editeur: Text
	- Genre: Text
	- Code de classification: Text {non null}
	- État: enum(Exemplaire) {non null}
	
__Remarque__: On peut gérér une classe Genre 

Un ressource peut avoir plusieurs exemplaires:

* Exemplaires:
    - id: varchar {key} (fait référence à Ressources)
    - Etat: {Neuf, Bon, Ablimé, Perte}

Parmi les ressources on gére 3 objets:

* Oeuvre musicale: 
	- Longeur: Nombre 

* Film:
	- Longeur: Nombre
	- Synopsis: Text {unique}
	- Langue: Text

* Livre:
	- ISBN: Nombre {unique} et {non null}
	- Resumé: Text {unique}
	- Langue: Text

__Remarque__: On peut gérér une classe Langue pour Livre et Film

* Contibuteur: 
	- Nom: Text
	- Prénom: Text
	- Date de naissance: Date
	- Nationalité: Text
	
__Remarque__: Il pourrait être nécessaire de choisir une clé articielle

On a des objets gerées par la classe Contributeur:

* Auteur (Referencé par Livre)
* Compositeur (Referencé par ouevre musicale)
* Interpréte (Referencé par oeuvre musicale)
* Réalisateur (Referencé par film)
* Acteur (Referencé par film)

On aura aussi le système de gestion d'utilisateurs, et donc la classe Utilisateur: 

* Personne:
    - Login: Text {unique} et {non null} 
    - Mot de passe: Text {non null}
    - Prenom: Text {not null}
    - Adresse: Text
    - Adresse e-mail: Text

On peut distinguer 2 objets à partir d'un utilisateur:

* Membre_biblio

* Adhérent:
    - Carte d'adhérent: Text {key}
    - Date de naissance: Date
    - Numéro téléphone: Numéro
    - Date debut: Date {non null}
    - Date fin: Date {non null}
    - Nombre de sanctions: Nombre
    - Blacklist: Boolean
    
Pour la gestion des prêts on aura:

* Prêt:
    - Adhérent: Text {key} (Fait référence à Adhérent)
    - Date d'empreunt: Date {non null}
    - Date de retour: Date {non null}
    - Durée: Nombre {non null}
    - État de retour: enum(Exemplaire) {non null}
    - Code ressource: (Fait référence à Ressource)

__Remarque:__ Prêt est une classe d'association entre Adhérent et Ressources

On peut avoir des Sanctions pour certains Adhérents en fonctions des certains attributs du Prêt:

* Sanction:
    - Adhérent: Text {key} (Fait référence à Prêt)
    - Date début: Date {non null}
    - Date fin: Date

La Sanction est de deux types:

* Retard 
* Perte/Détérioration :
    - Remboursement: Boolean {non null}


## Contraintes des objets 
* Pour emprunter, __l'adhérent__ doit s'identifier
* Un __ressource__ ne peut être disponible si __l'exemplaire__ n'est pas disponible et en bon état
* Un __adhérent__ ne peut empreunter simultanément qu'un nombre limité d'oeuvres et pour une durée limitée
* Un __adhérent__ sera sanctionné pour:
    - les retards dans le retour d'un __ressource__
    - S'il dégrade le __ressource__
* Tout __Retard__ dans le retour d'un __ressource__ entraîne une suspension du droit de prêt 
    - La suspension sera égale au nombre de jours de retard
* En cas de __perte ou détérioration__ d'un __ressource__
    - La suspension du droit de prêt sera maintenue jusqu'à __l'adhérent__ rembourse le __ressource__
* La bibliothèque peut faire une __Blacklist__ des __adhérents__ en cas de sanctions répétées

## Héritage:

* On a des classes mères abstraites:
    - Ressources
    - Utilisateur
    - Contributeur
    - Sanction
    
## Associations et compositions:

On peut distingues la compositions entre:
- Exemplaire et Ressources

Et pour les associations:
- On aura une relation __1:N__ entre Livre -> Auteur
- On aura une relation __1:N__ entre Oeuvre musicale -> Compositeurs et Oeuvre musicale -> Interpréte
- On aura une relation __1:M__ entre Film -> Réalisateur et Film -> Acteur
- On aura une relation __N:M__ entre Adhérent et Ressource, qui donnera une classe d'association Prêt
- L'exemplaire dépend de Ressource et la relation sera __1:N__ Ressource -> Exemplaire



