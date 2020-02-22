<?php

/*
 * class presences
 */
class presences
{
    /*
     * __construct
     * @param
     */
    public function __construct()
    {
    }

    /**
     * renvoie la liste des heures de cours données dans l'école.
     *
     * @param void
     *
     * @return array liste des périodes de cours
     */
    public function lirePeriodesCours()
    {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT debut, fin ';
        $sql = "SELECT DATE_FORMAT(debut,'%H:%i') as debut, DATE_FORMAT(fin,'%H:%i') as fin ";
        $sql .= 'FROM '.PFX.'presencesHeures ';
        $sql .= 'ORDER BY debut, fin ';

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
      * Enregistrement des définitions des périodes de cours
      * renvoie le nombre d'enregistrements effectivement réalisés et la liste des erreurs.
      *
      * @param $post : ensemble des informations provenant du formulaire de définition des heures de cours
      *
      * @return array : résultat de l'enregistrement
      */
     public function enregistrerHeures($post)
     {
         $listeData = array();
         foreach ($post as $champ => $value) {
             $split = explode('_', $champ);
             $champ = isset($split[0]) ? $split[0] : null;

             if (in_array($champ, array('debut', 'fin', 'del'))) {
                 $periode = $split[1];
                 switch ($champ) {
                    case 'del':
                        $listeData[$periode] = array('debut' => null, 'fin' => null, 'del' => true);
                        break;
                    case 'debut':
                        $listeData[$periode]['debut'] = $value;
                        break;
                    case 'fin':
                        $listeData[$periode]['fin'] = $value;
                        break;
                }
             }
         }
         $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        // vider toute la table pour la ré-enregistrer de zéro
        $sql = 'TRUNCATE TABLE '.PFX.'presencesHeures ';
         $resultat = $connexion->exec($sql);

         $ok = 0;
         $ko = array();
         $sql = 'INSERT INTO '.PFX.'presencesHeures ';
         $sql .= 'SET debut=:debut, fin=:fin ';
         $requete = $connexion->prepare($sql);
         foreach ($listeData as $periode => $data) {
             // on n'enregistre que si "del" n'est pas coché
            if (!(isset($data['del']))) {
                $debut = $data['debut'];
                $fin = $data['fin'];
                $dataPrep = array(':debut' => $debut, ':fin' => $fin);
                $resultat = $requete->execute($dataPrep);
                if ($resultat == 1) {
                    ++$ok;
                } else {
                    $ko[] = $data;
                }
            }
         }
         Application::deconnexionPDO($connexion);

         return array('ok' => $ok, 'ko' => $ko);
     }

    /**
     * ajoute une période de cours dans la table de la base de données.
     *
     * @param void
     *
     * @return $nb nombre de périodes ajoutées (normalement, une seule)
     */
    public function ajoutPeriode()
    {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'INSERT INTO '.PFX.'presencesHeures ';
        $sql .= "SET debut='', fin='' ";
        $resultat = $connexion->exec($sql);
        Application::deconnexionPDO($connexion);

        return $resultat;
    }

    /**
     * retourne le numéro de la période actuelle.
     *
     * @param $listePeriodes : liste des périodes de cours, y compris les heures de début et de fin
     *
     * @return int => numéro de la période en cours
     */
    public function periodeActuelle($listePeriodes)
    {
        $heureActuelle = date('H:i');
        $trouve = false;
        $periode = 0;
        while (!($trouve) && ($periode < count($listePeriodes))) {
            ++$periode;
            $trouve = ($heureActuelle < $listePeriodes[$periode]['fin']);
        }

        return $periode;
    }

// ******************************************************************************************************

    /**
     * retourne la liste des présences et absences pour un élève et pour une série de dates données.
     *
     * @param int :         $matricule
     * @param array|string: $listeDates (au format PHP)
     *
     * @return array
     */
    public function listePresencesEleveMultiDates($listeDates, $matricule)
    {
        foreach ($listeDates as $k => $uneDate) {
            $listeDatesSQL[$k] = Application::dateMysql($listeDates[$k]);
        }
        $listeDatesString = "'".implode("','", $listeDatesSQL)."'";

        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT educ, periode, statut, date, quand, heure, parent, media ';
        $sql .= 'FROM '.PFX.'presencesEleves AS dpe ';
        $sql .= 'LEFT JOIN '.PFX.'presencesLogs AS dpl ON dpl.id = dpe.id ';
        $sql .= "WHERE matricule = '$matricule' ";
        $sql .= "AND date IN ($listeDatesString) ";
        $sql .= 'ORDER BY date ';

        $resultat = $connexion->query($sql);
        $liste = array();
        if ($resultat) {
            $resultat->setFetchMode(PDO::FETCH_ASSOC);
            while ($ligne = $resultat->fetch()) {
                $date = Application::datePHP($ligne['date']);
                $ligne['date'] = $date;
                $ligne['quand'] = APPLICATION::datePHP($ligne['quand']);
                $periode = $ligne['periode'];
                $liste[$date][$periode] = $ligne;
            }
        }
        Application::deconnexionPDO($connexion);

        $listePeriodes = self::lirePeriodesCours();

        $listePresences = array();
        foreach ($liste as $uneDate => $dataUneDate) {
            // on prépare une journée générique sans prise de présences
            foreach ($listePeriodes as $noPeriode => $wtf) {
                $listePresences[$uneDate][$noPeriode] = array('educ' => '', 'statut' => 'indetermine', 'quand' => '', 'heure' => '', 'parent' => '', 'media' => '');
            }
            // on ajoute les informations dont on dispose aux endroits ad hoc
            foreach ($dataUneDate as $noPeriode => $data) {
                $listePresences[$uneDate][$noPeriode]['educ'] = $data['educ'];
                $listePresences[$uneDate][$noPeriode]['statut'] = $data['statut'];
                $listePresences[$uneDate][$noPeriode]['quand'] = $data['quand'];
                $listePresences[$uneDate][$noPeriode]['heure'] = $data['heure'];
                $listePresences[$uneDate][$noPeriode]['parent'] = $data['parent'];
                $listePresences[$uneDate][$noPeriode]['media'] = $data['media'];
            }
        }

        return $listePresences;
    }

    /**
     * retourne la liste des présences et absences des élèves d'un cours pour une date donnée
     *
     * @param string $datePHP
     * @param string $coursGrp
     *
     * @return array
     */
    public function listePresencesCoursDate($datePHP, $coursGrp){
        $date = Application::dateMysql($datePHP);
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT dpe.matricule, nom, prenom, groupe, educ, periode, statut, date, quand, heure, parent, media ';
        $sql .= 'FROM '.PFX.'presencesEleves AS dpe ';
        $sql .= 'JOIN '.PFX.'eleves AS de ON de.matricule = dpe.matricule ';
        $sql .= 'LEFT JOIN '.PFX.'presencesLogs AS dpl ON dpl.id = dpe.id ';
        $sql .= 'WHERE dpe.matricule IN (SELECT matricule FROM '.PFX.'elevesCours WHERE coursGrp = :coursGrp) ';
        $sql .= 'AND date = :date ';
        $requete = $connexion->prepare($sql);

        $requete->bindParam(':coursGrp', $coursGrp, PDO::PARAM_STR, 15);
        $requete->bindParam(':date', $date, PDO::PARAM_STR, 10);

        $resultat = $requete->execute();
        $liste = array();
        if ($resultat){
            $requete->setFetchMode(PDO::FETCH_ASSOC);
            while ($ligne = $requete->fetch()){
                $periode = $ligne['periode'];
                $ligne['date'] = Application::datePHP($ligne['date']);
                $ligne['quand'] = Application::datePHP($ligne['quand']);
                $liste[$matricule][$periode] = $ligne;
            }
        }

        Application::deconnexionPDO($connexion);

        $listePeriodes = self::lirePeriodesCours();
        // pour chaque élève, on prépare une journée sans prise de présences
        $journee = array();
        foreach ($listePeriodes as $noPeriode => $wtf) {
            $journee[$noPeriode] = array('educ' => '', 'statut' => 'indetermine', 'quand' => '', 'heure' => '', 'parent' => '', 'media' => '');
        }

        $listePresences = array();
        foreach ($liste as $matricule => $dataJournee) {
            $listePresences[$matricule] = $journee;    // initialisation de la journée vide (aucune présence prise)
            // on parcourt la liste des présences prises

            foreach ($dataJournee as $periode => $data) {
                $listePresences[$matricule][$periode] = array(
                        'educ' => $liste[$matricule][$periode]['educ'],
                        'statut' => $liste[$matricule][$periode]['statut'],
                        'quand' => $liste[$matricule][$periode]['quand'],
                        'heure' => $liste[$matricule][$periode]['heure'],
                        'parent' => $liste[$matricule][$periode]['parent'],
                        'media' => $liste[$matricule][$periode]['media'],
                        );
                    }
            }

        return $listePresences;
    }

    /**
     * retourne la liste des présences et absences pour une liste d'élèves donnée et pour une date donnée.
     *
     * @param string :        $datePHP     (au format PHP)
     * @param array | string: $listeEleves
     *
     * @return array
     */
    public function listePresencesElevesDate($datePHP, $listeEleves)
    {
        if (is_array($listeEleves)) {
            $listeElevesString = implode(',', array_keys($listeEleves));
        } else {
            $listeElevesString = $listeEleves;
        }
        $date = Application::dateMysql($datePHP);
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT dpe.matricule, nom, prenom, groupe, educ, periode, statut, date, quand, heure, parent, media ';
        $sql .= 'FROM '.PFX.'presencesEleves AS dpe ';
        $sql .= 'JOIN '.PFX.'eleves AS de ON de.matricule = dpe.matricule ';
        $sql .= 'LEFT JOIN '.PFX.'presencesLogs AS dpl ON dpl.id = dpe.id ';
        $sql .= "WHERE dpe.matricule IN ($listeElevesString) ";
        $sql .= "AND date = '$date' ";

        $resultat = $connexion->query($sql);
        $liste = array();
        if ($resultat) {
            $resultat->setFetchMode(PDO::FETCH_ASSOC);
            while ($ligne = $resultat->fetch()) {
                $matricule = $ligne['matricule'];
                $periode = $ligne['periode'];
                $ligne['date'] = Application::datePHP($ligne['date']);
                $ligne['quand'] = Application::datePHP($ligne['quand']);
                $liste[$matricule][$periode] = $ligne;
            }
        }
        Application::deconnexionPDO($connexion);

        $listePeriodes = self::lirePeriodesCours();
        // pour chaque élève, on prépare une journée sans prise de présences
        $journee = array();
        foreach ($listePeriodes as $noPeriode => $wtf) {
            $journee[$noPeriode] = array('educ' => '', 'statut' => 'indetermine', 'quand' => '', 'heure' => '', 'parent' => '', 'media' => '');
        }

        if (!(is_array($listeEleves))) {
            $listeEleves = array($listeEleves => 'wtf');
        }

        $listePresences = array();
        foreach ($listeEleves as $matricule => $wtf) {
            $listePresences[$matricule] = $journee;    // initialisation de la journée vide (aucune présence prise)
            // on parcourt la liste des présences prises
            foreach ($liste as $matricule => $dataJournee) {
                // et on y met les informations des présences prises
                foreach ($dataJournee as $periode => $data) {
                    $listePresences[$matricule][$periode] = array(
                            'educ' => $liste[$matricule][$periode]['educ'],
                            'statut' => $liste[$matricule][$periode]['statut'],
                            'quand' => $liste[$matricule][$periode]['quand'],
                            'heure' => $liste[$matricule][$periode]['heure'],
                            'parent' => $liste[$matricule][$periode]['parent'],
                            'media' => $liste[$matricule][$periode]['media'],
                            );
                }
            }
        }

        return $listePresences;
    }

    /**
     * retourne la liste des absences et des présences pour une date donnée pour l'ensemble de l'école.
     *
     * @param $date
     * @param array ('liste1'=>...,'liste2'=>...) $statutsAbs : les statuts des types d'absences qui doivent être recensées
     *
     * @return array $listeAbsences: deux listes des absences pour la date donnée et triées par statuts d'absences
     */
    public function listePresencesDate($date, $statuts)
    {
        if (is_array($statuts))
            $statutsString = "'".implode("','", $statuts)."'";
            else $statutsString = "'".$statuts."'";
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $date = Application::dateMysql($date);
        $sql = 'SELECT date, periode, educ, dpe.matricule, statut, nom, prenom, groupe AS classe, quand, heure, parent, media ';
        $sql .= 'FROM '.PFX.'presencesEleves AS dpe ';
        $sql .= 'JOIN '.PFX.'eleves AS de ON de.matricule = dpe.matricule ';
        $sql .= 'JOIN '.PFX.'presencesLogs AS dpl ON dpl.id = dpe.id ';
        $sql .= 'WHERE date = :date AND statut IN ('.$statutsString.') ' ;
        $sql .= 'ORDER BY nom, prenom, classe, date ASC, periode ASC ';
        $requete = $connexion->prepare($sql);

        $requete->bindParam(':date', $date, PDO::PARAM_STR, 10);
        $resultat = $requete->execute();

        $liste = array();

        if ($resultat) {
            $requete->setFetchMode(PDO::FETCH_ASSOC);
            while ($ligne = $requete->fetch()) {
                $matricule = $ligne['matricule'];
                $periode = $ligne['periode'];
                $liste[$matricule]['identite']['nom'] = $ligne['nom'].' '.$ligne['prenom'];
                $liste[$matricule]['identite']['classe'] = $ligne['classe'];
                $liste[$matricule]['identite']['photo'] = Ecole::photo($matricule);
                // date de l'absence
                $ligne['date'] = APPLICATION::datePHP($ligne['date']);
                // date de la prise de présence
                $ligne['quand'] = APPLICATION::datePHP($ligne['quand']);
                $liste[$matricule]['presences'][$periode] = $ligne;
            }
        }
        Application::deconnexionPDO($connexion);

        return $liste;
    }

    /**
     * enregistrement du local, de la période, du jour de la semaine (numérique commençant par 1 pour lundi), du prof et du cours.
     *
     * @param $local
     * @param $periode
     * @param $prof
     * @param $coursGrp
     *
     * @return $nb : nombre d'enregistrements/updates réalisés
     */
    public function saveLocalCoursGrp($local, $periode, $prof, $coursGrp)
    {
        $date = strftime('%d/%m/%Y');
        $jourSemaine = strftime('%w', $Application->dateFR2Time($date));
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'INSERT INTO '.PFX.'locauxDatesCours ';
        $sql .= "SET local='$local', jour='$jourSemaine', periode='$periode', acronyme='$prof', coursGrp='$coursGrp' ";
        $sql .= "ON DUPLICATE KEY UPDATE acronyme='$prof', coursGrp='$coursGrp' ";
        $nb = $connexion->exec($sql);
        Application::deconnexionPDO($connexion);

        return $nb;
    }

    /**
     * enregistre les informations de retard provenant du scan
     *
     * @param string $acronyme : qui a scanné
     * @param int $matricule
     * @param string $date
     * @param int $periode: période de cours pour arrivée
     * @param string $heure : heure de scan de l'élève
     *
     * @return int : nombre d'enregistrements (normalement 1)
     */
    public function saveScanRetard($acronyme, $matricule, $date, $periode, $heure){
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        // introduction dans la table des logs et récupération de l'id autoIncrementé
        $sql = 'INSERT INTO '.PFX.'presencesLogs ';
        $sql .= 'SET educ = :educ, parent = "scan", media = "scan", quand = :quand, heure = :heure ';
        $requete = $connexion->prepare($sql);

        $dateMysql = Application::dateMysql($date);
        $requete->bindParam(':educ', $acronyme, PDO::PARAM_STR, 7);
        $requete->bindParam(':quand', $dateMysql, PDO::PARAM_STR, 10);
        $requete->bindParam(':heure', $heure, PDO::PARAM_STR, 5);

        $resultat = $requete->execute();
        $id = $connexion->lastInsertId();

        $sql = 'INSERT INTO '.PFX.'presencesEleves ';
        $sql .= 'SET id = :id, matricule = :matricule, date = :date, periode = :periode, statut = "retard" ';
        $sql .= 'ON DUPLICATE KEY UPDATE id = :id, periode = :periode, statut = "retard" ';
        $requete = $connexion->prepare($sql);

        $requete->bindParam(':id', $id, PDO::PARAM_INT);
        $requete->bindParam(':matricule', $matricule, PDO::PARAM_INT);
        $requete->bindParam(':date', $dateMysql, PDO::PARAM_STR, 10);
        $requete->bindParam(':periode', $periode, PDO::PARAM_INT);

        $resultat = $requete->execute();

        Application::deconnexionPDO($connexion);

        return 1;
    }


    /**
     * fonction générale d'enregistrement des présences et des absences, quel que soit le statut.
     *
     * @param array $post : données sortant d'un formulaire écran
     *
     * @return int : nombre de modifications dans la BD
     */
    public function savePresences($post, $acronyme)
    {
        $parent = isset($post['parent']) ? $post['parent'] : null;
        $noPeriode = isset($post['periode']) ? $post['periode'] : null;
        $media = isset($post['media']) ? $post['media'] : null;
        $date = isset($post['date']) ? Application::dateMysql($post['date']) : null;
        $oups = ($post['oups'] == 'false') ? false : true;
        $presAuto = isset($post['presAuto']) ? $post['presAuto'] : null;
        $heure = date('H:i');
        $quand = date('Y-m-d');

        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        // introduction dans la table des logs et récupération de l'id autoIncrementé
        $sql = 'INSERT INTO '.PFX.'presencesLogs ';
        $sql .= 'SET educ = :educ, parent = :parent, media = :media, quand = :quand, heure = :heure ';
        $requete = $connexion->prepare($sql);

        $requete->bindParam(':educ', $acronyme, PDO::PARAM_STR, 7);
        $requete->bindParam(':parent', $parent, PDO::PARAM_STR, 40);
        $requete->bindParam(':media', $media, PDO::PARAM_STR, 30);
        $requete->bindParam(':quand', $quand, PDO::PARAM_STR, 10);
        $requete->bindParam(':heure', $heure, PDO::PARAM_STR, 5);

        $resultat = $requete->execute();
        $id = $connexion->lastInsertId();

        $sql = 'INSERT INTO '.PFX.'presencesEleves ';
        $sql .= 'SET id = :id, matricule = :matricule, date = :date, periode = :noPeriode, statut = :statut ';
        $sql .= 'ON DUPLICATE KEY UPDATE id = :id, periode = :noPeriode, statut = :statut ';
        $requete = $connexion->prepare($sql);

        $nb = 0;
        $listeJustificationsAbs = array_keys($this->listeJustificationsAbsences(false));

        foreach ($post as $field => $statut) {
            if (substr($field, 0, 5) == 'matr-') {
                $champ = explode('-', $field);
                $matricule = $champ[1];

                // on n'enregistre que s'il s'agit d'une absence ou d'une présence ou d'un indéterminé (s'il s'agit d'une réinitialisation après erreur d'encodage)
                // les statuts "indéterminé" sont des présences (sauf si $oups.....) ou si la prise de "présences" automatique est désactivée
                if ($oups == false) {
                    if ($presAuto === 'true') {
                        if ($statut == 'indetermine') {
                            $statut = 'present';
                        }
                    }
                }

                // si le statut est autorisé à un prof
                if (in_array($statut, $listeJustificationsAbs)) {
                    $requete->bindParam(':id', $id, PDO::PARAM_INT);
                    $requete->bindParam(':matricule', $matricule, PDO::PARAM_INT);
                    $requete->bindParam(':date', $date, PDO::PARAM_STR, 12);
                    $requete->bindParam(':noPeriode', $noPeriode, PDO::PARAM_INT);
                    $requete->bindParam(':statut', $statut, PDO::PARAM_STR, 12);
                    $resultat += $requete->execute();
                    $nb++;  // ne compte les boucles qu'une seule fois alors que "ON DUPLICATE" signale 2 modifications dans la table
                }
            }
        }

        Application::deconnexionPDO($connexion);

        return $nb;
    }

    /**
     * enregistrement des signalements d'absences (éventuellement sur plusieurs jours.
     *
     * @param array $post      : les informations provenant du formulaire de saisie
     *
     * @return int : nombre d'enregistrements
     */
    public function saveAbsences($post)
    {
        $educ = isset($post['educ']) ? $post['educ'] : null;
        $matricule = isset($post['matricule']) ? $post['matricule'] : null;
        $parent = isset($post['parent']) ? $post['parent'] : null;
        $media = isset($post['media']) ? $post['media'] : null;
        $heure = date('H:i');
        $quand = date('Y-m-d');

        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        // introduction dans la table des logs et récupération de l'id autoIncrementé
        $sql = 'INSERT INTO '.PFX.'presencesLogs ';
        $sql .= 'SET educ = :educ, parent = :parent, media = :media, quand = :quand, heure = :heure ';
        $requete = $connexion->prepare($sql);

        $requete->bindParam(':educ', $educ, PDO::PARAM_STR, 7);
        $requete->bindParam(':parent', $parent, PDO::PARAM_STR, 40);
        $requete->bindParam(':media', $media, PDO::PARAM_STR, 30);
        $requete->bindParam(':quand', $quand, PDO::PARAM_STR, 10);
        $requete->bindParam(':heure', $heure, PDO::PARAM_STR, 5);

        $resultat = $requete->execute();
        $id = $connexion->lastInsertId();

        $nb = 0;
        foreach ($post as $champ => $statut) {
            if (substr($champ, 0, 8) == 'periode-') {
                $pieces = explode('_', $champ, 2);

                $noPeriode = explode('-', $pieces[0]);
                $noPeriode = $noPeriode[1];
                $date = explode('-', $pieces[1]);
                $date = $date[1];
                // on n'enregistre que ce qui a été modifié
                if ($post['modif-'.$noPeriode.'_date-'.$date] == 'oui') {
                    $date = Application::dateMysql($date);
                    $sql = 'INSERT INTO '.PFX.'presencesEleves ';
                    $sql .= "SET id = :id, matricule = :matricule, date = :date, periode = :noPeriode, statut = :statut ";
                    $sql .= "ON DUPLICATE KEY UPDATE id = :id, periode = :noPeriode, statut = :statut ";
                    $requete = $connexion->prepare($sql);

                    $requete->bindParam(':id', $id, PDO::PARAM_INT);
                    $requete->bindParam(':matricule', $matricule, PDO::PARAM_STR, 7);
                    $requete->bindParam(':date', $date, PDO::PARAM_STR, 10);
                    $requete->bindParam(':noPeriode', $noPeriode, PDO::PARAM_INT);
                    $requete->bindParam(':statut', $statut, PDO::PARAM_STR, 11);

                    $resultat = $requete->execute();
                    if ($resultat) {
                        ++$nb;
                    }    // ne compte les boucles qu'une seule fois alors que "ON DUPLICATE" signale 2 modifications dans la table
                }
            }
        }
        Application::deconnexionPDO($connexion);

        return $nb;
    }

    /**
     * enregistrement des signalements d'absences (éventuellement sur plusieurs jours.
     *
     * @param array $post      : les informations provenant du formulaire de saisie
     *
     * @return int : nombre d'enregistrements
     */
    public function saveJustificationEleve($post)
    {

        $educ = isset($post['educ']) ? $post['educ'] : null;
        $matricule = isset($post['matricule']) ? $post['matricule'] : null;
        $parent = isset($post['parent']) ? $post['parent'] : null;
        $media = isset($post['media']) ? $post['media'] : null;
        // date et heure actuelles
        $heure = date('H:i');
        $quand = date('Y-m-d');

        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        // introduction dans la table des logs et récupération de l'id autoIncrementé
        $sql = 'INSERT INTO '.PFX.'presencesLogs ';
        $sql .= 'SET educ = :educ, parent = :parent, media = :media, quand = :quand, heure = :heure ';
        $requete = $connexion->prepare($sql);

        $requete->bindParam(':educ', $educ, PDO::PARAM_STR, 7);
        $requete->bindParam(':parent', $parent, PDO::PARAM_STR, 40);
        $requete->bindParam(':media', $media, PDO::PARAM_STR, 30);
        $requete->bindParam(':quand', $quand, PDO::PARAM_STR, 10);
        $requete->bindParam(':heure', $heure, PDO::PARAM_STR, 5);

        $resultat = $requete->execute();
        // on récupère l'id de la prise de présences
        $id = $connexion->lastInsertId();

        $nb = 0;

        $dateFrom = isset($post['dateFrom']) ? $post['dateFrom'] : null;
        $dateTo = isset($post['dateTo']) ? $post['dateTo'] : null;
        $dateFrom = Application::dateMysql($dateFrom);
        $dateTo = Application::dateMysql($dateTo);

        $periodeFrom = isset($post['periodeFrom']) ? $post['periodeFrom'] : null;
        $periodeTo = isset($post['periodeTo']) ? $post['periodeTo'] : null;

        $statut = isset($post['justification']) ? $post['justification'] : null;

        // ne conserver que les jours ouvrés de la période considérée
        $listeJours = $this->listBusinessDays($dateFrom, $dateTo);
        $nbJours = count($listeJours);

        // le nombre de périodes prévues dans la journée
        $listePeriodes = $this->lirePeriodesCours();
        $nbPeriodes = count($listePeriodes);

        $sql = 'INSERT INTO '.PFX.'presencesEleves ';
        $sql .= 'SET id = :id, matricule = :matricule, date = :date, periode = :noPeriode, statut = :statut ';
        $sql .= 'ON DUPLICATE KEY UPDATE id = :id, periode = :noPeriode, statut = :statut ';
        $requete = $connexion->prepare($sql);

        $requete->bindParam(':id', $id, PDO::PARAM_INT);
        $requete->bindParam(':statut', $statut, PDO::PARAM_STR, 11);
        $requete->bindParam(':matricule', $matricule, PDO::PARAM_STR, 7);

        $nb = 0;
        foreach ($listeJours as $n => $unJour) {
            $date = Application::dateMySql($unJour);
            $requete->bindParam(':date', $date, PDO::PARAM_STR, 10);

            // est-ce le premier jour?
            if ($n == 0) {
                // sur une seule journée
                if ($nbJours == 1) {
                    foreach (range($periodeFrom, $periodeTo) as $noPeriode) {
                        $requete->bindParam(':noPeriode', $noPeriode, PDO::PARAM_INT);
                        $resultat = $requete->execute();
                        if ($resultat)
                            $nb++;
                        }
                }
                else {
                    // on complète le statut jusqu'à la fin de la journée
                    foreach (range($periodeFrom, $nbPeriodes) as $noPeriode) {
                        $requete->bindParam(':noPeriode', $noPeriode, PDO::PARAM_INT);
                        $resultat = $requete->execute();
                        if ($resultat)
                            $nb++;
                        }
                    }
                }
                else {
                    // sommes-nous avant le dernier jour?
                    if ($n < $nbJours-1) {
                        // on complète le statut jusqu'à la fin de la journée
                        foreach (range(1, $nbPeriodes) as $noPeriode) {
                            $requete->bindParam(':noPeriode', $noPeriode, PDO::PARAM_INT);
                            $resultat = $requete->execute();
                            if ($resultat)
                                $nb++;
                            }
                        }
                    else {
                        // on complète le statut jusqu'à la période de fin
                        foreach (range(1, $periodeTo) as $noPeriode) {
                            $requete->bindParam(':noPeriode', $noPeriode, PDO::PARAM_INT);
                            $resultat = $requete->execute();
                            if ($resultat)
                                $nb++;
                            }
                    }
                }
            }

        Application::deconnexionPDO($connexion);

        return $nb;
    }

     /**
      * retourne la liste des jours d'absences d'un élève dont on fournit le matricule.
      *
      * @param $matricule
      *
      * @return array
      */
     public function listePresencesEleve($matricule)
     {
         $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
         $sql = 'SELECT date, periode, statut, educ, heure, quand, parent, media ';
         $sql .= 'FROM '.PFX.'presencesEleves AS dpe ';
         $sql .= 'JOIN '.PFX.'presencesLogs AS dpl ON dpl.id = dpe.id ';
         $sql .= 'WHERE matricule=:matricule ORDER BY date ';
         $requete = $connexion->prepare($sql);

         $requete->bindParam(':matricule', $matricule, PDO::PARAM_INT);
         $resultat = $requete->execute();

         // liste de tous les statuts d'absence existants dans la BD, sauf "present" et "indetermine"
         $statutsAbs = array_diff(array_keys($this->listeJustificationsAbsences()), array('present', 'indetermine'));

         $listePeriodes = $this->lirePeriodesCours();
         $empty = array('statut' => '', 'quand' => '', 'heure' => '', 'educ' => '', 'parent' => '', 'media' => '');
         $liste = array();
         $absents = array();
         if ($resultat) {
             $requete->setFetchMode(PDO::FETCH_ASSOC);
             while ($ligne = $requete->fetch()) {
                 $timeStamp = strtotime($ligne['date']);
                 setlocale(LC_TIME, "fr_FR");
                 $date = strftime("%a %d/%m", $timeStamp);
                 if (!(isset($liste[$date]))) {
                     foreach ($listePeriodes as $noPeriode => $bornes) {
                         $liste[$date][$noPeriode] = $empty;
                     }
                 }
                 $ligne['date'] = $date;
                 $quand = Application::datePHP($ligne['quand']);
                 $ligne['quand'] = $quand;
                // il y a une absence dans la ligne? On le note
                if (in_array($ligne['statut'], $statutsAbs)) {
                    $absents[$date] = true;
                }
                 $periode = $ligne['periode'];
                 $liste[$date][$periode] = $ligne;
             }
         }
         Application::deconnexionPDO($connexion);
        // on ne retient que les fiches pour lesquelles il y a une absence au moins
        $liste = array_intersect_key($liste, $absents);

         return $liste;
     }

     /**
      * retourne la liste des justifications d'absences possibles, avec leurs caractéristiques
      * $admin = true si toutes les justifications sont présentées sinon, seulement celles pour les profs.
      *
      * @param $admin : si "true", toutes les justifications, sinon, seulement celles des profs
      * @param $speed: si true, les justifications d'asences pour inscription rapide (obsolète: devrait être supprimé)
      *
      * @return array
      */
     public function listeJustificationsAbsences($admin = true, $speed = false)
     {
         $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
         $sql = 'SELECT justif, shortJustif, libelle, color, background, ordre, accesProf, obligatoire ';
         $sql .= 'FROM '.PFX.'presencesJustifications ';
         $sql .= 'WHERE 1 ';
         if ($admin == false) {
             $sql .= 'AND accesProf = true ';
         }
         $sql .= 'ORDER BY ordre, justif ';

         $resultat = $connexion->query($sql);
         $liste = array();
         if ($resultat) {
             $resultat->setFetchMode(PDO::FETCH_ASSOC);
             while ($ligne = $resultat->fetch()) {
                 $justif = $ligne['justif'];
                 $liste[$justif] = $ligne;
             }
         }

         Application::deconnexionPDO($connexion);

         return $liste;
     }

    public function getArrayOfStatus($listeJustifications)
    {
        $liste = array();
        foreach ($listeJustifications as $key => $wtf) {
            $liste[$key] = $key;
        }

        return $liste;
    }

    /**
     * renvoie les détails relatifs à une liste de statuts d'absences passée en argument
     *
     * @param array $statuts
     *
     * @return array
     */
    public function getDetailsStatuts ($statuts){
        $statutsString = "'".implode("','", $statuts)."'";
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT justif, shortJustif, ordre, libelle, color, background, accesProf, obligatoire ';
        $sql .= 'FROM '.PFX.'presencesJustifications ';
        $sql .= 'WHERE justif IN ('.$statutsString.') ';
        $sql .= 'ORDER BY ordre, libelle ';
        $requete = $connexion->prepare($sql);

        $liste = array();
        $resultat = $requete->execute();

        if ($resultat) {
            $requete->setFetchMode(PDO::FETCH_ASSOC);
            while ($ligne = $requete->fetch()){
                $justif = $ligne['justif'];
                $liste[$justif] = $ligne;
            }
        }

        Application::deconnexionPDO($connexion);

        return $liste;
    }

     /**
      * retourne les caractéristiques d'une justification d'absences possible.
      *
      * @param $just : le nom de la justifications
      *
      * @return array
      */
     public function getJustification($just)
     {
         $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
         $sql = 'SELECT justif, shortJustif, libelle, color, background, ordre, accesProf, obligatoire ';
         $sql .= 'FROM '.PFX.'presencesJustifications ';
         $sql .= "WHERE justif = '$just' ";
         $resultat = $connexion->query($sql);
         $justification = null;
         if ($resultat) {
             $resultat->setFetchMode(PDO::FETCH_ASSOC);
             $justification = $resultat->fetch();
         }

         Application::deconnexionPDO($connexion);

         return $justification;
     }

     /**
      * enregistre les informations sur un mode de justification d'absence.
      *
      * @param $post : informations provenant du formulaire
      *
      * @return int : nombre d'enregistrements réussis (0 ou 1)
      */
     public function saveJustification($post)
     {
         $justif = isset($post['justif']) ? $post['justif'] : null;
         $shortJustif = isset($post['shortJustif']) ? $post['shortJustif'] : null;
         $ordre = isset($post['ordre']) ? $post['ordre'] : null;
         $libelle = isset($post['libelle']) ? $post['libelle'] : null;
         $color = isset($post['color']) ? $post['color'] : null;
         $background = isset($post['background']) ? $post['background'] : null;
         $accesProf = isset($post['accesProf']) ? $post['accesProf'] : 0;

         $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);

         $sql = 'INSERT INTO '.PFX.'presencesJustifications ';
         $sql .= 'SET justif = :justif, shortJustif = :shortJustif, ordre = :ordre, ';
         $sql .= 'libelle = :libelle, color = :color, background = :background, accesProf = :accesProf ';
         $sql .= 'ON DUPLICATE KEY UPDATE ';
         $sql .= 'shortJustif = :shortJustif, ordre = :ordre, libelle = :libelle, color = :color, ';
         $sql .= 'background = :background, accesProf = :accesProf ';
         $requete = $connexion->prepare($sql);

         $requete->bindParam(':justif', $justif, PDO::PARAM_STR, 12);
         $requete->bindParam(':shortJustif', $shortJustif, PDO::PARAM_STR, 5);
         $requete->bindParam(':ordre', $ordre, PDO::PARAM_INT);
         $requete->bindParam(':libelle', $libelle, PDO::PARAM_STR, 30);
         $requete->bindParam(':color', $color, PDO::PARAM_STR, 7);
         $requete->bindParam(':background', $background, PDO::PARAM_STR, 7);
         $requete->bindParam(':accesProf', $accesProf, PDO::PARAM_INT);

         $resultat = $requete->execute();

         Application::deconnexionPDO($connexion);

         return $resultat;
     }

