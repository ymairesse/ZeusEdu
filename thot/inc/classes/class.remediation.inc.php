<?php


/**
 * fonctions et espace de noms pour la remediation
 */
class Remediation
{

    function __construct()
    {

    }

    /**
     * Recherche toutes les offres de remédiation pour l'utlisateur $acronyme
     *
     * @param string $acronyme
     * @param bool $archives : seulement les remédiations dont les dates sont passées
     *
     * @return array
     */
    public function getListeOffres($acronyme, $all=true) {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT acronyme, idOffre, title, contenu, startDate, endDate, local, places, cache ';
        $sql .= 'FROM '.PFX.'remediationOffre ';
        $sql .= 'WHERE acronyme = :acronyme ';
        if ($all == false) {
            $sql .= 'AND startDate >= NOW() ';
        }
        $sql .= 'ORDER BY startDate DESC ';
        $requete = $connexion->prepare($sql);

        $requete->bindParam(':acronyme', $acronyme, PDO::PARAM_STR, 7);

        $resultat = $requete->execute();
        $liste = array();
        if ($resultat) {
            $requete->setFetchMode(PDO::FETCH_ASSOC);
            while ($ligne = $requete->fetch()) {
                $idOffre = $ligne['idOffre'];
                $dt = explode(' ', $ligne['startDate']);
                $ligne['date'] = Application::datePHP($dt[0]);
                $ligne['heure'] = SUBSTR($dt[1], 0, 5);
                $liste[$idOffre] = $ligne;
            }
        }

        Application::deconnexionPDO($connexion);

        return $liste;
    }

    /**
     * retourne la liste des coursGrp actuels d'une liste d'élèves dont on fournit les matricules
     *
     * @param int $listeMatricules
     *
     * @return array
     */
    public function listeCoursGrpActuelsEleve($listeMatricules) {
        if (is_array($listeMatricules)) {
            $listeMatricules = implode(',', array_keys($listeMatricules));
        }
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT DISTINCT elCours.coursGrp, matricule, cours, libelle, nbheures, ';
        $sql .= 'statut.statut, section, rang, nom, prenom, pCours.acronyme ';
        $sql .= 'FROM '.PFX.'elevesCours AS elCours ';
        $sql .= 'JOIN '.PFX.'cours AS cours ON cours.cours = SUBSTR(coursGrp, 1,LOCATE("-",coursGrp)-1) ';
        $sql .= 'JOIN '.PFX.'statutCours AS statut ON statut.cadre = cours.cadre ';
        // LEFT JOIN pour les cas où un élève aurait été affecté à un cours qui n'existe plus dans la table des profs
        $sql .= 'LEFT JOIN '.PFX.'profsCours AS pCours ON pCours.coursGrp = elCours.coursGrp ';
        $sql .= 'LEFT JOIN '.PFX.'profs AS profs ON profs.acronyme = pCours.acronyme ';
        $sql .= 'WHERE matricule IN ('.$listeMatricules.') ';
        $sql .= 'ORDER BY statut DESC, nbheures DESC, rang, libelle ';
        $requete = $connexion->prepare($sql);

        $resultat = $requete->execute();
        $listeCours = array();
        if ($resultat) {
            $requete->setFetchMode(PDO::FETCH_ASSOC);
            while ($ligne = $requete->fetch()) {
                $matricule = $ligne['matricule'];
                $coursGrp = $ligne['coursGrp'];
                $listeCours[$matricule][$coursGrp] = $ligne;
            }
        }

        Application::DeconnexionPDO($connexion);

        return $listeCours;
    }

