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

--Statistique sur les documents empruntes par adherents,
--il s'agit de compter le nombre d'emprunts pour chaque documents
CREATE VIEW Statistique_Ouvrages_Populaires(Titre_Ouvrage, Date_publication, Genre, Nombre_emprunts)   
AS SELECT r.titre, r.annee_publication, r.genre, COUNT(*)                                             
FROM Ressources r, Pret p, Exemplaire e
WHERE p.exemplaire_id = e.id
AND r.code = e.ressources_code
GROUP BY r.code
ORDER BY COUNT(*) DESC;


--liste gestion les nombres exemplaires pour chaque ressources selon etats(neuf,perdu,etc)
CREATE VIEW Gestion_Nombre_Exemplaires_Chaque_Ressources(titre,etat,nombre) AS
SELECT r.titre,e.etat,count(*)
FROM Ressources r, Exemplaire e
WHERE r.code=e.ressources_code
GROUP BY r.code,e.etat;

--liste gestion des emprunts pour chaque adherent
CREATE VIEW GESTION_PRETS(login_adherent,Titre_Ouvrage, date_debut,date_reservation,type,date_retard,date_remboursement)   
AS SELECT p.adherent_login,r.titre,p.date_debut,p.date_reservation,
p.type,p.date_retard,p.date_remboursement                                              
FROM Ressources r, Pret p, Exemplaire e
WHERE p.exemplaire_id = e.id
AND r.code = e.ressources_code;

--liste des oeuvres musicales
CREATE VIEW vOeuvreMusicale AS
SELECT r.titre AS Oeuvre_musicale, r.annee_publication, r.editeur, r.genre, o.duree
FROM Ressources r, Oeuvre_musicale o
WHERE r.code = o.code;

--liste des livres
CREATE VIEW vLivre AS
SELECT r.titre AS Livre, r.annee_publication, r.editeur, r.genre, l.isbn, l.resume, l.longueur
FROM Ressources r, Livre l
WHERE r.code = l.code;

--liste dess films
CREATE VIEW vFilm AS
SELECT r.titre AS Film, r.annee_publication, r.editeur, r.genre, f.duree, f.sypnosis
FROM Ressources r, Film f
WHERE r.code = f.code;

--liste des compositeurs et leurs oeuvres musicales
CREATE VIEW Compositeur_Oeuvre(nom,prenom,ouvrage) AS
SELECT c.nom, c.prenom, r.titre
FROM Composer co, Contributeur c, Ressources r
WHERE co.compositeur_id = c.id
AND co.oeuvre_musicale = r.code;

--liste des interpretes et leurs oeuvres musicales
CREATE VIEW Interprete_Oeuvre(nom,prenom,ouvrage) AS
SELECT c.nom, c.prenom, r.titre
FROM Interpreter i, Contributeur c, Ressources r
WHERE i.interprete_id = c.id
AND i.oeuvre_musicale = r.code;

--liste des auteurs et leurs livres
CREATE VIEW Auteur_Livre(nom,prenom,livre) AS
SELECT c.nom, c.prenom, r.titre
FROM Ecrire e, Contributeur c, Ressources r
WHERE e.auteur_id = c.id
AND e.livre = r.code;

--liste des realisateurs et leurs films
CREATE VIEW Realisateur_Film(nom,prenom,film) AS
SELECT c.nom, c.prenom, r.titre
FROM Realiser re, Contributeur c, Ressources r
WHERE re.realisateur_id = c.id
AND re.film = r.code;

--liste des acteurs et leurs films
CREATE VIEW Acteur_Film(nom,prenom,film) AS
SELECT c.nom, c.prenom, r.titre
FROM Jouer j, Contributeur c, Ressources r
WHERE j.acteur_id = c.id
AND j.film = r.code;

