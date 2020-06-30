<?php
/*
 * class padEleve
 */
class padEleve
{
    private $matricule;
    private $proprio;    // propriétaire du pad (utilisateur ou application)
    private $pads = array('proprio' => array(), 'guest' => array());

    /**
     * constructeur de la class.
     *
     * @param $matricule
     * @param $proprio
     */
    public function __construct($matricule, $proprio)
    {
        if (isset($matricule)) {
            $this->matricule = $matricule;
            $this->proprio = $proprio;
            $this->setPadsEleve();
        }
    }

    /**
     * recherche les informations sur l'élève dans la BD en limitant celles qui appartiennent à $proprio.
     *
     * @param void
     */
    private function setPadsEleve()
    {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        // création d'un pad pour l'utilisateur et le matricule donné si celui-ci n'existe pas encore
        $sql = 'INSERT IGNORE INTO '.PFX.'pad ';
        $sql .= 'SET matricule = :matricule, proprio= :proprio ';
        $requete = $connexion->prepare($sql);

        $requete->bindParam(':matricule', $this->matricule, PDO::PARAM_INT);
        $requete->bindParam(':proprio', $this->proprio, PDO::PARAM_STR, 7);

        $resultat = $requete->execute();

        // sélection du pad propriétaire (y compris celui qui vient éventuellement d'être créé)
        $sql = 'SELECT id, proprio, texte ';
        $sql .= 'FROM '.PFX.'pad ';
        $sql .= "WHERE proprio = :proprio AND matricule = :matricule ";
        $requete = $connexion->prepare($sql);
        $requete->bindParam(':matricule', $this->matricule, PDO::PARAM_INT);
        $requete->bindParam(':proprio', $this->proprio, PDO::PARAM_STR, 7);

        $resultat = $requete->execute();

        $requete->setFetchMode(PDO::FETCH_ASSOC);

        $ligneProprio = $requete->fetch();
        $id = $ligneProprio['id'];
        $texte = $ligneProprio['texte'];
        $this->pads['proprio'][$id] = array('proprio' => $this->proprio, 'mode' => 'rw', 'texte' => $texte);

        // sélection des pads dont l'utilisateur est "guest" pour le matricule d'élève courant
        $sql = 'SELECT dpg.id, proprio, mode, texte ';
        $sql .= 'FROM '.PFX.'padGuest AS dpg ';
        $sql .= 'JOIN '.PFX.'pad AS dp ON dp.id = dpg.id ';
        $sql .= 'WHERE dpg.id IN (SELECT id FROM '.PFX."pad WHERE matricule = :matricule AND guest = :proprio) ";
        $sql .= 'ORDER BY proprio ';
        $requete = $connexion->prepare($sql);

        $requete->bindParam(':matricule', $this->matricule, PDO::PARAM_INT);
        $requete->bindParam(':proprio', $this->proprio, PDO::PARAM_STR, 7);

        $resultat = $requete->execute();
        $guest = array();
        if ($resultat) {
            $requete->setFetchMode(PDO::FETCH_ASSOC);
            while ($ligne = $requete->fetch()) {
                $id = $ligne['id'];
                $mode = $ligne['mode'];
                $texte = stripslashes($ligne['texte']);
                $proprio = $ligne['proprio'];
                $this->pads['guest'][$id] = array('proprio' => $proprio, 'mode' => $mode, 'texte' => $texte);
            }
        }

        Application::DeconnexionPDO($connexion);
    }

    /**
     * renvoie les textes du bloc-notes.
     *
     * @param void()
     *
     * @return string
     */
    public function getPads()
    {
        return $this->pads;
    }

