<?php

class Agenda
{
    /**
     * constructeur de l'objet jdc.
     */
    public function __construct()
    {
    }

    /**
     * retrouve les agendas de l'utilisateur $acronyme
     *
     * @param string $acronyme
     *
     * @return array
     */
    public function getAgendas4user($acronyme){
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT idAgenda, proprietaire, nomAgenda ';
        $sql .= 'FROM '.PFX.'thotAgendas ';
        $sql .= 'WHERE proprietaire = :acronyme ';
        $sql .= 'ORDER BY nomAgenda ';
        $requete = $connexion->prepare($sql);

        $requete->bindParam(':acronyme', $acronyme, PDO::PARAM_STR, 7);
        $liste = array();

        $resultat = $requete->execute();
        if ($resultat){
            $requete->setFetchMode(PDO::FETCH_ASSOC);
            while ($ligne = $requete->fetch()){
                $idAgenda = $ligne['idAgenda'];
                $liste[$idAgenda] = $ligne;
            }
        }

        Application::DeconnexionPDO($connexion);

        return $liste;
    }

    /**
     * retrouve les agendas partagés avec l'utilisateur $acronyme
     *
     * @param string $acronyme
     *
     * @return array
     */
    public function getAgendasShared4user($acronyme){
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT agendas.idAgenda, proprietaire, agendas.nomAgenda, droits, sexe, profs.nom AS nomProf, prenom ';
        $sql .= 'FROM '.PFX.'thotAgendas AS agendas ';
        $sql .= 'JOIN '.PFX.'thotAgendaPartages AS partages ON partages.idAgenda = agendas.idAgenda ';
        $sql .= 'LEFT JOIN '.PFX.'profs AS profs ON profs.acronyme = proprietaire ';
        $sql .= 'WHERE (type = "profs") AND ((destinataire = :acronyme) OR (destinataire = "tous")) ';
        $sql .= 'ORDER BY nomAgenda, idAgenda ';
        $requete = $connexion->prepare($sql);

        $requete->bindParam(':acronyme', $acronyme, PDO::PARAM_STR, 7);
        $liste = array();

        $resultat = $requete->execute();
        if ($resultat){
            $requete->setFetchMode(PDO::FETCH_ASSOC);
            while ($ligne = $requete->fetch()){
                $idAgenda = $ligne['idAgenda'];
                $liste[$idAgenda] = $ligne;
            }
        }

        Application::DeconnexionPDO($connexion);

        return $liste;
    }

    /**
     * renvoie la liste des utilisateurs abonnés à un agenda $idAgenda donné de l'utilisateur $acronyme
     *
     * @param int $idAgenda
     * @param string $acronyme
     *
     * @return array
     */
    public function getShares4agenda($idAgenda, $acronyme){
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT destinataire, type, droits, eleves.nom AS nomEleve, eleves.prenom AS prenomEleve, groupe, ';
        $sql .= 'profs.nom AS nomProf, profs.prenom AS prenomProf, libelle ';
        $sql .= 'FROM '.PFX.'thotAgendaPartages AS partages ';
        $sql .= 'JOIN '.PFX.'thotAgendas AS agendas ON agendas.idAgenda = partages.idAgenda ';
        $sql .= 'LEFT JOIN '.PFX.'eleves AS eleves ON destinataire = eleves.matricule ';
        $sql .= 'LEFT JOIN '.PFX.'profs AS profs ON destinataire = profs.acronyme ';
        $sql .= 'LEFT JOIN '.PFX.'cours AS cours ON (destinataire = cours.cours) OR ';
        $sql .= 'SUBSTR(destinataire, 1, LOCATE("-", destinataire)-1) = cours.cours ';
        $sql .= 'WHERE agendas.idAgenda = :idAgenda AND proprietaire = :acronyme ';
        $sql .= 'ORDER BY type, destinataire ';

        $requete = $connexion->prepare($sql);

        $requete->bindParam(':acronyme', $acronyme, PDO::PARAM_STR, 7);
        $requete->bindParam(':idAgenda', $idAgenda, PDO::PARAM_INT);

        $liste = array();
        $resultat = $requete->execute();
        if ($resultat){
            $requete->setFetchMode(PDO::FETCH_ASSOC);
            while ($ligne = $requete->fetch()){
                $type = $ligne['type'];
                $destinataire = $ligne['destinataire'];
                $liste[$type][$destinataire] = $ligne;
            }
        }

        Application::DeconnexionPDO($connexion);

        return $liste;
    }