     /**
      * supprime une justification.
      *
      * @param $justif : la justification à supprimer de la BD
      *
      * @return int : le nombre d'effacements (0 ou 1)
      */
     public function delJustif($justif)
     {
         $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
         $sql = 'DELETE FROM '.PFX.'presencesJustifications ';
         $sql .= 'WHERE justif = :justif ';
         $requete = $connexion->prepare($sql);

         $requete->bindParam(':justif', $justif, PDO::PARAM_STR, 12);

         $resultat = $requete->execute();

         Application::deconnexionPDO($connexion);

         return $resultat;
     }

     /**
      * retourne un tableau des nombres de prises de présences par date (mois, année)
      *
      * @param void()
      *
      * @return array
      */
     public function getHistory(){
         $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
         $sql = 'SELECT count(*) AS nb, YEAR(date) AS annee, MONTH(date) AS mois ';
         $sql .= 'FROM '.PFX.'presencesEleves ';
         $sql .= 'GROUP BY annee, mois ';
         $requete = $connexion->prepare($sql);

         $liste = array();
         $resultat = $requete->execute();
         if ($resultat){
             $requete->setFetchMode(PDO::FETCH_ASSOC);
             while ($ligne = $requete->fetch()) {
                 $annee = $ligne['annee'];
                 $mois = $ligne['mois'];
                 $liste[$annee][$mois] = $ligne['nb'];
             }
         }

         Application::deconnexionPDO($connexion);

         return $liste;
     }

