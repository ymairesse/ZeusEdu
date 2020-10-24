<?php

require_once INSTALL_DIR.'/inc/classes/classEcole.inc.php';

/*
 * class eleve
 */

class eleve
{
    private $detailsEleve;

    /**
     * _constructeur de la classe.
     *
     * @param $matricule = matricule de l'élève
     */
    public function __construct($matricule)
    {
        if ($matricule != null) {
            $this->setDetailsEleve($matricule);
        } else {
            $this->detailsEleve = null;
        }
    }

    /**
     * fixe tous les détails personnels de l'élève dans l'OBJECT
     * à partir de la BD.
     *
     * @param $matricule
     */
    public function setDetailsEleve($matricule)
    {
        if (!(isset($this->detailsEleve))) {
            $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
            $sql = 'SELECT de.*, user, mailDomain FROM '.PFX.'eleves AS de ';
            $sql .= 'LEFT JOIN '.PFX.'passwd AS dp ON (de.matricule = dp.matricule) ';
            $sql .= "WHERE de.matricule = '$matricule'";

            $resultat = $connexion->query($sql);
            if ($resultat) {
                $resultat->setFetchMode(PDO::FETCH_ASSOC);
                $this->detailsEleve = $resultat->fetch();
            }
            Application::DeconnexionPDO($connexion);
            $this->detailsEleve['age'] = $this->age();
            $this->detailsEleve['photo'] = Ecole::photo($this->detailsEleve['matricule']);
            $this->detailsEleve['DateNaiss'] = Application::datePHP($this->detailsEleve['DateNaiss']);
        }
    }

    /**
     * retourne toutes les informations connues sur cet élève.
     *
     * @param void
     *
     * @return array
     */
    public function getDetailsEleve()
    {
        if ($this->detailsEleve) {
            return $this->detailsEleve;
        } else {
            return;
        }
    }

    /**
     * retourne toutes les informations connues sur l'élève dont on fournit le matricule
     * procédure static sans l'objet Eleve.
     *
     * @param $matricule
     *
     * @return array
     */
    public static function staticGetDetailsEleve($matricule)
    {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT de.*, user, mailDomain, acronyme ';
        $sql .= 'FROM '.PFX.'eleves AS de ';
        $sql .= 'LEFT JOIN '.PFX.'passwd AS dp ON (de.matricule = dp.matricule) ';
        $sql .= 'LEFT JOIN '.PFX.'titus AS dt ON dt.classe = de.groupe ';
        $sql .= "WHERE de.matricule = '$matricule' ";

        $resultat = $connexion->query($sql);
        $detailsEleve = array();
        if ($resultat) {
            $resultat->setFetchMode(PDO::FETCH_ASSOC);
            $detailsEleve = $resultat->fetch();

            if ($detailsEleve != Null) {
                $dateNaissance = $detailsEleve['DateNaiss'];
                $detailsEleve['age'] = self::calculeAge($dateNaissance);
                $detailsEleve['photo'] = Ecole::photo($detailsEleve['matricule']);
                $detailsEleve['DateNaiss'] = Application::datePHP($detailsEleve['DateNaiss']);
            }
        }
        Application::DeconnexionPDO($connexion);

        return $detailsEleve;
    }

    /**
     * retourne les informations essentielles concernant un élève: nom, prenom, classe
     *
     * @param int $matricule
     *
     * @return array
     */
    public static function getMinDetailsEleve($matricule){
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT nom, prenom, classe, groupe ';
        $sql .= 'FROM '.PFX.'eleves ';
        $sql .= 'WHERE matricule = :matricule ';
        $requete = $connexion->prepare($sql);

        $requete->bindParam(':matricule', $matricule, PDO::PARAM_INT);

        $npc = array();
        $resultat = $requete->execute();
        if ($resultat){
            $ligne = $requete->fetch();
            $npc = array(
                'nom' => $ligne['nom'],
                'prenom' => $ligne['prenom'],
                'classe' => $ligne['classe'],
                'groupe' => $ligne['groupe'],
            );
        }

        Application::deconnexionPDO($connexion);

        return $npc;
    }

