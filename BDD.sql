-- Création des tables 
CREATE TABLE Ressources (
    code VARCHAR PRIMARY KEY,
    titre VARCHAR NOT NULL,
    annee_publication INT,
    CHECK (annee_publication<=2020),
    editeur VARCHAR,
    genre VARCHAR ,
    code_classification VARCHAR NOT NULL
);

CREATE TABLE Oeuvre_musicale (
    code VARCHAR PRIMARY KEY,
    duree INT,
    FOREIGN KEY (code) REFERENCES Ressources(code)
);

CREATE TABLE Livre (
    code VARCHAR PRIMARY KEY,
    isbn VARCHAR UNIQUE NOT NULL,
    resume VARCHAR,
    longueur INT,
    FOREIGN KEY (code) REFERENCES Ressources(code)
);

CREATE TABLE Film (
    code VARCHAR PRIMARY KEY,
    duree INT,
    sypnosis TEXT,
    FOREIGN KEY (code) REFERENCES Ressources(code)
);


CREATE TABLE Contributeur(
    id VARCHAR PRIMARY KEY,
    nom VARCHAR NOT NULL,
    prenom VARCHAR NOT NULL,
    nationalite VARCHAR,
    date_naissance DATE,
    interprete BIT,
    compositeur BIT,
    auteur BIT,
    realisateur BIT,
    acteur BIT
);

CREATE TABLE Interpreter (
    interprete_id VARCHAR REFERENCES Contributeur(id),
    oeuvre_musicale VARCHAR REFERENCES Oeuvre_musicale(code),
    PRIMARY KEY (interprete_id,oeuvre_musicale)
    );

CREATE TABLE Composer (
    compositeur_id VARCHAR REFERENCES Contributeur(id),
    oeuvre_musicale VARCHAR REFERENCES Oeuvre_musicale(code),
    PRIMARY KEY (compositeur_id,oeuvre_musicale)
);

CREATE TABLE Ecrire (
    auteur_id VARCHAR REFERENCES Contributeur(id),
    livre VARCHAR REFERENCES Livre(code),
    PRIMARY KEY (auteur_id,livre)
);

CREATE TABLE Realiser(
    realisateur_id VARCHAR REFERENCES Contributeur(id),
    film VARCHAR REFERENCES Film(code),
    PRIMARY KEY (realisateur_id,film)
);

CREATE TABLE Jouer (
    acteur_id VARCHAR REFERENCES Contributeur(id),
    film VARCHAR REFERENCES Film(code),
    PRIMARY KEY (acteur_id,film)
);

CREATE TABLE Exemplaire (
    ressources_code VARCHAR REFERENCES Ressources(code),
    id VARCHAR NOT NULL UNIQUE,
    etat VARCHAR NOT NULL,
    CHECK (etat = 'neuf' OR etat = 'bon' OR etat = 'abime' OR etat = 'perdu'),
    PRIMARY KEY(ressources_code,id)
);

CREATE TABLE Personne (
    login VARCHAR PRIMARY KEY,
    mot_de_passe VARCHAR NOT NULL,
    nom VARCHAR NOT NULL,
    prenom VARCHAR NOT NULL,
    adresse VARCHAR,
    mail VARCHAR
);

CREATE TABLE Membre_biblio (
    login VARCHAR PRIMARY KEY,
    FOREIGN KEY (login) REFERENCES Personne(login)
);

CREATE TABLE Adherent (
    login VARCHAR PRIMARY KEY,
    code_adherent VARCHAR UNIQUE NOT NULL,
    date_naissance DATE NOT NULL,
    num_tel VARCHAR,
    date_debut DATE NOT NULL,
    date_fin DATE,
    blacklist BIT DEFAULT '0',
    FOREIGN KEY (login) REFERENCES Personne(login),
    CHECK ((date_fin IS NULL OR DATE(date_fin) >= DATE(date_debut))
       AND DATE(date_naissance) < DATE(date_debut))
);

