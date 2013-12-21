<?php
/*
 * class padEleve
 */
class padEleve {

    private $texte;
    /*
     * function setPadEleve
     * @param $proprio
     * 
     * recherche les informations  sur l'élève dans la BD
     * mais uniquement celles qui appartiennent à $proprio
     */
    private function setPadEleve () {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = "SELECT * FROM ".PFX."pad ";
        $sql .= "WHERE matricule='$this->matricule' AND proprio = '$this->proprio'";

        $resultat = $connexion->query($sql);
        if ($resultat) {
			$resultat->setFetchMode(PDO::FETCH_ASSOC);
			$ligne = $resultat->fetch();
			$this->texte = stripslashes($ligne['texte']);
			}
        Application::DeconnexionPDO($connexion);
        }
        
    /* 
     * function getPadText
     * @param
     * renvoie le texte du bloc-notes
     * 
     * */
     public function getPadText() {
		 return $this->texte;
		 }

    /* 
     * function savePadEleve 
     * @param $POST
     * 
     * enregistrement des données élèves
     * $POST provient du $_POST de la fiche et peut contenir diverses données
     * */
    function savePadEleve ($post) {
		$texte = addslashes($post['texte']);
        $matricule = $post['matricule'];
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = "INSERT INTO ".PFX."pad SET matricule='$matricule', texte='$texte', ";
        $sql .= "proprio='$this->proprio' ";
        $sql .= "ON DUPLICATE KEY UPDATE texte='$texte' ";
        $resultat = $connexion->exec($sql);
        Application::DeconnexionPDO($connexion);
        $this->texte = stripslashes($texte);
        return $resultat; // nombre de lignes modifiées dans la BD
        }

	/*
	 * function prevNext
	 *
	 * @param $matricule
	 * @param $listeEleves
	 *
	 * return array ('prev', 'next')
	 *
	 * renvoie un tableau contenant l'élève précédent, l'élève courant et l'élève suivant
	 * celui dont le matricule est passé en argument
	 * */
	public function prevNext($matricule, $listeEleves) {
		$listeEleves = array_keys($listeEleves);
		$pos = array_search($matricule, $listeEleves);
		$prev = ($pos > 0)?$listeEleves[$pos-1]:Null;
		$next = ($pos < count($listeEleves))?$listeEleves[$pos+1]:Null;
		return (array('prev'=>$prev, 'next'=>$next));
		}

	/* 
	 * function syntheseCotes4Titu
	 * @param $matricule
	 * 
	 * retourne une synthèse de toutes les cotes pour le titulaire
	 * 
	 * */
	public function syntheseCotes4Titu ($matricule) {
		$connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
		$sql = "SELECT bulletin, statut, ".PFX."bullSituations.coursGrp, situation, maxSituation, ";
		$sql .= "round(situation*100/maxSituation) as pourcent, sitDelibe, hook, star, degre, cours, nbheures, libelle ";
		$sql .= "FROM ".PFX."bullSituations ";
		$sql .= "JOIN ".PFX."cours ON (".PFX."cours.cours = SUBSTR(coursGrp, 1, LOCATE('-', coursGrp)-1)) ";
		$sql .= "JOIN ".PFX."statutCours ON (".PFX."statutCours.cadre = ".PFX."cours.cadre) ";
		$sql .= "WHERE matricule = '$matricule' ";
		$sql .= "ORDER BY bulletin, statut DESC, nbheures DESC ";

		$synthese = array();
		$resultat = $connexion->query($sql);
		if ($resultat) {
			$resultat -> setFetchMode(PDO::FETCH_ASSOC);
			while ($ligne = $resultat->fetch()) {
				$bulletin = $ligne['bulletin'];
				$sitDelibe = $ligne['sitDelibe'];
				$pourcent = $ligne['pourcent'];
				$ligne['mention'] = str_replace('+','plus',self::calculeMention($pourcent));
				$pourcent = ($pourcent == Null)?'':$pourcent.'%';
				$ligne['pourcent'] = $pourcent;
				if ($sitDelibe != '') {
					if ($ligne['star'] == '1')
						$sitDelibe = $sitDelibe.'*';
					if ($ligne['hook'] == '1')
						$sitDelibe = "[".$sitDelibe."]";
					if ($ligne['degre'] == '1')
						$sitDelibe = $sitDelibe.'²';
					$ligne['sitDelibe'] = $sitDelibe;
					if ($sitDelibe < 50)
						$ligne['echec'] = 'echec';
					}
				$coursGrp = $ligne['coursGrp'];
				$synthese[$bulletin][$coursGrp] = $ligne;
				}
			}
		Application::DeconnexionPDO($connexion);
		afficher_silent($synthese);
		return $synthese;
		}
		
		/*
	 * function calculeMention
	 * @param $moyenne
	 *
	 *
	 * Calcule la mention obetnue par un élève selon les règles en vigueur à l'ISND
	 *
	 * */
	 function calculeMention ($moyenne) {
		if (is_numeric($moyenne)) {
			$moyenneEntiere = intval($moyenne/10);
			switch ($moyenneEntiere) {
				case 10: $mention = 'E'; break;
				case 9: $mention = 'E'; break;
				case 8: if ($moyenne >= 85) $mention = 'TB+';
					else $mention = 'TB'; break;
				case 7: if ($moyenne >= 75) $mention = 'B+';
					else $mention = 'B'; break;
				case 6: if ($moyenne >= 65) $mention = 'AB';
					else $mention = 'S'; break;
				case 5: $mention = 'F'; break;
				default: $mention = 'I';
				}
			}
			else $mention = '';
		return $mention;
	}