    /**
     * function classe.
     *
     * @param :
     *
     * @return $classe : la classe de l'élève
     */
    public function classe()
    {
        if (isset($this->detailsEleve['classe'])) {
            return $this->detailsEleve['classe'];
        } else {
            return '';
        }
    }

    /**
     * année d'étude de l'élève concerné.
     *
     * @return int : l'année d'étude
     */
    public function annee()
    {
        $classe = $this->classe();
        if ($classe != '') {
            return substr($classe, 0, 1);
        } else {
            return '';
        }
    }

    /**
     * function groupe.
     *
     * @param void
     *
     * @return string $groupe : le groupe de l'élève
     */
    public function groupe()
    {
        if (isset($this->detailsEleve['groupe'])) {
            return $this->detailsEleve['groupe'];
        } else {
            return '';
        }
    }

    /**
     * function matricule.
     *
     * @param void
     *
     * @return int le matricule de l'élève
     */
    public function matricule()
    {
        if (isset($this->detailsEleve['matricule'])) {
            return $this->detailsEleve['matricule'];
        } else {
            return '';
        }
    }

    /**
     * calcule un array contenant AA MM et JJ d'âge de l'élève à partir de la date de naissance.
     *
     * @param void()
     *
     * @return string
     */
    public function age()
    {
        // list($ajd['Y'], $ajd['m'], $ajd['d']) = explode('-', date('Y-m-d'));
        // list($nais['Y'], $nais['m'], $nais['d']) = explode('-', $this->detailsEleve['DateNaiss']);
        $dateNaissance = $this->detailsEleve['DateNaiss'];
        $age = self::calculeAge($dateNaissance);

        return $age;

        // calcul du nombre d'années d'âge
        // $age['Y'] = $ajd['Y'] - $nais['Y'];
        //
        // // calcul du nombre de mois d'âge en plus des années
        // // L'anniversaire est-il passé, cette année?
        // if ($ajd['m'] >= $nais['m']) {
        //     // depuis combien de mois?
        //     $age['m'] = $ajd['m'] - $nais['m'];
        // } else {
        //     // on a compté une année de trop: l'anniversaire n'est pas passé
        //     --$age['Y'];
        //     // combien de mois avant l'anniversaire?
        //     $age['m'] = 12 - $nais['m'] + $ajd['m'];
        // }
        //
        // // calcul du nombre de jours après la date-jour de l'anniversaire
        // if ($ajd['d'] >= $nais['d']) {
        //     // la date-jour est passée, le calcul est simple
        //     $age['d'] = $ajd['d'] - $nais['d'];
        // } else {
        //     --$age['m'];
        //     if ($age['m'] < 0) {
        //         $age['m'] = $age['m'] + 12;
        //         --$age['Y'];
        //     }
        //     $nbJoursMois = intval(date('t', $nais['m']));
        //     $age['d'] = $nbJoursMois - $nais['d'] + $ajd['d'];
        // }
        //
        // return $age;
    }

    /**
     * calcule l'âge approximatif d'un élève dont on fournit la date de naissance.
     *
     * @param $dateNaissance
     *
     * @return array
     */
    public static function calculeAge($dateNaissance)
    {
        list($ajd['Y'], $ajd['m'], $ajd['d']) = explode('-', date('Y-m-d'));
        list($nais['Y'], $nais['m'], $nais['d']) = explode('-', $dateNaissance);

        // calcul du nombre d'années d'âge
        $age['Y'] = $ajd['Y'] - $nais['Y'];

        // calcul du nombre de mois d'âge en plus des années
        // L'anniversaire est-il passé, cette année?
        if ($ajd['m'] >= $nais['m']) {
            // depuis combien de mois?
            $age['m'] = $ajd['m'] - $nais['m'];
        } else {
            // on a compté une année de trop: l'anniversaire n'est pas passé
            --$age['Y'];
            // combien de mois avant l'anniversaire?
            $age['m'] = 12 - $nais['m'] + $ajd['m'];
        }

        // calcul du nombre de jours après la date-jour de l'anniversaire
        if ($ajd['d'] >= $nais['d']) {
            // la date-jour est passée, le calcul est simple
            $age['d'] = $ajd['d'] - $nais['d'];
        } else {
            --$age['m'];
            if ($age['m'] < 0) {
                $age['m'] = $age['m'] + 12;
                --$age['Y'];
            }
            $nbJoursMois = intval(date('t', $nais['m']));
            $age['d'] = $nbJoursMois - $nais['d'] + $ajd['d'];
        }

        return $age;
    }

