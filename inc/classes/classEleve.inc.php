<?php

/*
 * class eleve
 */

class eleve {

    private $detailsEleve;

    /*
     * __construct
     * @param $matricule = matricule de l'élève
     */
    function __construct($matricule) {
        if ($matricule != Null)
        $this->setDetailsEleve($matricule);
		else $this->detailsEleve = Null;
    }

    /*
     * fixe tous les détails personnels de l'élève dans l'OBJECT
     * à partir de la BD
     * function setDetailsEleve
     * @param $matricule
     */
    function setDetailsEleve($matricule){
        if (!(isset($this->detailsEleve))) {
            $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
            $sql = "SELECT de.*, user, mailDomain FROM ".PFX."eleves AS de ";
            $sql .= "LEFT JOIN ".PFX."passwd AS dp ON (de.matricule = dp.matricule) ";
            $sql .= "WHERE de.matricule = '$matricule'";
            $resultat = $connexion->query($sql);
            if ($resultat) {
                $resultat->setFetchMode(PDO::FETCH_ASSOC);
                $this->detailsEleve =  $resultat->fetch();
                }
            Application::DeconnexionPDO($connexion);
            $this->detailsEleve['age'] = $this->age();
            $this->detailsEleve['photo'] = Ecole::photo($this->detailsEleve['matricule']);
            }
//        if ($this->detailsEleve['DateNaiss'] != '0000-00-00')
//			$this->detailsEleve['age'] = $this->age();
		
        }

    /*
     * function getDetailsEleve
     * @param
     * retourne toutes les informations connues sur cet élève
     */
    function getDetailsEleve() {
        if ($this->detailsEleve)
            return $this->detailsEleve;
            else return Null;
    }
    /*
	 * function classe
	 * @param :
	 * @return $classe : la classe de l'élève
	 */
    public function classe () {
        if (isset($this->detailsEleve['classe']))
            return $this->detailsEleve['classe'];
            else return '';
        }

	/**
	 * année d'étude de l'élève concerné
	 * @return integer : l'année d'étude
	 */
	public function annee () {
		$classe = $this->classe();
		if ($classe != '')
			return substr($classe,0,1);
			else return '';
		}

    /*
	 * function groupe
	 * @param :
	 * @return $groupe : le groupe de l'élève
	 */
    function groupe (){
        if (isset($this->detailsEleve['groupe']))
            return $this->detailsEleve['groupe'];
            else return '';
        }

	/*
	 * function matricule
	 * @param :
	 * @return : le matricule de l'élève
	 */
	function matricule() {
		if (isset($this->detailsEleve['matricule']))
			return $this->detailsEleve['matricule'];
			else return '';
		}

    /**
     * calcule un array contenant AA MM et JJ d'âge de l'élève à partir de la date de naissance
     * function age
     * @param
     */
    function age() {
        list($ajd['Y'], $ajd['m'], $ajd['d']) = explode("-",date("Y-m-d"));
        list($nais['Y'], $nais['m'], $nais['d']) = explode ('-', $this->detailsEleve['DateNaiss']);
        // calcul du nombre d'années d'âge
        $age['Y'] = $ajd['Y']-$nais['Y'];

        // calcul du nombre de mois d'âge en plus des années
        // L'anniversaire est-il passé, cette année?
        if ($ajd['m'] >= $nais['m']) {
            // depuis combien de mois?
            $age['m'] = $ajd['m']-$nais['m'];
        } else {
            // on a compté une année de trop: l'anniversaire n'est pas passé
            $age['Y']--;
            // combien de mois avant l'anniversaire?
            $age['m'] = 12-$nais['m']+$ajd['m'];
            }

        // calcul du nombre de jours après la date-jour de l'anniversaire
        if ($ajd['d'] >= $nais['d']) {
            // la date-jour est passée, le calcul est simple
            $age['d'] = $ajd['d']-$nais['d'];
            } else {
                $age['m']--;
                if ($age['m'] < 0) {
                    $age['m']= $age['m']+12;
                    $age['Y']--;
                }
                $nbJoursMois = intval(date("t",$nais['m']));
                $age['d'] = $nbJoursMois - $nais['d'] + $ajd['d'];
                }
        return $age;
    }


    /*
     * fonction utilisée par jquery pour rechercher les élèves qui correspondent à un critère donné
     * on cherche un élève par son nom ou par son prénom
     * @param $fragment
     * @return array : liste des élèves qui correspondent au critère
     */
    public static function searchEleve2($fragment) {
        if (!($fragment)) die();
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = "SELECT matricule, nom, prenom, CONCAT(nom,' ',prenom, ' : ',classe) AS nomPrenom ";
		$sql .= "FROM ".PFX."eleves ";
		$sql .= "WHERE (nom LIKE '%$fragment%' OR prenom LIKE '%$fragment%') AND section != 'PARTI' ";
        $sql .= "ORDER BY REPLACE(REPLACE(REPLACE(nom,' ',''),'-',''),'\'',''), prenom";

        $resultat = $connexion->query($sql);
        $listeEleves = array();
        if ($resultat) {
        while ($ligne = $resultat->fetch()) {
            array_push($listeEleves, array(
                    'value'=>$ligne['nomPrenom'], 'matricule'=>$ligne['matricule'],
                    'nom'=>$ligne['nom'], 'prenom'=>$ligne['prenom'])
                    );
                }
            }
        Application::DeconnexionPDO($connexion);
        return $listeEleves;
	}

