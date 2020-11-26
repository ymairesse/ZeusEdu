<?php

class Jdc
{
    /**
     * constructeur de l'objet jdc.
     */
    public function __construct()
    {
    }

    public function getConges($dateFrom, $dateTo, $acronyme){
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT id, destinataire, idCategorie, type, proprietaire, title, enonce, class, allDay, startDate, endDate ';
    	$sql .= 'FROM '.PFX.'thotJdc ';
    	$sql .= 'WHERE startDate BETWEEN :dateFrom AND :dateTo ';
    	$sql .= 'AND destinataire ="ecole" ';

        $requete = $connexion->prepare($sql);

        $requete->bindParam(':dateFrom', $dateFrom, PDO::PARAM_STR, 15);
        $requete->bindParam(':dateTo', $dateTo, PDO::PARAM_STR, 15);

        $resultat = $requete->execute();
        $liste = array();
        if ($resultat) {
            $requete->setFetchMode(PDO::FETCH_ASSOC);
            while ($ligne = $requete->fetch()) {
                $type = $ligne['type'];
                $destinataire = $ligne['destinataire'];
                $destin = $this->getRealDestinataire($connexion, $acronyme, $type, $destinataire);
                $liste[] = array(
        			'id' => $ligne['id'],
        			'title' => $ligne['title'],
        			'enonce' => mb_strimwidth (strip_tags($ligne['enonce'], '<br><p><a>'), 0 , 400, '... [suite]'),
                    'destinataire' => $destin,
        			'className'=>'cat_'.$ligne['idCategorie'],
        			'start'=> $ligne['startDate'],
        			'end' => $ligne['endDate'],
        			'allDay' => ($ligne['allDay']!=0),
                    'type' => $ligne['type'],
        			'editable' => ($ligne['proprietaire'] == $acronyme)
        			);
            }
        }
        Application::DeconnexionPDO($connexion);

        return $liste;
    }

    /**
     * renvoie la liste d'événements entres deux dates start et end pour une liste de cours donnée
     *
     * @param string $dateFrom : date de début
     * @param string $dateTo   : date de fin
     * @param string $listeCoursGrpString : les noms des cours séparés par des virgules et entourés de guillemets
     *
     * @return array
     */
    public function getEvents4Cours($dateFrom, $dateTo, $listeCoursGrp, $acronyme=Null)
    {
        if (is_array($listeCoursGrp)) {
            $listeCoursGrpString = "'".implode("','", array_keys($listeCoursGrp))."'";
        } else {
            $listeCoursGrpString = "'".$listeCoursGrp."'";
        }
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT id, destinataire, idCategorie, type, proprietaire, title, enonce, class, allDay, startDate, endDate ';
    	$sql .= 'FROM '.PFX.'thotJdc ';
    	$sql .= 'WHERE startDate BETWEEN :dateFrom AND :dateTo ';
        if ($acronyme != Null)
            $sql .= 'AND proprietaire = :acronyme ';
    	$sql .= 'AND destinataire IN ('.$listeCoursGrpString.') ';

        $requete = $connexion->prepare($sql);

        $requete->bindParam(':dateFrom', $dateFrom, PDO::PARAM_STR, 15);
        $requete->bindParam(':dateTo', $dateTo, PDO::PARAM_STR, 15);
        if ($acronyme != Null)
            $requete->bindParam(':acronyme', $acronyme, PDO::PARAM_STR, 7);

        $resultat = $requete->execute();
        $liste = array();
        if ($resultat) {
            $requete->setFetchMode(PDO::FETCH_ASSOC);
            while ($ligne = $requete->fetch()) {
                $type = $ligne['type'];
                $destinataire = $ligne['destinataire'];
                $destin = $this->getRealDestinataire($connexion, $acronyme, $type, $destinataire);
                $liste[] = array(
        			'id' => $ligne['id'],
        			'title' => $ligne['title'],
        			'enonce' => mb_strimwidth (strip_tags($ligne['enonce'], '<br><p><a>'), 0 , 400, '... [suite]'),
                    'destinataire' => $destin,
        			'className'=>'cat_'.$ligne['idCategorie'],
        			'start'=> $ligne['startDate'],
        			'end' => $ligne['endDate'],
        			'allDay' => ($ligne['allDay']!=0),
                    'type' => $ligne['type'],
        			'editable' => ($ligne['proprietaire'] == $acronyme)
        			);
            }
        }
        Application::DeconnexionPDO($connexion);

        return $liste;
    }

    /**
     * renvoie la liste d'événements entres deux dates start et end pour un élève donné
     * y compris son tmatricule, son niveau d'étude, sa classe et sa liste de cours
     *
     * @param int $from : date de début = timestamp Unix en millisecondes
     * @param int $to   : date de fin = timestamp Unix en millisecondes
     *
     * @return string liste json
     */
    public function retreiveEvents4Eleve($start, $end, $niveau, $classe, $matricule, $listeCoursString)
    {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT id, destinataire, idCategorie, type, proprietaire, redacteur, title, enonce, class, allDay, startDate, endDate ';
        $sql .= 'FROM '.PFX.'thotJdc ';
        $sql .= 'WHERE startDate BETWEEN :start AND :end ';
        $sql .= 'AND destinataire in ('.$listeCoursString.') OR destinataire = :classe ';
        $sql .= 'OR destinataire = :matricule OR destinataire = "all" OR destinataire = :niveau ';
        $requete = $connexion->prepare($sql);

        $requete->bindParam(':classe', $classe, PDO::PARAM_STR, 6);
        $requete->bindParam(':matricule', $matricule, PDO::PARAM_INT);
        $requete->bindParam(':niveau', $niveau, PDO::PARAM_INT);
        $requete->bindParam(':start', $start, PDO::PARAM_STR, 20);
        $requete->bindParam(':end', $end, PDO::PARAM_STR, 20);

        $resultat = $requete->execute();
        $liste = array();
        if ($resultat) {
            $requete->setFetchMode(PDO::FETCH_ASSOC);
            while ($ligne = $requete->fetch()) {
                $liste[] = array(
                    'id' => $ligne['id'],
                    'title' => $ligne['title'],
                    'enonce' => mb_strimwidth(strip_tags(html_entity_decode($ligne['enonce'])), 0, 200,'...'),
                    'className' => 'cat_'.$ligne['idCategorie'],
                    'start' => $ligne['startDate'],
                    'end' => $ligne['endDate'],
                    'allDay' => ($ligne['allDay'] != 0)
                    );
            }
        }
        Application::DeconnexionPDO($connexion);

        return $liste;
    }

      /**
     * retrouve la liste des remédiations entre deux dates destinées à un élève dont on fournit le matricule
     *
     * @param $start date de début
     * @param $end date de fin
     * @param int $matricule
     *
     * @return array
     */
    public function retreiveRemediations ($start, $end, $matricule) {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT eleves.idOffre, eleves.matricule, acronyme, title, contenu AS enonce, startDate, endDate, CONCAT(prenom," ", nom) AS destinataire, ';
        $sql .= 'nom, prenom ';
        $sql .= 'FROM '.PFX.'remediationEleves AS eleves ';
        $sql .= 'JOIN '.PFX.'remediationOffre AS offres ON offres.idOffre = eleves.idOffre ';
        $sql .= 'JOIN '.PFX.'eleves AS de ON de.matricule = eleves.matricule ';
        $sql .= 'WHERE startDate BETWEEN :start AND :end ';
        $sql .= 'AND eleves.matricule = :matricule ';
        $requete = $connexion->prepare($sql);

        $requete->bindParam(':start', $start, PDO::PARAM_STR, 20);
        $requete->bindParam(':end', $end, PDO::PARAM_STR, 20);
        $requete->bindParam(':matricule', $matricule, PDO::PARAM_INT);

        $liste = array();
        $resultat = $requete->execute();
        if ($resultat){
            $requete->setFetchMode(PDO::FETCH_ASSOC);
            while ($ligne = $requete->fetch()){
                $liste[] = array(
                    'id' => 'Rem_'.$ligne['idOffre'],
                    'title' => '[Remédiation] '.$ligne['title'],
                    'enonce' => mb_strimwidth(strip_tags(html_entity_decode($ligne['enonce'])), 0, 200,'...'),
                    'className' => 'remediation',
                    'start' => $ligne['startDate'],
                    'end' => $ligne['endDate'],
                    'allDay' => 0,
                    'destinataire' => '',
                    'cours' => '',
                    );
            }
        }
        Application::DeconnexionPDO($connexion);

        return $liste;
    }

    /**
     * retrouve la liste des événements liés à du soutien scolaire (coaching)
     * @param  string $start : date de début
     * @param  string $end : date de fin
     * @param  int $matricule : matricule de l'élève
     * @return array            liste des évenements
     */
    public function retreiveCoaching($start, $end, $matricule) {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT id, matricule, proprietaire, dp.nom, dp.prenom, dp.sexe, dp.mail, ';
        $sql .= 'date, heure, duree, jdc ';
        $sql .= 'FROM '.PFX.'athena AS da ';
        $sql .= 'LEFT JOIN '.PFX.'profs AS dp ON dp.acronyme = da.proprietaire ';
        $sql .= 'WHERE matricule = :matricule AND jdc = 1 ';
        $sql .= 'AND date BETWEEN :start AND :end ';
        $requete = $connexion->prepare($sql);

        $requete->bindParam(':start', $start, PDO::PARAM_STR, 20);
        $requete->bindParam(':end', $end, PDO::PARAM_STR, 20);
        $requete->bindParam(':matricule', $matricule, PDO::PARAM_INT);

        $liste = array();
        $resultat = $requete->execute();
        if ($resultat) {
            $requete->setFetchMode(PDO::FETCH_ASSOC);
            while ($ligne = $requete->fetch()){
                $sexe = $ligne['sexe'];
                $initiale = substr($ligne['prenom'], 0, 1);
                $formule = ($sexe == 'M') ? 'Monsieur' : 'Madame';
                $nomCoach = sprintf('%s %s. %s', $formule, $initiale, $ligne['nom']);
                $startDate = sprintf('%s %s', $ligne['date'], $ligne['heure']);
                $endTime = new DateTime($ligne['date']);
                $endTime->add(new DateInterval('PT'.$ligne['duree'].'M'));
                $endDate = $endTime->format('Y-m-d H:i');
                $liste[] = array (
                    'id' => 'Coach_'.$ligne['id'],
                    'title' => 'Soutien scolaire',
                    'enonce' => 'RV avec '.$nomCoach,
                    'className' => 'coaching',
                    'start' => $startDate,
                    'end' => $endDate,
                    'allDay' => 0,
                    'destinataire' => '',
                    'type' => 'coaching',
                );
            }
        }

        Application::DeconnexionPDO($connexion);

        return $liste;
    }

    /**
     * recherche le label précis comme cible du JDC
     *
     * @param string $type : type de destinataire (ecole, niveau, cours, classe, eleve)
     * @param string $cible : matricule, sigle du cours, niveau d'étude,...
     * @param string $acronyme : le propriétaire
     *
     * @return string $destinataire
     */
    // public function getActualTarget($type, $cible, $acronyme){
    //     $destinataire = '';
    //     switch ($type) {
    //         case 'ecole':
    //             $destinataire = 'Tous les élèves';
    //             break;
    //         case 'niveau':
    //             $destinataire = sprintf('Élèves de %s année', $destinataire);
    //             break;
    //         case 'classe':
    //             $destinataire = sprintf('Élèves de la classe %s', $destinataire);
    //             break;
    //         case 'coursGrp':
    //             $sql = 'SELECT nomCours FROM '.PFX.'profsCours ';
    //             $sql .= 'WHERE acronyme = :acronyme AND coursGrp = :destinataire ';
    //             $requete = $connexion->prepare($sql);
    //             $requete->bindParam(':acronyme', $acronyme, PDO::PARAM_STR, 7);
    //             $requete->bindParam(':destinataire', $cible, PDO::PARAM_STR, 15);
    //             $resultat = $requete->execute();
    //             $nomCours = '';
    //             if ($resultat) {
    //                 $ligne = $requete->fetch();
    //                 $nomCours = $ligne['nomCours'];
    //             }
    //             $destinataire = sprintf('%s [%s]', $nomCours, $cible);
    //             break;
    //         case 'eleve':
    //             $sql = 'SELECT nom, prenom, groupe FROM '.PFX.'eleves ';
    //             $sql .= 'WHERE matricule = :matricule ';
    //             $requete = $connexion->prepare($sql);
    //             $requete->bindParam(':matricule', $cible, PDO::PARAM_INT);
    //             $resultat = $requete->execute();
    //             $destinataire = '';
    //             if ($resultat) {
    //                 $ligne = $requete->fetch();
    //                 $destinataire = sprintf('%s %s [%s]', $ligne['prenom'], $ligne['nom'], $ligne['groupe']);
    //             }
    //             break;
    //     }
    //
    //     return $destinataire;
    // }

