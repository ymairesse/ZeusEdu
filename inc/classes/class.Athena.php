<?php


class athena
{
    public $id;
    public $acronyme;
    public $date, $heure;
    public $matricule;
    public $envoyePar;
    public $motif;
    public $traitement;
    public $aSuivre;

    public function __construct($id = '', $matricule = '')
    {
        if ($id == '') {
            $this->date = date('d/m/Y');
            $this->heure = date('H:i');
            $this->matricule = $matricule;
            $this->acronyme = $this->envoyePar = $this->motif = $this->traitement = $this->asuivre = '';
        } else {
            $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
            $sql = 'SELECT * FROM '.PFX.'athena ';
            $sql .= "WHERE id = '$id' ";
            $resultat = $connexion->query($sql);
            $ligne = $resultat->fetch();
            $this->id = $id;
            $this->date = Application::datePHP($ligne['date']);
            $this->matricule = $ligne['matricule'];
            $this->heure = $ligne['heure'];
            $this->envoyePar = $ligne['envoyePar'];
            $this->acronyme = $ligne['acronyme'];
            $this->motif = $ligne['motif'];
            $this->traitement = $ligne['traitement'];
            $this->aSuivre = $ligne['aSuivre'];
            Application::DeconnexionPDO($connexion);
        }
    }

    /**
     * Enregistrement des informations concernant une visite au coaching.
     *
     * @param $post : informations provenant du formulaire
     *
     * @return integer: nombre d'enregistrement dans la BD (normalement 1 )
     */
    public function saveSuiviEleve($post)
    {
        $id = ($post['id']) ? $post['id'] : null;
        $proprietaire = $post['proprietaire'];
        $matricule = $post['matricule'];
        $date = Application::dateMySql($post['date']);
        $heure = $post['heure'];
        $duree = $post['duree'];
        $jdc = $post['jdc'];
        $absent = isset($post['absent']) ? 1 : 0;
        $envoyePar = isset($post['envoyePar'])?$post['envoyePar']:$post['professeur'];
        $motif = $post['motif'];
        $traitement = $post['traitement'];
        $prive = isset($post['prive']) ? 1 : 0;
        $aSuivre = $post['aSuivre'];
        $anneeScolaire = $post['anneeScolaire'];
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);

        if ($id != null) {
            // c'est une mise à jour d'une visite précédente
            $sql = 'UPDATE '.PFX.'athena ';
            $sql .= 'SET matricule = :matricule, proprietaire = :proprietaire, date = :date, heure = :heure, duree = :duree, ';
            $sql .= 'jdc = :jdc, absent = :absent, prive= :prive, ';
            $sql .= 'envoyePar = :envoyePar, motif = :motif, traitement = :traitement,  aSuivre=:aSuivre, anneeScolaire=:anneeScolaire, lastModif = NOW() ';
            $sql .= 'WHERE id = :id ';
            $requete = $connexion->prepare($sql);
        } else {
            // c'est une nouvelle visite
            $sql = 'INSERT INTO '.PFX.'athena ';
            $sql .= 'SET matricule=:matricule, proprietaire=:proprietaire, date = :date, heure = :heure, duree = :duree, ';
            $sql .= 'jdc = :jdc, absent = :absent, prive = :prive, ';
            $sql .= 'envoyePar = :envoyePar, motif = :motif, traitement = :traitement, aSuivre = :aSuivre, anneeScolaire = :anneeScolaire, lastModif = NOW() ';
            $requete = $connexion->prepare($sql);
        }

        if ($id != Null)
            $requete->bindParam(':id', $id, PDO::PARAM_INT);
        $requete->bindParam(':proprietaire', $proprietaire, PDO::PARAM_STR, 7);
        $requete->bindParam(':envoyePar', $envoyePar, PDO::PARAM_STR, 7);
        $requete->bindParam(':matricule', $matricule, PDO::PARAM_INT);
        $requete->bindParam(':date', $date, PDO::PARAM_STR, 10);
        $requete->bindParam(':heure', $heure, PDO::PARAM_STR, 5);
        $requete->bindParam(':absent', $absent, PDO::PARAM_INT);
        $requete->bindParam(':duree', $duree, PDO::PARAM_INT);
        $requete->bindParam(':jdc', $jdc, PDO::PARAM_INT);
        $requete->bindParam(':prive', $prive, PDO::PARAM_INT);
        $requete->bindParam(':motif', $motif, PDO::PARAM_STR);
        $requete->bindParam(':traitement', $traitement, PDO::PARAM_STR);
        $requete->bindParam(':aSuivre', $aSuivre, PDO::PARAM_STR);
        $requete->bindParam(':anneeScolaire', $anneeScolaire, PDO::PARAM_STR, 9);

