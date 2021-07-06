<?php

/**
 *
 */
class Reservation
{

    function __construct()
    {
        // code...
    }

    /**
     * liste de toutes les pièces de matériel ou locaux disponibles
     * tri par type de matériel
     *
     * @param void
     *
     * @return array
     */
    public function getRessourceByType($idType) {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT types.idType, type, reservations.idType, reservations.description, reservations.reference, reservations.idRessource, ';
        $sql .= 'reservations.localisation, reservations.etat, reservations.hasCaution, reservations.caution, indisponible, longTermeBy, etat ';
        $sql .= 'FROM '.PFX.'reservationsTypes AS types ';
        $sql .= 'JOIN '.PFX.'reservations AS reservations ON reservations.idType = types.idType ';
        $sql .= 'WHERE types.idType = :idType ';
        $sql .= 'ORDER BY description ';
        $requete = $connexion->prepare($sql);

        $requete->bindParam(':idType', $idType, PDO::PARAM_STR, 7);

        $resultat = $requete->execute();

        $liste = array();
        if ($resultat) {
            $requete->setFetchMode(PDO::FETCH_ASSOC);
            while ($ligne = $requete->fetch()){
                $id = $ligne['idRessource'];
                $liste[$id] = $ligne;

            }
        }

        Application::DeconnexionPDO($connexion);

        return $liste;
    }

    /**
     * Recherche la liste de tous les types de ressources disponibles
     *
     * @param void
     *
     * @return array
     */
    public function getTypesRessources(){
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT idType, type ';
        $sql .= 'FROM '.PFX.'reservationsTypes ';
        $sql .= 'ORDER BY type ASC ';
        $requete = $connexion->prepare($sql);

        $liste = array();
        $resultat = $requete->execute();
        if ($resultat){
            $requete->setFetchMode(PDO::FETCH_ASSOC);
            while ($ligne = $requete->fetch()){
                $id = $ligne['idType'];
                $liste[$id] = $ligne['type'];
            }
        }

        Application::DeconnexionPDO($connexion);

        return $liste;
    }

    /**
     * Ajouter le type de ressources $type
     *
     * @param string $type
     *
     * @return int
     */
    public function addTypeRessource($type){
        // limiter le nombre de caractères
        $type = SUBSTR($type, 0, 30);
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT idType, type ';
        $sql .= 'FROM '.PFX.'reservationsTypes ';
        $sql .= 'WHERE type = :type ';
        $requete = $connexion->prepare($sql);

        $requete->bindParam(':type', $type, PDO::PARAM_STR, 30);

        $existe = 0;
        $resultat = $requete->execute();
        if ($resultat){
            $ligne = $requete->fetch();
            if ($ligne != Null)
                $existe = 1;
        }
        if ($existe == 0) {
            $sql = 'INSERT INTO '.PFX.'reservationsTypes ';
            $sql .= 'SET type = :type ';
            $requete = $connexion->prepare($sql);

            $requete->bindParam(':type', $type, PDO::PARAM_STR, 30);
            $resultat = $requete->execute();

            $id = $idCategorie = $connexion->lastInsertId();
        }

        Application::DeconnexionPDO($connexion);

        if (($existe == 0) || ($id != 0))
            return $id;
            else return 0;
    }

    /**
     * supprimer un type de ressource vide
     *
     * @param int $idType
     *
     * @return int
     */
    public function delTypeRessource($idType){
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'DELETE FROM '.PFX.'reservationsTypes  ';
        $sql .= 'WHERE idType = :idType ';
        $requete = $connexion->prepare($sql);

        $requete->bindParam(':idType', $idType, PDO::PARAM_INT);

        $resultat = $requete->execute();
        $n = $requete->rowCount();

        Application::DeconnexionPDO($connexion);

        return $n;
    }

    /**
     * suppression de toutes les réservations de la ressource $idRessource
     *
     * @param int $idRessource
     *
     * @return int
     */
    public function delReservations4ressource($idRessource){
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'DELETE FROM '.PFX.'reservationsUser ';
        $sql .= 'WHERE idRessource = :idRessource ';
        $requete = $connexion->prepare($sql);

        $requete->bindParam(':idRessource', $idRessource, PDO::PARAM_INT);

        $resultat = $requete->execute();
        $n = $requete->rowCount();

        Application::DeconnexionPDO($connexion);

        return $n;
    }