    /**
     * liste de tous les cours qui se donnent à une liste d'élèves
     * sans tenir compte des cours-groupes éventuels.
     *
     * @param $listeEleves
     * @param $highStatus : liste des statuts de cours de haut niveau ('FC','OB') -> permet d'écarter les cours de Rem, AC,... Utile pour les synthèses générales
     *
     * @return array
     */
    public function listeCoursEleves($listeEleves, $highStatus = false)
    {
        if (is_array($listeEleves)) {
            $listeMatricules = implode(',', array_keys($listeEleves));
        } else {
            $listeMatricules = $listeEleves;
        }
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = "SELECT DISTINCT coursGrp, SUBSTR(coursGrp, 1,LOCATE('-',coursGrp)-1) AS cours, matricule, ";
        $sql .= 'libelle, nbheures, statut, section ';
        $sql .= 'FROM '.PFX.'elevesCours ';
        $sql .= 'JOIN '.PFX.'cours ON ('.PFX."cours.cours = SUBSTR(coursGrp, 1,LOCATE('-',coursGrp)-1)) ";
        $sql .= 'JOIN '.PFX.'statutCours ON ('.PFX.'statutCours.cadre = '.PFX.'cours.cadre) ';
        $sql .= "WHERE matricule IN ($listeMatricules) ";
        // si l'on veut négliger les cours moins importants
        if ($highStatus) {
            $sql .= "AND statut IN ('FC','OB') ";
        }
        $sql .= 'ORDER BY nbheures DESC, libelle ';

        $resultat = $connexion->query($sql);
        $listeCours = array();
        if ($resultat) {
            $resultat->setFetchMode(PDO::FETCH_ASSOC);
            while ($ligne = $resultat->fetch()) {
                $cours = $ligne['cours'];
                $matricule = $ligne['matricule'];
                $listeCours[$cours][$matricule] = $ligne;
            }
        }
        Application::DeconnexionPDO($connexion);

        return $listeCours;
    }

    /**
     * renvoie le catalogue de toutes les offres de remédiation pour les élèves du $niveau donné
     *
     * @param int $niveau
     *
     * @return array
     */
    public function getCatalogue4Niveau($niveau){
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT offre.idOffre, offre.acronyme, title, contenu, startDate, DATE_FORMAT(startDate,"%d/%m/%Y") AS dateDebut, ';
        $sql .= 'TIMEDIFF(endDate, startDate) AS duree, endDate, local, places, cache, cible, type, ';
        $sql .= 'cours, libelle, nom, prenom ';
        $sql .= 'FROM '.PFX.'remediationOffre AS offre ';
        $sql .= 'JOIN '.PFX.'profs AS dp ON dp.acronyme = offre.acronyme ';
        $sql .= 'LEFT JOIN '.PFX.'remediationCibles AS cible ON offre.idOffre = cible.idOffre ';
        $sql .= 'LEFT JOIN '.PFX.'cours AS dc ON (dc.cours = SUBSTR(cible, 1, LOCATE("-", cible)-1) OR dc.cours = cible) ';
        $sql .= 'WHERE (startDate > NOW()) AND (cache = 0) AND (SUBSTR(cible, 1, 1) = :niveau OR cible.type = "ecole") ';
        $sql .= 'ORDER BY startDate ASC, title ';

        $requete = $connexion->prepare($sql);

        $requete->bindParam(':niveau', $niveau, PDO::PARAM_INT);

        $liste = array();
        $resultat = $requete->execute();
        if ($resultat) {
            $requete->setFetchMode(PDO::FETCH_ASSOC);
            while ($ligne = $requete->fetch()) {
                $idOffre = $ligne['idOffre'];
                if (!(isset($liste[$idOffre])))
                    $liste[$idOffre] = array('data' => $ligne, 'cibles' => array());
                $cible = $ligne['cible'] == Null ? 'tous' : $ligne['cible'];
                $cours = $ligne['cours'] == Null ? 'tous' : $ligne['cours'];
                $type = $ligne['type'];
                $liste[$idOffre]['cibles'][] = array('type' => $type, 'cible' => $cible, 'libelle' => $ligne['libelle']);
            }
        }

        Application::DeconnexionPDO($connexion);

        return $liste;
    }