     /**
      * suppression de toutes les archives de l'année et du mois donné
      *
      * @param int $month
      * @param int $year
      *
      * @return int nombre d'effacements dans la BD
      */
    public function cleanTables($year, $month) {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'DELETE FROM '.PFX.'presencesEleves ';
        $sql .= 'WHERE YEAR(date) = :year AND MONTH(date) = :month ';
        $requete = $connexion->prepare($sql);
        $nb = 0;
        $requete->bindParam(':year', $year, PDO::PARAM_INT);
        $requete->bindParam(':month', $month, PDO::PARAM_INT);
        $requete->execute();
        $nb = $requete->rowCount();

        $sql = 'OPTIMIZE TABLE '.PFX.'presencesEleves ';
        $requete = $connexion->prepare($sql);
        $requete->execute();

        $sql = 'DELETE FROM '.PFX.'presencesLogs ';
        $sql .= 'WHERE YEAR(quand) = :year AND MONTH(quand) = :month ';
        $requete = $connexion->prepare($sql);

        $requete->bindParam(':year', $year, PDO::PARAM_INT);
        $requete->bindParam(':month', $month, PDO::PARAM_INT);
        $requete->execute();
        $nb += $requete->rowCount();

        $sql = 'OPTIMIZE TABLE '.PFX.'presencesLogs ';
        $requete = $connexion->prepare($sql);
        $requete->execute();

        Application::deconnexionPDO($connexion);

        return $nb;
     }