    /**
     * enregistrement des partages de l'agenda $idAgenda pour le type d'utilisateur $type
     * la $liste détaillée éventuelle est donnée ou $TOUS = true
     *
     * @param int $idAgenda
     * @param string $type (cours, coursGrp, prof, classe,...)
     * @param bool $TOUS (si TRUE, tous les membres du grouipe sont concernés)
     * @param array $liste : liste des matricules des élèves ou des acronymes des profs
     *
     * @return int : nombre d'enregistrements
     */
    public function saveShares4Agenda($idAgenda, $type, $TOUS = false, $liste = Null){
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'INSERT IGNORE INTO '.PFX.'thotAgendaPartages ';
        switch ($type){
            case 'profs':
                if ($TOUS == true) {
                    $sql .= 'SET idAgenda = :idAgenda, type = :type, destinataire = "tous" ';
                    $requete = $connexion->prepare($sql);
                    $requete->bindParam(':idAgenda', $idAgenda, PDO::PARAM_INT);
                    $requete->bindParam(':type', $type, PDO::PARAM_STR, 8);
                    $resultat = $requete->execute();
                    }
                    else {
                        $sql .= 'SET idAgenda = :idAgenda, type = :type, destinataire = :acronyme ';
                        $requete = $connexion->prepare($sql);
                        $requete->bindParam(':idAgenda', $idAgenda, PDO::PARAM_INT);
                        $requete->bindParam(':type', $type, PDO::PARAM_STR, 8);
                        $resultat = 0;
                        foreach ($liste as $acronyme) {
                            $requete->bindParam(':acronyme', $acronyme, PDO::PARAM_STR, 7);
                            $resultat += $requete->execute();
                        }
                    }
                    break;
            case 'classe':
                if ($TOUS == true){
                    $sql .= 'SET idAgenda = :idAgenda, type = :type, destinataire = :destinataire ';
                    $requete = $connexion->prepare($sql);
                    $requete->bindParam(':idAgenda', $idAgenda, PDO::PARAM_INT);
                    $requete->bindParam(':type', $type, PDO::PARAM_STR, 8);
                    $requete->bindParam(':destinataire', $liste, PDO::PARAM_STR, 12);
                    $resultat = $requete->execute();
                }
                else {
                    // on passe en type "eleve" individuel
                    $type = 'eleve';
                    $sql .= 'SET idAgenda = :idAgenda, type = :type, destinataire = :matricule ';
                    $requete = $connexion->prepare($sql);
                    $requete->bindParam(':idAgenda', $idAgenda, PDO::PARAM_INT);
                    $requete->bindParam(':type', $type, PDO::PARAM_STR, 8);
                    $resultat = 0;
                    foreach ($liste as $matricule) {
                        $requete->bindParam(':matricule', $matricule, PDO::PARAM_INT);
                        $resultat += $requete->execute();
                    }
                }
                break;
            case 'cours':
                if ($TOUS == true){
                    $sql .= 'SET idAgenda = :idAgenda, type = :type, destinataire = :destinataire ';
                    $requete = $connexion->prepare($sql);
                    $requete->bindParam(':idAgenda', $idAgenda, PDO::PARAM_INT);
                    $requete->bindParam(':type', $type, PDO::PARAM_STR, 8);
                    $requete->bindParam(':destinataire', $liste, PDO::PARAM_STR, 12);
                    $resultat = $requete->execute();
                }
                else {
                    // on passe en type "eleve" individuel
                    $type = 'eleve';
                    $sql .= 'SET idAgenda = :idAgenda, type = :type, destinataire = :matricule ';
                    $requete = $connexion->prepare($sql);
                    $requete->bindParam(':idAgenda', $idAgenda, PDO::PARAM_INT);
                    $requete->bindParam(':type', $type, PDO::PARAM_STR, 8);
                    $resultat = 0;
                    foreach ($liste as $matricule) {
                        $requete->bindParam(':matricule', $matricule, PDO::PARAM_INT);
                        $resultat += $requete->execute();
                    }
                }
                break;
            case 'coursGrp':
                if ($TOUS == true){
                    $sql .= 'SET idAgenda = :idAgenda, type = :type, destinataire = :coursGrp ';
                    $requete = $connexion->prepare($sql);
                    $requete->bindParam(':idAgenda', $idAgenda, PDO::PARAM_INT);
                    $requete->bindParam(':type', $type, PDO::PARAM_STR, 8);
                    $requete->bindParam(':coursGrp', $liste, PDO::PARAM_STR, 12);
                    $resultat = $requete->execute();
                }
                else {
                    // on passe en type "eleve" individuel
                    $type = 'eleve';
                    $sql .= 'SET idAgenda = :idAgenda, type = :type, destinataire = :matricule ';
                    $requete = $connexion->prepare($sql);
                    $requete->bindParam(':idAgenda', $idAgenda, PDO::PARAM_INT);
                    $requete->bindParam(':type', $type, PDO::PARAM_STR, 8);
                    $resultat = 0;
                    foreach ($liste as $matricule) {
                        $requete->bindParam(':matricule', $matricule, PDO::PARAM_INT);
                        $resultat += $requete->execute();
                    }
                }
                break;
            case 'niveau':
                $sql .= 'SET idAgenda = :idAgenda, type = :type, destinataire = :niveau ';
                $requete = $connexion->prepare($sql);
                $requete->bindParam(':idAgenda', $idAgenda, PDO::PARAM_INT);
                $requete->bindParam(':type', $type, PDO::PARAM_STR, 8);
                $requete->bindParam(':niveau', $liste);
                $resultat = $requete->execute();
                break;
            case 'ecole':
                $sql .= 'SET idAgenda = :idAgenda, type = :type, destinataire = "tous" ';
                $requete = $connexion->prepare($sql);
                $requete->bindParam(':idAgenda', $idAgenda, PDO::PARAM_INT);
                $requete->bindParam(':type', $type, PDO::PARAM_STR, 8);
                $resultat = $requete->execute();
                break;
            default:
                $resultat = 'Erreur de type';
                break;
        }

        Application::DeconnexionPDO($connexion);

        return $resultat;
    }