    /**
     * enregistrement des données élèves
     * $POST provient du $_POST de la fiche et peut contenir diverses données
     * on en extrait:
     *  - le champ texte_ID dont le nom comtient l'ID du texte éventuellement existant.
     *
     * @param array $post
     *
     * @return int
     */
    public function savePadEleve($post)
    {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $nb = 0;
        foreach ($post as $field => $value) {
            // on enregistre les champs nommés "texte_"
            if (substr($field, 0, 6) == 'texte_') {
                $id = explode('_', $field);
                $id = $id[1];
                $texte = $value;
                $sql = 'UPDATE '.PFX.'pad ';
                $sql .= 'SET texte = :texte ';
                $sql .= 'WHERE id = :id ';
                $requete = $connexion->prepare($sql);

                $requete->bindParam(':id', $id, PDO::PARAM_INT);
                $requete->bindParam(':texte', $texte, PDO::PARAM_STR);

                $nb += $requete->execute();

                $this->texte = $texte;
            }
        }
        Application::DeconnexionPDO($connexion);

        return $nb; // nombre de lignes modifiées dans la BD
    }

    /**
     * mise à jour d'un padEleve dont on fournit l'ID, le matricule de l'élève et le texte
     *
     * @param int $idPad
     * @param int $matricule
     * @param string $texte
     *
     * @return int : nombre d'enregistrements réussis (0 ou 1)
     */
    public function updatePadEleve($idPad, $matricule, $texte){
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'UPDATE '.PFX.'pad ';
        $sql .= 'SET texte = :texte ';
        $sql .= 'WHERE ID = :idPad AND matricule = :matricule ';
        $requete = $connexion->prepare($sql);

        $requete->bindParam(':idPad', $idPad, PDO::PARAM_INT);
        $requete->bindParam(':matricule', $matricule, PDO::PARAM_INT);
        $requete->bindParam(':texte', $texte, PDO::PARAM_STR);

        $resultat = $requete->execute();

        $nb = $requete->rowCount();

        Application::DeconnexionPDO($connexion);

        return $nb;
    }

    /**
     * enregistrement des partages des fiches "élèves" entre utilisateurs.
     *
     * @param string $acronyme
     * @param string $moderw : mode de partage ('r','rw','')
     * @param array $listeEleves : liste des élèves
     * @param array $listeProfs : liste des profs
     *
     * @return int : nombre de modifications dans la BD
     */
    public static function savePartages($acronyme, $moderw, $listeEleves, $listeProfs)
    {
        $nbAjouts = 0;
        if ((count($listeEleves) != 0) && (count($listeProfs) != 0)) {
            $listeAcronymes = "'".implode("','", $listeProfs)."'";
            $listeMatricules = implode(',', $listeEleves);

            $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);

            // on traite d'abord le cas des autorisations de partage, on verra les "releases" après
            if (in_array($moderw, array('r', 'rw'))) {

                foreach ($listeEleves as $matricule) {
                    // on s'assure qu'il existe une fiche ou on la crée pour le couple acronyme/matricule
                    $sql = 'INSERT IGNORE INTO '.PFX.'pad ';
                    $sql .= "SET matricule='$matricule', proprio='$acronyme', texte=Null ";
                    $resultat = $connexion->exec($sql);
                }

                // on recherche les id's des fiches pour les couples acronyme/matricules à partager ou dé-partager
                $sql = 'SELECT id FROM '.PFX.'pad ';
                $sql .= "WHERE proprio ='$acronyme' AND matricule IN ($listeMatricules) ";
                $resultat = $connexion->query($sql);
                $resultat->setFetchMode(PDO::FETCH_ASSOC);
                $listeIds = $resultat->fetchAll();

                // on crée les guests dans la table padGuest
                foreach ($listeProfs as $unAcronyme) {
                    foreach ($listeIds as $wtf => $idArray) {
                        $id = $idArray['id'];
                        $sql = 'INSERT INTO '.PFX.'padGuest ';
                        $sql .= "SET id='$id', guest='$unAcronyme', mode='$moderw' ";
                        $sql .= "ON DUPLICATE KEY UPDATE mode='$moderw' ";
                        $nbAjouts += $connexion->exec($sql);
                    }
                }
            } else {
                // on recherche les id's des fiches pour les couples acronymes/matricules à partager ou dé-partager
                $sql = 'SELECT id FROM '.PFX.'pad ';
                $sql .= "WHERE proprio = '$acronyme' AND matricule IN ($listeMatricules) ";
                $resultat = $connexion->query($sql);
                $resultat->setFetchMode(PDO::FETCH_ASSOC);
                $listeIds = $resultat->fetchAll();
                // il s'agit de supprimer des guests => release
                foreach ($listeProfs as $unAcronyme) {
                    foreach ($listeIds as $wtf => $idArray) {
                        $id = $idArray['id'];
                        $sql = 'DELETE FROM '.PFX.'padGuest ';
                        $sql .= "WHERE id='$id' AND guest='$unAcronyme' ";
                        $nbAjouts -= $connexion->exec($sql);
                    }
                }
            }
            Application::DeconnexionPDO($connexion);
        }