    /*
     * fonction utilisée par jquery pour rechercher les élèves qui correspondent à un critère donné
     * on cherche un élève par son nom, par son prénom ou par sa classe
     * function searchEleve
     * @param $fragment, critere
     */
    public static function searchEleve($fragment, $critere) {
        if (!($fragment && $critere)) die("");
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = "SELECT matricule, CONCAT(nom,' ',prenom,': ', classe) AS nomPrenom, nom, prenom, classe ";
		$sql .= "FROM ".PFX."eleves ";
        switch ($critere) {
            case 'nom':
                $sql .= "WHERE nom LIKE '%$fragment%' ";
                break;
            case 'prenom':
                $sql .= "WHERE prenom LIKE '%$fragment%' ";
                break;
            case 'classe':
                $sql .= "WHERE classe LIKE '%$fragment%' ";
                break;
            default:
                die("inapproprieted criteria");
            }
        $sql .= "ORDER BY REPLACE(REPLACE(REPLACE(nom,' ',''),'-',''),'\'',''), prenom";
        $resultat = $connexion->query($sql);
        $listeEleves = array();
        if ($resultat) {
        while ($ligne = $resultat->fetch()) {
            array_push($listeEleves, array(
                    'value'=>$ligne['nomPrenom'], 'matricule'=>$ligne['matricule'],
                    'nom'=>$ligne['nom'], 'prenom'=>$ligne['prenom'],
                    'classe'=>$ligne['classe'])
                    );
                }
            }
        Application::DeconnexionPDO($connexion);
        return $listeEleves;
	}

    /*
     *retourne la liste des titulaires de la classe d'un élève
     * function titulaires
     * @param
     * @return $titulaire : array liste des titulaires de l'élève
     */
    function titulaires() {
        $classe = $this->detailsEleve['classe'];
       	$connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = "SELECT ".PFX."titus.acronyme, nom, prenom FROM ".PFX."titus ";
        $sql .= "JOIN ".PFX."profs ON (".PFX."profs.acronyme = ".PFX."titus.acronyme) ";
        $sql .= "WHERE classe = '$classe' ";
        $sql .= "ORDER BY REPLACE(REPLACE(REPLACE(nom,' ',''),'-',''),'\'',''), prenom ";
        $resultat = $connexion->query($sql);
        $listeTitus = array();
        if ($resultat) {
            $resultat->setFetchMode(PDO::FETCH_ASSOC);
            while ($ligne = $resultat->fetch()) {
                array_push($listeTitus, $ligne['prenom']." ".$ligne['nom']);
                }
            }
        Application::DeconnexionPDO($connexion);
        return $listeTitus;
        }


        /*
         * function enregistrer
         * @param $post
         * @return integer: nombre d'enregistrements 0 ou 1
         *
         * enregistre les informations relatives à un élève et issue d'un formulaire
         * les données sont passées dans le paramètre $post
         */
        function enregistrer($post) {
            $matricule = $post['matricule'];
			$connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
			// recherche des noms des champs à enregistrer
			$sql = "SHOW COLUMNS FROM ".PFX."eleves";
			$resultat = $connexion->query($sql);
            $listeChamps = array();
            while ($ligne = $resultat->fetch()) {
                $nomChamp = $ligne['Field'];
                $listeChamps[$nomChamp] = $nomChamp;
				}
            $sqlInsert = array();
            foreach ($listeChamps as $unChamp)
                $sqlInsert[$unChamp] = "$unChamp='".addslashes($post[$unChamp])."'";

            $sqlUpdate = $sqlInsert;
            // suppression du champ "clef primaire"
            unset($sqlUpdate['matricule']);
            $sql = "INSERT INTO ".PFX."eleves SET ".implode(",",$sqlInsert);
            $sql .= " ON DUPLICATE KEY UPDATE ".implode(",",$sqlUpdate);
			$resultat = $connexion->exec($sql);
			Application::DeconnexionPDO($connexion);
            return $resultat;

        }

	/*
	 * function ecoleOrigine
	 *
	 * retourne la liste des écoles d'origine connues de l'élève dont on fournit le matricule
	 * */
	public function ecoleOrigine () {
		$connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
		$matricule = $this->matricule();
		$sql = "SELECT annee, nomEcole, adresse,cPostal,commune ";
		$sql .= "FROM ".PFX."elevesEcoles ";
		$sql .= "JOIN ".PFX."ecoles ON (".PFX."ecoles.ecole = ".PFX."elevesEcoles.ecole) ";
		$sql .= "WHERE matricule='$matricule' ";
		$sql .= "ORDER BY annee ";

		$resultat = $connexion->query($sql);
		$ecoles = array();
		if ($resultat) {
            $resultat->setFetchMode(PDO::FETCH_ASSOC);
			while ($ligne = $resultat->fetch()) {
				$ligne['annee'] = 2000+$ligne['annee'];
				$ecoles[]=$ligne;
				}
			}
		Application::DeconnexionPDO($connexion);
		return $ecoles;
		}
	/**
	 * function generatePassword
	 * @param integer $length : longueur de mot de passe
	 * @param integer $robustesse: niveau de robustesse souhaité
	 *
	 * @return $password : renvoi un mot de passe aléatoire
	 */
	 function generatePassword($length=9, $robustesse=0) {
	  $voyelles = "aeiuy";
	  $consonnes = "bdghjkmnpqrstvwxz";
	  if ($robustesse & 1) {
		 $consonnes .= "BDGHJKLMNPQRSTVWXZ";
		 }
	  if ($robustesse & 2) {
		 $voyelles .= "AEUY";
		 }
	  if ($robustesse & 4) {
		 $consonnes .= "23456789";
		 }
	  if ($robustesse & 8) {
		 $consonnes .= "@#$%!";
		 }
		$password = "";
		$alt = time() % 2;
		for ($i = 0; $i < $length; $i++) {
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
}

?>