    /**
     * Supprime le partage de l'agenda $idAgenda d'avec l'utilisateur $destinataire du type $type
     *
     * @param int $idAgenda
     * @param string $destinataire
     * @param string $type (du destinataire)
     *
     * @return 0 ou 1
     */
    public function delSharedAgenda($idAgenda, $destinataire, $type){
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'DELETE FROM '.PFX.'thotAgendaPartages ';
        $sql .= 'WHERE idAgenda = :idAgenda AND destinataire = :destinataire AND type = :type ';
        $requete = $connexion->prepare($sql);

        $requete->bindParam(':destinataire', $destinataire, PDO::PARAM_STR, 12);
        $requete->bindParam(':idAgenda', $idAgenda, PDO::PARAM_INT);
        $requete->bindParam(':type', $type, PDO::PARAM_STR, 8);

        $resultat = $requete->execute();

        Application::DeconnexionPDO($connexion);

        return $resultat;
    }

    /**
     * renvoie les événements de l'agenda $id entre les dates $start et $end
     *
     * @param int $id : identifiant de l'agenda
     * @param date $start : date de début
     * @param date $end : date de fin
     * @param string $acronyme
     *
     * @return array
     */
    public function getEvents4Agenda($idAgenda, $start, $end, $acronyme){
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT contenu.idPost, contenu.idAgenda, title, enonce, allDay, startDate, endDate, ';
        $sql .= 'classe, lastModif, DATE_FORMAT(NOW(),"%Y-%m-%d") AS ajd ';
        $sql .= 'FROM '.PFX.'thotAgendasContenu AS contenu ';
        $sql .= 'JOIN '.PFX.'thotAgendas AS agendas ON agendas.idAgenda = contenu.idAgenda ';
        $sql .= 'JOIN '.PFX.'thotAgendaCategories AS cate ON cate.idCategorie = contenu.idCategorie ';
        $sql .= 'WHERE agendas.idAgenda = :idAgenda AND startDate BETWEEN :start AND :end ';
        $sql .= 'AND proprietaire = :acronyme ';
        $requete = $connexion->prepare($sql);

        $requete->bindParam(':start', $start, PDO::PARAM_STR, 20);
        $requete->bindParam(':end', $end, PDO::PARAM_STR, 20);
        $requete->bindParam(':acronyme', $acronyme, PDO::PARAM_STR, 7);
        $requete->bindParam(':idAgenda', $idAgenda, PDO::PARAM_INT);

        $liste = array();
        $resultat = $requete->execute();
        if ($resultat){
            $requete->setFetchMode(PDO::FETCH_ASSOC);
            while ($ligne = $requete->fetch()){
                $liste[] = array(
                    'idPost' => $ligne['idPost'],
                    'title' => $ligne['title'],
                    'enonce' => mb_strimwidth(strip_tags($ligne['enonce'], '<br><p><a>'), 0 , 400, '... [suite]'),
                    'start' => $ligne['startDate'],
                    'end' => $ligne['endDate'],
                    'allDay' => ($ligne['allDay'] != 0),
                );
            }
        }

        Application::DeconnexionPDO($connexion);

        return $liste;
    }