        $resultat = $requete->execute();

        // les ajouts d'élèves sont toujours considérés comme de nouvelles visites
        if (isset($post['elevesPlus'])) {
            $sql = 'INSERT INTO '.PFX.'athena ';
            $sql .= 'SET matricule = :matricule, proprietaire = :proprietaire, date = :date, heure = :heure, duree = :duree, ';
            $sql .= 'jdc = :jdc, absent = :absent, prive = :prive, ';
            $sql .= 'envoyePar = :envoyePar, motif = :motif, traitement = :traitement, aSuivre = :aSuivre, anneeScolaire = :anneeScolaire ';
            $requete = $connexion->prepare($sql);

            $requete->bindParam(':proprietaire', $proprietaire, PDO::PARAM_STR, 7);
            $requete->bindParam(':envoyePar', $envoyePar, PDO::PARAM_STR, 7);
            $requete->bindParam(':matricule', $matricule, PDO::PARAM_INT);
            $requete->bindParam(':date', $date, PDO::PARAM_STR, 10);
            $requete->bindParam(':heure', $heure, PDO::PARAM_STR, 5);
            $requete->bindParam(':absent', $absent, PDO::PARAM_INT);
            $requete->bindParam(':duree', $duree, PDO::PARAM_INT);
            $requete->bindParam(':jdc', $jdc, PDO::PARAM_INT);
            $requete->bindParam(':prive', $prive, PDO::PARAM_INT);
            $requete->bindParam(':motif', $motif, PDO::PARAM_STR);
            $requete->bindParam(':traitement', $traitement, PDO::PARAM_STR);
            $requete->bindParam(':aSuivre', $aSuivre, PDO::PARAM_STR);
            $requete->bindParam(':anneeScolaire', $anneeScolaire, PDO::PARAM_STR, 9);

            foreach ($post['elevesPlus'] as $wtf => $matricule) {
                $requete->bindParam(':matricule', $matricule, PDO::PARAM_INT);
                $resultat += $requete->execute();
            }
        }

        Application::DeconnexionPDO($connexion);