    public function getRealDestinataire($connexion=Null, $acronyme, $type, $destinataire){
        if ($connexion == Null) {
            $signal = 1;
            $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        }
        $cible = '';
        switch ($type) {
            case 'ecole':
                $cible = 'Tous les élèves';
                break;
            case 'niveau':
                $cible = sprintf('Tous les élèves de %se année', $destinataire);
                break;
            case 'classe':
                $cible = sprintf('Tous les élèves de la classe %s', $destinataire);
                break;
            case 'coursGrp':
                $sql = 'SELECT nomCours FROM '.PFX.'profsCours ';
                $sql .= 'WHERE coursGrp = :destinataire AND acronyme = :acronyme ';
                $requete = $connexion->prepare($sql);
                $requete->bindParam(':acronyme', $acronyme, PDO::PARAM_STR, 7);
                $requete->bindParam(':destinataire', $destinataire, PDO::PARAM_STR, 20);

                $resultat = $requete->execute();
                if ($resultat){
                    $ligne = $requete->fetch();
                    $cible = sprintf('%s [%s]', $ligne['nomCours'], $destinataire);
                }
                break;
            case 'cours':
                $sql = 'SELECT libelle, nbheures FROM '.PFX.'cours ';
                $sql .= 'WHERE cours = :destinataire ';
                $requete = $connexion->prepare($sql);
                $requete->bindParam(':destinataire', $destinataire, PDO::PARAM_STR, 17);
                $resultat = $requete->execute();
                if ($resultat){
                    $ligne = $requete->fetch();
                    $libelle = $ligne['libelle'];
                    $nbheures = $ligne['nbheures'];
                    $cible = sprintf('%s %sh [%s]', $libelle, $nbheures, $destinataire);
                }
                break;
            case 'eleve':
                $sql = 'SELECT nom, prenom, groupe FROM '.PFX.'eleves ';
                $sql .= 'WHERE matricule = :matricule ';
                $requete = $connexion->prepare($sql);
                $requete->bindParam(':matricule', $destinataire, PDO::PARAM_INT);
                $resultat = $requete->execute();
                if ($resultat){
                    $ligne = $requete->fetch();
                    $cible = sprintf('%s %s [%s]', $ligne['prenom'], $ligne['nom'], $ligne['groupe']);
                }
                break;
        }

        if (isset($signal))
            Application::DeconnexionPDO($connexion);

        return $cible;
    }

    /**
     * retourne la liste des notes pour les cours au JDC netre deux dates pour l'utilisateur $acronyme
     *
     * @param string $start : date de début
     * @param string $end : date de fin
     * @param string $acronyme
     *
     * @return array
     */
    public function getSynoptiqueCours($start, $end, $acronyme){
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT  * FROM '.PFX.'thotJdc AS jdc ';
        $sql .= 'WHERE proprietaire = :acronyme ';
        $sql .= 'AND destinataire IN (SELECT DISTINCT coursGrp FROM '.PFX.'profsCours WHERE acronyme = :acronyme) ';
        $sql .= 'AND startDate BETWEEN :start AND :end ';
        $requete = $connexion->prepare($sql);

        $requete->bindParam(':start', $start, PDO::PARAM_STR, 20);
        $requete->bindParam(':end', $end, PDO::PARAM_STR, 20);
        $requete->bindParam(':acronyme', $acronyme, PDO::PARAM_STR, 7);

        $liste = array();
        $resultat = $requete->execute();

        if ($resultat) {
            while ($ligne = $requete->fetch()) {
                $type = $ligne['type'];
                $destinataire = $ligne['destinataire'];
                $destin = $this->getRealDestinataire($connexion, $acronyme, $type, $destinataire);
                $liste[] = array(
                    'id' => $ligne['id'],
                    'title' => $ligne['title'],
                    'enonce' => mb_strimwidth(strip_tags($ligne['enonce'], '<br><p><a>'), 0 , 400, '... [suite]'),
                    'destinataire' => $destin,
                    'className' => 'cat_'.$ligne['idCategorie'],
                    'start' => $ligne['startDate'],
                    'end' => $ligne['endDate'],
                    'allDay' => ($ligne['allDay']!=0),
                    'type' => $ligne['type'],
                    'editable' => ($ligne['proprietaire'] == $acronyme),
                    );
            }
        }

        Application::DeconnexionPDO($connexion);

        return $liste;
    }

    /**
     * recherche de tous les événements non liés à des cours (école, niveau, matiere, groupe, classe)
     * pour l'utilisateur $acronyme entre les dates $start et $end
     *
     * @param string $start
     * @param string $end
     * @param string $acronyme
     *
     * @return array
     */
    public function getEventsNotCours($start, $end, $acronyme){
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT  * FROM '.PFX.'thotJdc AS jdc ';
        $sql .= 'WHERE proprietaire = :acronyme ';
        $sql .= 'AND type != "coursGrp" ';
        $sql .= 'AND startDate BETWEEN :start AND :end ';
        $requete = $connexion->prepare($sql);

        $requete->bindParam(':start', $start, PDO::PARAM_STR, 20);
        $requete->bindParam(':end', $end, PDO::PARAM_STR, 20);
        $requete->bindParam(':acronyme', $acronyme, PDO::PARAM_STR, 7);

        $liste = array();
        $resultat = $requete->execute();

        if ($resultat) {
            while ($ligne = $requete->fetch()) {
                $type = $ligne['type'];
                $destinataire = $ligne['destinataire'];
                $destin = $this->getRealDestinataire($connexion, $acronyme, $type, $destinataire);
                $liste[] = array(
                    'id' => $ligne['id'],
                    'title' => $ligne['title'],
                    'enonce' => mb_strimwidth(strip_tags($ligne['enonce'], '<br><p><a>'), 0 , 400, '... [suite]'),
                    'destinataire' => $destin,
                    'className' => 'cat_'.$ligne['idCategorie'],
                    'start' => $ligne['startDate'],
                    'end' => $ligne['endDate'],
                    'allDay' => ($ligne['allDay']!=0),
                    'type' => $ligne['type'],
                    'editable' => ($ligne['proprietaire'] == $acronyme),
                    );
            }
        }

        Application::DeconnexionPDO($connexion);

        return $liste;
    }

    /**
     * retourne la liste des JDC entre deux dates $start et $end pour l'utilisateur $acronyme
     *
     * @param string $type : niveau de l'annonce (ecole, niveau, classe, eleve)
     * @param string $destinataire : pour qui dans ce niveau ('all' si 'ecole')
     * @param string $start : date de début de l'intervalle
     * @param string $end : date de fin de l'intervalle
     * @param string $acronyme : Null si on veut tous les événements pour le niveau d'organisation
     *
     * @return array
     */
    public function getMyGlobalEvents($type, $destinataire, $start, $end, $acronyme=Null) {
        $acronyme = isset($post['acronyme']) ? $post['acronyme'] : Null;

        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT id, proprietaire, idCategorie, type, destinataire, title, enonce, ';
        $sql .= 'allDay, startDate, endDate, DATE_FORMAT(NOW(),"%Y-%m-%d") AS ajd ';
        $sql .= 'FROM '.PFX.'thotJdc ';
        $sql .= 'WHERE startDate BETWEEN :start AND :end ';
        $sql .= 'AND type = :type AND destinataire = :destinataire ';
        if ($acronyme != Null)
            $sql .= 'AND proprietaire = :acronyme ';

        $requete = $connexion->prepare($sql);

        $requete->bindParam(':start', $start, PDO::PARAM_STR, 20);
        $requete->bindParam(':end', $end, PDO::PARAM_STR, 20);
        $requete->bindParam(':destinataire', $destinataire, PDO::PARAM_STR, 20);
        $requete->bindParam(':type', $type, PDO::PARAM_STR, 10);

        if ($acronyme != Null)
            $requete->bindParam(':acronyme', $acronyme, PDO::PARAM_STR, 7);

        $liste = array();
        $resultat = $requete->execute();
        if ($resultat) {
            $requete->setFetchMode(PDO::FETCH_ASSOC);
            while ($ligne = $requete->fetch()) {
                $type = $ligne['type'];
                $destinataire = $ligne['destinataire'];
                $lblDestinataire = $this->getRealDestinataire($connexion, $acronyme, $type, $destinataire);
                $liste[] = array(
                    'id' => $ligne['id'],
                    'title' => $ligne['title'],
                    'enonce' => mb_strimwidth(strip_tags($ligne['enonce'], '<br><p><a>'), 0 , 400, '... [suite]'),
                    'type' => $ligne['type'],
                    'destinataire' => $destinataire,
                    'lblDestinataire' => $lblDestinataire,
                    'className' => 'cat_'.$ligne['idCategorie'],
                    'start' => $ligne['startDate'],
                    'end' => $ligne['endDate'],
                    'allDay' => ($ligne['allDay']!=0),
                    'editable' => ($ligne['proprietaire'] == $acronyme),
                    );
            }
        }

        Application::DeconnexionPDO($connexion);

        return $liste;
    }

    /**
     * renvoie la liste des événements entre deux dates start et end pour un niveau d'étude $niveaudonné
     *
     * @param string $dateFrom : date de début
     * @param string $dateTo   : date de fin
     * @param int $niveau : niveau d'étude
     * @param string $acronyme : identifiant du propriétaire (sécurité)
     *
     * @return array
     */
     public function getEvents4Niveau($dateFrom, $dateTo, $niveau, $acronyme = Null){
         $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
         $sql = 'SELECT id, destinataire, idCategorie, type, proprietaire, title, enonce, class, allDay, startDate, endDate, allDay ';
         $sql .= 'FROM '.PFX.'thotJdc ';
         $sql .= 'WHERE startDate BETWEEN :dateFrom AND :dateTo ';
         if ($acronyme != Null)
            $sql .= 'AND acronyme = :acronyme ';
         $sql .= 'AND destinataire LIKE :niveau ';
         $requete = $connexion->prepare($sql);

         $requete->bindParam(':dateFrom', $dateFrom, PDO::PARAM_STR, 15);
         $requete->bindParam(':dateTo', $dateTo, PDO::PARAM_STR, 15);
         $requete->bindParam(':niveau', $niveau, PDO::PARAM_INT);
         if ($acronyme != Null)
            $requete->bindParam(':acronyme', $acronyme, PDO::PARAM_STR, 7);

         $resultat = $requete->execute();
         $liste = array();
         if ($resultat) {
             $requete->setFetchMode(PDO::FETCH_ASSOC);
             while ($ligne = $requete->fetch()) {
                 $type = $ligne['type'];
                 $destinataire = $ligne['destinataire'];
                 $destin = $this->getRealDestinataire($connexion, $acronyme, $type, $destinataire);
                 $liste[] = array(
                     'id' => $ligne['id'],
                     'title' => $ligne['title'],
                     'enonce' => mb_strimwidth (strip_tags($ligne['enonce'], '<br><p><a>'), 0 , 400, '... [suite]'),
                     'destinataire' => $destin,
                     'className' => 'cat_'.$ligne['idCategorie'],
                     'start' => $ligne['startDate'],
                     'end' => $ligne['endDate'],
                     'allDay' => ($ligne['allDay']!=0),
                     'editable' => ($ligne['proprietaire'] == $acronyme)
                     );
             }
         }
         Application::DeconnexionPDO($connexion);

         return $liste;
     }