    /**
     * fonction utilisée par jquery pour rechercher les élèves qui correspondent à un critère donné
     * on cherche un élève par son nom ou par son prénom.
     *
     * @param string $fragment
     *
     * @return array : liste de 10 élèves qui correspondent au critère
     */
    public static function searchEleve2($fragment, $partis = false)
    {
        if (!($fragment)) {
            die();
        }
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = "SELECT matricule, nom, prenom, classe, CONCAT(nom,' ',prenom, ' : ',classe) AS nomPrenom ";
        $sql .= 'FROM '.PFX.'eleves ';
        $sql .= "WHERE CONCAT(nom,' ',prenom) LIKE :fragment ";
        if ($partis == false) {
            $sql .= "AND section != 'PARTI' ";
        }
        $sql .= "ORDER BY REPLACE(REPLACE(REPLACE(nom,' ',''),'-',''),'\'',''), prenom ";
        // $sql .= 'LIMIT 0,20 ';
        $requete = $connexion->prepare($sql);

        $fragment = '%'.$fragment.'%';
        $requete->bindParam(':fragment', $fragment, PDO::PARAM_STR);

        $resultat = $requete->execute();
        $listeEleves = array();
        if ($resultat) {
            while ($ligne = $requete->fetch()) {
                $listeEleves[] = $ligne['nomPrenom'];
            }
        }

        Application::DeconnexionPDO($connexion);

        return $listeEleves;
    }

    /**
     * recherche le matricule de l'élève dont la combinaison nom, prenom, classe est fournie
     * cette combinaison est générée par la fonction searchEleve2.
     *
     * @param $nomPrenomClasse : string
     *
     * @return $matricule : integer
     */
    public static function searchMatricule($nomPrenomClasse)
    {
        if (!($nomPrenomClasse)) {
            die();
        }
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT matricule ';
        $sql .= 'FROM '.PFX.'eleves ';
        $sql .= "WHERE CONCAT(nom,' ',prenom, ' : ',classe) = :nomPrenomClasse ";
        $requete = $connexion->prepare($sql);

        $requete->bindParam(':nomPrenomClasse', $nomPrenomClasse, PDO::PARAM_STR);

        $resultat = $requete->execute();
        $matricule = null;
        if ($resultat) {
            $ligne = $requete->fetch();
            $matricule = $ligne['matricule'];
        }
        Application::DeconnexionPDO($connexion);

        return $matricule;
    }

    /**
     * recherche le matricule de l'élève dont la combinaison nom, prenom, classe
     * est environ nom + prenom + classe
     *
     * @param string $nomPrenomClasse
     *
     * @return int
     */
    public static function searchFuzzyMatricule($nomPrenomClasse){
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT matricule ';
        $sql .= 'FROM '.PFX.'eleves ';
        $sql .= "WHERE CONCAT(nom,' ',prenom, ' : ',classe) LIKE :nomPrenomClasse ";
        $requete = $connexion->prepare($sql);

        $nomPrenomClasse = '%'.$nomPrenomClasse.'%';
        $requete->bindParam(':nomPrenomClasse', $nomPrenomClasse, PDO::PARAM_STR);

        $resultat = $requete->execute();
        $matricule = null;
        if ($resultat) {
            $ligne = $requete->fetch();
            $matricule = $ligne['matricule'];
        }
        Application::DeconnexionPDO($connexion);

        return $matricule;
    }