     /**
      * Lecture des derniers enregistrements dans la table des retards
      *
      * @param int $limite : le nombre d'enregistrements à lire
      * @param string : $acronyme
      *
      * @return array
      */
     // public function getLastRetards($limite, $acronyme) {
     //     $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
     //     $sql = 'SELECT idRetard, retards.matricule, acronyme, date, heure, periode, groupe, nom, prenom ';
     //     $sql .= 'FROM '.PFX.'adesRetards AS retards ';
     //     $sql .= 'JOIN '.PFX.'eleves AS de ON de.matricule = retards.matricule ';
     //     $sql .= 'WHERE acronyme = :acronyme ';
     //     $sql .= 'ORDER BY idRetard DESC limit :limite ';
     //     $requete = $connexion->prepare($sql);
     //
     //     $limite = (int) $limite;
     //     $requete->bindParam(':acronyme', $acronyme, PDO::PARAM_STR, 7);
     //     $requete->bindParam(':limite', $limite, PDO::PARAM_INT);
     //
     //     $liste = array();
     //     $resultat = $requete->execute();
     //
     //     if ($resultat) {
     //         $requete->setFetchMode(PDO::FETCH_ASSOC);
     //         while ($ligne = $requete->fetch()) {
     //             $idRetard = $ligne['idRetard'];
     //             $liste[$idRetard] = $ligne;
     //         }
     //     }
     //
     //     Application::DeconnexionPDO($connexion);
     //
     //     return $liste;
     // }