    /**
     * suppression d'une ressource existante
     *
     * @param int $idRessource
     *
     * @return int
     */
    public function delRessource($idRessource){
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'DELETE FROM '.PFX.'reservations  ';
        $sql .= 'WHERE idRessource = :idRessource ';
        $requete = $connexion->prepare($sql);

        $requete->bindParam(':idRessource', $idRessource, PDO::PARAM_INT);

        $resultat = $requete->execute();
        $n = $requete->rowCount();

        Application::DeconnexionPDO($connexion);

        return $n;
    }

    /**
     * recherche la ressource $idRessource
     *
     * @param int $idRessource
     *
     * @return array
     */
    public function getRessourceById($idRessource){
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT idRessource, description, reference, reservation.idType, localisation, etat, ';
        $sql .= 'indisponible, longTermeBy, hasCaution, caution, type, ';
        $sql .= 'eleves.groupe, eleves.prenom AS prenomEleve, eleves.nom AS nomEleve, ';
        $sql .= 'profs.nom AS nomProf, profs.prenom AS prenomProf ';
        $sql .= 'FROM '.PFX.'reservations AS reservation ';
        $sql .= 'JOIN '.PFX.'reservationsTypes AS types ON types.idType = reservation.idType ';
        $sql .= 'LEFT JOIN '.PFX.'eleves AS eleves ON eleves.matricule = reservation.longTermeBy ';
        $sql .= 'LEFT JOIN '.PFX.'profs AS profs ON profs.acronyme = reservation.longTermeBy ';
        $sql .= 'WHERE idRessource = :idRessource ';
        $requete = $connexion->prepare($sql);

        $requete->bindParam(':idRessource', $idRessource, PDO::PARAM_INT);

        $ligne = array();
        $resultat = $requete->execute();
        if ($resultat){
            $requete->setFetchMode(PDO::FETCH_ASSOC);
            $ligne = $requete->fetch();
        }

        Application::DeconnexionPDO($connexion);

        return $ligne;
    }

    /**
     * Vérifier si un référence existe déjà pour une ressource de type $idType
     *
     * @param int $idType
     * @param string $reference
     *
     * @return bool
     */
    public function referenceExiste($idType, $reference){
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT reference, idType ';
        $sql .= 'FROM '.PFX.'reservations ';
        $sql .= 'WHERE idType = :idType AND UPPER(reference) = :reference ';
        $requete = $connexion->prepare($sql);

        $reference = strtoupper($reference);
        $requete->bindParam(':reference', $reference, PDO::PARAM_STR, 32);
        $requete->bindParam(':idType', $idType, PDO::PARAM_INT);

        $resultat = $requete->execute();
        if ($resultat){
            $ligne = $requete->fetch();
        }

        Application::DeconnexionPDO($connexion);

        return $ligne != Null;
    }

    /**
     * enregistrer une ressource
     *
     * @param array $post : le formulaire qui va bien
     *
     * @return int : identifiant de la ressource
     */
    public function saveRessource($post){
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'INSERT INTO '.PFX.'reservations  ';
        $sql .= 'SET idRessource = :idRessource, description = :description, reference = :reference, idType = :idType, ';
        $sql .= 'localisation = :localisation, etat = :etat, hasCaution = :hasCaution, caution = :caution, indisponible = :indisponible, longTermeBy = :longTermeBy ';
        $sql .= 'ON DUPLICATE KEY UPDATE ';
        $sql .= 'description = :description, reference = :reference, idType = :idType, localisation = :localisation, ';
        $sql .= 'etat = :etat, hasCaution = :hasCaution, caution = :caution, indisponible = :indisponible, longTermeBy = :longTermeBy ';
        $requete = $connexion->prepare($sql);

        // $idRessource est la clef dans la table des réservations
        $idRessource = isset($post['idRessource']) ? $post['idRessource'] : Null;

        $description = isset($post['description']) ? $post['description'] : Null;
        $reference = isset($post['reference']) ? $post['reference'] : Null;
        $idType = isset($post['idType']) ? $post['idType'] : Null;
        $localisation = isset($post['localisation']) ? $post['localisation'] : Null;
        $etat = isset($post['etat']) ? $post['etat'] : Null;
        $hasCaution = isset($post['hasCaution']) ? $post['hasCaution'] : 0;
        $caution = isset($post['caution']) ? $post['caution'] : Null;
        $indisponible = isset($post['indisponible']) ? $post['indisponible'] : Null;
        $longTermeBy = isset($post['longTermeBy']) ? $post['longTermeBy'] : Null;

        $requete->bindParam(':idRessource', $idRessource, PDO::PARAM_INT);
        $requete->bindParam(':description', $description, PDO::PARAM_STR, 32);
        $requete->bindParam(':reference', $reference, PDO::PARAM_STR, 32);
        $requete->bindParam(':idType', $idType, PDO::PARAM_INT);
        $requete->bindParam(':localisation', $localisation, PDO::PARAM_STR, 32);
        $requete->bindParam(':etat', $etat, PDO::PARAM_STR);
        $requete->bindParam(':hasCaution', $hasCaution, PDO::PARAM_INT);
        $requete->bindParam(':caution', $caution, PDO::PARAM_INT);
        $requete->bindParam(':indisponible', $indisponible, PDO::PARAM_INT);
        $requete->bindParam(':longTermeBy', $longTermeBy, PDO::PARAM_STR, 7);

        $resultat = $requete->execute();

        $rowCount = $requete->rowCount();

        if ($rowCount == 1) { // une seule ligne a été ajoutée -> pas un UPDATE
            $idRessource = $connexion->lastInsertId();
        }

        Application::DeconnexionPDO($connexion);

        return $idRessource;
    }