    /**
     * retourne la liste des titulaires d'un élève dont on fournit la classe
     * (permet d'éviter de construire l'objet ELEVE)
     *
     * @param $classe
     *
     * @return array : liste des titulaires
     */
     public function staticGetTitulaires($classe)
     {
         $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
         $sql = 'SELECT '.PFX.'titus.acronyme, nom, prenom ';
         $sql .= 'FROM '.PFX.'titus ';
         $sql .= 'JOIN '.PFX.'profs ON ('.PFX.'profs.acronyme = '.PFX.'titus.acronyme) ';
         $sql .= 'WHERE classe =:classe ';
         $sql .= "ORDER BY REPLACE(REPLACE(REPLACE(nom,' ',''),'-',''),'\'',''), prenom ";
         $requete = $connexion->prepare($sql);

        $requete->bindParam(':classe', $classe, PDO::PARAM_STR, 5);
         $resultat = $requete->execute();
         $listeTitus = array();
         if ($resultat) {
             $requete->setFetchMode(PDO::FETCH_ASSOC);
             while ($ligne = $requete->fetch()) {
                 array_push($listeTitus, $ligne['prenom'].' '.$ligne['nom']);
             }
         }
         Application::DeconnexionPDO($connexion);

         return $listeTitus;
     }

    /**
     *retourne la liste des titulaires de la classe d'un élève.
     *
     * @param void()
     *
     * @return $titulaire : array liste des titulaires de l'élève
     */
    public function titulaires()
    {
        $classe = $this->detailsEleve['classe'];
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT '.PFX.'titus.acronyme, nom, prenom FROM '.PFX.'titus ';
        $sql .= 'JOIN '.PFX.'profs ON ('.PFX.'profs.acronyme = '.PFX.'titus.acronyme) ';
        $sql .= "WHERE classe = '$classe' ";
        $sql .= "ORDER BY REPLACE(REPLACE(REPLACE(nom,' ',''),'-',''),'\'',''), prenom ";
        $resultat = $connexion->query($sql);
        $listeTitus = array();
        if ($resultat) {
            $resultat->setFetchMode(PDO::FETCH_ASSOC);
            while ($ligne = $resultat->fetch()) {
                array_push($listeTitus, $ligne['prenom'].' '.$ligne['nom']);
            }
        }
        Application::DeconnexionPDO($connexion);

        return $listeTitus;
    }

        /**
         * enregistre les informations relatives à un élève et issue d'un formulaire les données sont passées dans le paramètre $post.
         *
         * @param $post
         *
         * @return integer: nombre d'enregistrements 0 ou 1
         */
        public static function enregistrer($post)
        {
            $matricule = $post['matricule'];
            $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
            // recherche des noms des champs à enregistrer
            $sql = 'SHOW COLUMNS FROM '.PFX.'eleves ';
            $resultat = $connexion->query($sql);
            $listeChamps = array();
            while ($ligne = $resultat->fetch()) {
                $nomChamp = $ligne['Field'];
                $listeChamps[$nomChamp] = $nomChamp;
            }
            $sqlInsert = array();
            foreach ($listeChamps as $unChamp) {
                // convertir les dates au format MySQL
                if (substr($unChamp, 0, 4) == 'Date') {
                    $post[$unChamp] = Application::dateMysql($post[$unChamp]);
                }
                $sqlInsert[$unChamp] = "$unChamp='".addslashes($post[$unChamp])."'";
            }

            $sqlUpdate = $sqlInsert;
            // suppression du champ "clef primaire"
            unset($sqlUpdate['matricule']);
            $n = 0;
            $sql = 'INSERT INTO '.PFX.'eleves SET '.implode(',', $sqlInsert);
            $sql .= ' ON DUPLICATE KEY UPDATE '.implode(',', $sqlUpdate);

            $resultat = $connexion->exec($sql);
            if ($resultat > 0) {
                ++$n;
            }
            Application::DeconnexionPDO($connexion);

            return $n;
        }