    /**
     * création d'un agenda pour l'utilisateur $acronyme
     *
     * @param string $acronyme
     * @param string $nom : nom donné à l'agenda
     *
     * @return int identifiant de l'agenda créé
     */
    public function createAgenda4user($acronyme, $nomAgenda){
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'INSERT INTO '.PFX.'thotAgendas ';
        $sql .= 'SET proprietaire = :acronyme, nomAgenda = :nomAgenda ';
        $requete = $connexion->prepare($sql);

        $requete->bindParam(':acronyme', $acronyme, PDO::PARAM_STR, 7);
        $requete->bindParam(':nomAgenda', $nomAgenda, PDO::PARAM_STR, 40);

        $resultat = $requete->execute();
        $id = $connexion->lastInsertId();

        Application::DeconnexionPDO($connexion);

        return $id;
    }

    /**
     * enregistre le nouveau nom pour l'agenda $idAgenda avec le nom $nomAgenda (utilisateur $acronyme = sécurité)
     *
     * @param int $idAgenda
     * @param string $nomAgenda
     * @param string $acronyme
     *
     * @return int 0 ou 1
     */
    public function saveNewName($idAgenda, $nomAgenda, $acronyme){
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'UPDATE '.PFX.'thotAgendas ';
        $sql .= 'SET nom = :nomAgenda ';
        $sql .= 'WHERE idAgenda = :idAgenda AND proprietaire = :acronyme ';
        $requete = $connexion->prepare($sql);

        $requete->bindParam(':acronyme', $acronyme, PDO::PARAM_STR, 7);
        $requete->bindParam(':idAgenda', $idAgenda, PDO::PARAM_INT);
        $requete->bindParam(':nomAgenda', $nomAgenda, PDO::PARAM_STR, 40);

        $resultat = $requete->execute();

        Application::DeconnexionPDO($connexion);

        return $resultat;
    }

    /**
     * sélection de l'agenda par défaut pour l'utilisateur $acronyme
     *
     * @param string $acronyme
     *
     * @return int|Null identifiant du premier agenda ou Null si rien trouvé
     */
    public function getDefaultAgenda($acronyme){
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT idAgenda ';
        $sql .= 'FROM '.PFX.'thotAgendas ';
        $sql .= 'WHERE proprietaire = :acronyme ';
        $sql .= 'ORDER BY idAgenda LIMIT 1 ';
        $requete = $connexion->prepare($sql);

        $requete->bindParam(':acronyme', $acronyme, PDO::PARAM_STR, 7);
        $resultat = $requete->execute();
        $idAgenda = Null;
        if ($resultat){
            $ligne = $requete->fetch();
            $idAgenda = $ligne['idAgenda'];
        }

        Application::DeconnexionPDO($connexion);

        return $idAgenda;
    }

    /**
     * renvoie les informations sur l'événement dont on fournit l'id dans la table des contenus
     *
     * @param int $id
     *
     * @return array
     */
    public function getEvent($idPost, $acronyme) {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT contenu.idPost, contenu.idAgenda, nomAgenda, title, enonce, DATE(startDate) AS startDate, TIME(startDate) AS startTime, DATE(endDate) AS endDate, ';
        $sql .= 'TIME(endDate) AS endTime, TIMEDIFF(endDate, startDate) AS duree, DATE_FORMAT(lastModif, "%d/%m/%Y %H:%i") AS lastModif, allDay, ';
        $sql .= 'proprietaire, redacteur, contenu.idCategorie, categorie, classe ';
        $sql .= 'FROM '.PFX.'thotAgendasContenu AS contenu ';
        $sql .= 'JOIN '.PFX.'thotAgendas AS agenda ON contenu.idAgenda = agenda.idAgenda ';
        $sql .= 'JOIN '.PFX.'thotAgendaCategories AS cat ON cat.idCategorie = contenu.idCategorie ';
        $sql .= 'WHERE contenu.idPost = :idPost AND (proprietaire = :acronyme OR redacteur = :acronyme) ';
        $requete = $connexion->prepare($sql);

        $requete->bindParam(':acronyme', $acronyme, PDO::PARAM_STR, 7);
        $requete->bindParam(':idPost', $idPost, PDO::PARAM_INT);

        $event = Null;
        $resultat = $requete->execute();
        if ($resultat) {
            $requete->setFetchMode(PDO::FETCH_ASSOC);
            $event = $requete->fetch();
            $event['startDate'] = Application::datePHP($event['startDate']);
            $event['endDate'] = Application::datePHP($event['endDate']);
        }

        Application::DeconnexionPDO($connexion);

        return $event;
    }