    /**
     * renvoie la liste des remédiations possibles pour l'élève en paramètre
     *
     * @param int $matricule
     * @param int $niveau : le niveau d'étude
     * @param string $classe : la classe de l'élève
     * @param array $listeCoursGrp : la liste des cours suivis par l'élève
     * @param array $listeMatieres : liste des matières de l'élève (cours sans le groupe)
     *
     * @return array
     */
    public function getCatalogue4eleve($niveau, $classe, $listeCoursGrp, $listeMatieres){
        $listeCoursGrpString = (is_array($listeCoursGrp)) ? "'".implode("','", $listeCoursGrp)."'" : Null;
        $listeMatieresString = (is_array($listeMatieres)) ? "'".implode("','", $listeMatieres)."'" : Null;
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT DISTINCT offre.idOffre, type, offre.acronyme, title, contenu, cours, libelle, local, cible, type, startDate, DATE_FORMAT(startDate,"%d/%m/%Y") AS dateDebut, ';
        $sql .= 'TIME_FORMAT(startDate,"%H:%i") AS heure, TIMEDIFF(endDate, startDate) AS duree, places, sexe, nom, prenom ';
        $sql .= 'FROM '.PFX.'remediationOffre AS offre ';
        $sql .= 'JOIN '.PFX.'remediationCibles AS cibles ON cibles.idOffre = offre.idOffre ';
        $sql .= 'LEFT JOIN '.PFX.'profs AS profs ON profs.acronyme = offre.acronyme ';
        $sql .= 'LEFT JOIN '.PFX.'cours AS dc ON (dc.cours = SUBSTR(cible, 1, LOCATE("-", cible)-1) OR dc.cours = cible) ';
        $sql .= 'WHERE (startDate >= NOW()) AND (cache = 0) AND (cible = :niveau OR cible = :classe OR cible IN ('.$listeCoursGrpString.') OR cible IN ('.$listeMatieresString.')) ';
        $sql .= 'ORDER BY startDate, heure, cible, title ';

        $requete = $connexion->prepare($sql);

        $requete->bindParam(':niveau', $niveau, PDO::PARAM_STR, 1);
        $requete->bindParam(':classe', $classe, PDO::PARAM_STR, 9);

        $liste = array();
        $resultat = $requete->execute();
        if ($resultat) {
            $requete->setFetchMode(PDO::FETCH_ASSOC);
            while ($ligne = $requete->fetch()) {
                $idOffre = $ligne['idOffre'];
                if (!(isset($liste[$idOffre])))
                    $liste[$idOffre] = array('data' => $ligne, 'cibles' => array());
                $cible = $ligne['cible'] == Null ? 'tous' : $ligne['cible'];
                $cours = $ligne['cours'] == Null ? 'tous' : $ligne['cours'];
                $type = $ligne['type'];
                $liste[$idOffre]['cibles'][] = array('type' => $type, 'cible' => $cible, 'libelle' => $ligne['libelle']);
            }
        }

        Application::DeconnexionPDO($connexion);

        return $liste;
    }

    /**
     * Recherche des détails concernant l'offre $idOffre pour l'utilisateur $acronyme
     *
     * @param int $idOffre
     * @param string $acronyme
     *
     * @return array
     */
    public function getOffre($idOffre, $acronyme = Null) {
        if ($idOffre != Null) {
            $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
            $sql = 'SELECT idOffre, acronyme, title, contenu, startDate, endDate, TIMEDIFF(endDate, startDate) AS duree, ';
            $sql .= 'local, places, cache ';
            $sql .= 'FROM '.PFX.'remediationOffre ';
            $sql .= 'WHERE idOffre = :idOffre ';
            if ($acronyme != Null)
                $sql .= 'AND acronyme = :acronyme ';
            $requete = $connexion->prepare($sql);

            $requete->bindParam(':idOffre', $idOffre, PDO::PARAM_INT);
            if ($acronyme != Null)
                $requete->bindParam(':acronyme', $acronyme, PDO::PARAM_STR, 7);

            $resultat = $requete->execute();
            $ligne = Null;
            if ($resultat) {
                $requete->setFetchMode(PDO::FETCH_ASSOC);
                $ligne = $requete->fetch();
                $dt = explode(' ', $ligne['startDate']);
                $ligne['startDate'] = Application::datePHP($dt[0]);
                $ligne['heure'] = SUBSTR($dt[1], 0, 5);
                $ligne['duree'] = SUBSTR($ligne['duree'], 0, 5);
            }

            Application::deconnexionPDO($connexion);
        }
        else {
            $startDate = Application::dateNow();
            $heure = SUBSTR(Application::timeNow(),0,5);
            $fin = strtotime($startDate) + (60*50); // 50 minutes;
            $endDate = date("Y-m-d H:i:s", $fin);
            $ligne = array(
                'idOffre' => Null,
                'acronyme' => $acronyme,
                'title' => '',
                'contenu' => '',
                'startDate' => $startDate,
                'endDate' => $endDate,
                'heure' => $heure,
                'local' => '',
                'duree' => '00:50',
                'places' => 0,
                'cache' => 0,
            );
        }

        return $ligne;
    }