        return $resultat;
    }

    /**
     * retourne la liste des visites au coaching pour un élève donné.
     *
     * @param int $matricule
     *
     * @return array
     */
     public function getSuiviEleve($matricule)
     {
         $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
         $sql = 'SELECT id, proprietaire, matricule, date, heure, envoyePar, motif, traitement, ';
         $sql .= 'prive, aSuivre, absent, duree, jdc ';
         $sql .= 'FROM '.PFX.'athena ';
         $sql .= 'WHERE matricule = :matricule AND proprietaire != "" ';
         $sql .= 'ORDER BY date DESC, heure DESC ';
         $requete = $connexion->prepare($sql);

 		$requete->bindParam(':matricule', $matricule, PDO::PARAM_INT);

         $resultat = $requete->execute();
         $liste = array();
         if ($resultat) {
             $requete->setFetchMode(PDO::FETCH_ASSOC);
             while ($ligne = $requete->fetch()) {
                 $id = $ligne['id'];
                 $ligne['date'] = Application::datePHP($ligne['date']);
                 $ligne['motif'] = htmlspecialchars($ligne['motif']);
                 $ligne['traitement'] = htmlspecialchars($ligne['traitement']);
                 $ligne['aSuivre'] = htmlspecialchars($ligne['aSuivre']);
                 $liste[$id] = $ligne;
             }
         }
         Application::DeconnexionPDO($connexion);

         return $liste;
     }

    /**
     * retourne les détails du contenu d'une visite d'élève à un suivi.
     *
     * @param int $id : l'identifiant de la visite
     * @param string $proprietaire : identifiant de l'utlisateur actuel (petite précaution de sécurité)
     *
     * @return array
     */
    public function getDetailsSuivi($id, $proprietaire)
    {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT id, proprietaire, matricule, date, heure, duree, envoyePar, motif, traitement, prive, aSuivre, absent, jdc ';
        $sql .= 'FROM '.PFX.'athena ';
        $sql .= 'WHERE id = :id AND proprietaire = :proprietaire ';
        $requete = $connexion->prepare($sql);

        $requete->bindParam(':proprietaire', $proprietaire, PDO::PARAM_STR, 7);
        $requete->bindParam(':id', $id, PDO::PARAM_INT);

        $resultat = $requete->execute();
        $visite = array();
        if ($resultat) {
            $requete->setFetchMode(PDO::FETCH_ASSOC);
            $visite = $requete->fetch();
            $visite['date'] = Application::datePHP($visite['date']);
        }
        Application::DeconnexionPDO($connexion);

        return $visite;
    }

    /**
     * supprime un item d'une liste de suivis d'élèversion_compare.
     *
     * @param $post : données provenant du formulaire d'effacement
     *
     * @return int : nombre de suppressions (normalement, 1)
     */
    public function delSuiviEleve($post)
    {
        $id = isset($post['id']) ? $post['id'] : null;
        $nb = 0;
        if ($id != null) {
            $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
            $sql = 'DELETE FROM '.PFX.'athena ';
            $sql .= "WHERE id='$id' ";
            $resultat = $connexion->exec($sql);
            $nb = $resultat;
            Application::DeconnexionPDO($connexion);
        }

        return $nb;
    }

     /**
      * liste des vistes au coaching. classées par date
      * dans une période entre $dateDebut et $dateFin.
      *
      * @param $dateDebut
      * @param $dateFin
      *
      * @return array
      */
     public static function listeSuiviParDate($dateDebut, $dateFin)
     {
         $listeConsultations = array();
         if ($dateDebut && $dateFin) {
             $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
             $sql = 'SELECT id, '.PFX.'athena.matricule, date, heure, nom, prenom, ';
             $sql .= 'classe, motif, traitement, aSuivre, absent, jdc ';
             $sql .= 'FROM '.PFX.'athena AS at ';
             $sql .= 'JOIN '.PFX.'eleves AS de ON (de.matricule = at.matricule) ';
             $sql .= "WHERE ((date >= '$dateDebut') AND (date <= '$dateFin')) ";
             $sql .= 'ORDER BY date, classe, heure, nom ';
             $resultat = $connexion->query($sql);
             $liste = array();
             if ($resultat) {
                 $resultat->setFetchMode(PDO::FETCH_ASSOC);
                 while ($ligne = $resultat->fetch()) {
                     $date = $ligne['date'];
                     $matricule = $ligne['matricule'];
                     $suiviID = $ligne['suiviID'];
                     $liste[$date][$matricule][$suiviID] = $ligne;
                 }
             }
             Application::DeconnexionPDO($connexion);
         }

         return $liste;
     }

     /**
      * recherche les infos EBS pour un élève dont on fournit le matricule
      *
      * @param int $matricule
      *
      * @return array
      */
     public function getEBSeleve($matricule){
         $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
         $sql = 'SELECT matricule, etr.idTrouble ';
         $sql .= 'FROM '.PFX.'EBSelevesTroubles AS etr ';
         $sql .= 'JOIN '.PFX.'EBStroubles AS tr ON etr.idTrouble = tr.idTrouble ';
         $sql .= 'WHERE matricule = :matricule ';
         $requete = $connexion->prepare($sql);

         $listeTroubles = array('troubles' => array(), 'amenagements' => array(), 'memo' => '');

         $requete->bindParam(':matricule', $matricule, PDO::PARAM_INT);

         $resultat = $requete->execute();

         if ($resultat) {
            $requete->setFetchMode(PDO::FETCH_ASSOC);
            while ($ligne = $requete->fetch()){
                $id = $ligne['idTrouble'];
                array_push($listeTroubles['troubles'], $id);
            }
         }

         $sql = 'SELECT matricule, eam.idAmenagement ';
         $sql .= 'FROM '.PFX.'EBSelevesAmenagements AS eam ';
         $sql .= 'JOIN '.PFX.'EBSamenagements AS am ON eam.idAmenagement = am.idAmenagement ';
         $sql .= 'WHERE matricule = :matricule ';
         $requete = $connexion->prepare($sql);

         $requete->bindParam(':matricule', $matricule, PDO::PARAM_INT);
         $resultat = $requete->execute();

         if ($resultat){
             $requete->setFetchMode(PDO::FETCH_ASSOC);
             while ($ligne = $requete->fetch()){
                 $id = $ligne['idAmenagement'];
                 array_push($listeTroubles['amenagements'], $id);
             }
         }

         $sql = 'SELECT matricule, memo ';
         $sql .= 'FROM '.PFX.'EBSdata ';
         $sql .= "WHERE matricule = :matricule ";
         $requete = $connexion->prepare($sql);

         $requete->bindParam(':matricule', $matricule, PDO::PARAM_INT);
         $resultat = $requete->execute();

         if ($resultat){
            $requete->setFetchMode(PDO::FETCH_ASSOC);
            $ligne = $requete->fetch();
             $listeTroubles['memo'] = $ligne['memo'];
            };

         Application::deconnexionPDO($connexion);

         return $listeTroubles;
     }

     /**
      * renvoie la liste de tous les troubles EBS recensés
      *
      * @param void
      *
      * @return array
      */
     public function getTroublesEBS(){
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT idTrouble, trouble ';
        $sql .= 'FROM '.PFX.'EBStroubles ';
        $sql .= 'ORDER BY trouble ';
        $requete = $connexion->prepare($sql);

        $liste = array();
        $resultat = $requete->execute();
        if ($resultat){
            $requete->setFetchMode(PDO::FETCH_ASSOC);
            while ($ligne = $requete->fetch()){
                $id = $ligne['idTrouble'];
                $liste[$id] = $ligne['trouble'];
            }
        }

        Application::deconnexionPDO($connexion);

        return $liste;
     }

     /**
      * ajoute un nouveau item dans la table des troubles EBS
      *
      * @param string $trouble
      *
      * @return int : nombre d'insertion dans la BD (0 ou 1)
      */
     public function addTrouble($trouble){
         $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
         $sql = 'INSERT IGNORE INTO '.PFX.'EBStroubles ';
         $sql .= 'SET trouble = :trouble ';
         $requete = $connexion->prepare($sql);

         $requete->bindParam(':trouble', $trouble, PDO::PARAM_STR, 50);

         $resultat = $requete->execute();

         Application::deconnexionPDO($connexion);

         return $resultat;
     }

     /**
      * ajoute un nouvel item dans la liste des aménagements EBS
      *
      * @param string $amenagement
      *
      * @return int : nombre d'insertions (0 ou 1)
      */
     public function addAmenagement($amenagement) {
         $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
         $sql = 'INSERT IGNORE INTO '.PFX.'EBSamenagements ';
         $sql .= 'SET amenagement = :amenagement ';
         $requete = $connexion->prepare($sql);

         $requete->bindParam(':amenagement', $amenagement, PDO::PARAM_STR, 50);

         $resultat = $requete->execute();

         Application::deconnexionPDO($connexion);

         return $resultat;
     }

     /**
      * renvoie la liste de tous les aménagements EBS recensés
      *
      * @param void
      *
      * @return array
      */
     public function getAmenagementsEBS(){
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT idAmenagement, amenagement ';
        $sql .= 'FROM '.PFX.'EBSamenagements ';
        $sql .= 'ORDER BY amenagement ';
        $requete = $connexion->prepare($sql);

        $liste = array();
        $resultat = $requete->execute();
        if ($resultat){
            $requete->setFetchMode(PDO::FETCH_ASSOC);
            while ($ligne = $requete->fetch()){
                $id = $ligne['idAmenagement'];
                $liste[$id] = $ligne['amenagement'];
            }
        }

        Application::deconnexionPDO($connexion);

        return $liste;
     }

     /**
      * Enregistre le contenu du mémo EBS
      *
      * @param int $matricule
      * @param string $memo
      *
      * @return int
      */
     public function saveMemo($matricule, $memo){
         $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
         $sql = 'INSERT INTO '.PFX.'EBSdata ';
         $sql .= 'SET matricule = :matricule, memo = :memo ';
         $sql .= 'ON DUPLICATE KEY UPDATE memo = :memo ';
         $requete = $connexion->prepare($sql);

         $requete->bindParam(':matricule', $matricule, PDO::PARAM_INT);
         $requete->bindParam(':memo', $memo, PDO::PARAM_STR);

         $resultat = $requete->execute();

         Application::deconnexionPDO($connexion);

         return $resultat;
     }

     /**
      * Enregistre les troubles présentés par un élève dont on fournit le matricule
      *
      * @param int $matricule
      * @param $listeTroubles : tous les troubles existants
      * @param $troubles : les troubles présents chez l'élève
      *
      * @return int : le nombre d'enregistrements
      */
     public function saveTroubles($matricule, $listeTroubles, $troubles){
         $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
         $sqlAdd = 'INSERT IGNORE INTO '.PFX.'EBSelevesTroubles ';
         $sqlAdd .= 'SET matricule = :matricule, idTrouble = :idTrouble ';
         $requeteAdd = $connexion->prepare($sqlAdd);
         $requeteAdd->bindParam(':matricule', $matricule, PDO::PARAM_INT);

         $sqlRemove = 'DELETE FROM '.PFX.'EBSelevesTroubles ';
         $sqlRemove .= 'WHERE matricule = :matricule AND idTrouble = :idTrouble ';
         $requeteRemove = $connexion->prepare($sqlRemove);
         $requeteRemove->bindParam(':matricule', $matricule, PDO::PARAM_INT);

         $nb = 0;
         foreach ($listeTroubles as $idTrouble => $denomination) {
             if (in_array($idTrouble, $troubles)) {
                 $requeteAdd->bindParam(':idTrouble', $idTrouble, PDO::PARAM_INT);
                 $resultat = $requeteAdd->execute();
             }
             else {
                 $requeteRemove->bindParam(':idTrouble', $idTrouble, PDO::PARAM_INT);
                 $resultat = $requeteRemove->execute();
             }
             $nb += $resultat;
         }

         Application::deconnexionPDO($connexion);

         return $nb;
     }

     /**
      * Enregistre les aménagements pour un élève dont on fournit le matricule
      *
      * @param int $matricule
      * @param $listeAmenagements : tous les aménagements existants
      * @param $amenagements : les amenagements réalisés chez l'élève
      *
      * @return int : le nombre d'enregistrements
      */
     public function saveAmenagements($matricule, $listeAmenagements, $amenagements){
         $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
         $sqlAdd = 'INSERT IGNORE INTO '.PFX.'EBSelevesAmenagements ';
         $sqlAdd .= 'SET matricule = :matricule, idAmenagement = :idAmenagement ';
         $requeteAdd = $connexion->prepare($sqlAdd);
         $requeteAdd->bindParam(':matricule', $matricule, PDO::PARAM_INT);

         $sqlRemove = 'DELETE FROM '.PFX.'EBSelevesAmenagements ';
         $sqlRemove .= 'WHERE matricule = :matricule AND idAmenagement = :idAmenagement ';
         $requeteRemove = $connexion->prepare($sqlRemove);
         $requeteRemove->bindParam(':matricule', $matricule, PDO::PARAM_INT);

         $nb = 0;
         foreach ($listeAmenagements as $idAmenagement => $denomination) {
             if (in_array($idAmenagement, $amenagements)) {
                 $requeteAdd->bindParam(':idAmenagement', $idAmenagement, PDO::PARAM_INT);
                 $resultat = $requeteAdd->execute();
             }
             else {
                 $requeteRemove->bindParam(':idAmenagement', $idAmenagement, PDO::PARAM_INT);
                 $resultat = $requeteRemove->execute();
             }
             $nb += $resultat;
         }

         Application::deconnexionPDO($connexion);

         return $nb;
     }


     /**
      * si une photo est présente, retourne le matricule de l'élève; sinon, retourne la chaîne 'nophoto'.
      *
      * @param $acronyme
      *
      * @return string
      */
     public static function photo($matricule)
     {
         if (file_exists(INSTALL_DIR."/photos/$matricule.jpg")) {
             return $matricule;
         } else {
             return 'nophoto';
         }
     }

     /**
      * recherche la liste des élèves suivis par l'utlisateur $acronyme.
      *
      * @param string $acronyme
      *
      * @return array
      */
     public static function getEleveUser($acronyme, $dateDebut=null, $dateFin=null, $tri='chrono', $anneeScolaire=null, $sansRV = false)
     {
         $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
         $sql = "SELECT anneeScolaire, da.matricule, DATE_FORMAT(date,'%d/%m/%Y') AS laDate, DATE_FORMAT(heure,'%H:%i') AS heure, ";
         $sql .= 'absent, nom, prenom, groupe ';
         $sql .= 'FROM '.PFX.'athena AS da ';
         $sql .= 'JOIN '.PFX.'eleves AS de ON de.matricule = da.matricule ';
         $sql .= "WHERE proprietaire = '$acronyme' ";
         if ($sansRV == true) {
            $sql .= "AND date IS Null ";
            }
            else {
                $sql .= "AND date IS NOT NULL ";
            }

         if ($dateDebut != null) {
             $sql .= "AND date >= '$dateDebut' ";
         }
         if ($dateFin != null) {
             $sql .= "AND date <= '$dateFin' ";
         }
         if ($anneeScolaire != null) {
             $sql .= "AND anneeScolaire = '$anneeScolaire' ";
         }
         switch ($tri) {
            case 'alpha':
                $sql .= 'ORDER BY nom, prenom ';
                break;
            case 'classeAlpha':
                $sql .= 'ORDER BY groupe ASC, nom, prenom ';
                break;
            case 'chrono':
               $sql .= 'ORDER BY date DESC, heure ASC ';
               break;
         }

         $resultat = $connexion->query($sql);
         $liste = array();
         $n = 0;
         if ($resultat) {
             $resultat->setFetchMode(PDO::FETCH_ASSOC);
             while ($ligne = $resultat->fetch()) {
                 $anneeScolaire = $ligne['anneeScolaire'];
                 $date = ($ligne['laDate'] != '') ? $ligne['laDate'] : $n++;
                 $matricule = $ligne['matricule'];
                 $ligne['photo'] = self::photo($matricule);
                 $liste[$anneeScolaire][$matricule][$date] = $ligne;
             }
         }
         Application::DeconnexionPDO($connexion);

         return $liste;
     }

     /**
     * liste de tous les élèves ayant fréquenté le coaching
     *
     * @param void
     *
     * @return array
     */
     public static function clientCoaching() {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT da.matricule, proprietaire, de.nom, de.prenom, groupe, dp.nom AS nomCoach, dp.prenom AS prenomCoach ';
        $sql .= 'FROM '.PFX.'athena AS da ';
        $sql .= 'JOIN '.PFX.'eleves AS de ON de.matricule = da.matricule ';
        $sql .= 'LEFT JOIN '.PFX.'profs AS dp ON dp.acronyme = proprietaire ';
        $sql .= "WHERE proprietaire != '' ";
        $sql .= 'ORDER BY nom, prenom, date ';

        $resultat = $connexion->query($sql);
        $liste = array();
        if ($resultat) {
            $resultat->setFetchMode(PDO::FETCH_ASSOC);
            while ($ligne = $resultat->fetch()) {
                $matricule = $ligne['matricule'];
                $classe = $ligne['groupe'];
                $niveau = substr($classe, 0, 1);
                $coach = $ligne['proprietaire'];
                if(!(isset($liste[$niveau][$matricule]))) {
                    $liste[$niveau][$matricule]['eleve'] = array('classe'=>$ligne['groupe'], 'nom'=>sprintf('%s %s', $ligne['nom'], $ligne['prenom']));
                    $liste[$niveau][$matricule]['coaches'][$coach] = array('nomCoach'=> sprintf('%s %s', $ligne['prenomCoach'], $ligne['nomCoach']), 'nb'=>1);
                }
                else {
                    if (!(isset($liste[$niveau][$matricule]['coaches'][$coach]))) {
                        $liste[$niveau][$matricule]['coaches'][$coach] = array('nomCoach'=> sprintf('%s %s', $ligne['prenomCoach'], $ligne['nomCoach']), 'nb'=>1);
                    }
                    else {
                        $liste[$niveau][$matricule]['coaches'][$coach]['nb']++;
                    }
                }
            }
        }
        Application::DeconnexionPDO($connexion);

        return $liste;
     }

     /**
      * enregistre une demande de suivi d'un élève (demande issu du formulaire ad-hoc)
      *
      * @param array $post : cntenu du formulaire de demande
      *
      * @return int l'identifiant du nouvel enregistremnt
      */
     public function saveEleveASuivre($post) {
         $id = isset($post['id']) ? $post['id'] : Null;
         $matricule = isset($post['matricule']) ? $post['matricule'] : Null;
         $anneeScolaire = isset($post['anneeScolaire']) ? $post['anneeScolaire'] : Null;
         $urgence = isset($post['urgence']) ? $post['urgence'] : Null;
         $envoyePar = isset($post['envoyePar']) ? $post['envoyePar'] : Null;
         $date = isset($post['date']) ? $post['date'] : Null;
         $date = Application::dateMySQL($date);
         $motif = isset($post['motif']) ? $post['motif'] : Null;

         $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
         if ($id == Null) {
            $sql = 'INSERT INTO '.PFX.'athena ';
            $sql .= 'SET matricule = :matricule, envoyePar = :envoyePar, anneeScolaire = :anneeScolaire, ';
            $sql .= 'proprietaire = "", date = NOW(), heure = "", motif = :motif, traitement = "", prive = 0, aSuivre = "" ';
            $requete = $connexion->prepare($sql);
         }
        else {
            $sql = 'UPDATE '.PFX.'athena ';
            $sql .= 'SET matricule = :matricule, envoyePar = :envoyePar, anneeScolaire = :anneeScolaire, ';
            $sql .= 'proprietaire = "", heure = "", date = :date, motif = :motif, traitement = "", prive = 0, aSuivre = "" ';
            $sql .= 'WHERE id = :id ';
            $requete = $connexion->prepare($sql);
        }

        $requete->bindParam(':matricule', $matricule, PDO::PARAM_INT);
        $requete->bindParam(':envoyePar', $envoyePar, PDO::PARAM_STR, 7);
        $requete->bindParam(':anneeScolaire', $anneeScolaire, PDO::PARAM_STR, 9);
        $requete->bindParam(':motif', $motif, PDO::PARAM_STR);

        if ($id != Null) {
            $requete->bindParam(':id', $id, PDO::PARAM_INT);
            $requete->bindParam(':date', $date, PDO::PARAM_STR);
            $resultat = $requete->execute();
            $lastId = $id;
            }
            else {
                $resultat = $requete->execute();
                $lastId = $connexion->lastInsertId();
            }

        Application::deconnexionPDO($connexion);

        return $lastId;
     }

     /**
      * enregistre la date de la demande et le niveau d'urgence pour une demande de suivi
      *
      * @param int $id : l'identifiant dans la table didac_athena
      * @param string $date : la date de la demande
      * @param int $urgence : le niveau d'urgence de la demande
      *
      * @return boolean : enregistrement effectué?
      */
      public function saveDemandeSuivi($id, $date, $urgence) {
          $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
          $sql = 'INSERT INTO '.PFX.'athenaDemandes ';
          $sql .= 'SET id = :id, date = :date, urgence = :urgence ';
          $sql .= 'ON DUPLICATE KEY UPDATE date = :date, urgence = :urgence ';
          $requete = $connexion->prepare($sql);

          $requete->bindParam(':id', $id, PDO::PARAM_INT);
          $requete->bindParam(':date', $date, PDO::PARAM_STR, 10);
          $requete->bindParam(':urgence', $urgence, PDO::PARAM_INT);

          $resultat = $requete->execute();

          Application::deconnexionPDO($connexion);

          return $resultat;
      }

      /**
       * recherche les demandes de prise en charge d'élèves
       *
       * @param void
       *
       * @return array
       */
        public function getDemandesSuivi(){
            $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
            $sql = 'SELECT dad.id, dad.date, urgence, da.matricule, nom, prenom, groupe, motif, envoyePar ';
            $sql .= 'FROM '.PFX.'athenaDemandes AS dad ';
            $sql .= 'JOIN '.PFX.'athena AS da ON da.id = dad.id ';
            $sql .= 'JOIN '.PFX.'eleves AS de ON de.matricule = da.matricule ';
            $sql .= 'ORDER BY dad.date, urgence DESC ';
            $requete = $connexion->prepare($sql);

            $liste = array();
            $resultat = $requete->execute();
            if ($resultat) {
                $requete->setFetchMode(PDO::FETCH_ASSOC);
                while ($ligne = $requete->fetch()) {
                    $id = $ligne['id'];
                    $ligne['motif'] = strip_tags($ligne['motif']);
                    $liste[$id] = $ligne;
                    }
                }

              Application::deconnexionPDO($connexion);

              return $liste;
          }

    /**
     * recherche les détails d'une demande de suivi dont on fournit l'id
     *
     * @param int $id
     *
     * @return array
     */
    public function getDemandeSuivi($id){
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT dad.id, dad.date, urgence, motif, envoyePar, dp.nom AS nomProf, dp.prenom AS prenomProf, ';
        $sql .= 'da.matricule, de.nom, de.prenom, groupe  ';
        $sql .= 'FROM '.PFX.'athenaDemandes AS dad ';
        $sql .= 'JOIN '.PFX.'athena AS da ON da.id = dad.id ';
        $sql .= 'JOIN '.PFX.'eleves AS de ON de.matricule = da.matricule ';
        $sql .= 'LEFT JOIN '.PFX.'profs AS dp ON dp.acronyme = envoyePar ';
        $sql .= 'WHERE dad.id = :id ';
        $requete = $connexion->prepare($sql);

        $requete->bindParam(':id', $id, PDO::PARAM_INT);
        $demande = array();
        $resultat = $requete->execute();
        if ($resultat) {
            $demande = $requete->fetch();
        }

        Application::deconnexionPDO($connexion);

        return $demande;
    }

    /**
     * renvoie la liste des intervenants qui ont déjà pris l'élève $matricule en charge
     *
     * @param int $matricule
     *
     * @return array
     */
    public function getCoachesDe($matricule) {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT DISTINCT proprietaire, CONCAT(dp.prenom," ", dp.nom) AS nomProf ';
        $sql .= 'FROM '.PFX.'athena ';
        $sql .= 'JOIN '.PFX.'profs AS dp ON dp.acronyme = proprietaire ';
        $sql .= 'WHERE matricule = :matricule ';
        $sql .= 'ORDER BY proprietaire ';
        $requete = $connexion->prepare($sql);

        $requete->bindParam(':matricule', $matricule, PDO::PARAM_INT);
        $liste = array();

        $resultat = $requete->execute();
        if ($resultat){
            $requete->setFetchMode(PDO::FETCH_ASSOC);
            while ($ligne = $requete->fetch()) {
                $acronyme = $ligne['proprietaire'];
                $liste[$acronyme] = $ligne;
            }
        }

        Application::deconnexionPDO($connexion);

        return $liste;
    }

    /**
     * indique la prise en charge d'un élève par le coach $acronyme dans la base de données pour la demande $id
     *
     * @param int $id
     * @param string $acronyme
     *
     * @return bool : la transaction s'est bien passée
     */
    public function adopterDemande($id, $acronyme){
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'UPDATE '.PFX.'athena ';
        $sql .= 'SET proprietaire = :acronyme ';
        $sql .= 'WHERE id = :id ';
        $requete = $connexion->prepare($sql);

        $requete->bindParam(':id', $id, PDO::PARAM_INT);
        $requete->bindParam(':acronyme', $acronyme, PDO::PARAM_STR, 7);

        $resultat = $requete->execute();

        $sql = 'DELETE FROM '.PFX.'athenaDemandes ';
        $sql .= 'WHERE id = :id ';
        $requete = $connexion->prepare($sql);
        $requete->bindParam(':id', $id, PDO::PARAM_INT);

        $resultat = $requete->execute();

        Application::deconnexionPDO($connexion);

        return $resultat;
    }

    /**
     * retourne la liste des années scolaires disponibles dans les fiches d'élèves
     *
     * @param void
     *
     * @return array
     */
    public function getListeAnneesScolaires(){
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT DISTINCT anneeScolaire ';
        $sql .= 'FROM '.PFX.'athena ';
        $sql .= 'ORDER BY anneeScolaire ';
        $requete = $connexion->prepare($sql);

        $liste = array();
        $resultat = $requete->execute();
        if ($resultat) {
            $requete->setFetchMode(PDO::FETCH_ASSOC);
            while ($ligne = $requete->fetch()){
                $liste[] = $ligne['anneeScolaire'];
            }
        }

        Application::deconnexionPDO($connexion);

        return $liste;
    }

    /**
     * recherche toutes les remédiations pour un niveau d'étude donné
     * entre deux dates données
     *
     * @param int $niveau
     * @param string $dateFrom
     * @param string $dateTo
     *
     * @return array
     */
    public function getRemed4niveauDates($niveau, $dateFrom, $dateTo){
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT offre.idOffre, offre.acronyme, title, nom, prenom, sexe, startDate, endDate ';
        $sql .= 'FROM '.PFX.'remediationOffre AS offre ';
        $sql .= 'JOIN '.PFX.'profs AS profs ON profs.acronyme = offre.acronyme ';
        $sql .= 'JOIN '.PFX.'remediationCibles AS cible ON cible.idOffre = offre.idOffre ';
        $sql .= 'WHERE startDate BETWEEN :dateFrom AND :dateTo AND cible = :niveau ';
        $sql .= 'ORDER BY nom, prenom ';
        $requete = $connexion->prepare($sql);

        $requete->bindParam(':niveau', $niveau, PDO::PARAM_INT);
        $requete->bindParam(':dateFrom', $dateFrom, PDO::PARAM_STR, 10);
        $requete->bindParam(':dateTo', $dateTo, PDO::PARAM_STR, 10);

        $liste = array();
        $resultat = $requete->execute();
        if ($resultat){
            $requete->setFetchMode(PDO::FETCH_ASSOC);
            while ($ligne = $requete->fetch()){
                $idOffre = $ligne['idOffre'];
                // $ligne['startDate'] = Application::datePHP($ligne['startDate']);
                $liste[$idOffre] = $ligne;
            }
        }

        Application::deconnexionPDO($connexion);

        return $liste;
    }
}