    /**
     * retourne la liste des écoles d'origine connues de l'élève courant.
     *
     * @param void()
     *
     * @return array
     */
    public function ecoleOrigine()
    {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $matricule = $this->matricule();
        $sql = 'SELECT DISTINCT annee, nomEcole, adresse,cPostal,commune ';
        $sql .= 'FROM '.PFX.'elevesEcoles ';
        $sql .= 'JOIN '.PFX.'ecoles ON ('.PFX.'ecoles.ecole = '.PFX.'elevesEcoles.ecole) ';
        $sql .= "WHERE matricule='$matricule' ";
        $sql .= 'ORDER BY annee ';

        $resultat = $connexion->query($sql);
        $ecoles = array();
        if ($resultat) {
            $resultat->setFetchMode(PDO::FETCH_ASSOC);
            while ($ligne = $resultat->fetch()) {
                $ligne['annee'] = 2000 + $ligne['annee'];
                $ecoles[] = $ligne;
            }
        }
        Application::DeconnexionPDO($connexion);

        return $ecoles;
    }

     /**
      * renvoie un mot de passe aléatoire de longueur et de robustesse choisies.
      *
      * @param int $length : longueur de mot de passe
      * @param int $robustesse: niveau de robustesse souhaité
      *
      * @return $password : renvoi un mot de passe aléatoire
      */
     public function generatePassword($length = 9, $robustesse = 0)
     {
         $voyelles = 'aeiuy';
         $consonnes = 'bdghjkmnpqrstvwxz';
         if ($robustesse & 1) {
             $consonnes .= 'BDGHJKLMNPQRSTVWXZ';
         }
         if ($robustesse & 2) {
             $voyelles .= 'AEUY';
         }
         if ($robustesse & 4) {
             $consonnes .= '23456789';
         }
         if ($robustesse & 8) {
             $consonnes .= '@#$%!';
         }
         $password = '';
         $alt = time() % 2;
         for ($i = 0; $i < $length; ++$i) {
             if ($alt == 1) {
                 $password .= $consonnes[(rand() % strlen($consonnes))];
                 $alt = 0;
             } else {
                 $password .= $voyelles[(rand() % strlen($voyelles))];
                 $alt = 1;
             }
         }

         return $password;
     }

    /**
     * renvoie la liste des coursGrp d'un élève.
     *
     * @param void()
     *
     * @return array
     */
    public function listeCoursGrp()
    {
        $matricule = $this->matricule();
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT coursGrp ';
        $sql .= 'FROM '.PFX.'elevesCours ';
        $sql .= "WHERE matricule = '$matricule' ";
        $resultat = $connexion->query($sql);
        $liste = array();
        if ($resultat) {
            $resultat->setFetchMode(PDO::FETCH_ASSOC);
            while ($ligne = $resultat->fetch()) {
                $liste[] = $ligne['coursGrp'];
            }
        }
        Application::DeconnexionPDO($connexion);

        return $liste;
    }

    /**
     * renvoie la liste des cours d'un élève dont on fournit le matricule
     *
     * @param int $matricule
     *
     * @return array
     */
    public static function getListeCoursEleve($matricule) {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = "SELECT DISTINCT ec.coursGrp, SUBSTR(ec.coursGrp, 1,LOCATE('-',ec.coursGrp)-1) AS cours, ";
        $sql .= 'libelle, nbheures, dsc.statut, section, nom, prenom ';
        $sql .= 'FROM '.PFX.'elevesCours AS ec ';
        $sql .= 'JOIN '.PFX."cours AS dc ON dc.cours = SUBSTR(coursGrp, 1,LOCATE('-',coursGrp)-1) ";
        $sql .= 'JOIN '.PFX.'statutCours AS dsc ON dsc.cadre = dc.cadre ';
        $sql .= 'JOIN '.PFX.'profsCours AS pc ON pc.coursGrp = ec.coursGrp ';
        $sql .= 'JOIN '.PFX.'profs AS dp ON dp.acronyme = pc.acronyme ';
        $sql .= "WHERE matricule = :matricule ";
        $sql .= 'ORDER BY nbheures DESC, libelle ';
        $requete = $connexion->prepare($sql);

        $requete->bindParam(':matricule', $matricule, PDO::PARAM_INT);
        $liste = array();
        $resultat = $requete->execute();
        if ($resultat) {
            $requete->setFetchMode(PDO::FETCH_ASSOC);
            while ($ligne = $requete->fetch()){
                $coursGrp = $ligne['coursGrp'];
                $liste[$coursGrp] = $ligne;
            }
        }

        Application::DeconnexionPDO($connexion);

        return $liste;
    }