    /**
     * renvoie les types de cibles existantes pour les remédiations
     *
     * @param void
     *
     * @return array
     */
    public function getTypes(){
        return array(
            '' => 'Choisir',
            'ecole' => 'Tous les élèves',
            'niveau' => 'Un niveau',
            'classe' => 'Une classe',
            'matiere' => 'Une matière',
            'coursGrp' => 'Un de vos cours'
        );
    }

    /**
     * retourne les types et les cibles pour l'offre $idOffre de l'utilisateur $acronyme
     *
     * @param int $idOffre : identifiant de l'offre de remédiation
     *
     * @return array
     */
    public function getCibles($idOffre, $acronyme) {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT DISTINCT cibles.idOffre, type, cible ';
        $sql .= 'FROM '.PFX.'remediationCibles AS cibles ';
        $sql .= 'JOIN '.PFX.'remediationOffre AS offre ON offre.idOffre = cibles.idOffre ';
        $sql .= 'LEFT JOIN '.PFX.'remediationEleves AS remEl ON remEl.idOffre = cibles.idOffre ';
        $sql .= 'WHERE cibles.idOffre = :idOffre AND acronyme = :acronyme ';
        $sql .= 'ORDER BY type, cible ';
        $requete = $connexion->prepare($sql);

        $requete->bindParam(':idOffre', $idOffre, PDO::PARAM_INT);
        $requete->bindParam(':acronyme', $acronyme, PDO::PARAM_STR, 7);

        $liste = array();
        $resultat = $requete->execute();
        if ($resultat) {
            $requete->setFetchMode(PDO::FETCH_ASSOC);
            while ($ligne = $requete->fetch()) {
                $type = $ligne['type'];
                $liste[$type][] = $ligne['cible'];
            }
        }

        Application::DeconnexionPDO($connexion);

        return $liste;
    }

    /**
     * renvoie la liste des élèves inscrits à la remédiation $idOffre pour le prof $acronyme
     *
     * @param int $idOffre : l'offre de remédiation
     * @param string $acronyme : l'acronyme du prof
     *
     * @return array
     */
    public function getEleves ($idOffre, $acronyme){
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT rem.idOffre, rem.matricule, groupe, nom, prenom, presence, obligatoire ';
        $sql .= 'FROM '.PFX.'remediationEleves AS rem ';
        $sql .= 'JOIN '.PFX.'remediationOffre AS offre ON offre.idOffre = rem.idOffre ';
        $sql .= 'JOIN '.PFX.'eleves AS de ON de.matricule = rem.matricule ';
        $sql .= 'WHERE rem.idOffre = :idOffre AND acronyme = :acronyme ';
        $sql .= "ORDER BY REPLACE(REPLACE(REPLACE(nom,' ',''),'-',''),'\'',''), prenom, groupe ";
        $requete = $connexion->prepare($sql);

        $requete->bindParam(':idOffre', $idOffre, PDO::PARAM_INT);
        $requete->bindParam(':acronyme', $acronyme, PDO::PARAM_STR, 7);

        $liste = array();
        $resultat = $requete->execute();
        if ($resultat){
            $requete->setFetchMode(PDO::FETCH_ASSOC);
            while ($ligne = $requete->fetch()){
                $matricule = $ligne['matricule'];
                $liste[$matricule] = $ligne;
            }
        }

        Application::DeconnexionPDO($connexion);

        return $liste;
    }