CREATE TABLE Pret (
    adherent_login VARCHAR REFERENCES Adherent(login),
    exemplaire_id VARCHAR REFERENCES Exemplaire(id),
    date_debut DATE NOT NULL,
    date_reservation DATE,
    type VARCHAR NOT NULL,
    date_retard DATE,
    date_remboursement DATE,
    PRIMARY KEY (adherent_login,exemplaire_id),
    CHECK (type = 'retard' OR type ='perte_degradation' OR type = 'sans_sanction'),
    CHECK ((type = 'sans_sanction' AND date_retard IS NULL AND date_remboursement IS NULL)
       OR (type = 'retard' AND date_retard IS NOT NULL AND date_remboursement IS NULL)
       OR (type = 'perte_degradation' AND date_retard IS NULL AND date_remboursement IS NOT NULL))
);

-- Création de vues
--Blacklist
CREATE VIEW vBlacklist
AS SELECT P.prenom, P.login, P.adresse, P.mail 
FROM Personne P INNER JOIN Adherent A ON A.login = P.login
WHERE A.blacklist = '1';
--Liste de retards
CREATE VIEW vSanctionRetard
AS SELECT A.login, P.date_retard
FROM Pret P INNER JOIN Adherent A ON A.login = P.adherent_login
WHERE P.type = 'retard';
--Liste de Perte ou Degradation
CREATE VIEW vSanctionPerte
AS SELECT A.login, P.date_remboursement
FROM Pret P INNER JOIN Adherent A ON A.login = P.adherent_login
WHERE P.type = 'perte_degradation';

CREATE VIEW Statistique_Ouvrages_Populaires(Titre_Ouvrage, Date_publication, Genre, Nombre_emprunts)  --Statistique sur les documents empruntes par adherents, 
AS SELECT r.titre, r.annee_publication, r.genre, COUNT(*)                                             --il s'agit de compter le nombre d'emprunts pour chaque documents
FROM Ressources r, Pret p, Exemplaire e
WHERE p.exemplaire_id = e.id
AND r.code = e.ressources_code
GROUP BY r.code
ORDER BY COUNT(*) DESC;

-- AJOUT DE VALEURS
--PERSONNES ET ADHÉRENTS
INSERT INTO Personne VALUES ('lucar', 'mdp','Rougeron','luca','19 rue de paris','mail0');
INSERT INTO Personne VALUES ('sabrim', 'mdp','Makhlouti','sabri','19 rue de paris','mail1');
INSERT INTO Personne VALUES ('uyent', 'mdp','Nguyen','Uyen','19 rue de paris','mail2');
INSERT INTO Personne VALUES ('andreac', 'mdp','Chavez','Andrea','19 rue de paris','mail3');
INSERT INTO Personne VALUES ('membreb', 'mdp','La bibliotécaire','Mme','19 rue de paris','mail4');


INSERT INTO Adherent VALUES ('lucar', '1','1999-04-08','0688569230','2019-09-12','2020-04-05','1');
INSERT INTO Adherent VALUES ('sabrim', '2','2000-08-18','0666666666','2019-09-12');
INSERT INTO Adherent VALUES ('uyent', '3','1999-03-09','0777777777','2019-09-12');
INSERT INTO Adherent VALUES ('andreac', '4','2000-12-10','0888888888','2019-09-12');

INSERT INTO Membre_biblio VALUES ('membreb');

--CONTRIBUTEURS

INSERT INTO Contributeur VALUES ('1' , 'Baudelaire' , 'Charles' , 'Francaise', '09/04/1821','0','0','1','0','0');
INSERT INTO Contributeur VALUES ('2' , 'Arthur' , 'Rimbaud' , 'Francaise', '1854-10-20','0','0','1','0','0');
INSERT INTO Contributeur VALUES ('3' , 'Clint' , 'Eastwood' , 'Américaine', '1930-05-31','0','0','0','1','1');
INSERT INTO Contributeur VALUES ('4' , 'Frédéric' , 'Chopin' , 'Franco-Polonaise', '01/04/1810','0','1','0','0','0');