    /**
     * rechercher les réservations déjà existantes pour les ressources
     * dont on fournit la liste des idRessources entre
     * les dates $start et $end
     *
     * @param array $listePeriodesWanted
     * $listePeriodesWanted =>
     *      array('2021-06-01' => array(0 => 8:15, 1 => 9:05, ...), '2021-06-02' => array(0 => ...)
     * @param array $listeRessources
     * $listeRessources =>
     *    array (
     *     0 => '1',
     *     1 => '2',
     *   ),
     *
     * @return array
     */
    public function getPlanOccupation($listePeriodesWanted, $listeRessources){
        $listePeriodes = array();
        foreach ($listePeriodesWanted as $oneDay => $arrayPeriodes) {
            foreach ($arrayPeriodes as $unePeriode){
                $listePeriodes[] = sprintf('%s %s', $oneDay, $unePeriode);
            }
        }
        $listePeriodes = '"'.implode('","', $listePeriodes).'"';

        // recherche des réservations déjà faites pour les périodes indiquées
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT idRessource, idReservation, user, ';
        $sql .= 'DATE_FORMAT(dateDebut, "%H:%i") AS heure, DATE_FORMAT(dateDebut, "%Y-%m-%d") AS date,';
        $sql .= 'DATE_FORMAT(dateDebut, "%d-%m-%Y") AS dateFR, sexe, nom, prenom ';
        $sql .= 'FROM '.PFX.'reservationsUser AS res ';
        $sql .= 'LEFT JOIN '.PFX.'profs AS profs ON profs.acronyme = res.user ';
        $sql .= 'WHERE dateDebut IN ('.$listePeriodes.') AND idRessource = :idRessource ';
        $requete = $connexion->prepare($sql);

        $listeOccupation = array();
        foreach ($listeRessources as $idRessource){
            $requete->bindParam(':idRessource', $idRessource, PDO::PARAM_INT);
            $resultat = $requete->execute();
            if ($resultat){
                $requete->setFetchMode(PDO::FETCH_ASSOC);
                while ($ligne = $requete->fetch()){
                    $date = $ligne['date'];
                    $heure = $ligne['heure'];
                    $listeOccupation[$idRessource][$date][$heure] = $ligne;
                }
            }
        }
        // combinaison des demandes et des réservations déjà réalisées
        $planOccupation = array();
        foreach ($listeRessources as $idRessource) {
            foreach ($listePeriodesWanted AS $date => $lesHeures) {
                foreach ($lesHeures as $uneHeure) {
                    if (isset($listeOccupation[$idRessource][$date][$uneHeure]))
                        $planOccupation[$idRessource][$date][$uneHeure] = $listeOccupation[$idRessource][$date][$uneHeure];
                        else $planOccupation[$idRessource][$date][$uneHeure] = Null;
                }
            }
        }

        return $planOccupation;
    }