    /**
     * modifie les dates de début et de fin d'un évenement dont on fournit aussi l'id
     * fonction nécessaire après un drag/drop;.
     *
     * @param $id : l'identifiant de l'inscription dans le JDC
     * @param $startDate : date et heure de début de l'événement
     * @param $endDate : date et heure de fin de l'événement
     *
     * @return int 0 OU 1
     */
    public function modifEvent($idPost, $startDate, $endDate, $allDay)
    {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'UPDATE '.PFX.'thotAgendasContenu ';
        $sql .= "SET startDate = '$startDate', endDate = '$endDate', allDay = $allDay ";
        $sql .= "WHERE idPost = '$idPost' ";

        $resultat = $connexion->exec($sql);

        Application::DeconnexionPDO($connexion);

        return $resultat;
    }

    /**
     * renvoie la liste des catégories d'événements existants dans la BD
     *
     * @param void
     *
     * @return array
     */
    public function getCategoriesAgenda(){
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT idCategorie, ordre, classe, categorie ';
        $sql .= 'FROM '.PFX.'thotAgendaCategories ';
        $sql .= 'ORDER BY ordre, categorie ';
        $requete = $connexion->prepare($sql);

        $liste = array();
        $resultat = $requete->execute();
        if ($resultat){
            $requete->setFetchMode(PDO::FETCH_ASSOC);
            while ($ligne = $requete->fetch()){
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
         $sql .= 'FROM '.PFX.'thotAgendasContenu ';
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
          $sql = 'UPDATE '.PFX.'thotAgendaCategories ';
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
            $sql = 'INSERT INTO '.PFX.'thotAgendaCategories ';
            $sql .= 'SET categorie = :categorie ';
          }
          else {
              $sql = 'UPDATE '.PFX.'thotAgendaCategories ';
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
       * retourne les différentes catégories d'agendas disponibles (interro, devoir,...).
       *
       * @param void
       *
       * @return array
       */
      public function categoriesAgenda()
      {
          $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
          $sql = 'SELECT idCategorie, categorie, ordre ';
          $sql .= 'FROM '.PFX.'thotAgendaCategories ';
          $sql .= 'ORDER BY ordre ';
          $resultat = $connexion->query($sql);
          $liste = array();
          if ($resultat) {
              $resultat->setFetchMode(PDO::FETCH_ASSOC);
              while ($ligne = $resultat->fetch()) {
                  $id = $ligne['idCategorie'];
                  $liste[$id] = $ligne;
              }
          }
          Application::DeconnexionPDO($connexion);

          return $liste;
      }

      /**
       * suppression d'une catégorie d'événements aux agendas
       *
       * @param int $idCategorie : catégorie du premier élément à supprimer
       *
       * @return int nombre de suppressions
       */
       public function delCategorie($idCategorie)
       {
           $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
           $sql = 'DELETE FROM '.PFX.'thotAgendaCategories ';
           $sql .= 'WHERE idCategorie = :idCategorie ';
           $requete = $connexion->prepare($sql);

           $requete->bindParam(':idCategorie', $idCategorie, PDO::PARAM_INT);
           $resultat = $requete->execute();

           $nb = $requete->rowCount();

           Application::DeconnexionPDO($connexion);

           return $nb;
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
          $sql = 'SELECT MAX(ordre) AS maxOrdre FROM '.PFX.'thotAgendaCategories ';
          $requete = $connexion->prepare($sql);
          $resultat = $requete->execute();
          if ($resultat) {
              $ligne = $requete->fetch();
              $maxOrdre = $ligne['maxOrdre'] + 1;
              }

          $sql = 'UPDATE '.PFX.'thotAgendaCategories ';
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
     * vérifie que le post $idPost appartient bien à l'utilisateur $acronyme en tant que propriétaire ou rédacteur
     *
     * @param int $idPost
     * @param string $acronyme
     *
     * @return int : la valeur de l'$id si correct, sinon Null
     */
    public function verifIdProprio($idPost, $acronyme){
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT contenu.idPost, proprietaire, redacteur ';
        $sql .= 'FROM '.PFX.'thotAgendasContenu AS contenu ';
        $sql .= 'JOIN '.PFX.'thotAgendas AS agendas ON agendas.idAgenda = contenu.idAgenda ';
        $sql .= 'WHERE (proprietaire = :acronyme OR redacteur = :acronyme) AND contenu.idPost = :idPost ';
        $requete = $connexion->prepare($sql);

        $requete->bindParam(':acronyme', $acronyme, PDO::PARAM_STR, 7);
        $requete->bindParam(':idPost', $idPost, PDO::PARAM_INT);

        $result = Null;
        $resultat = $requete->execute();
        if ($resultat){
            $ligne = $requete->fetch();
            $verifIdPost = $ligne['idPost'];
            $proprio = $ligne['proprietaire'];
            $redacteur = $ligne['redacteur'];
            $result = ($verifIdPost == $idPost) && (($proprio == $acronyme) || ($redacteur == $acronyme)) ? $idPost : Null;;
        }

        Application::DeconnexionPDO($connexion);

        return $result;
    }

    /**
     * vérifie que l'agenda $idAgenda appartient bien à l'utilisateur $acronyme
     *
     * @param int $idAgenda
     * @param string $acronyme
     *
     * @return int -1 si pas correct, sinon $idAgenda
     */
    public function verifIdAgendaProprio($idAgenda, $acronyme){
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT idAgenda, proprietaire ';
        $sql .=  'FROM '.PFX.'thotAgendas ';
        $sql .= 'WHERE proprietaire = :acronyme AND idAgenda = :idAgenda ';
        $requete = $connexion->prepare($sql);

        $requete->bindParam(':acronyme', $acronyme, PDO::PARAM_STR, 7);
        $requete->bindParam(':idAgenda', $idAgenda, PDO::PARAM_INT);

        $id = -1;
        $resultat = $requete->execute();
        if ($resultat){
            $ligne = $requete->fetch();
            if ($ligne['idAgenda'] == $idAgenda)
                $id = $ligne['idAgenda'];
        }

        Application::DeconnexionPDO($connexion);

        return $id;
    }

    /**
     * vérifie que le post $idPost fait partie d'un agenda partagé avec l'utilisateur $acronyme
     *
     * @param int $idPost identifiant du post
     * @param string $proprietaire : acronyme du propriétaire
     * @param string $hote : acronyme de l'hôte de l'agenda
     *
     * @return bool
     */
    public function verifSharedPostProprio($idPost, $hote) {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT idPost, contenu.idAgenda, proprietaire, destinataire ';
        $sql .= 'FROM '.PFX.'thotAgendasContenu AS contenu ';
        $sql .= 'JOIN '.PFX.'thotAgendas AS agendas ON agendas.idAgenda = contenu.idAgenda ';
        $sql .= 'JOIN '.PFX.'thotAgendaPartages AS partages ON agendas.idAgenda = partages.idAgenda ';
        $sql .= 'WHERE idPost = :idPost AND destinataire = :hote AND type = "profs" ';
        $requete = $connexion->prepare($sql);

        $requete->bindParam(':hote', $hote, PDO::PARAM_STR, 7);
        $requete->bindParam(':idPost', $idPost, PDO::PARAM_INT);

        $resultat = $requete->execute();
        $proprio = Null;
        if ($resultat) {
            $ligne = $requete->fetch();
            $proprio = $ligne['proprietaire'];
        }

        Application::DeconnexionPDO($connexion);

        return $proprio;
    }

    /**
     * liste le propriétaire et le rédacteur d'un post
     *
     * @param int $idPost
     *
     * @return array ('proprietaire' => $acronyme, 'redacteur' => $acronyme)
     */
    public function getProprioRedacteurPost($idPost){
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT proprietaire, redacteur ';
        $sql .= 'FROM '.PFX.'thotAgendasContenu AS contenu ';
        $sql .= 'JOIN '.PFX.'thotAgendas as agendas ON agendas.idAgenda = contenu.idAgenda ';
        $sql .= 'WHERE idPost = :idPost ';
        $requete = $connexion->prepare($sql);

        $requete->bindParam(':idPost', $idPost, PDO::PARAM_INT);

        $resultat = $requete->execute();
        $binome = array();
        if ($resultat){
            $ligne = $requete->fetch();
            $binome = array('proprietaire' => $ligne['proprietaire'], 'redacteur' => $ligne['redacteur']);
        }

        Application::DeconnexionPDO($connexion);

        return $binome;
    }

    /**
     * enregistre un Post dans un agenda
     *
     * @param array $post : tout le contenu du formulaire
     * @param string $acronyme : identifiant de l'utilisateur
     *
     * @return integer: last Id
     */
    public function saveAgenda($post, $redacteur)
    {
        $idPost = isset($post['idPost']) ? $post['idPost'] : null;
        $idAgenda = isset($post['idAgenda']) ? $post['idAgenda'] : null;
        $categorie = isset($post['categorie']) ? $post['categorie'] : null;
        $startDate = Application::dateMysql($post['startDate']);
        $endDate = Application::dateMysql($post['endDate']);
        $startTime = isset($post['startTime']) ? $post['startTime'] : null;
        $endTime = isset($post['endTime']) ? $post['endTime'] : null;
        $allDay = isset($post['allDay']) ? $post['allDay'] : 0;

        if ($allDay == 0) {
            $startDate = sprintf('%s %s', $startDate, $startTime);
            $endDate = sprintf('%s %s', $endDate, $endTime);
        } else {
            $startDate = sprintf('%s %s', $startDate, '00:00:00');
            $endDate = sprintf('%s %s', $endDate, '00:00:00');
        }

        $title = isset($post['title']) ? $post['title'] : null;
        $enonce = isset($post['texte']) ? $post['texte'] : null;

        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        if ($idPost == null) {
            // nouvel enregistrement
            $sql = 'INSERT INTO '.PFX.'thotAgendasContenu ';
            $sql .= 'SET idCategorie = :categorie, idAgenda = :idAgenda, title = :title, enonce = :enonce, redacteur = :redacteur, ';
            $sql .= 'startDate = :startDate, endDate = :endDate, allDay = :allDay, lastModif = NOW() ';
        } else {
            // simple mise à jour
            $sql = 'UPDATE '.PFX.'thotAgendasContenu ';
            $sql .= 'SET idCategorie = :categorie, idAgenda = :idAgenda, title = :title, enonce = :enonce, redacteur = :redacteur, ';
            $sql .= 'startDate = :startDate, endDate = :endDate, allDay = :allDay, lastModif = NOW() ';
            $sql .= 'WHERE idPost = :idPost ';
        }
        $requete = $connexion->prepare($sql);

        $requete->bindParam(':categorie', $categorie, PDO::PARAM_INT);
        $requete->bindParam(':idAgenda', $idAgenda, PDO::PARAM_INT);
        $requete->bindParam(':title', $title, PDO::PARAM_STR, 100);
        $requete->bindParam(':enonce', $enonce, PDO::PARAM_STR);
        $requete->bindParam(':redacteur', $redacteur, PDO::PARAM_STR, 7);
        $requete->bindParam(':startDate', $startDate, PDO::PARAM_STR, 20);
        $requete->bindParam(':endDate', $endDate, PDO::PARAM_STR, 20);
        $requete->bindParam(':allDay', $allDay, PDO::PARAM_INT);
        if ($idPost != Null) {
            $requete->bindParam(':idPost', $idPost, PDO::PARAM_INT);
        }

        $resultat = $requete->execute();
        if ($idPost == null) {
            $lastId = $connexion->lastInsertId();
        }

        Application::DeconnexionPDO($connexion);

        if ($idPost == null) {
            return $lastId;
        } elseif ($resultat > 0) {
            return 1;
        } else {
            return 0;
        }
    }

    /**
     * supprimer le post $id pour l'utilisateur $acronyme
     *
     * @param int $idPost identifiant de la publication
     * @param string $acronyme (pour la sécurité)
     *
     * @return int 0 ou 1
     */
    public function deletePost($idPost, $acronyme){
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'DELETE FROM '.PFX.'thotAgendasContenu ';
        $sql .= 'WHERE idPost = :idPost AND idAgenda IN (SELECT idAgenda FROM '.PFX.'thotAgendas WHERE proprietaire = :acronyme OR redacteur = :acronyme) ';
        $requete = $connexion->prepare($sql);

        $requete->bindParam(':acronyme', $acronyme, PDO::PARAM_STR, 7);
        $requete->bindParam(':idPost', $idPost, PDO::PARAM_INT);

        $resultat = $requete->execute();

        Application::DeconnexionPDO($connexion);

        return $resultat;
    }

    /**
     * efface tous les posts d'un agenda
     *
     * @param int $idAgenda : identifiant de l'agenda
     *
     * @return int
     */
    public function deleteAllPosts ($idAgenda){
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT idPost FROM '.PFX.'thotAgendasContenu WHERE idAgenda = :idAgenda ';
        $requete = $connexion->prepare($sql);

        $requete->bindParam(':idAgenda', $idAgenda, PDO::PARAM_INT);

        $listePosts = array();
        $resultat = $requete->execute();
        if ($resultat){
            $requete->setFetchMode(PDO::FETCH_ASSOC);
            while ($ligne = $requete->fetch()){
                $listePosts[] = $ligne['idPost'];
            }
        }
        $listePosts = implode(',', $listePosts);

        $sql = 'DELETE FROM '.PFX.'thotAgendasContenu ';
        $sql .= 'WHERE idPost IN ('.$listePosts.') ';
        $requete = $connexion->prepare($sql);

        $resultat = $requete->execute();

        $nb = $requete->rowCount();

        Application::DeconnexionPDO($connexion);

        return $nb;
    }

    /**
     * efface l'agenda $idAgenda (préalablement vidé) de l'utilisateur $acronyme (sécurité)
     *
     * @param int $idagenda
     * @param string $acronyme
     *
     * @return int
     */
    public function delAgenda($idAgenda, $acronyme){
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'DELETE FROM '.PFX.'thotAgendas ';
        $sql .= 'WHERE idAgenda = :idAgenda AND proprietaire = :acronyme ';
        $requete = $connexion->prepare($sql);

        $requete->bindParam(':idAgenda', $idAgenda, PDO::PARAM_INT);
        $requete->bindParam(':acronyme', $acronyme, PDO::PARAM_STR, 7);

        $resultat = $requete->execute();

        Application::DeconnexionPDO($connexion);

        return $resultat;
    }

    /**
     * liste des destinataires possibles pour un agenda
     *
     * @param void
     *
     * @return array
     */
    public function listeDestinataires() {
        $liste = array(
            'cours' => 'Élèves d\'une matière',
            'coursGrp' => 'Élèves d\'un cours',
            'classe' => 'Élèves d\'une classe',
            'niveau' => 'Élèves d\'un niveau',
            // 'groupe' => 'Élèves d\'un groupe périscolaire',
            'ecole' => 'Tous les élèves',
            'profs' => 'Professeur ou Éducateur'
        );

        return $liste;
    }

    /**
     * retourne l'acronyme du propriétaire de l'aganda $idAgenda
     *
     * @param int $idAgenda
     *
     * @return string
     */
    public function proprio4idAgenda($idAgenda){
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT proprietaire FROM '.PFX.'thotAgendas ';
        $sql .= 'WHERE idAgenda = :idAgenda ';
        $requete = $connexion->prepare($sql);

        $requete->bindParam(':idAgenda', $idAgenda, PDO::PARAM_INT);

        $acronyme = Null;
        $resultat = $requete->execute();
        if ($resultat){
            $ligne = $requete->fetch();
            $acronyme = $ligne['proprietaire'];
        }

        Application::DeconnexionPDO($connexion);

        return $acronyme;
    }

    /**
     * retourne le $idAgenda correspondant à un $idPost
     *
     * @param int $idPost
     *
     * @return int
     */
    public function getIdAgenda4idPost($idPost){
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT idAgenda ';
        $sql .= 'FROM '.PFX.'thotAgendasContenu ';
        $sql .= 'WHERE idPost = :idPost ';
        $requete = $connexion->prepare($sql);

        $requete->bindParam(':idPost', $idPost, PDO::PARAM_INT);
        $idAgenda = -1;

        $resultat = $requete->execute();
        if ($resultat){
            $ligne = $requete->fetch();
            $idAgenda = $ligne['idAgenda'];
        }

        Application::DeconnexionPDO($connexion);

        return $idAgenda;
    }

}