     /**
      * renvoie la liste des événements entre deux dates start et end pour un niveau d'étude $niveaudonné
      *
      * @param string $dateFrom : date de début
      * @param string $dateTo   : date de fin
      * @param int $niveau : niveau d'étude
      * @param string $acronyme : identifiant du propriétaire (sécurité)
      *
      * @return array
      */
      public function getEvents4Ecole($dateFrom, $dateTo, $acronyme = Null){
          $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
          $sql = 'SELECT id, destinataire, idCategorie, type, proprietaire, title, enonce, class, allDay, startDate, endDate, allDay ';
          $sql .= 'FROM '.PFX.'thotJdc ';
          $sql .= 'WHERE startDate BETWEEN :dateFrom AND :dateTo ';
          if ($acronyme != Null)
            $sql .= 'AND proprietaire = :acronyme ';
          $sql .= "AND destinataire = 'all' ";
          $requete = $connexion->prepare($sql);

          $requete->bindParam(':dateFrom', $dateFrom, PDO::PARAM_STR, 15);
          $requete->bindParam(':dateTo', $dateTo, PDO::PARAM_STR, 15);
          if ($acronyme != Null)
             $requete->bindParam(':acronyme', $acronyme, PDO::PARAM_STR, 7);

          $resultat = $requete->execute();
          $liste = array();
          if ($resultat) {
              $requete->setFetchMode(PDO::FETCH_ASSOC);
              while ($ligne = $requete->fetch()) {
                  $type = $ligne['type'];
                  $destinataire = $ligne['destinataire'];
                  $destin = $this->getRealDestinataire($connexion, $acronyme, $type, $destinataire);
                  $liste[] = array(
                      'id'=>$ligne['id'],
                      'title'=>$ligne['title'],
                      'enonce'=>$ligne['enonce'],
                      'destinataire' => $destin,
                      'className'=>'cat_'.$ligne['idCategorie'],
                      'start'=> $ligne['startDate'],
                      'end' => $ligne['endDate'],
                      'allDay' => ($ligne['allDay']!=0),
                      'editable' => ($ligne['proprietaire'] == $acronyme)
                      );
              }
          }
          Application::DeconnexionPDO($connexion);

          return $liste;
      }

    /**
     * renvoie la liste des événements entre deux dates start et end pour un élève de $matricule donné
     *
     * @param string $dateFrom : date de début
     * @param string $dateTo   : date de fin
     * @param int $matricule : matricule de l'élève
     * @param string $acronyme : identifiant du propriétaire (sécurité)
     *
     * @return array
     */
    public function getEvents4Eleve($dateFrom, $dateTo, $matricule, $acronyme = Null)
    {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT id, destinataire, idCategorie, type, proprietaire, title, enonce, class, allDay, startDate, endDate, allDay ';
        $sql .= 'FROM '.PFX.'thotJdc ';
        $sql .= 'WHERE startDate BETWEEN :dateFrom AND :dateTo ';
        if ($acronyme != Null)
            $sql .= 'AND acronyme = :acronyme ';
        $sql .= 'AND destinataire = :matricule ';
        $requete = $connexion->prepare($sql);

        $requete->bindParam(':dateFrom', $dateFrom, PDO::PARAM_STR, 15);
        $requete->bindParam(':dateTo', $dateTo, PDO::PARAM_STR, 15);
        $requete->bindParam(':matricule', $matricule, PDO::PARAM_INT);
        if ($acronyme != Null)
           $requete->bindParam(':acronyme', $acronyme, PDO::PARAM_STR, 7);

        $resultat = $requete->execute();
        $liste = array();
        if ($resultat) {
            $requete->setFetchMode(PDO::FETCH_ASSOC);
            while ($ligne = $requete->fetch()) {
                $type = $ligne['type'];
                $destinataire = $ligne['destinataire'];
                $destin = $this->getRealDestinataire($connexion, $acronyme, $type, $destinataire);
                $liste[] = array(
                    'id'=>$ligne['id'],
                    'title'=>$ligne['title'],
                    'enonce'=>$ligne['enonce'],
                    'destinataire' => $destin,
                    'className'=>'cat_'.$ligne['idCategorie'],
                    'start'=> $ligne['startDate'],
                    'end' => $ligne['endDate'],
                    'allDay' => ($ligne['allDay']!=0),
                    'editable' => ($ligne['proprietaire'] == $acronyme)
                    );
            }
        }
        Application::DeconnexionPDO($connexion);

        return $liste;
    }

    /**
     * renvoie la liste d'événements entres deux dates start et end pour une classe donnée
     *
     * @param string $dateFrom : date de début
     * @param string $dateTo   : date de fin
     * @param string $classe : la classe concernée
     *
     * @return array
     */
    public function getEvents4Classe($dateFrom, $dateTo, $classe, $acronyme)
    {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);

        $sql = 'SELECT id, destinataire, idCategorie, type, proprietaire, title, enonce, class, allDay, startDate, endDate, allDay ';
    	$sql .= 'FROM '.PFX.'thotJdc ';
    	$sql .= 'WHERE startDate BETWEEN :dateFrom AND :dateTo ';
    	$sql .= 'AND destinataire= :classe ';
        $requete = $connexion->prepare($sql);

        $requete->bindParam(':dateFrom', $dateFrom, PDO::PARAM_STR, 15);
        $requete->bindParam(':dateTo', $dateTo, PDO::PARAM_STR, 15);
        $requete->bindParam(':classe', $classe, PDO::PARAM_STR, 5);

        $resulat = $requete->execute();
        $liste = array();
        if ($resulat) {
            $requete->setFetchMode(PDO::FETCH_ASSOC);
            while ($ligne = $requete->fetch()) {
                $type = $ligne['type'];
                $destinataire = $ligne['destinataire'];
                $destin = $this->getRealDestinataire($connexion, $acronyme, $type, $destinataire);
                $liste[] = array(
                    'id'=>$ligne['id'],
                    'title'=>$ligne['title'],
                    'enonce'=>$ligne['enonce'],
                    'destinataire' => $destin,
                    'className'=>'cat_'.$ligne['idCategorie'],
                    'start'=> $ligne['startDate'],
                    'end' => $ligne['endDate'],
                    'allDay' => ($ligne['allDay']!=0),
                    'editable' => ($ligne['proprietaire'] == $acronyme)
                    );
            }
        }
        Application::DeconnexionPDO($connexion);