    public function getListOfDays($startDate, $endDate) {
        $start = new DateTime($startDate);
        $end = new DateTime($endDate);
        $oneday = new DateInterval("P1D");

        $days = array();
        // $days[] = $startDate;
        foreach(new DatePeriod($start, $oneday, $end->add($oneday)) as $day) {
            $day_num = $day->format("N");
            if ($day_num < 6) { /* jour ouvré */
                $days[] = $day->format("Y-m-d");
            }
        }

        return $days;
    }

    /**
     * rechercher la liste des périodes de demande de réservation entre la date/heure de début
     * et la date/heure de fin (FORMAT: "2021-05-03 08:15")
     *
     * @param string $startSQL
     * @param string $endSQL
     *
     * @return array
     */
    public function getListePeriodes2dates($startSQL, $endSQL){
        // $start et $endSQL sont des tableaux contenant la date et l'heure de la réservation
        $startSQL = explode(' ', $startSQL);
        $endSQL = explode(' ', $endSQL);
        // isoler la date seule sans l'heure
        $startSQLdate = new DateTime($startSQL[0]);
        $endSQLdate = new DateTime($endSQL[0]);
        // le dernier jour n'est pas compris => on ajoute un jour
        $endSQLdate->modify('+1 day');
        // construire la liste des jours entre les deux dates
        $intervalle = new DateInterval('P1D');
        $listeJours = new DatePeriod($startSQLdate, $intervalle, $endSQLdate);

        // conversion en simple array de jours sans le week-ends
        $listeJoursArray = array();

        foreach ($listeJours as $uneDate){
            // nom du jour en trois lettres EN
            $curr = $uneDate->format('D');
            if (!(in_array($curr, array('Sat','Sun'))))
                $listeJoursArray[] =  $uneDate->format('Y-m-d');
        }

        // heure au format hh:mm de début et de fin de réservation
        $startHeure = $startSQL[1];
        $endHeure = $endSQL[1];

        // la liste des périodes de cours dans la journée
        $listePeriodes = $this->getPeriodesCours();

        // recherche de l'indice de l'heure de début dans la liste des périodes
        // $listeHeuresDebut contient uniquement les heures de début de période
        $listeHeuresDebut = array_column($listePeriodes, 'debut');

        $premierePeriode = array_search($startHeure, $listeHeuresDebut);
        $dernierePeriode = array_search($endHeure, $listeHeuresDebut);

        // construction de la liste des périodes de réservation
        $listePeriodesReservation = array();

        $nbJours = count($listeJoursArray);

        foreach ($listeJoursArray as $n => $uneDate){
            switch($n) {
                // premier jour de la réservation
                case 0:
                    // s'il n'y a qu'un seul jour
                    if ($nbJours == 1) {
                        for($periode = $premierePeriode-1; $periode < $dernierePeriode; ++$periode){
                            $heure = $listePeriodes[$periode+1]['debut'];
                            $listePeriodesReservation[$uneDate][$heure] = $heure;
                        }
                    }
                    else
                        for($periode = $premierePeriode-1; $periode < count($listePeriodes)-1; ++$periode) {
                            $heure = $listePeriodes[$periode+1]['debut'];
                            $listePeriodesReservation[$uneDate][$heure] = $heure;
                        }
                    break;
                // dernier jour de la réservation
                case count($listeJoursArray)-1:
                    for($periode = 0; $periode <= $dernierePeriode; ++$periode) {
                        $heure = $listePeriodes[$periode]['debut'];
                        $listePeriodesReservation[$uneDate][$heure] = $heure;
                    }
                    break;
                // un autre jour complet de la réservation
                default:
                    // toutes les périodes de la journée
                    foreach ($listePeriodes as $periode => $data){
                        $heure = $listePeriodes[$periode]['debut'];
                        $listePeriodesReservation[$uneDate][$heure] = $heure;
                    }
                    break;
            }
        }

        return $listePeriodesReservation;
    }

    /**
     * renvoie la liste des heures de cours données dans l'école.
     *
     * @param void
     *
     * @return array
     */
    public function getPeriodesCours() {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT debut, fin ';
        $sql = "SELECT DATE_FORMAT(debut,'%H:%i') as debut, DATE_FORMAT(fin,'%H:%i') as fin ";
        $sql .= 'FROM '.PFX.'presencesHeures ';
        $sql .= 'ORDER BY debut, fin';

        $resultat = $connexion->query($sql);
        $listePeriodes = array();
        if ($resultat) {
            while ($ligne = $resultat->fetch()) {
                $debut = $ligne['debut'];
                $fin = $ligne['fin'];
                $listePeriodes[] = array('debut' => $debut, 'fin' => $fin);
            }
        }
        Application::deconnexionPDO($connexion);

        return $listePeriodes;
    }