		public function listeCoursGrpEleves($listeEleves, $bulletin) {
		if (is_array($listeEleves)) 
			$listeMatricules = implode(",", array_keys($listeEleves));
		else
			$listeMatricules = $listeEleves;

		$connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
		$sql = "SELECT DISTINCT " . PFX . "elevesCours.coursGrp, cours, libelle, nbheures, ";
		$sql .= PFX."statutCours.statut, section, rang, matricule, nom, prenom, ".PFX."profsCours.acronyme ";
		$sql .= "FROM ".PFX."elevesCours ";
		$sql .= "JOIN ".PFX."cours ON (".PFX."cours.cours = SUBSTR(coursGrp, 1,LOCATE('-',coursGrp)-1)) ";
		$sql .= "JOIN ".PFX."statutCours ON (".PFX."statutCours.cadre = ".PFX . "cours.cadre) ";
		$sql .= "JOIN ".PFX."profsCours ON (".PFX."profsCours.coursGrp = ".PFX."elevesCours.coursGrp) ";
		$sql .= "JOIN ".PFX."profs ON (".PFX."profs.acronyme = ".PFX."profsCours.acronyme) ";
		$sql .= "WHERE matricule IN ($listeMatricules) ";
		$sql .= "ORDER BY statut DESC, nbheures DESC, rang, libelle";

		$resultat = $connexion->query($sql);
		$listeCours = array();
		if ($resultat) {
			$resultat -> setFetchMode(PDO::FETCH_ASSOC);
			while ($ligne = $resultat -> fetch()) {
				$matricule = $ligne['matricule'];
				$coursGrp = $ligne['coursGrp'];
				$listeCours[$matricule][$coursGrp] = $ligne;
				}
			}
		// tenir compte de l'historique
		$sql = "SELECT matricule, ".PFX."bullHistoCours.coursGrp, mouvement,  bulletin, ".PFX."statutCours.statut, ";
		$sql .= "cours, libelle, nbheures, rang, section, rang, nom, prenom, ".PFX."profsCours.acronyme ";
		$sql .= "FROM ".PFX."bullHistoCours ";
		$sql .= "JOIN ".PFX."profsCours ON (".PFX."profsCours.coursGrp = ".PFX."bullHistoCours.coursGrp) ";
		$sql .= "JOIN ".PFX."cours ON (".PFX."cours.cours = SUBSTR(".PFX."profsCours.coursGrp, 1, LOCATE('-',".PFX."profsCours.coursGrp)-1)) ";
		$sql .= "JOIN ".PFX."statutCours ON (".PFX."statutCours.cadre = ".PFX."cours.cadre) ";
		$sql .= "JOIN ".PFX."profs ON (".PFX."profs.acronyme = ".PFX."profsCours.acronyme) ";
		$sql .= "WHERE matricule IN ($listeMatricules)";

		$resultat = $connexion->query($sql);

		if ($resultat) {
			while ($ligne = $resultat->fetch()) {
				$matricule = $ligne['matricule'];
				$coursGrp = $ligne['coursGrp'];
				$mouvement = $ligne['mouvement'];
				$depuis = $ligne['bulletin'];
				// si cela concerne l'élève $matricule
				if (isset($listeCours[$matricule])) {
					if ($bulletin < $depuis)
						if ($mouvement == 'ajout')
							unset($listeCours[$matricule][$coursGrp]);
							else $listeCours[$matricule][$coursGrp] = array(
								'coursGrp'=>$coursGrp,
								'cours'=>$ligne['cours'],
								'libelle'=>$ligne['libelle'],
								'nbheures'=>$ligne['nbheures'],
								'statut'=>$ligne['statut'],
								'section'=>$ligne['section'],
								'rang'=>$ligne['rang'], 
								'matricule'=>$matricule,
								'nom'=>$ligne['nom'],
								'prenom'=>$ligne['prenom'],
								'acronyme'=>$ligne['acronyme']
								);
					}
				}
			}
		Application::DeconnexionPDO($connexion);
		return $listeCours;
	}

	/* 
	 * function listePeriodes
	 * 
	 * @param $nbBulletins
	 * 
	 * retourne un array contenant une liste des périodes de l'année scolaire
	 * */
	public function listePeriodes ($nbBulletins) {
		return range(0,$nbBulletins);
		}

	/*
	 * function listeMentions
	 * @param $matricule, $periode
	 *
	 * retourne la mention accordée par le conseil de classe pour une période donnée
	 * à une liste d'élèves donnée
	 */
	function listeMentions($listeEleves, $periode=Null) {
		if (is_array($listeEleves))
			$listeElevesString = implode(",", array_keys($listeEleves));
		else
			$listeElevesString = $listeEleves;
		$connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
		$sql = "SELECT matricule, mention, periode ";
		$sql .= "FROM " . PFX . "bullMentions ";
		$sql .= "WHERE matricule IN ($listeElevesString) ";
		if ($periode != Null)
			$sql .= "AND periode = '$periode'";
		$resultat = $connexion -> query($sql);
		$listeMentions = array();
		while ($ligne = $resultat -> fetch()) {
			$matricule = $ligne['matricule'];
			$mention = $ligne['mention'];
			$periode = $ligne['periode'];
			$listeMentions[$matricule][$periode] = $mention;
			}
		Application::DeconnexionPDO($connexion);
		return $listeMentions;
	}

}      

?>