    /**
     * enregistre une édition d'une offre de remédiation depuis le formulaire correspondant pour l'utilisateur $acronyme
     *
     * @param array $form
     * @param string $acronyme
     *
     * @return boolean
     */
    public function saveRemediation($form, $acronyme){
        $title = SUBSTR($form['title'], 0, 50);

        $date = Application::dateMysql($form['date']);
        $heure = SUBSTR($form['heure'],0,5);
        $startDate = $date.' '.$heure;

        $duree = $form['duree'];
        if (!is_numeric($duree)) {
            if (strpos($duree,':') > 0) {
                // c'est sans doute le format hh::mm
                $duree = explode(':', $duree);
                $duree = intval($duree[0]) * 50 + intval($duree[1]);
            }
            else $duree = 0;
        }

        $endDate = new DateTime($startDate);
        $endDate->add(new DateInterval('PT'.$duree.'M'));
        $endDate = $endDate->format('Y-m-d H:i');

        $contenu = $form['contenu'];
        $local = SUBSTR($form['local'], 0, 12);
        $places = $form['places'];

        $cache = isset($form['cache']) ? 1 : 0;
        $idOffre = $form['idOffre'];

        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'INSERT INTO '.PFX.'remediationOffre ';
        if ($idOffre == '')
            $sql .= "SET idOffre = Null, ";
            else $sql .= "SET idOffre = :idOffre, ";
        $sql .= 'acronyme = :acronyme, title = :title, contenu = :contenu, startDate = :startDate, endDate = :endDate, ';
        $sql .= 'local = :local, places = :places, cache = :cache, lastModif = NOW() ';
        $sql .= 'ON DUPLICATE KEY UPDATE title = :title, contenu = :contenu, startDate = :startDate, endDate = :endDate, ';
        $sql .= 'local = :local, places = :places, cache = :cache, lastModif = NOW() ';
        $requete = $connexion->prepare($sql);

        $requete->bindParam(':idOffre', $idOffre, PDO::PARAM_INT);
        $requete->bindParam(':acronyme', $acronyme, PDO::PARAM_STR, 7);
        $requete->bindParam(':title', $title, PDO::PARAM_STR, 50);
        $requete->bindParam(':contenu', $contenu, PDO::PARAM_STR);
        $requete->bindParam(':startDate', $startDate, PDO::PARAM_STR, 19);
        $requete->bindParam(':endDate', $endDate, PDO::PARAM_STR, 19);
        $requete->bindParam(':local', $local, PDO::PARAM_STR, 12);
        $requete->bindParam(':places', $places, PDO::PARAM_INT);
        $requete->bindParam(':cache', $cache, PDO::PARAM_INT);

        $resultat = $requete->execute();


        if ($idOffre == Null)
            $idOffre = $connexion->lastInsertId();

        Application::DeconnexionPDO($connexion);

        return $idOffre;
    }

    /**
     * modifie les dates/heures de début et fin d'un événement après drag/drop
     * @param  int $idOffre   identifiant de l'offre
     * @param  string $startTime nouvelle date de début
     * @param  string $endTime   nouvelle date de fin
     * @return bool
     */
    public function changeEventTime($idOffre, $startTime, $endTime){
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'UPDATE '.PFX.'remediationOffre ';
        $sql .= 'SET startDate = :startTime, endDate = :endTime ';
        $sql .= 'WHERE idOffre = :idOffre ';
        $requete = $connexion->prepare($sql);

        $requete->bindParam(':idOffre', $idOffre, PDO::PARAM_INT);
        $requete->bindParam(':startTime', $startTime, PDO::PARAM_STR, 20);
        $requete->bindParam(':endTime', $endTime, PDO::PARAM_STR, 20);

        $resultat = $requete->execute();

        Application::DeconnexionPDO($connexion);

        return $resultat;
    }

    /**
     * clonage des groupes liés à la remédiation $idOffre qui recopie la remédiation existante $idClone pour l'utilisateur $acronyme
     *
     * @param int $idOffre : identifiant de la nouvelle offre "clone"
     * @param int $idClone : identifiant de l'offre originale
     * @param string $acronyme
     *
     * @return boolean
     */
    public function cloneGroupesRemediation($idOffre, $idClone, $acronyme) {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        // recherche des enregistrements concernant la remédiation à cloner
        $sql = 'SELECT idOffre, type, cible ';
        $sql .= 'FROM '.PFX.'remediationCibles ';
        $sql .= 'WHERE idOffre = :idClone ';
        $requete = $connexion->prepare($sql);

        $requete->bindParam(':idClone', $idClone, PDO::PARAM_INT);

        $resultat = $requete->execute();
        $requete->setFetchMode(PDO::FETCH_ASSOC);
        $listeAcloner = $requete->fetchAll();

        $sql = 'INSERT INTO '.PFX.'remediationCibles ';
        $sql .= 'SET idOffre = :idOffre, type = :type, cible = :cible ';
        $requete = $connexion->prepare($sql);

        $requete->bindParam(':idOffre', $idOffre, PDO::PARAM_INT);
        foreach ($listeAcloner as $wtf => $original) {
            $requete->bindParam(':type', $original['type'], PDO::PARAM_INT);
            $requete->bindParam(':cible', $original['cible'], PDO::PARAM_INT);
            $resultat = $requete->execute();
        }

        Application::DeconnexionPDO($connexion);

        return $resultat;
    }

