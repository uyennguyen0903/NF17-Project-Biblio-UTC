# Normalisation
## 0NF -> 1NF
**Relations:**
- Ressources (#code:varchar, titre:varchar, date_apparation:date, editeur:varchar, genre:varchar, code_classification:varchar)
- Oeuvre_musicale (#code=>Ressources, longueur:integer)
- Livre (#code=>Ressources, IBSN:varchar, resume:varchar, longueur:integer) AVEC resume UNIQUE et ISBN UNIQUE NOT NULL
- Film(#code=>Ressources, longueur:integer, synopsis:integer) AVEC synopsis UNIQUE

- Contributeur(#id:varchar, nom:varchar, prenom:varchar, nationalite:varchar, date_naissance:date, type_C:{interprete|compositeur|auteur|realisateur|acteur}) AVEC nom, prenom NOT NULL 

- Interpreter(#interprete=>Contributeur, #oeuvre_musicale=>Oeuvre_musicale)
- Composer(#compositeur=>Contributeur, #oeuvre_musicale=>Oeuvre_musicale)
- Ecrire(#auteur=>Contributeur, #livre=>Livre)
- Realiser(#realisateur=>Contributeur, #film=>Film)
- Jouer(#acteur=>Contributeur, #film=>Film)

- Exemplaire(#ressource=>Ressources, #id:varchar, etat: {neuf|bon|abime|perdu}) AVEC etat NOT NULL

- Personne(#login:varchar, mot_de_passe:varchar, prenom:varchar, adresse:varchar, mail:varchar) AVEC prenom, mot_de_passe NOT NULL
- Membre_biblio(#login=>Personne) 
- Adherent(#login=>Personne, code_adherent:varchar, date_de_naissance:date, num_tel:varchar, date_debut:date, date_fin:date, blacklist:bool) AVEC code_adherent UNIQUE NOT NULL, date_debut, date_naissance NOT NULL

- Pret(#adherent=>Adherent, #exemplaire=>Exemplaire, date_debut:date, date_reservation:date, type_P:{retard|perte_degradation}, date_retard:date, date_rembourser:date) AVEC date_debut,date_reservation NOT NULL

On peut voir que tous les relations sont en 1NF parce qu'ils ont une clé et les attributs sont atomiques, même si on a des types, ils sont complement une relation XOR parmi eux, donc ce sont pas d'attributs multivalués.

## 1NF -> 2NF

Nous sommes en 1NF et tout attribut qui n'appartenant à aucune clé candidate ne dépend pas d'une partie seulement d'une clé candidate donc nous sommes aussi en 2NF.


## 2NF -> 3NF

Nous sommes donc en 2NF et tout attribut n'appartenant à aucune clé candidate ne dépend directement que de clés candidates, donc nous sommes en 3NF.

- DF pour Ressources:

    * Code -> {titre, date_apparition, editeur, genre, code_classification}

- DF pour Oeuvre_musicale:

    * Code -> {longeur}

- DF pour Livre:

    * Code -> {ISBN, resumé, longueur}

**Remarque:** ISBN est une clé candidate aussi, mais on a choisi le code comme clé primaire grâce à l'heritage fait entre Ressource et Livre.

- DF pour Film:

    * Code -> {longueur, synopsis}
    

- DF pour Contributeur:

    * id -> {nom, prenom, nationalite, date_naissance, type}
    

- DF pour Interpreter:

    * (interprete, oueuvre_musicale) -> {}
    

- DF pour Composer:

    * (compositeur, oeuvre_musicale) -> {}
    

- DF pour Ecrire:

    * (auteur, livre) -> {}
    

- DF pour Realiser:
    
    * (realisateur, film) -> {}
    

- DF pour Jouer:
    
    * (acteur, film) -> {}
    

- DF pour Exemplaire:
    
    * (ressource, id) -> {etat}
    

- DF pour Personne:

    * login -> {mot_de_passe, prenom, adresse, mail}
    

- DF pour Membre_biblio: 

    * login -> {}
    

- DF pour Adherent:

    * login -> {code_adherent, date_de_naissance, num_tel, date_debut, date_fin, blacklist}
    

**Remarque:** code_adherent c'est une clé candidate aussi, mais par l'héritage entre Personne et Adherent on a decidé de laisser login comme clé primaire

- DF pour Pret:

    * (adherent, exemplaire) -> {date_debut, date_reservation, type_P, date_retar, date_remburser}

Par transitivité on peut acceder aux données de Livre, Oeuvre musicale et Film avec la clé primaire de Ressources. Aussi on peut acceder aux donnes des Contributeur pour chaque type de ressource, grâce aux classes: Interpreter, Composer, Ecrire, Realiser et Joueur.

Ainsi par transitivé on peut obtenir des données des Membre_biblio et des Adhérents grace à la clé primaire du Personne.

Finalement on peut faire un lien parmi les Adhérents et les Exemplaires du biblio, avec la classe Pret.