        return $nbAjouts;
    }

    /**
     * renvoie la liste des partages (noms des profs) pour une liste d'élèves donnée pour un propriétaire donné.
     *
     * @param $acronyme : string
     * @param $listeEleves : array|string
     *
     * @return array
     */
    public static function listePartages($acronyme, $listeEleves)
    {
        if (is_array($listeEleves)) {
            $listeElevesString = implode(',', array_keys($listeEleves));
        } else {
            $listeElevesString = $listeEleves;
        }
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT matricule, dp.id, guest, mode ';
        $sql .= 'FROM '.PFX.'pad AS dp ';
        $sql .= 'JOIN '.PFX.'padGuest AS dpg ON dp.id = dpg.id ';
        $sql .= "WHERE matricule IN ($listeElevesString) AND proprio = '$acronyme' ";

        $resultat = $connexion->query($sql);
        $liste = array();
        if ($resultat) {
            $resultat->setFetchMode(PDO::FETCH_ASSOC);
            while ($ligne = $resultat->fetch()) {
                $matricule = $ligne['matricule'];
                $guest = $ligne['guest'];
                $mode = $ligne['mode'];
                $liste[$matricule][$guest] = array('id' => $ligne['id'], 'mode' => $ligne['mode']);
            }
        }
        Application::DeconnexionPDO($connexion);

        return $liste;
    }

    /**
     * Création d'une nouvelle matière dans le pad "coordinateur"
     *
     * @param int $matricule : matricule de l'élève
     * @param string $anScol : année scolaire en cours
     * @param int $periode : période de l'année scolaire
     * @param array $listeCoursGrp : cours et groupe
     *
     * @return int
     */
    public function createNewMatieres4pad($matricule, $anScol, $periode, $listeCoursGrp){
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'INSERT IGNORE INTO '.PFX.'padMatieres ';
        $sql .= 'SET matricule = :matricule, anScol = :anScol, periode = :periode, ';
        $sql .= 'coursGrp = :coursGrp, acronyme = :acronyme ';
        $requete = $connexion->prepare($sql);

        $requete->bindParam(':matricule', $matricule, PDO::PARAM_INT);
        $requete->bindParam(':anScol', $anScol, PDO::PARAM_STR, 9);
        $requete->bindParam(':periode', $periode, PDO::PARAM_INT);

        $nb = 0;
        foreach ($listeCoursGrp as $coursGrp => $data){
            $requete->bindParam(':coursGrp', $coursGrp, PDO::PARAM_STR, 15);
            $requete->bindParam(':acronyme', $data['acronyme'], PDO::PARAM_STR, 9);
            $resultat = $requete->execute();
            $nb += $requete->rowCount();
        }

        Application::DeconnexionPDO($connexion);

        return $nb;
    }

    /**
     * renvoie les matières présentes dans le volet "Matière" d'un pad "coordinateur" pour un élève donné
     * durant une année scolaire donnée et une période donnée
     * si $anScol et $periode ne sont pas donnés, renvoie tous les items de matières pour l'élève
     *
     * @param int $matricule : matricule de l'élève
     * @param string $anScol : année scolaire en cours
     * @param int $periode : période de l'année scolaire
     *
     * @return array
     */
    public function getMatieres4pad($matricule, $anScol = Null, $periode = Null){
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT matricule, anScol, periode, coursGrp, padM.acronyme, cause1, cause2, cause3, cause4, ';
        $sql .= 'autreCause, remediation, padM.acronyme, cours, libelle, nbheures ';
        $sql .= 'FROM '.PFX.'padMatieres AS padM ';
        // trouver le libellé du cours s'il existe encore
        $sql .= 'LEFT JOIN '.PFX.'cours AS cours ON cours.cours = SUBSTR(padM.coursGrp, 1, LOCATE("-", padM.coursGrp)-1) ';
        // trouver le nom du prof s'il est toujours présent dans l'école
        $sql .= 'LEFT JOIN '.PFX.'profs AS profs ON padM.acronyme = profs.acronyme ';
        $sql .= 'WHERE matricule = :matricule ';
        if (($anScol != Null) && ($periode != Null))
            $sql.=  'AND anScol = :anScol AND periode = :periode ';
        $sql .= 'ORDER BY coursGrp, anScol, periode ';
        $requete = $connexion->prepare($sql);

        $requete->bindParam(':matricule', $matricule, PDO::PARAM_INT);
        if (($anScol != Null) && ($periode != Null)) {
            $requete->bindParam(':anScol', $anScol, PDO::PARAM_STR, 9);
            $requete->bindParam(':periode', $periode, PDO::PARAM_INT);
        }
        $resultat = $requete->execute();

        $liste = array();
        if ($resultat){
            $requete->setFetchMode(PDO::FETCH_ASSOC);
            while ($ligne = $requete->fetch()){
                $anScol = $ligne['anScol'];
                $periode = $ligne['periode'];
                $coursGrp = $ligne['coursGrp'];
                if (($ligne['cause1'] == 0) AND
                    ($ligne['cause2'] == 0) AND
                    ($ligne['cause3'] == 0) AND
                    ($ligne['cause4'] == 0) AND
                    (($ligne['autreCause'] == Null) OR $ligne['autreCause'] == '') AND
                    (($ligne['remediation'] == Null) OR $ligne['remediation'] == ''))
                    $ligne['empty'] = 1;
                    else $ligne['empty'] = 0;
                $liste[$anScol][$periode][$coursGrp] = $ligne;
            }
        }

        Application::DeconnexionPDO($connexion);

        return $liste;
    }

    /**
     * renvoie las matières déjà présentes dans un pad pour un élève dans l'année scolaire et la période
     *
     * @param int $matricule
     * @param string $anScol
     * @param int $periode
     *
     * @return array : la liste des coursGrp
     */
    public function getCours4pad($matricule, $anScol, $periode){
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT coursGrp FROM '.PFX.'padMatieres ';
        $sql .= 'WHERE matricule = :matricule AND anScol = :anScol AND periode = :periode ';
        $sql .= 'ORDER BY coursGrp ';
        $requete = $connexion->prepare($sql);

        $requete->bindParam(':matricule', $matricule, PDO::PARAM_INT);
        $requete->bindParam(':anScol', $anScol, PDO::PARAM_STR, 9);
        $requete->bindParam(':periode', $periode, PDO::PARAM_INT);

        $liste = array();
        $resultat = $requete->execute();
        if ($resultat){
            $requete->setFetchMode(PDO::FETCH_ASSOC);
            while ($ligne = $requete->fetch()){
                $liste[] = $ligne['coursGrp'];
            }
        }

        Application::DeconnexionPDO($connexion);

        return $liste;
    }

    /**
     * renvoie les informations de suivi scolaire pour le pad "coordinateur" pour un élève donné
     * si $anScol et $periode ne sont pas donnés, retourne toutes les informations pour toutes les périodes
     *
     * @param int $matricule : matricule de l'élève
     * @param string $anScol : année scolaire en cours
     * @param int $periode : période de l'année scolaire
     *
     * @return array
     */
    public function getSuivi4pad($matricule, $anScol = Null, $periode = Null){
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT * FROM '.PFX.'padSuivi ';
        $sql .= 'WHERE matricule = :matricule ';
        if (($anScol != Null) && ($periode != Null))
            $sql.=  'AND anScol = :anScol AND periode = :periode ';
        $sql .= 'ORDER BY anScol, periode ';
        $requete = $connexion->prepare($sql);

        $requete->bindParam(':matricule', $matricule, PDO::PARAM_INT);
        if (($anScol != Null) && ($periode != Null)) {
            $requete->bindParam(':anScol', $anScol, PDO::PARAM_STR, 9);
            $requete->bindParam(':periode', $periode, PDO::PARAM_INT);
        }
        $resultat = $requete->execute();

        $liste = array();
        if ($resultat){
            $requete->setFetchMode(PDO::FETCH_ASSOC);
            while ($ligne = $requete->fetch()){
                $anScol = $ligne['anScol'];
                $periode = $ligne['periode'];
                $liste[$anScol][$periode] = $ligne;
            }
        }

        Application::DeconnexionPDO($connexion);

        return $liste;
    }

    /**
     * ajoute éventuellement la période de l'année scolaire demandée à la liste des onglets disponibles
     * pour le pad "coordinateur"
     *
     * @param string $anScol
     * @param int $periode
     *
     * @return int : nombre d'enregistrements (0 ou 1)
     */
    public function addPeriode($anScol, $periode) {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'INSERT IGNORE INTO '.PFX.'padPeriodes ';
        $sql .= 'SET anScol = :anScol, periode = :periode ';
        $requete = $connexion->prepare($sql);

        $requete->bindParam(':anScol', $anScol, PDO::PARAM_STR, 9);
        $requete->bindParam(':periode', $periode, PDO::PARAM_INT);

        $nb = 0;
        $resultat = $requete->execute();
        if ($resultat) {
            $nb = $requete->rowCount();
        }

        Application::DeconnexionPDO($connexion);

        return $nb;
    }

    /**
     * retoure les années scolaires et les périodes présentes dans les information du pad "direction"
     *
     * @param array $matieres4pad : liste des matières problématiques pour l'élève
     * @param array .....
     *
     * @return array
     */
    public function getAnPeriode(){
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT anScol, periode ';
        $sql .= 'FROM '.PFX.'padPeriodes ';
        $sql .= 'ORDER BY anScol, periode ';
        $requete = $connexion->prepare($sql);

        $liste = array();
        $resultat = $requete->execute();
        if ($resultat){
            $requete->setFetchMode(PDO::FETCH_ASSOC);
            while ($ligne = $requete->fetch()){
                $anScol = $ligne['anScol'];
                $periode = $ligne['periode'];
                $liste[] = array('anScol' => $anScol, 'periode' => $periode);
            }
        }

        Application::DeconnexionPDO($connexion);

        return $liste;
        }

     /**
      * retourne une liste des profs ou des membres du personnel.
      *
      * @param void
      *
      * @return array liste de tous les profs de l'école
      */
     public function dicoProfs()
     {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT profs.acronyme, sexe, nom, prenom FROM '.PFX.'profs AS profs ';
        $sql .= 'JOIN '.PFX.'profsCours AS pc ON (pc.acronyme = profs.acronyme) ';
        $resultat = $connexion->query($sql);
        $listeProfs = array();
        if ($resultat) {
            $resultat->setFetchMode(PDO::FETCH_ASSOC);
            while ($ligne = $resultat->fetch()) {
                $acronyme = $ligne['acronyme'];
                $listeProfs[$acronyme] = ($ligne['sexe'] == 'F') ? 'Mme ' : 'M. ';
                $listeProfs[$acronyme] .= $ligne['prenom'].' '.$ligne['nom'];
            }
        }
        Application::DeconnexionPDO($connexion);

        return $listeProfs;
     }

     /**
      * Enregistrement des informations "générales" de la fiche de l'élève
      *
      * @param array $form : le formulaire du coordinateur
      *
      * @return int : nombre d'enregistrements (0 ou 1)
      */
     public function saveFicheGenerale($form){
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'INSERT INTO '.PFX.'padSuivi ';
        $sql .= 'SET matricule = :matricule, anScol = :anScol, periode = :periode, ';
        $sql .= 'pp1 = :pp1, pp2 = :pp2, ppa = :ppa, ';
        $sql .= 'ff1 = :ff1, ff2 = :ff2, ';
        $sql .= 'poInterne = :pi, poExterne = :pe, ';
        $sql .= 'id1 = :id1, id2 = :id2, id3 = :id3, id4 = :id4, idTexte = :idTexte, ';
        $sql .= 'discipline = :discipline, priseEnCharge = :prEnCharge ';
        $sql .= 'ON DUPLICATE KEY UPDATE ';
        $sql .= 'pp1 = :pp1, pp2 = :pp2, ppa = :ppa, ';
        $sql .= 'ff1 = :ff1, ff2 = :ff2, ';
        $sql .= 'poInterne = :pi, poExterne = :pe, ';
        $sql .= 'id1 = :id1, id2 = :id2, id3 = :id3, id4 = :id4, idTexte = :idTexte, ';
        $sql .= 'discipline = :discipline, priseEnCharge = :prEnCharge ';
        $requete = $connexion->prepare($sql);

        $anScol = $form['anScol'];
        $periode = $form['periode'];
        $matricule = $form['matricule'];
        $requete->bindParam(':anScol', $anScol, PDO::PARAM_STR, 9);
        $requete->bindParam(':periode', $periode, PDO::PARAM_INT);
        $requete->bindParam(':matricule', $matricule, PDO::PARAM_INT);

        // poursuite du parcours
        $pp1 = isset($form['cbMeritant']) ? 1 : 0;
        $pp2 = isset($form['cbFacilite']) ? 1 : 0;
        $ppa = $form['meritant'];   // texte libre
        // $ppb = $form['facilite'];   // texte libre
        $requete->bindParam(':pp1', $pp1, PDO::PARAM_INT);
        $requete->bindParam(':pp2', $pp2, PDO::PARAM_INT);
        $requete->bindParam(':ppa', $ppa, PDO::PARAM_STR, 256);
        // $requete->bindParam(':ppb', $ppb, PDO::PARAM_STR, 128);
        //
        // // force et faiblesse
        $ff1 = $form['justification'];
        $ff2 = $form['remediation'];

        $requete->bindParam(':ff1', $ff1, PDO::PARAM_STR, 128);
        $requete->bindParam(':ff2', $ff2, PDO::PARAM_STR, 128);
        //
        // // projets interne et externe
        $pi = $form['orientationInterne'];
        $pe = $form['orientationExterne'];
        $requete->bindParam(':pi', $pi, PDO::PARAM_STR, 128);
        $requete->bindParam(':pe', $pe, PDO::PARAM_STR, 128);
        //
        // interventions demandées
        $id1 = isset($form['intervention1']) ? 1 : 0;
        $id2 = isset($form['intervention2']) ? 1 : 0;
        $id3 = isset($form['intervention3']) ? 1 : 0;
        $id4 = isset($form['intervention4']) ? 1 : 0;
        $idTexte = $form['intervention'];  // texte libre
        $requete->bindParam(':id1', $id1, PDO::PARAM_INT);
        $requete->bindParam(':id2', $id2, PDO::PARAM_INT);
        $requete->bindParam(':id3', $id3, PDO::PARAM_INT);
        $requete->bindParam(':id4', $id4, PDO::PARAM_INT);
        $requete->bindParam(':idTexte', $idTexte, PDO::PARAM_STR, 128);
        //
        $discipline = $form['discipline'];
        $prEnCharge = $form['prEnCharge'];
        $requete->bindParam(':discipline', $discipline, PDO::PARAM_STR, 128);
        $requete->bindParam(':prEnCharge', $prEnCharge, PDO::PARAM_STR, 128);

        $resultat = $requete->execute();

        $nb = $requete->rowCount();

        Application::DeconnexionPDO($connexion);

        return $nb;
     }

     /**
      * retourne l'acronyme du premier prof titulaire du cours $coursGrp
      *
      * @param string $coursGrp
      *
      * @return string
      */
     public function prof4coursGrp($coursGrp){
         $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
         $sql = 'SELECT acronyme FROM '.PFX.'profsCours ';
         $sql .= 'WHERE coursGrp = :coursGrp ';
         $requete = $connexion->prepare($sql);

         $requete->bindParam(':coursGrp', $coursGrp, PDO::PARAM_STR, 15);

         $acronyme = '';
         $resultat = $requete->execute();
         if ($resultat){
             $ligne = $requete->fetch();
             $acronyme = $ligne['acronyme'];
         }

         Application::DeconnexionPDO($connexion);

         return $acronyme;
     }

    /**
     * Enregistre les informations de "matières" de la fiche de l'élève dans le pad "coordinateur"
     *
     * @param array $form : le formulaire
     *
     * @return int : le nombre d'enregistrmeents (0 ou 1)
     */
    public function saveFicheMatiere($form){
        $matricule = $form['matricule'];
        $listeChampsMatiere = array();
        $fieldsModele = array(
            'cause1' => 0,   'cause2' => 0,   'cause3' => 0,
            'cause4' => 0,   'cause5' => Null,   'cause6' => NUll
            );
        foreach ($form AS $field => $value){
            if (substr($field, 0, 5) == 'cause') {
                $explodeField = explode('_', $field);
                $leChamp = $explodeField[0];
                $anScol = $explodeField[1];
                $periode = $explodeField[2];
                $coursGrp = str_replace('#', ' ', $explodeField[3]);
                $listeChampsMatiere[$coursGrp]['acronyme'] = $this->prof4coursGrp($coursGrp);
                $listeChampsMatiere[$coursGrp]['anScol'] = $anScol;
                $listeChampsMatiere[$coursGrp]['periode'] = $periode;
                $listeChampsMatiere[$coursGrp]['coursGrp'] = $coursGrp;
                if (!(isset($listeChampsMatiere[$coursGrp]['fields'])))
                    $listeChampsMatiere[$coursGrp]['fields'] = $fieldsModele;
                $listeChampsMatiere[$coursGrp]['fields'][$leChamp] = $value;
            }
        }

        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'INSERT INTO '.PFX.'padMatieres ';
        $sql .= 'SET matricule = :matricule, anScol = :anScol, periode = :periode, coursGrp = :coursGrp, ';
        $sql .= 'acronyme = :acronyme, ';
        $sql .= 'cause1 = :cause1, cause2 = :cause2, cause3 = :cause3, cause4 = :cause4, autreCause = :autreCause, ';
        $sql .= 'remediation = :remediation ';
        $sql .= 'ON DUPLICATE KEY UPDATE ';
        $sql .= 'acronyme = :acronyme, ';
        $sql .= 'cause1 = :cause1, cause2 = :cause2, cause3 = :cause3, cause4 = :cause4, autreCause = :autreCause, ';
        $sql .= 'remediation = :remediation ';
        $requete = $connexion->prepare($sql);

        $requete->bindParam(':matricule', $matricule, PDO::PARAM_INT);

        $nb = 0;
        foreach ($listeChampsMatiere AS $coursGrp => $data){
            $requete->bindParam(':anScol', $data['anScol'], PDO::PARAM_STR, 9);
            $requete->bindParam(':periode', $data['periode'], PDO::PARAM_INT);
            $requete->bindParam(':coursGrp', $data['coursGrp'], PDO::PARAM_STR, 15);
            $requete->bindParam(':acronyme', $data['acronyme'], PDO::PARAM_STR, 7);
            $requete->bindParam(':cause1', $data['fields']['cause1'], PDO::PARAM_STR, 128);
            $requete->bindParam(':cause2', $data['fields']['cause2'], PDO::PARAM_STR, 128);
            $requete->bindParam(':cause3', $data['fields']['cause3'], PDO::PARAM_STR, 128);
            $requete->bindParam(':cause4', $data['fields']['cause4'], PDO::PARAM_STR, 128);
            $requete->bindParam(':autreCause', $data['fields']['cause5'], PDO::PARAM_STR, 128);
            $requete->bindParam(':remediation', $data['fields']['cause6'], PDO::PARAM_STR, 128);
            $resultat = $requete->execute();
            $nb += $requete->rowCount();
        }

        Application::DeconnexionPDO($connexion);

        return $nb;
    }

    /**
     * suppression de la matiere $coursGrp pour l'élève $matricule à la période $periode
     * de l'année scolaire $anScol
     *
     * @param int $matricule
     * @param string $coursGrp
     * @param string anScol
     * @param int periode
     *
     * @return int : suppression réussies (0 ou 1)
     */
    public function delMatiere($matricule, $coursGrp, $anScol, $periode) {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'DELETE FROM '.PFX.'padMatieres ';
        $sql .= 'WHERE matricule = :matricule AND coursGrp = :coursGrp AND anScol = :anScol ';
        $sql .= 'AND periode = :periode ';
        $requete = $connexion->prepare($sql);

        $requete->bindParam(':matricule', $matricule, PDO::PARAM_INT);
        $requete->bindParam(':anScol', $anScol, PDO::PARAM_STR, 9);
        $requete->bindParam(':periode', $periode, PDO::PARAM_INT);
        $requete->bindParam(':coursGrp', $coursGrp, PDO::PARAM_STR, 15);

        $resultat = $requete->execute();

        $nb = $requete->rowCount();

        Application::DeconnexionPDO($connexion);

        return $nb;
    }

    /**
     * vérifie si l'utilisateur $acronyme est propriétaire du pad $id
     *
     * @param int $id : identifiant de la note pad
     * @param string $acronyme : l'utlisateur actuel
     *
     * @return bool
     */
    public function isOwner($acronyme, $id){
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT proprio, id ';
        $sql .= 'FROM '.PFX.'pad ';
        $sql .= 'WHERE id = :id AND proprio = :acronyme ';
        $requete = $connexion->prepare($sql);

        $requete->bindParam(':id', $id, PDO::PARAM_INT);
        $requete->bindParam(':acronyme', $acronyme, PDO::PARAM_STR, 7);

        $resultat = $requete->execute();
        if ($resultat) {
            $ligne = $requete->fetch();
        }

        Application::DeconnexionPDO($connexion);

        return $ligne != Null;
    }

    /**
     * interrompt le partage du pad id $id avec l'utilisateur $guest
     *
     * @param int $id : identifiant de la note pad
     * @param string $guest : acronyme de l'utilisateur guest
     *
     * @return int : nombre de suppressions de partage
     */
    public function unlink($guest, $id) {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'DELETE FROM '.PFX.'padGuest ';
        $sql .= 'WHERE id = :id AND guest = :guest ';
        $requete = $connexion->prepare($sql);

        $requete->bindParam(':id', $id, PDO::PARAM_INT);
        $requete->bindParam(':guest', $guest, PDO::PARAM_STR, 7);

        $resultat = $requete->execute();
        $nb = 0;
        if ($resultat){
            $nb = $requete->rowCount();
        }

        Application::DeconnexionPDO($connexion);

        return $nb;
    }

    /**
     * retourne l'image en base64 de l'horaire de l'élève $matricule depuis le répertoire $directory
     *
     * @param string $directory : le répertoire où se trouve l'image
     * @param int $matricule
     *
     * @return string
     */
     public function getHoraire($directory, $matricule){
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT nomImage, nomSimple ';
        $sql .= 'FROM '.PFX.'EDTeleves ';
        $sql .= 'WHERE matricule = :matricule ';
        $requete = $connexion->prepare($sql);

        $requete->bindParam(':matricule', $matricule, PDO::PARAM_INT);

        $src = '';
        $resultat = $requete->execute();
        if ($resultat) {
            $ligne = $requete->fetch();
            if (isset($ligne['nomImage']) && $ligne['nomImage'] != '') {
				$image = $directory.'/'.$ligne['nomImage'];
				if (file_exists($image)) {
					$imageData = base64_encode(file_get_contents($image));
					$src = 'data: '.mime_content_type($image).';base64,'.$imageData;
					}
				}
			}

        Application::deconnexionPDO($connexion);

        return $src;
    }

}