     /**
      * renvoie les détails du retard $idRetard afin d'édition
      *
      * @param int $idRetard
      * @param string $acronyme
      *
      * @return json
      */
     public function getRetard($idRetard, $acronyme){
         $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
         $sql = 'SELECT idRetard, retards.matricule, acronyme, date, heure, periode, groupe, nom, prenom ';
         $sql .= 'FROM '.PFX.'adesRetards AS retards ';
         $sql .= 'JOIN '.PFX.'eleves AS de ON de.matricule = retards.matricule ';
         $sql .= 'WHERE acronyme = :acronyme AND idRetard = :idRetard ';
         $requete = $connexion->prepare($sql);

         $requete->bindParam(':acronyme', $acronyme, PDO::PARAM_STR, 7);
         $requete->bindParam(':idRetard', $idRetard, PDO::PARAM_INT);

         $resultat = $requete->execute();

         $retard = array();
         if ($resultat) {
             $requete->setFetchMode(PDO::FETCH_ASSOC);
             $retard = $requete->fetch();
             $retard['date'] = Application::datePHP($retard['date']);
             $retard['heure'] = substr($retard['heure'], 0, 5);
         }

         Application::deconnexionPDO($connexion);

         return $retard;
     }

     /**
      * renvoie la liste des retards durant une période pour un niveau d'étude, une classe ou un élève
      *
      * @param string $debut : début de la période
      * @param string $fin : fin de la période
      * @param int $niveau : niveau d'étude
      * @param string $classe : classe
      * @param int $matricule : matricule de l'élève
      *
      * @return array
      */
     public function getRetards4Periode($debut, $fin, $niveau, $classe, $matricule){
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT id, pel.matricule, date, groupe, nom, prenom, traitLogs.idTraitement, periode, ';
        $sql .= 'dateTraitement, dateRetour, impression ';
        $sql .= 'FROM '.PFX.'presencesEleves AS pel ';
        $sql .= 'JOIN '.PFX.'eleves AS de ON de.matricule = pel.matricule ';
        $sql .= 'LEFT JOIN '.PFX.'presencesIdTraitementLogs AS traitLogs ON (traitLogs.idRetard = id AND traitLogs.matricule = pel.matricule) ';
        $sql .= 'LEFT JOIN '.PFX.'presencesTraitement AS trait ON trait.idTraitement = traitLogs.idTraitement ';
        $sql .= 'WHERE date BETWEEN :debut AND :fin ';
        $sql .= 'AND statut = "retard" ';
        if ($matricule != Null)
            $sql .= 'AND pel.matricule = :matricule ';
            else if ($classe != Null)
                $sql .= 'AND de.groupe = :classe ';
                else if ($niveau != Null)
                    $sql .= 'AND SUBSTR(de.groupe, 1, 1) = :niveau ';
        $sql .= 'ORDER BY groupe, nom, prenom, date ';

        $requete = $connexion->prepare($sql);

        $debut = Application::dateMySql($debut);
        $fin = Application::dateMySql($fin);

        $requete->bindParam(':debut', $debut, PDO::PARAM_STR, 10);
        $requete->bindParam(':fin', $fin, PDO::PARAM_STR, 10);
        if ($matricule != Null)
            $requete->bindParam(':matricule', $matricule, PDO::PARAM_INT);
            else if ($classe != Null)
                    $requete->bindParam(':classe', $classe, PDO::PARAM_STR, 6);
                    else if ($niveau != Null)
                        $requete->bindParam(':niveau', $niveau, PDO::PARAM_INT);

        $liste = array();

        $resultat = $requete->execute();
        if ($resultat) {
            $requete->setFetchMode(PDO::FETCH_ASSOC);
            while ($ligne = $requete->fetch()){
                $matricule = $ligne['matricule'];
                // création de la liste d'informations pour cet élève
                if (!(isset($liste[$matricule])))
                    $liste[$matricule] = array('traite' => Null, 'nonTraite' => Null);
                // $idTraitement est peut-être Null si le retard n'a pas encore été traité
                $idTraitement = $ligne['idTraitement'];

                // la date du retard (on s'en fiche, non?)
                // $ligne['date'] = Application::datePHP($ligne['date']);

                // identifiant de la prise de présence prof/educ correspondant au retard
                $id = $ligne['id'];
                // nombre d'impressions déjà réalisées
                // $liste[$matricule]['impression'] = isset($ligne['impression']) ? $ligne['impression'] : 0;

                // if (!(isset($liste[$matricule]['nom']))) {
                    $liste[$matricule]['classe'] = $ligne['groupe'];
                    $liste[$matricule]['nom'] = sprintf('%s %s', $ligne['nom'], $ligne['prenom']);
                // }
                // mettre dans une liste ou dans l'autre
                if ($idTraitement != Null){
                    $liste[$matricule]['traite'][$idTraitement] =
                        array('dateTraitement' => $ligne['dateTraitement'],
                            'dateRetour' => Application::datePHP($ligne['dateRetour']),
                            'impression' => $ligne['impression']);
                    }
                    else $liste[$matricule]['nonTraite'][$id] = $ligne;
            }
        }

        Application::deconnexionPDO($connexion);

        return $liste;
     }

