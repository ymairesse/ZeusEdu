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

    public function __construct($id, $matricule = '')
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
            $this->date = datePHP($ligne['date']);
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
        $absent = isset($post['absent']) ? 1 : 0;
        $envoyePar = isset($post['envoyePar'])?$post['envoyePar']:$post['professeur'];
        $motif = $post['motif'];
        $traitement = $post['traitement'];
        $prive = isset($post['prive']) ? 1 : 0;
        $aSuivre = $post['aSuivre'];
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        if ($id != null) {
            // c'est une mise à jour d'une visite précédente
            $sql = 'UPDATE '.PFX.'athena ';
            $sql .= "SET matricule=:matricule, proprietaire=:proprietaire, date='$date', heure='$heure', absent='$absent', prive='$prive', ";
            $sql .= 'envoyePar=:envoyePar, motif=:motif, traitement=:traitement,  aSuivre=:aSuivre ';
            $sql .= "WHERE id='$id' ";
            $requete = $connexion->prepare($sql);
        } else {
            // c'est une nouvelle visite
            $sql = 'INSERT INTO '.PFX.'athena ';
            $sql .= "SET matricule=:matricule, proprietaire=:proprietaire, date='$date', heure='$heure', absent='$absent', prive='$prive', ";
            $sql .= 'envoyePar=:envoyePar, motif=:motif, traitement=:traitement, aSuivre=:aSuivre ';
            $requete = $connexion->prepare($sql);
        }
        $data = array(':proprietaire' => $proprietaire,
                    ':envoyePar' => $envoyePar,
                    ':matricule' => $matricule,
                    ':motif' => $motif,
                    ':traitement' => $traitement,
                    ':aSuivre' => $aSuivre, );
        $resultat = $requete->execute($data);
        Application::DeconnexionPDO($connexion);

        return $resultat;
    }

    /**
     * retourne la liste des visites au coaching pour un élève donné.
     *
     * @param $matricule
     *
     * @return array
     */
    public function getSuiviEleve($matricule)
    {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT id, proprietaire, matricule, date, heure, envoyePar, motif, traitement, prive, aSuivre, absent ';
        $sql .= 'FROM '.PFX.'athena ';
        $sql .= "WHERE matricule = '$matricule' ";
        $sql .= 'ORDER BY date DESC, heure DESC ';
        $resultat = $connexion->query($sql);
        $liste = array();
        if ($resultat) {
            $resultat->setFetchMode(PDO::FETCH_ASSOC);
            while ($ligne = $resultat->fetch()) {
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
     * @param $id : l'identifiant de la visite
     * @param $proprietaire : identifiant de l'utlisateur actuel (petite précaution de sécurité)
     *
     * @return array
     */
    public function getDetailsSuivi($id, $proprietaire)
    {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT id, proprietaire, matricule, date, heure, envoyePar, motif, traitement, prive, aSuivre, absent ';
        $sql .= 'FROM '.PFX.'athena ';
        $sql .= "WHERE id='$id' AND proprietaire='$proprietaire' ";
        $resultat = $connexion->query($sql);
        $visite = array();
        if ($resultat) {
            $resultat->setFetchMode(PDO::FETCH_ASSOC);
            $visite = $resultat->fetch();
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
      * liste des viistes au coaching. classées par date
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
             $sql = 'SELECT id, '.PFX.'athena.matricule, date, heure, nom, prenom, classe, motif, traitement, aSuivre, absent ';
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
      * recherche la liste des élèves suivis par l'utlisateur $acronyme.
      *
      * @param $acronyme
      *
      * @return array
      */
     public static function getEleveUser($acronyme, $dateDebut=null, $dateFin=null)
     {
         $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
         $sql = "SELECT da.matricule, DATE_FORMAT(date,'%d/%m/%Y') AS laDate, DATE_FORMAT(heure,'%H:%i') AS heure, ";
         $sql .= 'absent, nom, prenom, groupe ';
         $sql .= 'FROM '.PFX.'athena AS da ';
         $sql .= 'JOIN '.PFX.'eleves AS de ON de.matricule = da.matricule ';
         $sql .= "WHERE proprietaire = '$acronyme' ";
         if ($dateDebut != null) {
             $sql .= "AND date >= '$dateDebut' ";
         }
         if ($dateFin != null) {
             $sql .= "AND date <= '$dateFin' ";
         }
         $sql .= 'ORDER BY date DESC, heure ASC ';

         $resultat = $connexion->query($sql);
         $liste = array();
         if ($resultat) {
             $resultat->setFetchMode(PDO::FETCH_ASSOC);
             while ($ligne = $resultat->fetch()) {
                 $date = $ligne['laDate'];
                 $matricule = $ligne['matricule'];
                 $ligne['photo'] = Ecole::photo($matricule);
                 $liste[$matricule][$date] = $ligne;
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
        $sql .= 'ORDER BY groupe, nom, prenom, date ';
        $resultat = $connexion->query($sql);
        $liste = array();
        if ($resultat) {
            $resultat->setFetchMode(PDO::FETCH_ASSOC);
            while ($ligne = $resultat->fetch()) {
                $matricule = $ligne['matricule'];
                $coach = $ligne['proprietaire'];
                if(!(isset($liste[$matricule]))) {
                    $liste[$matricule]['eleve'] = array('classe'=>$ligne['groupe'], 'nom'=>sprintf('%s %s', $ligne['nom'], $ligne['prenom']));
                    $liste[$matricule]['coaches'][$coach] = array('nomCoach'=> sprintf('%s %s', $ligne['prenomCoach'], $ligne['nomCoach']), 'nb'=>1);
                }
                else {
                    if (!(isset($liste[$matricule]['coaches'][$coach]))) {
                        $liste[$matricule]['coaches'][$coach] = array('nomCoach'=> sprintf('%s %s', $ligne['prenomCoach'], $ligne['nomCoach']), 'nb'=>1);
                    }
                    else {
                        $liste[$matricule]['coaches'][$coach]['nb']++;
                    }
                }
            }
        }
        Application::DeconnexionPDO($connexion);

        return $liste;
     }


}