    /**
     * clonage des élèves liés à la remédiation $idOffre qui recopie la remédiation existante $idClone pour l'utilisateur $acronyme
     *
     * @param int $idOffre : identifiant de la nouvelle offre "clone"
     * @param int $idClone : identifiant de l'offre originale
     * @param string $acronyme
     */
    public function cloneElevesRemediation($idOffre, $idClone, $acronyme) {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        // recherche des élèves liés à la remédiation $idClone
        $sql = 'SELECT idOffre, matricule ';
        $sql .= 'FROM '.PFX.'remediationEleves ';
        $sql .= 'WHERE idOffre = :idClone AND obligatoire = 1 ';
        $requete = $connexion->prepare($sql);

        $requete->bindParam(':idClone', $idClone, PDO::PARAM_INT);

        $resultat = $requete->execute();
        $requete->setFetchMode(PDO::FETCH_ASSOC);
        $listeAcloner = $requete->fetchAll();

        $sql = 'INSERT IGNORE INTO '.PFX.'remediationEleves ';
        $sql .= 'SET idOffre = :idOffre, matricule = :matricule, obligatoire = 1 ';
        $requete = $connexion->prepare($sql);

        $requete->bindParam(':idOffre', $idOffre, PDO::PARAM_INT);

        foreach ($listeAcloner as $wtf => $data) {
            $requete->bindParam(':matricule', $data['matricule'], PDO::PARAM_INT);
            $requete->bindParam(':idOffre', $idOffre, PDO::PARAM_INT);
            $resulat = $requete->execute();
        }

        Application::DeconnexionPDO($connexion);

        return $resultat;
    }

    /**
     * enregistre les informations relatives à la cible d'une remédiation dont on fournit le $idOffre pour l'utilisateur $acronyme
     *
     * @param string $acronyme
     * @param array $form : le formulaire contenant les détails de la cible
     *
     * @return boolean
     */
    public function saveCibleOffre($idOffre, $type, $cible, $acronyme){
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'INSERT IGNORE INTO '.PFX.'remediationCibles ';
        $sql .= 'SET idOffre = :idOffre, type = :type, cible = :cible ';
        $requete = $connexion->prepare($sql);

        $requete->bindParam(':idOffre', $idOffre, PDO::PARAM_INT);
        $requete->bindParam(':type', $type, PDO::PARAM_STR, 15);
        $requete->bindParam(':cible', $cible, PDO::PARAM_STR, 10);

        $resultat = $requete->execute();

        Application::DeconnexionPDO($connexion);

        return $requete->rowCount();
    }

    /**
     * Suppression définitive de la remédiation $idOffre de l'utilisateur $acronyme
     *
     * @param int $idOffre
     * @param string $acronyme
     *
     * @return boolean
     */
    public function delRemediation ($idOffre, $acronyme) {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'DELETE FROM '.PFX.'remediationOffre ';
        $sql .= 'WHERE idOffre = :idOffre AND acronyme = :acronyme ';
        $requete = $connexion->prepare($sql);

        $requete->bindParam(':idOffre', $idOffre, PDO::PARAM_INT);
        $requete->bindParam(':acronyme', $acronyme, PDO::PARAM_STR, 7);
        $resultat = $requete->execute();

        $sql = 'DELETE FROM '.PFX.'remediationCibles ';
        $sql .= 'WHERE idOffre = :idOffre ';
        $requete = $connexion->prepare($sql);

        $requete->bindParam(':idOffre', $idOffre, PDO::PARAM_INT);
        $resultat = $requete->execute();

        $sql = 'DELETE FROM '.PFX.'remediationEleves ';
        $sql .= 'WHERE idOffre = :idOffre ';
        $requete = $connexion->prepare($sql);

        $requete->bindParam(':idOffre', $idOffre, PDO::PARAM_INT);
        $resultat = $requete->execute();

        Application::DeconnexionPDO($connexion);

        return $resultat;
    }