     /**
      * enregistrement initial des informations de tratiement d'un retard
      *
      * @param string $acronyme : acronyme du prpriétaire
      *
      * @return int : la référence de l'enregistrement (id ou ref de l'enregistrement)
      */
     public function initTraitementRetard($acronyme){
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'INSERT INTO '.PFX.'presencesTraitement ';
        $sql .= 'SET dateTraitement = NOW(), acronyme = :acronyme ';
        $requete = $connexion->prepare($sql);

        $requete->bindParam(':acronyme', $acronyme, PDO::PARAM_STR, 7);

        $resultat = $requete->execute();

        $ref = $connexion->lastInsertId();

        Application::deconnexionPDO($connexion);

        return $ref;
     }

     /**
      * Enregistrement des dates de sanction pour retard
      *
      * @param int $ref : référence dans la table des traitements
      * @param array $listeDates : liste des dates de sanction
      *
      * @return int : nombre d'enregistrements
      */
     public function saveDatesSanction($idTraitement, $form){
         $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
         $sql = 'INSERT IGNORE INTO '.PFX.'presencesDatesSanctions ';
         $sql .= 'SET idTraitement = :idTraitement, dateSanction = :date ';
         $requete = $connexion->prepare($sql);

         $resultat = 0;
         $requete->bindParam(':idTraitement', $idTraitement, PDO::PARAM_INT);

         $datesSanctions = $form['datesSanctions'];
         foreach ($datesSanctions as $uneDate) {
             $date = Application::dateMysql($uneDate);
             $requete->bindParam(':date', $date, PDO::PARAM_STR, 10);
             $resultat += $requete->execute();
         }

         Application::deconnexionPDO($connexion);

         return $resultat;
     }

     /**
      * enregistrement des couples $ref des retards et $log de la table des présences
      *
      * @param int $ref : référence dans la table des traitements
      * @param array $listeIdLogs
      *
      * @return int : nombre d'enregistrements
      */
     public function saveIdTraitementIdLogs($idTraitement, $form){
         $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
         $sql = 'INSERT IGNORE INTO '.PFX.'presencesIdTraitementLogs ';
         $sql .= 'SET idTraitement = :idTraitement, idRetard = :idRetard, matricule = :matricule ';
         $requete = $connexion->prepare($sql);

         $resultat = 0;
         $matricule = $form['matricule'];
         // $liste
         $requete->bindParam(':idTraitement', $idTraitement, PDO::PARAM_INT);
         $requete->bindParam(':matricule', $matricule, PDO::PARAM_INT);

         $listeIdsLogs = $form['idRetards'];
         foreach ($listeIdsLogs AS $idRetard) {
             $requete->bindParam(':idRetard', $idRetard, PDO::PARAM_INT);
             $resultat += $requete->execute();
         }

         Application::deconnexionPDO($connexion);

         return $resultat;
     }

     /**
      * effacement d'une sanction dont on passe la référence
      *
      * @param int $ref : référence de la sanction dans les différentes tables
      *
      * @return int : nombre de suppressions (0 ou 1)
      */
     public function delSanctionRef($ref){
         $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
         $sql = 'DELETE FROM '.PFX.'presencesRefLogs ';
         $sql .= 'WHERE ref = :ref ';
         $requete = $connexion->prepare($sql);
         $requete->bindParam(':ref', $ref, PDO::PARAM_INT);
         $requete->execute();

         $sql = 'DELETE FROM '.PFX.'presencesDatesSanctions ';
         $sql .= 'WHERE ref = :ref ';
         $requete = $connexion->prepare($sql);
         $requete->bindParam(':ref', $ref, PDO::PARAM_INT);
         $requete->execute();

         $sql = 'DELETE FROM '.PFX.'presencesTraitement ';
         $sql .= 'WHERE ref = :ref ';
         $requete = $connexion->prepare($sql);
         $requete->bindParam(':ref', $ref, PDO::PARAM_INT);
         $resultat = $requete->execute();

         Application::deconnexionPDO($connexion);

         return $resultat;
     }

     /**
      * recherche les dates de sanction pour un  billet dont on donne le $idTraitement
      *
      * @param int $idTraitement
      *
      * @return array
      */
     public function getDatesSanction4idTraitement($idTraitement){
         $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
         $sql = 'SET lc_time_names = "fr_FR" ';
         $requete = $connexion->prepare($sql);
         $requete->execute();

         $sql = 'SELECT dateSanction, DATE_FORMAT(dateSanction, "%W") AS jour, idTraitement ';
         $sql .= 'FROM '.PFX.'presencesDatesSanctions ';
         $sql .= 'WHERE idTraitement = :idTraitement ';
         $requete = $connexion->prepare($sql);

         $requete->bindParam(':idTraitement', $idTraitement, PDO::PARAM_INT);
         $resultat = $requete->execute();
         $liste = array();
         if ($resultat) {
             $requete->setFetchMode(PDO::FETCH_ASSOC);
             while ($ligne = $requete->fetch()){
                 $liste[] = sprintf('%s %s', ucfirst($ligne['jour']), Application::datePHP($ligne['dateSanction']));
             }
         }

         Application::DeconnexionPDO($connexion);

         return $liste;
     }

     /**
      * liste les dates de retards pour le carton $idTraitement
      *
      * @param int $idTraitement
      *
      * @return array
      */
     public function getDatesRetards4idTraitement($idTraitement){
         $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
         $sql = 'SET lc_time_names = "fr_FR" ';
         $requete = $connexion->prepare($sql);
         $requete->execute();

         $sql = 'SELECT refLogs.idRetard, DATE_FORMAT(quand, "%W %d/%m/%Y") AS date, DATE_FORMAT(quand, "%d/%m/%Y") AS dateSimple ';
         $sql .= 'FROM '.PFX.'presencesIdTraitementLogs AS refLogs ';
         $sql .= 'JOIN '.PFX.'presencesLogs AS logs ON logs.id = refLogs.idRetard ';
         $sql .= 'WHERE idTraitement = :idTraitement ';
         $sql .= 'ORDER BY quand ';
         $requete = $connexion->prepare($sql);

         $requete->bindParam(':idTraitement', $idTraitement, PDO::PARAM_INT);
         $resultat = $requete->execute();

         $liste = array();
         if ($resultat) {
             $requete->setFetchMode(PDO::FETCH_ASSOC);
             while ($ligne = $requete->fetch()){
                 $idRetard = $ligne['idRetard'];
                 $liste[$idRetard] = $ligne;
             }
         }

         Application::DeconnexionPDO($connexion);

         return $liste;
     }