--RESSOURCES 
INSERT INTO Ressources VALUES ('1','Million Dollar Baby','2004','','sport','A1');
INSERT INTO Ressources VALUES ('2','The mule', '2018','','thriller','A1');
INSERT INTO Ressources VALUES ('3','Nocturnes opus 9', '1831','','classique','B1');
INSERT INTO Ressources VALUES ('4','Fantaisie-Impromptu', '1834','','classique','B1');
INSERT INTO Ressources VALUES ('5' ,'Les fleurs du Mal' , '1857' , 'Hachette' , 'Poèsie' , ' A2 ');
INSERT INTO Ressources VALUES ('6' ,'Les Paradis artificiels' , '1860' , 'Gallimard' , 'Poèsie' , ' A3 ');
INSERT INTO Ressources VALUES ('7' ,'Illuminations' , '1875' , 'Gallimard' , 'Poèsie' , ' B4 ');
INSERT INTO Ressources VALUES ('8' ,'Une saison en Enfer' , '1873' , 'Gallimard' , 'Poèsie' , ' B5 ');

-- Films, livres, oeuvres musicales
INSERT INTO Oeuvre_musicale VALUES ('3',54);
INSERT INTO Oeuvre_musicale VALUES ('4', 87);
INSERT INTO Film VALUES ('1',164,'million dollar baby est un film sur une boxeuse');
INSERT INTO Film VALUES ('2',176,'the mule est un film vachement bien');
INSERT INTO Livre VALUES ('5','3434-44454-7745','Poèmes de Baudelaire...',215);
INSERT INTO Livre VALUES ('6','6547-5448-99888','Poèmes de Baudelaire encore un ...',325);
INSERT INTO Livre VALUES ('7','67-4536448-99888','Poèmes de Rimbaud  ...',327);
INSERT INTO Livre VALUES ('8','6782-7288-99837878','Poèmes de Rimbaud encore un ...',325);


--Interpréter, composer, réaliser, jouer, écrire
INSERT INTO Composer VALUES ('4','3');
INSERT INTO Composer VALUES ('4','4');
INSERT INTO Realiser VALUES ('3','1');
INSERT INTO Realiser VALUES ('3','2');
INSERT INTO Jouer VALUES ('3','1');
INSERT INTO Ecrire VALUES ('1','5');
INSERT INTO Ecrire VALUES ('1','6');
INSERT INTO Ecrire VALUES ('2','7');
INSERT INTO Ecrire VALUES ('2','8');

--Exemplaires
INSERT INTO Exemplaire VALUES(1,'1a','neuf');
INSERT INTO Exemplaire VALUES(1,'1b','perdu');
INSERT INTO Exemplaire VALUES(1,'1c','neuf');
INSERT INTO Exemplaire VALUES(1,'1d','perdu');
INSERT INTO Exemplaire VALUES(2,'2a','neuf');
INSERT INTO Exemplaire VALUES(2,'2b','neuf');
INSERT INTO Exemplaire VALUES(3,'3a','bon');
INSERT INTO Exemplaire VALUES(3,'3b','bon');
INSERT INTO Exemplaire VALUES(4,'4a','abime');
INSERT INTO Exemplaire VALUES(4,'4b','perdu');
INSERT INTO Exemplaire VALUES(5,'5a','neuf');
INSERT INTO Exemplaire VALUES(6,'6a','bon');
INSERT INTO Exemplaire VALUES(7,'7a','bon');
INSERT INTO Exemplaire VALUES(8,'8a','abime');
INSERT INTO Exemplaire VALUES(8,'8b','abime');


--Prêts
INSERT INTO Pret VALUES('sabrim','5a','18/02/2019','02/03/2019','sans_sanction');
INSERT INTO Pret VALUES('uyent','1a','17/03/2019','21/03/2019','sans_sanction');
INSERT INTO Pret VALUES('uyent','2a','31/03/2019','07/04/2019','retard','09/04/2019');
INSERT INTO Pret VALUES('andreac','4a','31/03/2019','04/04/2019','retard','09/04/2019');
INSERT INTO Pret VALUES('sabrim','8a','18/04/2019','25/04/2019','perte_degradation',null,'25/05/2019');
INSERT INTO Pret VALUES('andreac','1b','18/04/2019','25/04/2019','sans_sanction');