    /**
     * vérifie que l'utilisateur $acronyme est propriétaire de l'offre $idOffre (avant un effacement, par exemple)
     *
     * @param int $idOffre
     * @param string $acronyme
     *
     * @return boolean
     */
    public function isOwner($idOffre, $acronyme) {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT acronyme ';
        $sql .= 'FROM '.PFX.'remediationOffre ';
        $sql .= 'WHERE idOffre = :idOffre AND acronyme = :acronyme ';
        $sql .= 'LIMIT 1';
        $requete = $connexion->prepare($sql);

        $requete->bindParam(':idOffre', $idOffre, PDO::PARAM_INT);
        $requete->bindParam(':acronyme', $acronyme, PDO::PARAM_STR, 7);

        $resultat = $requete->execute();
        $ligne = array();
        if ($resultat) {
            $requete->setFetchMode(PDO::FETCH_ASSOC);
            $ligne = $requete->fetch();
        }

        Application::DeconnexionPDO($connexion);

        return ($ligne['acronyme'] == $acronyme);
    }

    /**
     * suppression du groupe cible $cible du type $type pour l'offre $idOffre pour l'utilisateur $acronyme
     *
     * @param int $idOffre
     * @param string $type
     * @param string $cible
     *
     * @return boolean
     */
    public function delGroupeCible($idOffre, $type, $cible){
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'DELETE FROM '.PFX.'remediationCibles ';
        $sql .= 'WHERE idOffre = :idOffre AND type = :type AND cible = :cible ';
        $requete = $connexion->prepare($sql);

        $requete->bindParam(':idOffre', $idOffre, PDO::PARAM_INT);
        $requete->bindParam(':type', $type, PDO::PARAM_STR, 15);
        $requete->bindParam(':cible', $cible, PDO::PARAM_STR, 20);

        $resultat = $requete->execute();

        Application::DeconnexionPDO($connexion);

        return $requete->rowCount();
    }

    /**
     * inscription des élèves de la liste $listeEleves à la remédiation $idOffre
     *
     * @param array $listeEleves : liste des matricules des élèves à inscrire
     * @param int $idOffre
     *
     * @return boolean
     */
    public function inviteEleves($listeEleves, $idOffre){
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'INSERT IGNORE INTO '.PFX.'remediationEleves ';
        $sql .= 'SET matricule = :matricule, idOffre = :idOffre, obligatoire = 1 ';
        $requete = $connexion->prepare($sql);

        $requete->bindParam(':idOffre', $idOffre, PDO::PARAM_INT);
        foreach ($listeEleves as $wtf => $matricule) {
            $requete->bindParam(':matricule', $matricule, PDO::PARAM_INT);
            $resultat = $requete->execute();
        }

        Application::DeconnexionPDO($connexion);

        return $resultat;
    }

    /**
     * supprime l'inscription d'un élève $matricule de l'offre de remédiation $idOffre
     *
     * @param int $matricule
     * @param int $idOffre
     *
     * @return boolean
     */
    public function deleteEleve($matricule, $idOffre){
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'DELETE FROM '.PFX.'remediationEleves ';
        $sql .= 'WHERE matricule = :matricule AND idOffre = :idOffre ';
        $requete = $connexion->prepare($sql);

        $requete->bindParam(':matricule', $matricule, PDO::PARAM_INT);
        $requete->bindParam(':idOffre', $idOffre, PDO::PARAM_INT);

        $resultat = $requete->execute();

        Application::DeconnexionPDO($connexion);

        return $resultat;
    }

    /**
     * Enregistre les prises de présences pour l'offre $idOffre et la liste $listePresences (matricule => statut)
     *
     * @param int $idOffre
     * @param array $listePresences
     *
     * @return int
     */
    public function savePresences($idOffre, $listePresences) {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'UPDATE '.PFX.'remediationEleves ';
        $sql .= 'SET idOffre = :idOffre, matricule = :matricule, presence = :presence ';
        $sql .= 'WHERE matricule = :matricule AND idOffre = :idOffre ';

        $requete = $connexion->prepare($sql);

        $resultat = 0;
        $requete->bindParam(':idOffre', $idOffre, PDO::PARAM_INT);
        foreach ($listePresences as $matricule => $statut) {
            $requete->bindParam(':matricule', $matricule, PDO::PARAM_INT);
            switch ($statut) {
                case 'P':
                    $presence = 'present';
                    break;
                case 'A':
                    $presence = 'absent';
                    break;
                case 'I':
                    $presence = 'indetermine';
                    break;
                default:
                    $presence = Null;
                    break;
                }
            $requete->bindParam(':presence', $presence, PDO::PARAM_STR);
            $resultat += $requete->execute();
        }

        Application::DeconnexionPDO($connexion);

        return $resultat;
    }