    /**
     * réserve la ressource $idRessource à la date $date et l'heure $heure
     * pour l'utilisateur $acronyme
     *
     * @param int $idRessource
     * @param string $date
     * @param string $heure
     * @param string $acronyme
     *
     * @return string : l'acronyme de l'utilisateur si réussi
     */
    public function reserveRessource($idRessource, $date, $heure, $acronyme){
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'INSERT INTO '.PFX.'reservationsUser ';
        $sql .= 'SET idRessource = :idRessource, dateDebut = :dateDebut, user = :acronyme ';
        $requete = $connexion->prepare($sql);

        $dateDebut = sprintf('%s %s', $date, $heure);

        $requete->bindParam(':idRessource', $idRessource, PDO::PARAM_INT);
        $requete->bindParam(':dateDebut', $dateDebut, PDO::PARAM_STR, 20);
        $requete->bindParam(':acronyme', $acronyme, PDO::PARAM_STR, 7);

        $resultat = $requete->execute();

        $nb = $requete->rowCount();

        Application::deconnexionPDO($connexion);

        if ($nb > 0)
            return $acronyme;
            else return Null;
    }

    /**
     * supprime la réservation de la ressource $idRessource à la date $date et l'heure $heure
     * pour l'utlisateur $acronyme
     *
     * @param int $idRessource
     * @param string $date
     * @param string $heure
     * @param string $acronyme
     *
     * @return string : l'acronyme de l'utilisateur si réussi
     */
    public function unReserveRessource($idRessource, $date, $heure, $acronyme){
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'DELETE FROM '.PFX.'reservationsUser ';
        $sql .= 'WHERE user = :acronyme AND dateDebut = :dateDebut AND idRessource = :idRessource ';
        $requete = $connexion->prepare($sql);

        $dateDebut = sprintf('%s %s', $date, $heure);

        $requete->bindParam(':idRessource', $idRessource, PDO::PARAM_INT);
        $requete->bindParam(':dateDebut', $dateDebut, PDO::PARAM_STR, 20);
        $requete->bindParam(':acronyme', $acronyme, PDO::PARAM_STR, 7);

        $resultat = $requete->execute();

        $nb = $requete->rowCount();

        Application::deconnexionPDO($connexion);

        if ($nb > 0)
            return $acronyme;
            else return Null;
    }

    /**
     * réserve la ressource $idRessource à la date $date et l'heure $heure
     * pour l'utilisateur $acronyme
     *
     * @param int $idRessource
     * @param string $date
     * @param string $heure
     * @param string $acronyme
     *
     * @return string : l'acronyme de l'utilisateur si réussi
     */
    public function reserveAllRessource4date($idRessource, $date, $acronyme){
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        // recherche des heures de réservation déjà affectées
        $sql = 'SELECT dateDebut ';
        $sql .= 'FROM '.PFX.'reservationsUser WHERE dateDebut LIKE :date ';
        $sql .= 'AND idRessource = :idRessource ';
        $sql .= 'ORDER BY dateDebut ';

        $requete = $connexion->prepare($sql);

        $dateGnagna = $date.'%';
        $requete->bindParam(':date', $dateGnagna, PDO::PARAM_STR, 20);
        $requete->bindParam(':idRessource', $idRessource, PDO::PARAM_INT);

        $listeReservations = array();
        $resultat = $requete->execute();

        if ($resultat){
            $requete->setFetchMode(PDO::FETCH_ASSOC);
            while ($ligne = $requete->fetch()){
                $dateDebut = $ligne['dateDebut'];
                $listeReservations[] = $dateDebut;
            }
        }

        $listePeriodes = $this->getPeriodesCours();
        $listeDatesDebut = array();
        foreach ($listePeriodes as $periode => $data){
            $listeDatesDebut[] = sprintf('%s %s:00', $date, $data['debut']);
        }

        // on enlève les dates déjà réservées de la liste de toutes les périodes possibles
        $listeDates = array_diff($listeDatesDebut, $listeReservations);

        // enregistrement pour les dates restantes
        $sql = 'INSERT INTO '.PFX.'reservationsUser ';
        $sql .= 'SET idRessource = :idRessource, dateDebut = :dateDebut, user = :acronyme ';

        $requete = $connexion->prepare($sql);

        $requete->bindParam(':idRessource', $idRessource, PDO::PARAM_INT);
        $requete->bindParam(':acronyme', $acronyme, PDO::PARAM_STR, 7);

        $listeModifs = array();
        foreach ($listeDates as $periode => $dateDebut) {
            $requete->bindParam(':dateDebut', $dateDebut, PDO::PARAM_STR, 20);
            $resultat = $requete->execute();
            $nb = $requete->rowCount();
            if ($nb == 1) {
                $heure = $listePeriodes[$periode]['debut'];
                $listeModifs[] = $heure;
            }
        }

        Application::deconnexionPDO($connexion);

        return $listeModifs;
    }