     /**
      * supprime une date de retard (l'identifiant dans les logs, en fait)
      * de la table presencesIdTraitementLogs
      * pour l'élève de $matricule donné et le traitement $idTraitement
      *
      * @param int $idTraitement
      * @param int $idRetard : identifiant de le prise de présences dans les logs
      * @param int $matricule : matricule de l'élève
      *
      * @return int : le nombre de suppressions (0 ou 1)
      */
     public function delTraitementLogs($idTraitement, $idRetard, $matricule){
         $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
         $sql = 'DELETE FROM '.PFX.'presencesIdTraitementLogs ';
         $sql .= 'WHERE idTraitement = :idTraitement AND idRetard = :idRetard ';
         $sql .= 'AND matricule = :matricule ';
         $requete = $connexion->prepare($sql);

         $requete->bindParam(':idTraitement', $idTraitement, PDO::PARAM_INT);
         $requete->bindParam(':idRetard', $idRetard, PDO::PARAM_INT);
         $requete->bindParam(':matricule', $matricule, PDO::PARAM_INT);

         $resultat = $requete->execute();
         $nb = $requete->rowCount();

         Application::DeconnexionPDO($connexion);

         return $nb;
     }

     /**
      * Effacement des dates de sanctions après édition du billet de retard
      *
      * @param int $idTraitement
      * @param array $listeDates : liste des dates de sanction qui restent
      *
      * @return int : nombre de suppressions effectuées
      */
     public function delDatesSanction($idTraitement, $listeDates){
         $listeDatesSQL = array();
         foreach ($listeDates as $uneDate){
             $listeDatesSQL[] = Application::dateMySql(explode(' ', $uneDate)[1]);
            }
         $listeDatesSQL = "'".implode("','", $listeDatesSQL)."'";
         $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
         $sql = 'DELETE FROM '.PFX.'presencesDatesSanctions ';
         $sql .= 'WHERE idTraitement = :idTraitement AND ';
         $sql .= 'dateSanction NOT IN ('.$listeDatesSQL.') ';
         $requete = $connexion->prepare($sql);

         $requete->bindParam(':idTraitement', $idTraitement, PDO::PARAM_INT);

         $resultat = $requete->execute();
         $nb = $requete->rowCount();

         Application::DeconnexionPDO($connexion);

         return $nb;
     }

/**
 * mise à jour des informations générales de traitement (date, impression, date de retour, acronyme)
 *
 * @param int $idTraitement
 * @param string $acronyme
 * @param string $dateRetour
 * @param int $impression : nombre d'impressions
 *
 * @return int
 */
public function updatePresencesTraitement($idTraitement, $acronyme, $dateRetour, $impression){
    $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
    $sql = 'UPDATE '.PFX.'presencesTraitement ';
    $sql .= 'SET acronyme = :acronyme, dateTraitement = NOW() ';
    if ($impression != Null)
        $sql .= ', impression = impression + 1 ';
    $sql .= ', dateRetour = :dateRetour ';
    $sql .= 'WHERE idTraitement = :idTraitement ';
    $requete = $connexion->prepare($sql);

    $requete->bindParam(':idTraitement', $idTraitement, PDO::PARAM_INT);
    $requete->bindParam(':acronyme', $acronyme, PDO::PARAM_STR, 7);

    $dateRetour = ($dateRetour != '') ? Application::dateMySql($dateRetour) : Null;
    $requete->bindParam(':dateRetour', $dateRetour, PDO::PARAM_STR, 10);

    $resultat = $requete->execute();
    $nb = $requete->rowCount();

    Application::DeconnexionPDO($connexion);

    return $nb;
    }