    /**
     * liste détaillée de tous les cours qui se donnent à l'élève courant
     *
     * @return array
     */
    public function listeCoursEleve()
    {
        $matricule = $this->matricule();
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = "SELECT DISTINCT ec.coursGrp, SUBSTR(ec.coursGrp, 1,LOCATE('-',ec.coursGrp)-1) AS cours, ";
        $sql .= 'libelle, nbheures, dsc.statut, section, nom, prenom ';
        $sql .= 'FROM '.PFX.'elevesCours AS ec ';
        $sql .= 'JOIN '.PFX."cours AS dc ON dc.cours = SUBSTR(coursGrp, 1,LOCATE('-',coursGrp)-1) ";
        $sql .= 'JOIN '.PFX.'statutCours AS dsc ON dsc.cadre = dc.cadre ';
        $sql .= 'JOIN '.PFX.'profsCours AS pc ON pc.coursGrp = ec.coursGrp ';
        $sql .= 'JOIN '.PFX.'profs AS dp ON dp.acronyme = pc.acronyme ';
        $sql .= "WHERE matricule = '$matricule' ";
        $sql .= 'ORDER BY nbheures DESC, libelle ';

        $resultat = $connexion->query($sql);
        $listeCours = array();
        if ($resultat) {
            $resultat->setFetchMode(PDO::FETCH_ASSOC);
            while ($ligne = $resultat->fetch()) {
                $cours = $ligne['cours'];
                $listeCours[$cours] = $ligne;
            }
        }
        Application::DeconnexionPDO($connexion);

        return $listeCours;
    }

    /**
     * renvoie les données de mot de passe en clair de l'élève.
     *
     * @param void
     *
     * @return array
     */
    public function getDataPwd()
    {
        $matricule = $this->matricule();
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT matricule, user, passwd, mailDomain ';
        $sql .= 'FROM '.PFX.'passwd ';
        $sql .= "WHERE matricule = '$matricule' ";
        $resultat = $connexion->query($sql);
        $dataPwd = array();
        if ($resultat) {
            $resultat->setFetchMode(PDO::FETCH_ASSOC);
            $dataPwd = $resultat->fetch();
        }
        Application::DeconnexionPDO($connexion);

        return $dataPwd;
    }

    /**
     * renvoie les informations de passwd de l'élève dont on fournit le matricule
     * procédure n'utilisant pas l'objet eleve.
     *
     * @param int $matricule
     *
     * @return array
     */
    public static function staticGetDataPwd($matricule)
    {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT matricule, user, passwd, mailDomain ';
        $sql .= 'FROM '.PFX.'passwd ';
        $sql .= "WHERE matricule = '$matricule' ";
        $resultat = $connexion->query($sql);
        $dataPwd = array();
        if ($resultat) {
            $resultat->setFetchMode(PDO::FETCH_ASSOC);
            $dataPwd = $resultat->fetch();
        }
        Application::DeconnexionPDO($connexion);

        return $dataPwd;
    }

    /**
     * renvoie les informations concernant les élèves du groupe $classe
     * à partir de leur adresse mail dans la table MS
     *
     * @param string $groupe
     *
     * @return array
     */
    public function getInfosEleveFromMail($groupe) {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql .= 'SELECT de.matricule, nom, prenom, groupe ';
        $sql .= 'FROM '.PFX.'eleves AS de ';
        $sql .= 'JOIN '.PFX.'csvMs AS ms ON SUBSTR(mail, POSITION("@" IN mail)-4, 4) = de.matricule ';
        $sql .= 'WHERE groupe = :groupe ';
        $sql .= 'ORDER BY REPLACE(REPLACE(REPLACE(nom," ",""),"-",""),"\",""), prenom ';
        $requete = $connexion->prepare($sql);

        $requete->bindParam(':groupe', $groupe, PDO::PARAM_STR,7);

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

        return $ligne;
    }

}