    /**
     * réserve toutes les ressources de la $listeRessources à la période $heure pour l'utilisateur $acronyme
     * pour chacun des jours le la $listeJours
     *
     * @param array $listeRessources
     * @param array $listeDatesDebut
     * @param string $heure
     * @param string $acronyme
     *
     * @return array
     */
    public function reserveAllRessource4periode($listeRessources, $listeDatesDebut, $heure, $acronyme){
        // recherche des heures de réservation déjà affectées
        $listeDatesDebutString = '"'.implode('","', $listeDatesDebut).'"';
        $listeRessourcesString = implode(',', $listeRessources);
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT dateDebut ';
        $sql .= 'FROM '.PFX.'reservationsUser ';
        $sql .= 'WHERE idRessource = :idRessource AND dateDebut IN ('.$listeDatesDebutString.') ';
        $requete = $connexion->prepare($sql);
    // Application::afficher($sql);
    // Application::afficher(array($listeRessources, $listeDatesDebut, $heure, $acronyme), true);
        $listeReserved = array();
        foreach ($listeRessources as $wtf => $idRessource) {
            $requete->bindParam(':idRessource', $idRessource, PDO::PARAM_INT);
            $resultat = $requete->execute();
            if ($resultat){
                $requete->setFetchMode(PDO::FETCH_ASSOC);
                while ($ligne = $requete->fetch()){
                    $listeReserved[$idRessource][] = $ligne['dateDebut'];
                }
            }
        }

        // on ne retient que les dates encore disponibles
        $listeJours = array();
        foreach ($listeRessources as $wtf => $idRessource) {
            $listeJ = $listeDatesDebut;
            if (isset($listeReserved[$idRessource]))
                $listeJours[$idRessource] = array_diff($listeJ, $listeReserved[$idRessource]);
                else $listeJours[$idRessource] = $listeJ;
        }

        $sql = 'INSERT INTO '.PFX.'reservationsUser ';
        $sql .= 'SET idRessource = :idRessource, dateDebut = :dateDebut, user = :acronyme ';
        $requete = $connexion->prepare($sql);

        $requete->bindParam(':acronyme', $acronyme, PDO::PARAM_STR, 7);
        $listeModifs = array();
        foreach ($listeJours as $idRessource => $listeDates){
            $requete->bindParam(':idRessource', $idRessource, PDO::PARAM_INT);
            foreach ($listeDates as $periode => $dateDebut){
                $requete->bindParam(':dateDebut', $dateDebut, PDO::PARAM_STR, 20);
                $resultat = $requete->execute();
                $nb = $requete->rowCount();
                if ($nb == 1) {
                    $heure = $listeJours[$idRessource][$periode];
                    $listeModifs[$idRessource][] = $heure;
                }
            }
        }

        Application::afficher($listeModifs, true);
    }

    /**
     * renvoie la liste des réservations passées et futures de la ressource $idRessource
     *
     * @param int $idRessource
     *
     * @return array
     */
    public function getListeReservations4ressource($idRessource){
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT idReservation, idRessource, user, dateDebut, NOW() AS now ';
        $sql .= 'FROM '.PFX.'reservationsUser ';
        $sql .= 'WHERE idRessource = :idRessource ';
        $sql .= 'ORDER BY dateDebut ';
        $requete = $connexion->prepare($sql);

        $requete->bindParam(':idRessource', $idRessource, PDO::PARAM_INT);

        $liste = array('avant' => array(), 'apres' => array());
        $avant = 0; $apres = 0;
        $liste = array();
        $resultat = $requete->execute();
        if ($resultat){
            $requete->setFetchMode(PDO::FETCH_ASSOC);
            while ($ligne = $requete->fetch()){
                $idReservation = $ligne['idReservation'];
                if ($ligne['dateDebut'] < $ligne['now']){
                    $liste['avant'][$idReservation] = $ligne;
                    $avant++;
                    }
                    else {
                        $liste['apres'][$idReservation] = $ligne;
                        $apres++;
                        }
            }
        }

        $liste['count'] = array('avant' => $avant, 'apres' => $apres);

        Application::deconnexionPDO($connexion);

        return $liste;
    }