        return $liste;
    }

    /**
     * retourne le niveau d'étude d'un élève dont on fournit le matricule
     *
     * @param int $matricule
     *
     * @return int : le niveau d'étude
     */
    public function getNiveauEleve ($matricule){
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT groupe FROM '.PFX.'eleves ';
        $sql .= 'WHERE matricule = :matricule ';
        $requete = $connexion->prepare($sql);

        $requete->bindParam(':matricule', $matricule, PDO::PARAM_INT);
        $niveau = Null;
        $resultat = $requete->execute();
        if ($resultat) {
            $requete->setFetchMode(PDO::FETCH_ASSOC);
            $ligne = $requete->fetch();
            $groupe = $ligne['groupe'];
            $niveau = substr($groupe, 0, 1);
        }

        Application::DeconnexionPDO($connexion);

        return $niveau;
    }

    /**
     * retourne la liste des cours effectivement suivis par chacun des élèves d'une classe.
     *
     * @param $classe string: la classe de ces élèves
     *
     * @return array
     */
    public function listeCoursClasse($groupe)
    {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = "SELECT coursGrp, SUBSTR(coursGrp,1, LOCATE('-',coursGrp)-1) as cours, ec.matricule ";
        $sql .= 'FROM '.PFX.'elevesCours AS ec ';
        $sql .= 'JOIN '.PFX.'eleves AS de ON (de.matricule = ec.matricule) ';
        $sql .= 'WHERE groupe = :groupe ';
        $sql .= 'ORDER BY matricule, cours ';
        $requete = $connexion->prepare($sql);

        $liste = array();
        $requete->bindParam(':groupe', $groupe, PDO::PARAM_STR, 5);
        $resultat = $requete->execute();
        if ($resultat) {
            $requete->setFetchMode(PDO::FETCH_ASSOC);
            while ($ligne = $requete->fetch()) {
                $coursGrp = $ligne['coursGrp'];
                $liste[$coursGrp] = $ligne;
            }
        }
        Application::DeconnexionPDO($connexion);

        return $liste;
    }

    /**
     * retourne la liste de tous les coursGrp d'un élève dont on fournit le matricule
     *
     * @param array|string $listeEleves liste des matricules des élèves
     *
     * @return array
     */
     public function listeCoursGrpEleves($listeEleves)
     {
         if (is_array($listeEleves)) {
             $listeElevesString = implode(',', array_keys($listeEleves));
         } else {
             $listeElevesString = $listeEleves;
         }
         $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
         $sql = 'SELECT coursGrp ';
         $sql .= 'FROM '.PFX.'elevesCours ';
         $sql .= "WHERE matricule IN ($listeElevesString) ";
         $requete = $connexion->prepare($sql);

         $requete->bindParam(':matricule', $matricule, PDO::PARAM_INT);
         $liste = array();
         $resultat = $requete->execute();
         if ($resultat) {
             $requete->setFetchMode(PDO::FETCH_ASSOC);
             while ($ligne = $requete->fetch()){
                 $coursGrp = $ligne['coursGrp'];
                 $liste[$coursGrp] = $coursGrp;
             }
         }
         Application::DeconnexionPDO($connexion);

         return $liste;
     }

    /**
     * retrouve une notification dont on fournit l'identifiant.
     *
     * @param int $id : l'identifiant dans la BD
     *
     * @return array
     */
    public function getTravail($id, $acronyme = Null)
    {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT jdc.id, destinataire, type, proprietaire, title, enonce, class, jdc.id, startDate, ';
        $sql .= 'TIME(startDate) AS heure, endDate, TIMEDIFF(endDate, startDate) AS duree, allDay, DATE_FORMAT(lastModif, "%d/%m/%Y %H:%i") AS lastModif, ';
        $sql .= 'jdc.idCategorie, categorie, sexe, nom, prenom, dpc.acronyme, libelle, nbheures, nomCours ';
        $sql .= 'FROM '.PFX.'thotJdc AS jdc ';
        $sql .= 'JOIN '.PFX.'thotJdcCategories AS cat ON cat.idCategorie = jdc.idCategorie ';
        $sql .= 'LEFT JOIN '.PFX.'profs AS dp ON dp.acronyme = jdc.proprietaire ';
        $sql .= 'LEFT JOIN '.PFX.'cours AS dc ON cours = SUBSTR(jdc.destinataire,1,LOCATE("-",jdc.destinataire)-1) ';
        $sql .= 'LEFT JOIN '.PFX.'profsCours AS dpc ON dpc.coursGrp = destinataire ';
        $sql .= 'WHERE jdc.id = :id ';

        if ($acronyme != Null)
            $sql .= 'AND proprietaire = :acronyme ';
        $requete = $connexion->prepare($sql);

        $requete->bindParam(':id', $id, PDO::PARAM_INT);
        if ($acronyme != Null)
            $requete->bindParam(':acronyme', $acronyme, PDO::PARAM_STR, 7);

        $travail = Null;
        $resultat = $requete->execute();
        if ($resultat) {
            $requete->setFetchMode(PDO::FETCH_ASSOC);
            $ligne = $requete->fetch();

            $adresse = ($ligne['sexe'] == 'F') ? 'Mme' : 'M.';
            if ($ligne['prenom'] != '') {
                $nom = sprintf('%s %s. %s', $adresse, mb_substr($ligne['prenom'], 0, 1, 'UTF-8'), $ligne['nom']);
                }
                else $nom = '';
                $ligne['profs'] = $nom;
                $ligne['startDate'] = Application::datePHP(explode(' ', $ligne['startDate'])[0]);
                $ligne['heure'] = date('H:i', strtotime($ligne['heure']));
                $ligne['duree'] = date('H:i', strtotime($ligne['duree']));
                if ($ligne['allDay'] == 0)
                    unset($ligne['allDay']);
                $travail = $ligne;
            }

        Application::DeconnexionPDO($connexion);

        return $travail;
    }

    /**
     * retrouve la remédiation dont on fournit l'identifiant
     *
     * @param int $id : identifiant de la remédiation
     *
     * @return array
     */
    public function getRemediation($id) {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT DATE_FORMAT(startDate, "%H:%i") AS heure, DATE_FORMAT(startDate,"%d/%m/%Y") AS startDate, ';
        $sql .= 'TIMEDIFF(endDate, startDate) AS duree, local, title, contenu AS enonce, ';
        $sql .= 'offre.acronyme AS proprietaire, nom, prenom, sexe, DATE_FORMAT(lastModif, "%d/%m/%Y %H:%i") AS lastModif ';
        $sql .= 'FROM '.PFX.'remediationOffre AS offre ';
        $sql .= 'JOIN '.PFX.'remediationEleves AS eleves ON eleves.idOffre = offre.idOffre ';
        $sql .= 'LEFT JOIN '.PFX.'profs AS profs ON profs.acronyme = offre.acronyme ';
        $sql .= 'WHERE offre.idOffre = :id ';
        $requete = $connexion->prepare($sql);

        $requete->bindParam(':id', $id, PDO::PARAM_INT);

        $travail = array();
        $resultat = $requete->execute();
        if ($resultat){
            $requete->setFetchMode(PDO::FETCH_ASSOC);
            $travail = $requete->fetch();
            $travail['profs'] = ($travail['sexe'] == 'F') ? 'Mme ' : 'M. ';
            $travail['profs'] .= mb_substr($travail['prenom'], 0, 1, 'UTF-8').'. '.$travail['nom'];
        }

        Application::DeconnexionPDO($connexion);

        return $travail;
    }


    /**
     * retrouve les informations sur le RV de coaching dont on fournit l'identifiant
     *
     * @param int $id : identifiant du RV coaching dans didac_athena
     *
     * @return array
     */
    public function getCoaching($id){
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT id, matricule, DATE_FORMAT(date,"%d/%m/%Y") AS startDate, DATE_FORMAT(heure,"%H:%i") AS heure, ';
        $sql .= 'duree, proprietaire, sexe, nom, prenom, "" AS enonce, DATE_FORMAT(lastModif, "%d/%m/%Y %H:%i") AS lastModif ';
        $sql .= 'FROM '.PFX.'athena AS da ';
        $sql .= 'LEFT JOIN '.PFX.'profs AS de ON de.acronyme = proprietaire ';
        $sql .= 'WHERE id = :id ';
        $requete = $connexion->prepare($sql);

        $requete->bindParam(':id', $id, PDO::PARAM_INT);

        $travail = array();
        $resultat = $requete->execute();
        if ($resultat){
            $requete->setFetchMode(PDO::FETCH_ASSOC);
            $travail = $requete->fetch();
            $travail['profs'] = ($travail['sexe'] == 'F') ? 'Mme ' : 'M. ';
            $travail['profs'] .= mb_substr($travail['prenom'], 0, 1, 'UTF-8').'. '.$travail['nom'];
            $travail['categorie'] = 'Soutien scolaire';
            $travail['title'] = 'Travail avec '.$travail['profs'];
        }

        Application::DeconnexionPDO($connexion);

        return $travail;
    }


    /**
     * renvoie un squelette de "travail" pour le JDC à partir de l'identifiant ghost
     *
     * @param int $idGhost
     * @param string $acronyme : acronyme de l'utilisateur
     *
     * @return array
     */
    public function getTravailFromGhost($idGhost, $acronyme){
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT ghost.acronyme AS proprietaire, ghost.idCategorie, destinataire, jour, TIME_FORMAT(startTime, "%H:%i") AS heure, endTime, allDay, ';
        $sql .= 'TIME_FORMAT(TIMEDIFF(endTime, startTime),"%H:%i") AS duree, sexe, nom, prenom, categorie, cours, nbheures, libelle ';
        $sql .= 'FROM '.PFX.'thotGhost AS ghost ';
        $sql .= 'LEFT JOIN '.PFX.'profs AS profs ON profs.acronyme = ghost.acronyme ';
        $sql .= 'JOIN '.PFX.'thotJdcCategories AS categories ON categories.idCategorie = ghost.idCategorie ';
        $sql .= 'LEFT JOIN '.PFX.'cours AS dc ON cours = SUBSTR(ghost.destinataire,1,LOCATE("-",ghost.destinataire)-1) ';
        $sql .= 'WHERE id = :idGhost AND ghost.acronyme = :acronyme ';
        $requete = $connexion->prepare($sql);

        $requete->bindParam(':idGhost', $idGhost, PDO::PARAM_INT);
        $requete->bindParam(':acronyme', $acronyme, PDO::PARAM_STR, 7);

        $travail = array();
        $resultat = $requete->execute();
        if ($resultat){
            $requete->setFetchMode(PDO::FETCH_ASSOC);
            $travail = $requete->fetch();
            $travail['profs'] = ($travail['sexe'] == 'F') ? 'Mme ' : 'M. ';
            $travail['profs'] .= mb_substr($travail['prenom'], 0, 1, 'UTF-8').'. '.$travail['nom'];
        }

        Application::DeconnexionPDO($connexion);

        return $travail;
    }

    /**
     * lie un document partagé par son $shareId avec un JDC dont on fournit l'id
     *
     * @param int $id : identifiant du Jdc
     * @param int $shareId : identifiant du document partagé
     *
     * @return int : le nombre d'insertion (une)
     */
    public function setPJ($idJdc, $shareId) {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'INSERT IGNORE INTO '.PFX.'thotJdcPJ ';
        $sql .= 'SET idJdc = :idJdc, shareId = :shareId ';
        $requete = $connexion->prepare($sql);

        $requete->bindParam(':idJdc', $idJdc, PDO::PARAM_INT);
        $requete->bindParam(':shareId', $shareId, PDO::PARAM_INT);

        $resultat = $requete->execute();

        Application::DeconnexionPDO($connexion);

        return $resultat;
    }

    /**
     * recherche les PJ liées à un JDC dont on fournit l'id
     *
     * @param int $id
     *
     * @return array
     */
    public function getPJ($id) {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT idJdc, pj.shareId,  dts.fileId, path, fileName ';
        $sql .= 'FROM '.PFX.'thotJdcPJ AS pj ';
        $sql .= 'JOIN '.PFX.'thotShares AS dts ON dts.shareId = pj.shareId ';
        $sql .= 'JOIN '.PFX.'thotFiles AS files ON files.fileId = dts.fileId ';
        $sql .= 'WHERE idJdc = :id AND dirOrFile = "file" ';
        $requete = $connexion->prepare($sql);

        $requete->bindParam(':id', $id, PDO::PARAM_INT);

        $liste = array();
        $resultat = $requete->execute();
        if ($resultat) {
            $requete->setFetchMode(PDO::FETCH_ASSOC);
            while ($ligne = $requete->fetch()) {
                $shareId = $ligne['shareId'];
                $liste[$shareId] = $ligne;
            }
        }

        Application::DeconnexionPDO($connexion);

        return $liste;
    }

    /**
     * supprime la PJ $shareId de la note $id du JDC
     *
     * @param int $shareId
     * @param int $id
     *
     * @return int : nombre de suppressions
     */
    public function delPJ($id, $shareId) {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'DELETE FROM '.PFX.'thotJdcPJ ';
        $sql .= 'WHERE id = :id AND shareId = :shareId ';
        $requete = $connexion->prepare($sql);

        $requete->bindParam(':id', $id, PDO::PARAM_INT);
        $requete->bindParam(':shareId', $shareId, PDO::PARAM_INT);

        $resultat = $requete->execute();

        Application::DeconnexionPDO($connexion);

        return $resultat;
    }

    /**
     * modifie les dates de début et de fin d'un évenement dont on fournit aussi l'id
     * fonction nécessaire après un drag/drop;.
     *
     * @param $id : l'identifiant de l'inscription dans le JDC
     * @param $startDate : date et heure de début de l'événement
     * @param $endDate : date et heure de fin de l'événement
     *
     * @return int
     */
    public function modifEvent($id, $startDate, $endDate, $allDay)
    {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'UPDATE '.PFX.'thotJdc ';
        $sql .= "SET startDate = '$startDate', endDate = '$endDate', allDay = $allDay ";
        $sql .= "WHERE id='$id' ";
        $resultat = $connexion->exec($sql);

        Application::DeconnexionPDO($connexion);

        return $resultat;
    }

    /**
     * vérifie si l'élément dont l'identifiant est passé appartient bien au propriétaire utlisateur actuel.
     *
     * @param $id : l'identifiant de l'inscription dans le JDC
     * @param $user : l'acronyme de l'utilisateur
     *
     * @return bool : true si ok
     */
    public function verifIdProprio($id, $proprio)
    {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT id FROM '.PFX.'thotJdc ';
        $sql .= "WHERE id ='$id' AND proprietaire = '$proprio' ";
        $resultat = $connexion->query($sql);
        if ($resultat) {
            $ligne = $resultat->fetch();
            $id = $ligne['id'];
        } else {
            $id = null;
        }
        Application::DeconnexionPDO($connexion);

        return $id;
    }

    /**
     * suppression d'une notification au journal de classe.
     *
     * @param $id : l'identifiant de l'enregistrement
     *
     * @return int : le nombre de suppression (0 -si échec- ou 1)
     */
    public function deleteJdc($id)
    {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'DELETE FROM '.PFX.'thotJdc ';
        $sql .= 'WHERE id = :id ';
        $requete = $connexion->prepare($sql);

        $requete->bindParam(':id', $id, PDO::PARAM_INT);
        $resultat1 = $requete->execute();

        // suppression des PJ
        $sql = 'DELETE FROM '.PFX.'thotJdcPJ ';
        $sql .= 'WHERE idJdc = '.$id.' ';

        $resultat = $connexion->exec($sql);

        Application::DeconnexionPDO($connexion);

        return $resultat1;
    }

    /**
     * suppression des PJ liées au journal de classe mais qui ne sont plus partagées
     *
     * @param void
     *
     * @return int : le nombre de suppressions
     */
    public function delUnSharedPJ(){
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'DELETE FROM '.PFX.'thotJdcPJ ';
        $sql .= 'WHERE shareId NOT IN (SELECT shareId FROM '.PFX.'thotShares) ';
        $requete = $connexion->prepare($sql);

        $resultat = $requete->execute();
        $nb = $requete->rowCount();

        Application::DeconnexionPDO($connexion);

        return $nb;
        }

    /**
     * enregistre une notification au JDC.
     *
     * @param array $post : tout le contenu du formulaire
     * @param string $acronyme : identifiant de l'utilisateur
     *
     * @return integer: last Id
     */
    public function saveJdc($post, $acronyme)
    {
        $id = isset($post['id']) ? $post['id'] : null;
        $destinataire = isset($post['destinataire']) ? $post['destinataire'] : null;
        $type = isset($post['type']) ? $post['type'] : null;
        $date = Application::dateMysql($post['date']);
        $duree = isset($post['duree']) ? $post['duree'] : null;
        $allDay = isset($post['journee']) ? $post['journee'] : 0;

        if ($allDay == 0) {
            $heure = $post['heure'];
            $startDate = $date.' '.$heure;
            // $duree peut être exprimé en minutes ou en format horaire hh:mm
            $duree = $post['duree'];
            if (!is_numeric($duree)) {
                if (strpos($duree,':') > 0) {
                    // c'est sans doute le format hh::mm
                    $duree = explode(':', $duree);
                    $duree = $duree[0] * 60 + $duree[1];
                }
                else $duree = 0;
            }

            $endDate = new DateTime($startDate);
            $endDate->add(new DateInterval('PT'.$duree.'M'));
            $endDate = $endDate->format('Y-m-d H:i');
        } else {
            $duree = Null;
            $heure = Null;
            $startDate = $date.' '.'00:00';
            $endDate = $startDate;
        }

        $titre = $post['titre'];
        $categorie = $post['categorie'];
        $class = $categorie;
        $enonce = $post['enonce'];

        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        if ($id == null) {
            // nouvel enregistrement
            $sql = 'INSERT INTO '.PFX.'thotJdc ';
            $sql .= 'SET destinataire = :destinataire, type = :type, proprietaire = :proprietaire, idCategorie = :categorie, ';
            $sql .= 'title = :titre, enonce = :enonce, startDate = :startDate, endDate = :endDate, allDay = :allDay, lastModif = NOW() ';


        } else {
            // simple mise à jour
            $sql = 'UPDATE '.PFX.'thotJdc ';
            $sql .= 'SET destinataire = :destinataire, type = :type, proprietaire = :proprietaire, idCategorie = :categorie, ';
            $sql .= 'title = :titre, enonce = :enonce, startDate = :startDate, endDate = :endDate, allDay = :allDay, lastModif = NOW() ';
            $sql .= 'WHERE id = :id ';
        }
        $requete = $connexion->prepare($sql);

        $requete->bindParam(':destinataire', $destinataire, PDO::PARAM_STR, 20);
        $requete->bindParam(':type', $type, PDO::PARAM_STR, 10);
        $requete->bindParam(':proprietaire', $acronyme, PDO::PARAM_STR, 7);
        $requete->bindParam(':categorie', $categorie, PDO::PARAM_INT);
        $requete->bindParam(':titre', $titre, PDO::PARAM_STR, 100);
        $requete->bindParam(':enonce', $enonce, PDO::PARAM_STR);
        $requete->bindParam(':startDate', $startDate, PDO::PARAM_STR, 20);
        $requete->bindParam(':endDate', $endDate, PDO::PARAM_STR, 20);
        $requete->bindParam(':allDay', $allDay, PDO::PARAM_INT);
        if ($id != Null) {
            $requete->bindParam(':id', $id, PDO::PARAM_INT);
        }


        $resultat = $requete->execute();
        if ($id == null) {
            $lastId = $connexion->lastInsertId();
        }
        Application::DeconnexionPDO($connexion);

        if ($id == null) {
            return $lastId;
        } elseif ($resultat > 0) {
            return 1;
        } else {
            return 0;
        }
    }

    /**
     * retourne les différentes catégories de travaux disponibles (interro, devoir,...).
     *
     * @param void
     *
     * @return array
     */
     public function categoriesTravaux()
     {
         $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
         $sql = 'SELECT idCategorie, categorie, ordre ';
         $sql .= 'FROM '.PFX.'thotJdcCategories ';
         $sql .= 'ORDER BY ordre ';
         $requete = $connexion->prepare($sql);

         $resultat = $requete->execute();
         $liste = array();
         if ($resultat) {
             $requete->setFetchMode(PDO::FETCH_ASSOC);
             while ($ligne = $requete->fetch()) {
                 $id = $ligne['idCategorie'];
                 $liste[$id] = $ligne;
             }
         }
         Application::DeconnexionPDO($connexion);

         return $liste;
     }

    /**
     * renvoie la liste des catégories de travaux déjà utilisées dans le JDC
     * => non effaçables dans la configuration du JDC
     *
     * @param void
     *
     * @return array
     */
     public function getUsedCategories()
     {
         $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
         $sql = 'SELECT DISTINCT idCategorie ';
         $sql .= 'FROM '.PFX.'thotJdc ';
         $sql .= 'ORDER BY idCategorie ';
         $requete = $connexion->prepare($sql);

         $resultat = $requete->execute();
         $liste = array();
         if ($resultat) {
             $requete->setFetchMode(PDO::FETCH_ASSOC);
             while ($ligne = $requete->fetch()){
                 array_push($liste, $ligne['idCategorie']);
                }
             }

         Application::DeconnexionPDO($connexion);

         return $liste;
     }

     /**
      * enregistre la mention $mention pour la categorie $idCategorie
      *
      * @param string $mention
      * @param int $idCategorie
      *
      * @return array
      */
      public function saveMention($categorie, $idCategorie = Null) {
          $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
          if ($idCategorie == Null) {
              $sql = 'INSERT INTO '.PFX.'thotJdcCategories ';
              $sql .= 'SET categorie = :categorie ';
            }
            else {
                $sql = 'UPDATE '.PFX.'thotJdcCategories ';
                $sql .= 'SET categorie = :categorie ';
                $sql .= 'WHERE idCategorie = :idCategorie ';
            }
          $requete = $connexion->prepare($sql);

          $requete->bindParam(':categorie', $categorie, PDO::PARAM_STR, 30);
          if ($idCategorie != Null) {
              $requete->bindParam(':idCategorie', $idCategorie, PDO::PARAM_INT);
            }

          $resultat = $requete->execute();
          if ($idCategorie == null) {
              $idCategorie = $connexion->lastInsertId();
          }

          Application::DeconnexionPDO($connexion);

          return $idCategorie;
        }

        /**
        * définit un nouvel ordre pour une nouvelle catégorie $idCategorie
        * après le plus grand ordre existant
        *
        * @param int $idCategorie
        *
        * @return int : le nouvel ordre qui a été attribué
        */
        public function putOrdre4Categorie($idCategorie) {
            $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
            $sql = 'SELECT MAX(ordre) AS maxOrdre FROM '.PFX.'thotJdcCategories ';
            $requete = $connexion->prepare($sql);
            $resultat = $requete->execute();
            if ($resultat) {
                $ligne = $requete->fetch();
                $maxOrdre = $ligne['maxOrdre'] + 1;
                }

            $sql = 'UPDATE '.PFX.'thotJdcCategories ';
            $sql .= 'SET ordre = 1 + :maxOrdre ';
            $sql .= 'WHERE idCategorie = :idCategorie ';
            $requete = $connexion->prepare($sql);

            $requete->bindParam(':maxOrdre', $maxOrdre, PDO::PARAM_INT);
            $requete->bindParam(':idCategorie', $idCategorie, PDO::PARAM_INT);

            $resultat = $requete->execute();

            $ordre = $connexion->lastInsertId();

            Application::DeconnexionPDO($connexion);

            return $ordre;
            }

   /**
     * échange l'ordre d'affichage des items du JDC pour les éléments
     * idCategorie et nextidCategorie
     *
     * @param int $ordre : ordre de l'élément $idCategorie
     * @param int $idCategorie : catégorie du premier élément à échanger
     * @param int $nextOrdre : ordre de l'élément $nextidCategorie
     * @param void $nextidCategorie : catégorie du deuxième élément de l'échange
     *
     * @return int
     */
     public function attribOrdreCategorie($ordre, $idCategorie)
     {
         $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
         $sql = 'UPDATE '.PFX.'thotJdcCategories ';
         $sql .= 'SET ordre = :ordre ';
         $sql .= 'WHERE idCategorie = :idCategorie ';
         $requete = $connexion->prepare($sql);

         $requete->bindParam(':ordre', $ordre, PDO::PARAM_INT);
         $requete->bindParam(':idCategorie', $idCategorie, PDO::PARAM_INT);
         $resultat = $requete->execute();

         $nb = $requete->rowCount();

         Application::DeconnexionPDO($connexion);

         return $nb;
     }

    /**
      * suppression d'une catégorie d'événements au JDX
      *
      * @param int $idCategorie : catégorie du premier élément à échanger
      *
      * @return int nombre de suppressions
      */
      public function delCategorie($idCategorie)
      {
          $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
          $sql = 'DELETE FROM '.PFX.'thotJdcCategories ';
          $sql .= 'WHERE idCategorie = :idCategorie ';
          $requete = $connexion->prepare($sql);

          $requete->bindParam(':idCategorie', $idCategorie, PDO::PARAM_INT);
          $resultat = $requete->execute();

          $nb = $requete->rowCount();

          Application::DeconnexionPDO($connexion);

          return $nb;
      }

    /**
     * retourne la liste des types d'accès existants: eleve, classe, cours, niveau, ecole...
     *
     * @param void
     *
     * @return array
     */
    public function getListeTypes(){
      $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
      $sql = 'SELECT type, libelle ';
      $sql .= 'FROM '.PFX.'thotJdcTypes ';
      $requete = $connexion->prepare($sql);

      $resulat = $requete->execute();
      $liste = array();
      if ($resulat){
        $requete->setFetchMode(PDO::FETCH_ASSOC);
        while ($ligne = $requete->fetch()){
          $type = $ligne['type'];
          $liste[$type] = $ligne['libelle'];
        }
      }

      Application::DeconnexionPDO($connexion);

      return $liste;
    }

    /**
     * renvoie le label utilisable pour le destinataire en fonction du type
     *
     * @param string $type : type de destinataire (ecole, niveau, classe, groupe, eleve)
     * @param string $destinataire : le nom du destinataire
     *
     * @return string
     */
    public function getLabel($type, $destinataire, $infos=Null) {
        $lblDestinataire = Null;
        switch ($type) {
            case 'eleve':
                // $infos est un tableau avec les détails de l'élève
                $lblDestinataire = $this->getLblEleve($infos);
                break;
            case 'coursGrp':
                // $infos est la liste des cours du prof
                $lblDestinataire =  $this->getLblCours($destinataire, $infos);
                break;
            case 'classe':
                $lblDestinataire = $this->getLblClasse($destinataire);
                break;
            case 'niveau':
                $lblDestinataire = $this->getLblNiveau($destinataire);
                break;
            case 'ecole':
                $lblDestinataire = $this->getLblEcole();
                break;
        }

        return $lblDestinataire;
    }

	/**
	 * renvoie le label utilisable pour un cours si on fournit $coursGrp et $listeCours (avec détails de dénomination) de l'utilisateur
	 *
	 * @param string $coursGrp
	 * @param array $listeCours
	 *
	 * @return string
	 */
	public function getLblCours ($coursGrp, $listeCours) {
		$detailsCours = $listeCours[$coursGrp];
		if ($detailsCours['nomCours'] != '') {
			$lbl = sprintf('%s %dh | %s',$detailsCours['libelle'], $detailsCours['nbheures'], $detailsCours['nomCours']);
            }
		else {
			$lbl = sprintf('%s %s %s %dh [%s]', $detailsCours['annee'], $detailsCours['statut'], $detailsCours['libelle'], $detailsCours['nbheures'], $detailsCours['coursGrp']);
		}

		return $lbl;
	}

	/**
	 * renvoie le label utilisable pour une classe si on fournit $classe
	 *
	 * @param string $classe
	 *
	 * @return string
	 */
	public function getLblClasse ($classe) {
		return sprintf('Classe de %s', $classe);
	}

	/**
	 * renvoie le label utilisable pour un élève dont on fournit les détails
	 * @param array $detailsEleve
	 *
	 * @return string
	 */
	public function getLblEleve ($detailsEleve) {
		return sprintf('%s %s [%s]', $detailsEleve['nom'], $detailsEleve['prenom'], $detailsEleve['groupe']);
	}

	/**
	 * renvoie le label utilisable pour le niveau d'étude précisé
	 *
	 * @param int $niveau
	 *
	 * @return string
	 */
	public function getLblNiveau ($niveau) {
		$suffixe = ($niveau == 1) ? 'ères' : 'èmes';
		return sprintf('Élèves de %d%s', $niveau, $suffixe);
	}

	/**
	 * renvoie le label utilisable pour tous les élèves de l'école
	 *
	 * @param void()
	 *
	 * @return string
	 */
	public function getLblEcole () {
		return 'Tous les élèves';
	}

    /**
     * renvoie la liste des heures de cours données dans l'école.
     *
     * @param void
     *
     * @return array
     */
    public function lirePeriodesCours()
    {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT debut, fin ';
        $sql = "SELECT DATE_FORMAT(debut,'%H:%i') as debut, DATE_FORMAT(fin,'%H:%i') as fin ";
        $sql .= 'FROM '.PFX.'presencesHeures ';
        $sql .= 'ORDER BY debut, fin';

        $resultat = $connexion->query($sql);
        $listePeriodes = array();
        $periode = 1;
        if ($resultat) {
            while ($ligne = $resultat->fetch()) {
                $debut = $ligne['debut'];
                $fin = $ligne['fin'];
                $listePeriodes[$periode++] = array('debut' => $debut, 'fin' => $fin);
            }
        }
        Application::deconnexionPDO($connexion);

        return $listePeriodes;
    }

    /**
     * renvoie l'heure de la période de cours la plus proche de l'heure passée en argument
     *
     * @param string $heure
     *
     * @return string
     */
    public function heureLaPlusProche($heure){
        $listePeriodes = $this->lirePeriodesCours();
        $time = explode(':', $heure);
        $time = mktime($heure[0], $heure[1]);

        $n = 1;
        while (($listePeriodes[$n]['fin'] < $heure) && ($n < count($listePeriodes))) {
            $n++;
        }
        $timeDebut = explode(':', $listePeriodes[$n]['debut']);
        $timeFin = explode(':', $listePeriodes[$n]['fin']);

        if (((float) $time - (float) $timeDebut) > ((float) $timeFin - (float) $time))
            return $listePeriodes[$n]['debut'];
            else return $listePeriodes[$n]['fin'];
    }

    /**
     * renvoie les notes du JDC comprises entre la date "from" et la date "to"
     * en tenant compte des options d'impression: rien que les matières vues et/ou tout
     *
     * @param array $form : formulaire provenant de la boîte modale "modalPrintJDC"
     * @param string $acronyme : identifiant de l'utilisateur (sécurité)
     *
     * @return array
     */
    public function fromToJDCList($form, $acronyme) {
        $startDate = Application::dateMysql($form['from']);
        $endDate = Application::dateMysql($form['to']);
        $coursGrp = $form['coursGrp'];
        $listeCategoriesString = implode(',', $form['printOptions']);

        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT id, categorie, libelle, nomCours, destinataire, title, enonce, startDate, endDate, dtjdc.idCategorie ';
        $sql .= 'FROM '.PFX.'thotJdc AS dtjdc ';
        $sql .= 'JOIN '.PFX.'thotJdcCategories AS cate ON cate.idCategorie = dtjdc.idCategorie ';
        $sql .= 'JOIN '.PFX."cours AS dc ON dc.cours = SUBSTR(destinataire, 1, LOCATE('-', destinataire)-1) ";
        $sql .= 'LEFT JOIN '.PFX.'profsCours AS pc ON pc.coursGrp = destinataire ';
        $sql .= 'WHERE proprietaire = :acronyme AND startDate >= :startDate AND endDate <= :endDate ';
        $sql .= 'AND dtjdc.idCategorie IN ('.$listeCategoriesString.') ';
        if ($coursGrp != 'all')
            $sql .= 'AND destinataire = :coursGrp ';
        $sql .= 'ORDER BY startDate, nomCours, libelle ';
        $requete = $connexion->prepare($sql);

        $requete->bindParam(':startDate', $startDate, PDO::PARAM_STR, 15);
        $requete->bindParam(':endDate', $endDate, PDO::PARAM_STR, 15);
        $requete->bindParam(':acronyme', $acronyme, PDO::PARAM_STR, 7);

        if ($coursGrp != 'all') {
            $requete->bindParam(':coursGrp', $coursGrp, PDO::PARAM_STR, 20);
        }

        $liste = array();
        $resultat = $requete->execute();
        if ($resultat) {
            $requete->setFetchMode(PDO::FETCH_ASSOC);
            while ($ligne = $requete->fetch()){
                $id = $ligne['id'];
                $startDate = explode(' ', $ligne['startDate']);
                $endDate = explode(' ', $ligne['endDate']);
                if ($startDate == $endDate) {
                  $ligne['startDate'] = 'Toute la journée';
                }
                else {
                  $ligne['startDate'] = Application::datePHP($startDate[0]);
                }
                $ligne['startHeure'] = $startDate[1];
                $ligne['endDate'] = Application::datePHP($endDate[0]);
                $ligne['endHeure'] = $endDate[1];
                $ligne['enonce'] = strip_tags($ligne['enonce'], '<h1><h2><h3><br><p><a>');
                $liste[$id] = $ligne;
            }

        Application::deconnexionPDO($connexion);

        return $liste;
        }
    }

    /**
     * modifie les dates/heures de début et fin d'un événement après drag/drop
     * @param  int $id   identifiant de l'événement
     * @param  string $startTime nouvelle date de début
     * @param  string $endTime   nouvelle date de fin
     *
     * @return bool
     */
    public function changeEventTime($id, $startTime, $endTime){
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'UPDATE '.PFX.'thotJdc ';
        $sql .= 'SET startDate = :startTime, endDate = :endTime ';
        $sql .= 'WHERE id = :id ';
        $requete = $connexion->prepare($sql);

        $requete->bindParam(':id', $id, PDO::PARAM_INT);
        $requete->bindParam(':startTime', $startTime, PDO::PARAM_STR, 20);
        $requete->bindParam(':endTime', $endTime, PDO::PARAM_STR, 20);

        $resultat = $requete->execute();

        Application::DeconnexionPDO($connexion);

        return $resultat;
    }

    /**
     * renvoie les notes du JDC comprises entre la date "start" et la date "end"
     * en tenant compte des options d'impression pour les catégories d'événements
     *
     * @param string $startDate
     * @param string $endDate
     * @param array $listeCoursGrp : la liste des cours pour l'élève
     * @param array $listeCatagories : la liste des catégories d'événements à imprimer
     *
     * @return array
     */
    public function jdcFromTo($startDate, $endDate, $listeCoursGrp, $listeCategories) {
        $startDate = Application::dateMysql($startDate).' 00:00';
        $endDate = Application::dateMysql($endDate).' 23:59';

        $listeCoursGrpString = "'".implode("','", array_keys($listeCoursGrp))."'";
        $listeCategoriesString = is_array($listeCategories) ? implode(',', $listeCategories) : "'".$listeCategories."'";

        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT id, categorie, libelle, type, destinataire, title, enonce, ';
        $sql .= 'sexe, nom, prenom, proprietaire, startDate, endDate, jdc.idCategorie ';
        $sql .= 'FROM '.PFX.'thotJdc AS jdc ';
        $sql .= 'JOIN '.PFX.'thotJdcCategories AS cat ON cat.idCategorie = jdc.idCategorie ';
        $sql .= 'JOIN '.PFX."cours AS dc ON dc.cours = SUBSTR(destinataire, 1, LOCATE('-', destinataire)-1) ";
        $sql .= 'LEFT JOIN '.PFX.'profs AS profs ON profs.acronyme = proprietaire ';
        $sql .= 'WHERE startDate >= :startDate AND endDate <= :endDate ';
        $sql .= 'AND jdc.idCategorie IN ('.$listeCategoriesString.') ';
        $sql .= 'AND destinataire IN ('.$listeCoursGrpString.') ';
        $sql .= 'ORDER BY destinataire, startDate, jdc.idCategorie ';
        $requete = $connexion->prepare($sql);

        $requete->bindParam(':startDate', $startDate, PDO::PARAM_STR, 15);
        $requete->bindParam(':endDate', $endDate, PDO::PARAM_STR, 15);

        $liste = array();
        $resultat = $requete->execute();
        if ($resultat) {
            $requete->setFetchMode(PDO::FETCH_ASSOC);
            while ($ligne = $requete->fetch()){
                $id = $ligne['id'];
                $startDate = explode(' ', $ligne['startDate']);
                $endDate = explode(' ', $ligne['endDate']);
                if ($startDate == $endDate) {
                  $ligne['startDate'] = 'Toute la journée';
                }
                else {
                  $ligne['startDate'] = Application::datePHP($startDate[0]);
                }
                // extraire le sigle du cours Ex: 2C:INFO2-03 => INFO2
                $type = $ligne['type'];
                if ($type = 'coursGrp') {
                    $pattern = '/.*:([A-Z0-9]*)-[0-9]*/';
                    preg_match($pattern, $ligne['destinataire'], $matches);
                    $ligne['dest'] = $matches[1];
                }
                else $ligne['dest'] = '';

                $ligne['startHeure'] = $startDate[1];
                $ligne['endDate'] = Application::datePHP($endDate[0]);
                $ligne['endHeure'] = $endDate[1];
                $ligne['enonce'] = strip_tags($ligne['enonce'], '<br><p><a>');
                $ligne['nomProf'] = $this->nomProf($ligne['sexe'], $ligne['nom'], $ligne['prenom']);
                $liste[$id] = $ligne;
            }

        Application::deconnexionPDO($connexion);

        return $liste;
        }
    }

    /**
     * renvoie toutes les mentions de types choisis pour l'utilisateur $acronyme entre deux dates
     *
     * @param string $acronyme
     * @param string $startDate
     * @param string $endDate
     * @param array $listeCategories : types d'événements à inclure
     *
     *
     * @return array
     */
    public function getGhostJdc ($acronyme, $startDate, $endDate, $listeCategories){
        $listeCategories = implode(',', $listeCategories);
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT destinataire, idCategorie, allDay, DATEDIFF(startDate, :startDate) AS jour, ';
        $sql .= 'TIME(startDate) AS startTime, TIME(endDate) AS endTime ';
        $sql .= 'FROM '.PFX.'thotJdc ';
        $sql .= 'WHERE type = "coursGrp" AND idCategorie IN ('.$listeCategories.') AND ';
        $sql .= 'startDate BETWEEN :startDate AND :endDate AND proprietaire = :acronyme ';
        $requete = $connexion->prepare($sql);

        $requete->bindParam(':startDate', $startDate, PDO::PARAM_STR, 15);
        $requete->bindParam(':endDate', $endDate, PDO::PARAM_STR, 15);
        $requete->bindParam(':acronyme', $acronyme, PDO::PARAM_STR, 7);

        $liste = array();
        $resultat = $requete->execute();

        if ($resultat){
            $requete->setFetchMode(PDO::FETCH_ASSOC);
            while ($ligne = $requete->fetch()){
                $liste[] = $ligne;
            }
        }

        Application::DeconnexionPDO($connexion);

        return $liste;
    }

    /**
     * enregistrement du modèle d'horaire hebodmadaire
     *
     * @param array $listeCours
     * @param string $acronyme
     *
     * @return int : nombre d'items enregistrés
     */
     public function saveGhost($listePlages, $acronyme){
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'DELETE FROM '.PFX.'thotGhost ';
        $sql .= 'WHERE acronyme = :acronyme ';
        $requete = $connexion->prepare($sql);

        $requete->bindParam(':acronyme', $acronyme, PDO::PARAM_STR, 7);
        $requete->execute();

        $sql = 'INSERT INTO '.PFX.'thotGhost ';
        $sql .= 'SET destinataire = :destinataire, idCategorie = :idCategorie, allDay = :allDay, ';
        $sql .= 'jour = :jour, startTime = :startTime, endTime = :endTime, acronyme = :acronyme ';
        $requete = $connexion->prepare($sql);

        $requete->bindParam(':acronyme', $acronyme, PDO::PARAM_STR, 7);

        $nb = 0;
        foreach ($listePlages as $unePlage) {
            $requete->bindParam(':destinataire', $unePlage['destinataire'], PDO::PARAM_STR, 15);
            $requete->bindParam(':idCategorie', $unePlage['idCategorie'], PDO::PARAM_INT);
            $requete->bindParam(':allDay', $unePlage['allDay'], PDO::PARAM_INT);
            $requete->bindParam(':jour', $unePlage['jour'], PDO::PARAM_INT);
            $requete->bindParam(':startTime', $unePlage['startTime'], PDO::PARAM_STR, 8);
            $requete->bindParam(':endTime', $unePlage['endTime'], PDO::PARAM_STR, 8);
            $nb += $requete->execute();
        }

        Application::DeconnexionPDO($connexion);

        return $nb;
     }

     /**
    * renvoie les événements fullCalendar pour les catégories souhaitées
    *
    * @param array $listeCategories
    * @param string $start : date de début de l'intervalle
    * @param string $end : date de fin de l'intervalle
    * @param string $acronyme : Null si on veut tous les événements pour le niveau d'organisation
    *
    * @return array
    */
   public function getEvents2createModele($listeCategories, $start, $end, $acronyme){
       if ($listeCategories != Null)
           $listeCategories = implode(',', $listeCategories);
       $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
       $sql = 'SELECT id, proprietaire, idCategorie, type, destinataire, title, enonce, ';
       $sql .= 'allDay, startDate, endDate, DATE_FORMAT(NOW(),"%Y-%m-%d") AS ajd ';
       $sql .= 'FROM '.PFX.'thotJdc ';
       $sql .= 'WHERE startDate BETWEEN :start AND :end ';
       $sql .= 'AND type = "coursGrp" AND idCategorie IN ('.$listeCategories.') ';
       $sql .= 'AND proprietaire = :acronyme ';
       $requete = $connexion->prepare($sql);

       $requete->bindParam(':start', $start, PDO::PARAM_STR, 20);
       $requete->bindParam(':end', $end, PDO::PARAM_STR, 20);
       $requete->bindParam(':acronyme', $acronyme, PDO::PARAM_STR, 7);

       $liste = array();
       $resultat = $requete->execute();
       if ($resultat) {
           $requete->setFetchMode(PDO::FETCH_ASSOC);
           while ($ligne = $requete->fetch()) {
               $type = $ligne['type'];
               $destinataire = $ligne['destinataire'];
               $destin = $this->getRealDestinataire($connexion, $acronyme, $type, $destinataire);
               $liste[] = array(
                   'id' => $ligne['id'],
                   'title' => $ligne['title'],
                   'enonce' => mb_strimwidth(strip_tags($ligne['enonce'], '<br><p><a>'), 0 , 400, '... [suite]'),
                   'destinataire' => $destin,
                   'className' => 'cat_'.$ligne['idCategorie'],
                   'start' => $ligne['startDate'],
                   'end' => $ligne['endDate'],
                   'allDay' => ($ligne['allDay']!=0),
                   'type' => $ligne['type'],
                   'editable' => ($ligne['proprietaire'] == $acronyme),
                   );
           }
       }

       Application::DeconnexionPDO($connexion);

       return $liste;
   }

     /**
      * renvoie les événements fullCalendar l'utilisateur souhaité pour la semaine
      * dont on fournit la date du lundi
      *
      * @param string $acronyme
      * @param string $dateLundi (au format YYYY-MM-DD)
      *
      * @return array
      */
     public function getEvents4modele($acronyme, $dateLundi){
         $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
         $sql = 'SELECT id, acronyme, idCategorie, destinataire, jour, startTime, endTime, allDay, ';
         $sql .= 'libelle, nbheures, statut ';
         $sql .= 'FROM '.PFX.'thotGhost AS ghost ';
         $sql .= 'JOIN '.PFX.'cours AS cours ON SUBSTR(destinataire, 1, LOCATE("-", destinataire)-1) = cours.cours ';
         $sql .= 'JOIN '.PFX.'statutCours AS sc ON sc.cadre = cours.cadre ';
         $sql .= 'WHERE acronyme = :acronyme ';

         $requete = $connexion->prepare($sql);

         $requete->bindParam(':acronyme', $acronyme, PDO::PARAM_STR, 7);

         $liste = array();
         $resultat = $requete->execute();
         if ($resultat) {
             $requete->setFetchMode(PDO::FETCH_ASSOC);
             while ($ligne = $requete->fetch()) {
                 $destinataire = $ligne['destinataire'];
                 $liste[] = array(
                     'id' => $ligne['id'],
                     'className' => 'cat_'.$ligne['idCategorie'],
                     'coursGrp' => $ligne['destinataire'],
                     'startTime' => SUBSTR($ligne['startTime'], 0, 5),
                     'endTime' => SUBSTR($ligne['endTime'], 0, 5),
                     'start' => date('Y-m-d', strtotime($dateLundi . '+' . $ligne['jour'] . 'day')) .' '. $ligne['startTime'],
                     'end' => date('Y-m-d', strtotime($dateLundi . '+' . $ligne['jour'] . 'day')) .' '. $ligne['endTime'],
                     'allDay' => ($ligne['allDay']!=0),
                     'libelle' => sprintf('%s %s %dh', $ligne['statut'], $ligne['libelle'], $ligne['nbheures']),
                     );
             }
         }

         Application::DeconnexionPDO($connexion);

         return $liste;
     }


      /**
       * lecture des enregistrements d'horaire hebdomadaire pour l'utilisateur $acronyme
       *
       * @param string $acronyme
       *
       * @return array
       */
      public function getGhost($acronyme){
          $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
          $sql = 'SELECT id, ghost.idCategorie, destinataire, libelle, nbheures, statut, jour, startTime, endTime, allDay, categorie ';
          $sql .= 'FROM '.PFX.'thotGhost AS ghost ';
          $sql .= 'JOIN '.PFX.'thotJdcCategories AS categ ON categ.idCategorie = ghost.idCategorie ';
          $sql .= 'JOIN '.PFX.'cours AS cours ON cours.cours = SUBSTR(destinataire, 1, LOCATE("-", destinataire)-1) ';
          $sql .= 'JOIN '.PFX.'statutCours AS sc ON sc.cadre = cours.cadre ';
          $sql .= 'WHERE acronyme = :acronyme ';
          $sql .= 'ORDER BY jour, startTime ';
          $requete = $connexion->prepare($sql);

          $requete->bindParam(':acronyme', $acronyme, PDO::PARAM_STR, 7);

          $liste = array();
          $resultat = $requete->execute();
          if ($resultat){
              $requete->setFetchMode(PDO::FETCH_ASSOC);
              while ($ligne = $requete->fetch()){
                  $id = $ligne['id'];
                  $ligne['jourSemaine'] = self::jourSemaine($ligne['jour']);
                  $liste[$id] = $ligne;
              }
          }

          Application::DeconnexionPDO($connexion);

          return $liste;
      }


    /**
     * retourne le numéro du jour de la semaine correspondant à une date au format 'YYYY-MM-DD'
     *
     * @param string $date
     *
     * @return int
     */
    public function getDayOfweek4date($date){
        $unixTimestamp = strtotime($date);
        return date("w", $unixTimestamp);
    }

    /**
     * retourne la liste des catégories d'événements au JDC
     *
     * @param void
     *
     * @return array 'idCategorie' => 'categorie'
     */
    public function getListeCategoriesJDC(){
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT idCategorie, categorie ';
        $sql .= 'FROM '.PFX.'thotJdcCategories ';
        $sql .= 'ORDER BY ordre ';
        $requete = $connexion->prepare($sql);

        $liste = array();
        $resultat = $requete->execute();
        if ($resultat){
            $requete->setFetchMode(PDO::FETCH_ASSOC);
            while ($ligne = $requete->fetch()){
                $idCategorie = $ligne['idCategorie'];
                $liste[$idCategorie] = $ligne['categorie'];
            }
        }

        Application::DeconnexionPDO($connexion);

        return $liste;
    }

    /**
     * renvoie les statistiques de remplissage du JDC entre deux dates pour les profs sélectionnés
     * @param array $listeProfs
     * @param array $idCategorie
     *
     * @return array
     */
    public function getStatsJDC($listeProfs=Null, $idCategories, $debut, $fin){
        if ($listeProfs != Null) {
            $listeProfsString = "'".implode("','", $listeProfs)."'";
        }
        if ($idCategories != Null) {
            $idCategoriesString = implode(",", $idCategories);
        }
        $debut = Application::dateMySql($debut);
        $fin = Application::dateMySql($fin);

        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT proprietaire, destinataire, COUNT(*) AS nb ';
        $sql .= 'FROM '.PFX.'thotJdc AS jdc ';
        $sql .= 'WHERE type="coursGrp" AND startDate BETWEEN :debut AND :fin ';
        if ($idCategories != Null)
            $sql .= 'AND idCategorie IN ('.$idCategoriesString.') ';
        if ($listeProfs != Null)
            $sql .= 'AND proprietaire IN ('.$listeProfsString.') ';
        $sql .= 'GROUP BY destinataire, proprietaire ';
        $sql .= 'ORDER BY nb, proprietaire, destinataire ';
        $requete  = $connexion->prepare($sql);

        $requete->bindParam(':debut', $debut, PDO::PARAM_STR, 10);
        $requete->bindParam(':fin', $fin, PDO::PARAM_STR, 10);

        $liste = array();
        $resultat = $requete->execute();
        if ($resultat){
            $requete->setFetchMode(PDO::FETCH_ASSOC);
            while ($ligne = $requete->fetch()){
                $acronyme = $ligne['proprietaire'];
                $destinataire = $ligne['destinataire'];
                $liste[$acronyme][$destinataire] = $ligne['nb'];
            }
        }

        Application::DeconnexionPDO($connexion);

        return $liste;
    }

    /**
     * renvoie les types de cibles existantes pour les JDC
     *
     * @param bool $prof : true si prof ordinaire; si educ ou direction, plus d'options
     *
     * @return array
     */
	public function getTypes($prof = true){
        if ($prof == false) {
            $liste = array('' => 'Choisir',
                'ecole' => 'Tous les élèves',
                'niveau' => 'Un niveau',
                'classe' => 'Une classe',
                'matiere' => 'Une matière',
                'coursGrp' => 'Un de vos cours');
            }
        else {
            $liste = array('' => 'Choisir',
            'coursGrp' => 'Un de vos cours');
            }
        return $liste;
        }

    /**
     * renvoie le jour de la semaine dont on donne le numéro (0 = lundi)
     *
     * @param int $jour
     *
     * @return string
     */
    public static function jourSemaine($jour) {
        $semaine = array(
            0 => 'Lundi',
            1 => 'Mardi',
            2 => 'Mercredi',
            3 => 'Jeudi',
            4 => 'Vendredi',
            5 => 'Samedi',
            6 => 'Dimanche'
        );
            return $semaine[$jour];
    }

	 /**
	 * recherche l'historique des cours pour l'élève $matricule
	 *
	 * @param int $matricule
	 * @param bool $flat : is "true", les périodes sont négligées
	 *
	 * @return array
	 */
	public function getHistorique($matricule, $flat=true){
		$connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
		$sql = 'SELECT bulletin, histo.coursGrp, mouvement, nbheures, libelle, pc.acronyme, CONCAT(prenom," ", nom) AS nom ';
		$sql .= 'FROM '.PFX.'bullHistoCours AS histo ';
		$sql .= 'JOIN '.PFX.'cours AS cours ON cours.cours = SUBSTR(coursGrp, 1, LOCATE("-", coursGrp)-1) ';
		$sql .= 'JOIN '.PFX.'profsCours AS pc ON pc.coursGrp = histo.coursGrp ';
		$sql .= 'LEFT JOIN '.PFX.'profs AS profs ON profs.acronyme = pc.acronyme ';
		$sql .= 'WHERE matricule = :matricule ';
		$sql .= 'ORDER BY bulletin, coursGrp, mouvement ';
		$requete = $connexion->prepare($sql);

		$requete->bindParam(':matricule', $matricule, PDO::PARAM_INT);

		$liste =array();
		$resultat = $requete->execute();
		if ($resultat){
			$requete->setFetchMode(PDO::FETCH_ASSOC);
			while ($ligne = $requete->fetch()){
				$bulletin = $ligne['bulletin'];
				$coursGrp = $ligne['coursGrp'];
				$mouvement = $ligne['mouvement'];
				if ($mouvement == 'ajout')
					$liste[$bulletin][$coursGrp] = $ligne;
					else unset($liste[$bulletin][$coursGrp]);
				}
			}

		if ($flat == true) {
			$newListe = array();
			foreach ($liste as $periode => $listeCours) {
				foreach ($listeCours as $wtf => $data) {
					$coursGrp = $data['coursGrp'];
					$newListe[$coursGrp] = array(
						'acronyme' => $data['acronyme'],
						'nom' => $data['nom'],
						'coursGrp' => $coursGrp,
						'libelle' => $data['libelle'],
						'nbheures' => $data['nbheures']
						);
					}
				}
			$liste = $newListe;
			}

		Application::deconnexionPDO($connexion);

		return $liste;
	}


    /**
     * retrouve les années scolaires de JDC archivées
     *
     * @param void
     *
     * @return array
     */
    public function getAnneesArchivesJdc(){
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT DISTINCT anScol FROM '.PFX.'thotJdcArchive ';
        $requete = $connexion->prepare($sql);

        $liste = array();
        $resultat = $requete->execute();
        if ($resultat){
            $requete->setFetchMode(PDO::FETCH_ASSOC);
            while ($ligne = $requete->fetch()){
                $liste[] = $ligne['anScol'];
            }
        }

        Application::deconnexionPDO($connexion);

		return $liste;
	}

	public function getSizeArchivesJdc(){
		$connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
		$sql = 'SELECT TABLE_NAME AS `Table`, round(((data_length + index_length) / 1024 / 1024), 2) AS size ';
		$sql .= 'FROM information_schema.TABLES ';
		$sql .= 'WHERE table_schema = "'.BASE.'" ';
		$sql .= 'AND table_name = "'.PFX.'thotJdc" ';
		$requete = $connexion->prepare($sql);

		$resultat = $requete->execute();

		$size = Null;
		if ($resultat){
			$ligne = $requete->fetch();
			$size = $ligne['size'];
		}

		Application::deconnexionPDO($connexion);

		return $size;
	}

    /**
     * renvoie la liste des classes pour l'année scolaire archivée $anScol
     *
     * @param string $anScol : année scolaire
     * @param int $niveau : niveau d'étude
     *
     * @return array
     */
    public function listeClassesNiveau4anScol($anScol, $niveau){
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT DISTINCT classe ';
        $sql .= 'FROM '.PFX.'bullArchives ';
        $sql .= 'WHERE annee = :anScol AND SUBSTR(classe, 1, 1) = :niveau ';
        $sql .= 'ORDER BY classe ';
        $requete = $connexion->prepare($sql);

        $requete->bindParam(':anScol', $anScol, PDO::PARAM_STR, 9);
        $requete->bindParam(':niveau', $niveau, PDO::PARAM_INT);

        $resultat = $requete->execute();

        $liste = array();
        if ($resultat) {
            $requete->setFetchMode(PDO::FETCH_ASSOC);
            while ($ligne = $requete->fetch()) {
                $liste[] = $ligne['classe'];
            }
        }

        Application::deconnexionPDO($connexion);

        return $liste;
    }

    /**
     * renvoie la liste des élèves pour l'année scolaire archivée $anScol
     *
     * @param string $anScol : année scolaire
     * @param int $niveau : niveau d'étude
     *
     * @return array
     */
    public function listeElevesNiveau4anScol($anScol, $niveau){
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT DISTINCT leMatricule, nomPrenom, classe ';
        $sql .= 'FROM '.PFX.'bullArchives ';
        $sql .= 'WHERE annee = :anScol AND SUBSTR(classe, 1, 1) = :niveau ';
        $sql .= 'ORDER BY REPLACE(REPLACE(REPLACE(nomPrenom," ",""),"-",""),"\'","") ';
        $requete = $connexion->prepare($sql);

        $requete->bindParam(':anScol', $anScol, PDO::PARAM_STR, 9);
        $requete->bindParam(':niveau', $niveau, PDO::PARAM_INT);

        $resultat = $requete->execute();

        $liste = array();
        if ($resultat) {
            $requete->setFetchMode(PDO::FETCH_ASSOC);
            while ($ligne = $requete->fetch()) {
                $matricule = $ligne['leMatricule'];
                $liste[$matricule] = $ligne;
            }
        }

        Application::deconnexionPDO($connexion);

        return $liste;
    }

    /**
     * renvoie la liste des élèves pour la classe $classe durant l'année archivée $anScol
     *
     * @param string $anScol : année scolaire
     * @param string $classe : niveau d'étude
     *
     * @return array
     */
    public function listeElevesClasse4anScol($anScol, $classe){
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT DISTINCT leMatricule, nomPrenom, classe ';
        $sql .= 'FROM '.PFX.'bullArchives ';
        $sql .= 'WHERE annee = :anScol AND classe = :classe ';
        $sql .= 'ORDER BY REPLACE(REPLACE(REPLACE(nomPrenom," ",""),"-",""),"\'","") ';
        $requete = $connexion->prepare($sql);

        $requete->bindParam(':anScol', $anScol, PDO::PARAM_STR, 9);
        $requete->bindParam(':classe', $classe, PDO::PARAM_STR, 5);

        $resultat = $requete->execute();

        $liste = array();
        if ($resultat) {
            $requete->setFetchMode(PDO::FETCH_ASSOC);
            while ($ligne = $requete->fetch()) {
                $matricule = $ligne['leMatricule'];
                $liste[$matricule] = $ligne;
            }
        }

        Application::deconnexionPDO($connexion);

        return $liste;
    }

    /**
     * archive l'ensemble des tables thotJdc et tables annexes (categories, cours)
     *
     * @param string $anScol : l'année scolaire en cours
     *
     * @return int : nombre d'enregistrements
     */
    public function saveArchiveJDC($anScol){
        // récupération de tous les JDC de l'année scolaire en cours -----------
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT * FROM '.PFX.'thotJdc ';
        $requete = $connexion->prepare($sql);

        $jdc = array();
        $resultat = $requete->execute();
        if ($resultat){
            $requete->setFetchMode(PDO::FETCH_ASSOC);
            $jdc = $requete->fetchall();
        }

        // archivage des journaux de classe pour année scolaire
        $sql = 'INSERT IGNORE INTO '.PFX.'thotJdcArchive ';
        $sql .= 'SET id = :id, anScol = :anScol, destinataire = :destinataire, type = :type, proprietaire = :proprietaire, ';
        $sql .= 'idCategorie = :idCategorie, title = :title, enonce = :enonce, startDate = :startDate, ';
        $sql .= 'endDate = :endDate, allDay = :allDay ';
        $requete = $connexion->prepare($sql);

        $nb = 0;
        $requete->bindParam(':anScol', $anScol, PDO::PARAM_STR, 7);
        foreach ($jdc as $wtf => $data){
            $requete->bindParam(':id', $data['id'], PDO::PARAM_INT);
            $requete->bindParam(':destinataire', $data['destinataire'], PDO::PARAM_STR, 20);
            $requete->bindParam(':type', $data['type'], PDO::PARAM_STR, 12);
            $requete->bindParam(':proprietaire', $data['proprietaire'], PDO::PARAM_STR, 7);
            $requete->bindParam(':idCategorie', $data['idCategorie'], PDO::PARAM_INT);
            $requete->bindParam(':title', $data['title'], PDO::PARAM_STR, 10);
            $requete->bindParam(':enonce', $data['enonce'], PDO::PARAM_STR);
            $requete->bindParam(':startDate', $data['startDate'], PDO::PARAM_STR, 20);
            $requete->bindParam(':endDate', $data['endDate'], PDO::PARAM_STR, 20);
            $requete->bindParam(':allDay', $data['allDay'], PDO::PARAM_INT);

            $requete->execute();
            $nb += $requete->rowCount();
        }

        // recherche des catégories utilisées durant cette année scolaire -----------
        $sql = 'SELECT idCategorie, ordre, urgence, categorie ';
        $sql .= 'FROM '.PFX.'thotJdcCategories ';
        $requete = $connexion->prepare($sql);

        $categories = array();
        $resultat = $requete->execute();
        if ($resultat){
            $requete->setFetchMode(PDO::FETCH_ASSOC);
            while ($ligne = $requete->fetch()) {
                $categories[] = $ligne;
            }
        }

        // archivage des catégories de l'année scolaire en cours
        $sql = 'INSERT IGNORE INTO '.PFX.'thotJdcCategoriesArchive ';
        $sql .= 'SET idCategorie = :idCategorie, anScol = :anScol, ordre = :ordre, ';
        $sql .= 'urgence = :urgence, categorie = :categorie ';

        $requete = $connexion->prepare($sql);

        $requete->bindParam(':anScol', $anScol, PDO::PARAM_STR, 7);
        foreach ($categories as $wtf => $data) {
            $requete->bindParam(':idCategorie', $data['idCategorie'], PDO::PARAM_INT);
            $requete->bindParam(':ordre', $data['ordre'], PDO::PARAM_INT);
            $requete->bindParam(':urgence', $data['urgence'], PDO::PARAM_INT);
            $requete->bindParam(':categorie', $data['categorie'], PDO::PARAM_STR, 30);
            $resultat = $requete->execute();
        }

        // recherche des cours donné cette année scolaire ----------------------
        $sql = 'SELECT cours, nbheures, libelle, cadre, section ';
        $sql .= 'FROM '.PFX.'cours ';
        $requete = $connexion->prepare($sql);

        $cours = array();
        $resultat = $requete->execute();
        if ($resultat){
            $requete->setFetchMode(PDO::FETCH_ASSOC);
            while ($ligne = $requete->fetch()) {
                $cours[] = $ligne;
            }
        }

        // archivage de la table des cours donné cette année scolaire-là
        $sql = 'INSERT IGNORE INTO '.PFX.'thotJdcCoursArchive ';
        $sql .= 'SET cours = :cours, anScol = :anScol, nbheures = :nbheures, ';
        $sql .= 'libelle = :libelle, cadre = :cadre, section = :section ';

        $requete = $connexion->prepare($sql);

        $requete->bindParam(':anScol', $anScol, PDO::PARAM_STR, 9);
        foreach ($cours as $wtf => $data) {
            $requete->bindParam(':cours', $data['cours'], PDO::PARAM_STR, 17);
            $requete->bindParam(':nbheures', $data['nbheures'], PDO::PARAM_INT);
            $requete->bindParam(':libelle', $data['libelle'], PDO::PARAM_STR, 50);
            $requete->bindParam(':cadre', $data['cadre'], PDO::PARAM_INT);
            $requete->bindParam(':section', $data['section'], PDO::PARAM_STR, 3);
            $resultat = $requete->execute();
        }

        // recherche des classes des élèves pour l'année scolaire en cours -----------
        $sql = 'SELECT matricule, groupe, CONCAT(nom, " ", prenom) AS nomPrenom ';
        $sql .= 'FROM '.PFX.'eleves ';
        $requete = $connexion->prepare($sql);

        $liste = array();
        $resultat = $requete->execute();
        if ($resultat) {
            $requete->setFetchMode(PDO::FETCH_ASSOC);
            $liste = $requete->fetchall();
        }

        // archivage des élèves de l'année scolaire courante dans la table bullArchives
        $sql = 'INSERT IGNORE INTO '.PFX.'bullArchives ';
        $sql .= 'SET leMatricule = :matricule, annee = :anScol, classe = :groupe, nomPrenom = :nomPrenom ';
        $requete = $connexion->prepare($sql);

        $requete->bindParam(':anScol', $anScol, PDO::PARAM_STR, 9);
        foreach ($liste as $wtf => $data){
            $requete->bindParam(':matricule', $data['matricule'], PDO::PARAM_INT);
            $requete->bindParam(':groupe', $data['groupe'], PDO::PARAM_STR, 5);
            $requete->bindParam(':nomPrenom', $data['nomPrenom'], PDO::PARAM_STR, 40);
            $resultat = $requete->execute();
        }

        Application::deconnexionPDO($connexion);

        return $nb;
    }

    /**
     * Effacement de l'archive du JDC de l'année scolaire $anScol
     *
     * @param string $anScol : année scolaire à supprimer
     *
     * @return int : nombre d'effacements
     */
    public function delArchiveJDC($anScol){
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        // table des JDC
        $sql = 'DELETE FROM '.PFX.'thotJdcArchive ';
        $sql .= 'WHERE anScol = :anScol ';
        $requete = $connexion->prepare($sql);

        $requete->bindParam(':anScol', $anScol, PDO::PARAM_STR, 7);

        $resultat = $requete->execute();
        $nb = $requete->rowCount();

        // table des archives des cours définis cette année-là
        $sql = 'DELETE FROM '.PFX.'thotJdcCoursArchive ';
        $sql .= 'WHERE anScol = :anScol ';
        $requete = $connexion->prepare($sql);

        $requete->bindParam(':anScol', $anScol, PDO::PARAM_STR, 7);

        $resultat = $requete->execute();
        $nb2 = $requete->rowCount();

        // table des archives des catégories utilisées cette année scolaire-là
        $sql = 'DELETE FROM '.PFX.'thotJdcCategoriesArchive ';
        $sql .= 'WHERE anScol = :anScol ';
        $requete = $connexion->prepare($sql);

        $requete->bindParam(':anScol', $anScol, PDO::PARAM_STR, 7);

        $resultat = $requete->execute();
        $nb3 = $requete->rowCount();

        Application::deconnexionPDO($connexion);

        return $nb;
    }

    /**
     * réinitialisation avec effacement complet des tables du JDC de l'année scolaire en cours
     *
     * @param void
     *
     * @return int
     */
     public function resetTablesJDC(){
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'TRUNCATE '.PFX.'thotJdc ';
        $requete = $connexion->prepare($sql);
        $resultat = $requete->execute();
        $nb = $requete->rowCount();

        $sql = 'TRUNCATE '.PFX.'thotJdcEleve ';
        $requete = $connexion->prepare($sql);
        $requete->execute();
        $nb += $requete->rowCount();

        $sql = 'TRUNCATE '.PFX.'thotJdcPJ ';
        $requete = $connexion->prepare($sql);
        $requete->execute();
        $nb += $requete->rowCount();

        Application::deconnexionPDO($connexion);

        return $nb;
     }

     /**
     * construction du nom du prof depuis sexe, nom et prénom
     * $adresse = ($ligne['sexe'] == 'F') ? 'Mme' : 'M.';
     * @param string $sexe
     * @param string $nom
     * @param string $prenom
     *
     * @return string
     */
     public function nomProf($sexe, $nom, $prenom){
         $adresse = ($sexe == 'F') ? 'Mme' : 'M.';
         $nomProf = '---';
         if ($prenom != '') {
           $nomProf = sprintf('%s %s. %s', $adresse, mb_substr($prenom, 0, 1, 'UTF-8'), $nom);
           }

         return $nomProf;
     }

}