    /**
     * renvoie la liste des présences pour une $classe donnée entre une date de $debut et une date de $fin
     *
     * @param string $classe
     * @param string $debut
     * @param string $fin
     *
     * @return array
     */
    public function getListePresences($classe, $debut, $fin) {
        $debut = Application::dateMysql($debut);
        $fin = Application::dateMysql($fin);
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT eleves.idOffre, eleves.matricule, presence, obligatoire, de.nom AS nomEleve, de.prenom AS prenomEleve, de.groupe, ';
        $sql .= 'profs.acronyme, profs.nom AS nomProf, profs.prenom AS prenomProf, title, ';
        $sql .= 'DATE_FORMAT(startDate,"%d/%m/%Y") AS date, TIME_FORMAT(startDate,"%H:%i") AS heure ';
        $sql .= 'FROM '.PFX.'remediationEleves AS eleves ';
        $sql .= 'JOIN '.PFX.'remediationOffre AS offre ON offre.idOffre = eleves.idOffre ';
        $sql .= 'JOIN '.PFX.'eleves AS de ON de.matricule = eleves.matricule ';
        $sql .= 'LEFT JOIN '.PFX.'profs AS profs ON profs.acronyme = offre.acronyme ';
        $sql .= 'WHERE groupe = :classe AND startDate BETWEEN :debut AND :fin ';
        $sql .= 'ORDER BY de.nom, de.prenom, date, heure ';
        $requete = $connexion->prepare($sql);

        $requete->bindParam(':classe', $classe, PDO::PARAM_STR, 6);
        $requete->bindParam(':debut', $debut, PDO::PARAM_STR, 10);
        $requete->bindParam(':fin', $fin, PDO::PARAM_STR, 10);

        $resultat = $requete->execute();
        $liste = array();
        if ($resultat) {
            $requete->setFetchMode(PDO::FETCH_ASSOC);
            while ($ligne = $requete->fetch()) {
                $matricule = $ligne['matricule'];
                if (!(isset($liste[$matricule])))
                    $liste[$matricule]['dataEleve'] = array('classe' => $ligne['groupe'], 'nom' => $ligne['nomEleve'].' '.$ligne['prenomEleve']);
                $idOffre = $ligne['idOffre'];
                $liste[$matricule]['offres'][$idOffre] = $ligne;
            }
        }

        Application::DeconnexionPDO($connexion);

        return $liste;
    }

    /**
     * retourne la liste des remédiations entre deux dates $start et $end pour l'utilisateur $acronyme
     *
     * @param string $start : date de début de l'intervalle
     * @param string $end : date de fin de l'intervalle
     * @param string $acronyme
     *
     * @return array
     */
    public function getListeRemediations($start, $end, $acronyme) {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT idOffre AS id, acronyme, title, contenu, startDate AS start, endDate AS end, local, DATE_FORMAT(NOW(),"%Y-%m-%d") AS ajd ';
        $sql .= 'FROM '.PFX.'remediationOffre ';
        $sql .= 'WHERE startDate BETWEEN :start AND :end ';
        $requete = $connexion->prepare($sql);

        $requete->bindParam(':start', $start, PDO::PARAM_STR, 20);
        $requete->bindParam(':end', $end, PDO::PARAM_STR, 20);
        // $requete->bindParam(':acronyme', $acronyme, PDO::PARAM_STR, 7);

        $liste = array();
        $resultat = $requete->execute();
        if ($resultat) {
            $requete->setFetchMode(PDO::FETCH_ASSOC);
            while ($ligne = $requete->fetch()) {
                $ligne['className'] = array(sprintf('class_%s', $ligne['id']));
                if ($ligne['acronyme'] == $acronyme) {
                     array_push($ligne['className'], 'proprio');
                     // si l'événement du proprio est dans le futur, il peut être déplacé
                     if ($ligne['start'] >= $ligne['ajd'])
                         $ligne['editable'] = true;
                    }
                if ($ligne['start'] < $ligne['ajd'])
                    array_push($ligne['className'], 'past-event');
                $liste[] = $ligne;
            }
        }

        Application::DeconnexionPDO($connexion);

        return $liste;
    }
}