    /**
     * renvoie les stats de prises de présences pour les profs de la liste fournie entre les dates données
     *
     * @param array $listeProfs
     * @param date $debut
     * @param date $fin
     *
     * @return array
     */
    public function getStatsPresences($listeProfs, $debut, $fin){
        if ($listeProfs != Null)
            $listeProfsString = "'".implode("','", $listeProfs)."'";
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT educ, COUNT(*) AS nb, nom, prenom ';
        $sql .= 'FROM '.PFX.'presencesLogs AS logs ';
        $sql .= 'LEFT JOIN '.PFX.'profs AS profs ON profs.acronyme = logs.educ ';
        $sql .= 'WHERE educ IN ('.$listeProfsString.') AND quand BETWEEN :debut AND :fin ';
        $sql .= 'GROUP BY educ ';
        $sql .= 'ORDER BY nom, prenom ';
        $requete = $connexion->prepare($sql);

        $debut = Application::dateMySql($debut);
        $fin = Application::dateMySql($fin);

        $requete->bindParam(':debut', $debut, PDO::PARAM_STR, 10);
        $requete->bindParam(':fin', $fin, PDO::PARAM_STR, 10);

        $liste = array();
        $resultat = $requete->execute();
        if ($resultat) {
            $requete->setFetchMode(PDO::FETCH_ASSOC);
            while ($ligne = $requete->fetch()){
                $acronyme = $ligne['educ'];
                $liste[$acronyme] = $ligne;
            }
        }

        Application::DeconnexionPDO($connexion);

        return $liste;
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
 * retourne les caractéristiques du traitement $idTraitement (date trait, impr, retour)
 *
 * @param int $idTraitement
 *
 * @return array
 */
public function getDataTraitement($idTraitement){
    $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
    $sql = 'SET lc_time_names = "fr_FR" ';
    $requete = $connexion->prepare($sql);
    $requete->execute();

    $sql = 'SELECT idTraitement, DATE_FORMAT(dateTraitement,"%W %d/%m/%Y") AS dateTraitement, ';
    $sql .= 'impression, dateRetour, presTrait.acronyme, nom, prenom ';
    $sql .= 'FROM '.PFX.'presencesTraitement AS presTrait ';
    $sql .= 'LEFT JOIN '.PFX.'profs AS profs ON profs.acronyme = presTrait.acronyme ';
    $sql .= 'WHERE idTraitement = :idTraitement ';
    $requete = $connexion->prepare($sql);

    $requete->bindParam(':idTraitement', $idTraitement, PDO::PARAM_INT);

    $ligne = array();
    $resultat = $requete->execute();
    if ($resultat){
        $requete->setFetchMode(PDO::FETCH_ASSOC);
        $ligne = $requete->fetch();
        $ligne['dateRetour'] = Application::datePHP($ligne['dateRetour']);
    }

    Application::DeconnexionPDO($connexion);

    return $ligne;
}

/**
 * retourne la liste des dates de sanction correspondant à un $idTraitement
 *
 * @param int $idTraitement
 *
 * @return array
 */
public function getDatesSanction($idTraitement){
    $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
    $sql = 'SELECT dateSanction ';
    $sql .= 'FROM '.PFX.'presencesDatesSanctions ';
    $sql .= 'WHERE idTraitement = :idTraitement ';
    $sql .= 'ORDER BY dateSanction ';
    $requete = $connexion->prepare($sql);

    $requete->bindParam(':idTraitement', $idTraitement, PDO::PARAM_INT);

    $liste = array();
    $resultat = $requete->execute();
    if ($resultat){
        $requete->setFetchMode(PDO::FETCH_ASSOC);
        while ($ligne = $requete->fetch()){
            $liste[] = $ligne['dateSanction'];
        }
    }

    Application::DeconnexionPDO($connexion);

    return $liste;
}

/**
 * retourne la liste des dates de retard liées à un $idTraitement pour l'élève $matricule
 *
 * @param int $idTraitement
 * @param int $matricule
 *
 * @return array
 */
public function getDatesRetard($idTraitement, $matricule){
    $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
    $sql = 'SELECT idRetard, date, periode, statut ';
    $sql .= 'FROM '.PFX.'presencesIdTraitementLogs as traitLogs ';
    $sql .= 'JOIN '.PFX.'presencesEleves AS pel ON pel.id = traitLogs.idRetard ';
    $sql .= 'AND pel.matricule = traitLogs.matricule ';
    $sql .= 'WHERE idTraitement = :idTraitement AND traitLogs.matricule = :matricule ';

    $requete = $connexion->prepare($sql);

    $requete->bindParam(':idTraitement', $idTraitement, PDO::PARAM_INT);
    $requete->bindParam(':matricule', $matricule, PDO::PARAM_INT);

    $liste = array();
    $resultat = $requete->execute();
    if ($resultat){
        $requete->setFetchMode(PDO::FETCH_ASSOC);
        while ($ligne = $requete->fetch()){
            $idRetard = $ligne['idRetard'];
            $liste[$idRetard] = $ligne;
        }
    }

    Application::DeconnexionPDO($connexion);

    return $liste;
}

/**
 * retourne l'acronyme du propriétaire d'un traitement de retard
 *
 * @param int $idRetard
 *
 * @return string
 */
public function getProprioTraitement ($idTraitement){
    $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
    $sql = 'SELECT acronyme ';
    $sql .= 'FROM '.PFX.'presencesTraitement ';
    $sql .= 'WHERE idTraitement = :idTraitement ';
    $requete = $connexion->prepare($sql);

    $requete->bindParam(':idTraitement', $idTraitement, PDO::PARAM_INT);

    $acronyme = Null;
    $resultat = $requete->execute();
    if ($resultat) {
        $requete->setFetchMode(PDO::FETCH_ASSOC);
        $ligne = $requete->fetch();
        $acronym = $ligne['acronyme'];
    }

    Application::DeconnexionPDO($connexion);

    return $acronyme;
}

/**
 * suppression d'un traitement de retards et des sanctions
 *
 * @param int $idTraitement
 *
 * @return int : nombre d'effacements (0 ou 1)
 */
public function delTraitement($idTraitement){
    $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
    $sql = 'DELETE FROM '.PFX.'presencesIdTraitementLogs ';
    $sql .= 'WHERE idTraitement = :idTraitement ';
    $requete = $connexion->prepare($sql);
    $requete->bindParam(':idTraitement', $idTraitement, PDO::PARAM_INT);
    $resultat = $requete->execute();

    $sql = 'DELETE FROM '.PFX.'presencesDatesSanctions ';
    $sql .= 'WHERE idTraitement = :idTraitement ';
    $requete = $connexion->prepare($sql);
    $requete->bindParam(':idTraitement', $idTraitement, PDO::PARAM_INT);
    $resultat = $requete->execute();

    $sql = 'DELETE FROM '.PFX.'presencesTraitement ';
    $sql .= 'WHERE idTraitement = :idTraitement ';
    $requete = $connexion->prepare($sql);
    $requete->bindParam(':idTraitement', $idTraitement, PDO::PARAM_INT);
    $resultat = $requete->execute();

    Application::DeconnexionPDO($connexion);

    return $resultat;
    }

/**
 * incrémente le nombre d'impressions de la fiche $idTraitement
 *
 * @param int $idTraitement
 *
 * @return int
 */
public function incrementPrint($idTraitement){
    $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
    $sql = 'UPDATE '.PFX.'presencesTraitement ';
    $sql .= 'SET impression = impression + 1 ';
    $sql .= 'WHERE idTraitement = :idTraitement ';
    $requete = $connexion->prepare($sql);

    $requete->bindParam(':idTraitement', $idTraitement, PDO::PARAM_INT);
    $resultat = $requete->execute();

    $nb = $requete->rowCount();

    Application::DeconnexionPDO($connexion);

    return $resultat;
    }

    /**
     * recension des nombres de jours avec au moins une absence
     * on ne compte qu'une seule absence pour la journée même si plusieurs occurrences
     * dans une liste de présences
     *
     * @param array $listePresences
     *
     * @return int
     */
    public function nbJoursAvecAbsence($listePresences){
        $listeAbsences = array();
        foreach ($listePresences AS $date => $listePeriodes){
            foreach ($listePeriodes as $periode => $data) {
                if ($data['statut'] == 'absent')
                    $listeAbsences[$date] = 1;
            }
        }

        return count($listeAbsences);
    }

    /**
     * recension du nombre de retards
     * dans une liste de présences ($this->listePresencesEleve($matricule)) d'un élève
     * on compte chaque retard dans la journée
     *
     * @param array $listePresences
     *
     * @return int
     */
    public function nbRetards($listePresences){
        $nb = 0;
        foreach ($listePresences AS $date => $listePeriodes){
            foreach ($listePeriodes as $periode => $data) {
                if ($data['statut'] == 'retard')
                    $nb++;
            }
        }

        return $nb;
    }

    /**
     * liste des élèves pour vérification du retour des billets de sanctions retard
     *
     * @param string $niveau : date de départ dete
     * @param string $dateFin : date de fin de la liste
     * @param int $niveau : niveau d'étude demandé
     * @param string $groupe : groupe classe (éventuellement vide)
     * @param int $matricule : matricule de l'élève (éventuellement vide)
     */
    public function getListeSyntheseRetards($dateDebut, $dateFin, $niveau, $groupe, $matricule){
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT logs.matricule, nom, prenom, groupe, dateSanction, pds.idTraitement, idRetard, dateRetour, impression ';
        $sql .= 'FROM '.PFX.'presencesDatesSanctions AS pds ';
        $sql .= 'JOIN '.PFX.'presencesIdTraitementLogs AS logs ON logs.idTraitement = pds.idTraitement ';
        $sql .= 'JOIN '.PFX.'presencesTraitement AS pt ON pt.idTraitement = pds.idTraitement ';
        $sql .= 'JOIN '.PFX.'eleves AS de ON de.matricule = logs.matricule ';
        $sql .= 'WHERE dateSanction BETWEEN :dateDebut AND :dateFin ';
        if ($niveau != Null)
            $sql .= 'AND SUBSTRING(groupe,1,1) = :niveau ';
        if ($groupe != '')
            $sql .= 'AND groupe = :groupe ';
        if ($matricule != '')
            $sql .= 'AND matricule = :matricule ';
        $sql .= 'ORDER BY groupe, nom, prenom, idTraitement, dateSanction ';

        $requete = $connexion->prepare($sql);

        $requete->bindParam(':dateDebut', $dateDebut, PDO::PARAM_STR, 10);
        $requete->bindParam(':dateFin', $dateFin, PDO::PARAM_STR, 10);
        if ($niveau != Null)
            $requete->bindParam(':niveau', $niveau, PDO::PARAM_INT);
        if ($groupe != Null)
            $requete->bindParam(':groupe', $groupe, PDO::PARAM_STR, 6);
        if ($matricule != Null)
            $requete->bindParam(':matricule', $matricule, PDO::PARAM_STR, 10);
        $resultat = $requete->execute();

        $liste = array();
        if ($resultat){
            $requete->setFetchMode(PDO::FETCH_ASSOC);
            while ($ligne = $requete->fetch()){
                $matricule = $ligne['matricule'];
                $idTraitement = $ligne['idTraitement'];
                $nomPrenomClasse = sprintf('%s %s %s', $ligne['groupe'], $ligne['nom'], $ligne['prenom']);

                $liste[$matricule][$idTraitement]['npc'] = $nomPrenomClasse;

                $liste[$matricule][$idTraitement]['dateRetour'] = Application::datePHP($ligne['dateRetour']);

                $dateSanction = Application::datePHP($ligne['dateSanction']);
                if (!(isset($liste[$matricule][$idTraitement]['datesSanction'])))
                    $liste[$matricule][$idTraitement]['datesSanction'] = array();
                if (!(in_array($dateSanction, $liste[$matricule][$idTraitement]['datesSanction'])))
                    $liste[$matricule][$idTraitement]['datesSanction'][] = $dateSanction;
            }
        }

        Application::deconnexionPDO($connexion);

        return $liste;
    }

    /**
     * retourne la liste de tous les retards pour l'élève $matricule durant l'année scolaire
     *
     * @param int $matricule
     *
     * @return array
     */
    public function getAllRetards($listeEleves, $long=false) {
        $listeMatricules = implode(',', $listeEleves);
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT matricule, date, periode ';
        $sql .= 'FROM '.PFX.'presencesEleves ';
        $sql .= 'WHERE matricule IN ('.$listeMatricules.') AND statut = "retard" ';
        $requete = $connexion->prepare($sql);

        $requete->bindParam(':matricule', $matricule, PDO::PARAM_STR, 10);

        $resultat = $requete->execute();
        $liste = array();
        if ($resultat){
            $requete->setFetchMode(PDO::FETCH_ASSOC);
            while ($ligne = $requete->fetch()){
                $matricule = $ligne['matricule'];
                $date = Application::datePHP($ligne['date']);
                if ($long == false) {
                    $date = substr($date, 0, 5);
                }
                $periode = $ligne['periode'];
                $liste[$matricule][] = sprintf('%s <strong>%se</strong> heure', $date, $periode);
            }
        }

        Application::deconnexionPDO($connexion);

        return $liste;
    }

    /**
     * retourne la liste des jours ouvrés entre deux dates au format 'Y-m-d'
     *
     * @param string $dateFrom
     * @param string $dateTo
     *
     * @return array
     */
    public function listBusinessDays($dateFrom, $dateTo){
        $dateFrom = new DateTime($dateFrom);
        $dateTo = new DateTime($dateTo);
        // inclure le dernier jour
        $dateTo = $dateTo->modify( '+1 day' );
        $period = new DatePeriod(
            $dateFrom,
            new DateInterval('P1D'),
            $dateTo
        );

        $liste = array();
        foreach ($period as $key => $value) {
            $laDate = $value->format('Y-m-d');
            $unixTimeStamp = strToTime($laDate);
            $dow = date('w', $unixTimeStamp);
            // ne pas prendre les jours de WE
            if (($dow != 6) && ($dow != 0))
                $liste[] = $value->format('d/m/Y');
        }

        return $liste;
    }

}