    /**
     * recherche le nom complet d'un utilisateur prof ou élève sur base de
     * son matricule ou de son acronyme
     *
     * @param string $user
     *
     * @return string
     */
    public function getUserName($user){
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT nom, prenom, groupe ';
        $sql .= 'FROM '.PFX.'eleves AS el ';
        $sql .= 'WHERE matricule = :user ';
        $requete = $connexion->prepare($sql);

        $requete->bindParam(':user', $user, PDO::PARAM_STR, 7);

        $nom = Null;
        $resultat = $requete->execute();
        if ($resultat){
            $ligne = $requete->fetch();
            $nom = sprintf('%s %s %s', $ligne['nom'], $ligne['prenom'], $ligne['groupe']);
        }

        if ($nom == Null) {
            $sql = 'SELECT nom, prenom ';
            $sql .= 'FROM '.PFX.'profs ';
            $sql .= 'WHERE acronyme = :user ';
            $requete = $connexion->prepare($sql);

            $requete->bindParam(':user', $user, PDO::PARAM_STR, 7);

            $resultat = $requete->execute();
            if ($resultat){
                $requete->setFetchMode(PDO::FETCH_ASSOC);
                while ($ligne = $requete->fetch()) {
                    $nom = sprintf('%s %s', $ligne['nom'], $ligne['prenom']);
                    }

            }
        }

        Application::deconnexionPDO($connexion);

        return $nom;
    }

    /**
	 * recherche les réservation de la ressource $idRessource entre les dates $start et $end
	 *
	 * @param string $start : date de début d'Absences
	 * @param string $end : date de fin d'absences
	 * @param string $idRessource: identifiant de la ressource
	 *
	 * @return array
	 */
	public function getCalendar4ressource($start, $end, $idRessource){
		$connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
		$sql = 'SELECT user.idRessource, idReservation, user, dateDebut, description, reference, ';
        $sql .= 'CONCAT(profs.nom, " ", profs.prenom) AS nomProf, ';
        $sql .= 'CONCAT(eleves.nom, " ", eleves.prenom, " ", eleves.groupe) AS nomEleve ';
		$sql .= 'FROM '.PFX.'reservationsUser AS user ';
        $sql .= 'JOIN '.PFX.'reservations AS res ON res.idRessource = user.idRessource ';
        $sql .= 'LEFT JOIN didac_profs AS profs ON profs.acronyme = user.user ';
        $sql .= 'LEFT JOIN didac_eleves AS eleves ON eleves.matricule = user.user ';
        $sql .= 'WHERE user.idRessource = :idRessource ';
		$sql .= 'AND dateDebut BETWEEN :start AND :end ';
		$sql .= 'ORDER BY dateDebut ';
		$requete = $connexion->prepare($sql);
// echo $sql;
		$requete->bindParam(':idRessource', $idRessource, PDO::PARAM_INT);
		$requete->bindParam(':start', $start, PDO::PARAM_STR, 10);
		$requete->bindParam(':end', $end, PDO::PARAM_STR, 10);
// Application::afficher(array($idRessource, $start, $end), true);
		$liste = array();
		$resultat = $requete->execute();
		if ($resultat) {
			$requete->setFetchMode(PDO::FETCH_ASSOC);
			while ($ligne = $requete->fetch()){
				$start = explode(' ', $ligne['dateDebut']);
				$heure = SUBSTR($start[1], 0, 5);
                $nom = ($ligne['nomProf'] != '') ? $ligne['nomProf'] : $ligne['nomEleve'];
				$liste[] = array(
                    'reservation' => $ligne['user'],
					'title' => sprintf('%s %s', $nom, $heure),
					'start' => $ligne['dateDebut']
					);
			}
		}

		Application::deconnexionPDO($connexion);

		return $liste;
	}

}
