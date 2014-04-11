<?php

/*
 * class presences
 */
class presences {

    /*
     * __construct
     * @param 
     */
    function __construct() {
        }
		
	/*
	* function lirePeriodesCours
	*
	* @param
	*
	* @return $listeHeures  renvoie la liste des heures de cours données dans l'école
	*/
	public function lirePeriodesCours () {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
		$sql = "SELECT debut, fin ";
		$sql = "SELECT DATE_FORMAT(debut,'%H:%i') as debut, DATE_FORMAT(fin,'%H:%i') as fin ";
		$sql .= "FROM ".PFX."presencesHeures ";
		$sql .= "ORDER BY debut, fin";

		$resultat = $connexion->query($sql);
		$listePeriodes = array();
		$periode = 1;
		if ($resultat) 
			while ($ligne = $resultat->fetch()) {
			$debut = $ligne['debut'];
			$fin = $ligne['fin'];
			$listePeriodes[$periode++] = array('debut'=>$debut, 'fin'=>$fin);
			}
		Application::deconnexionPDO($connexion);
		return $listePeriodes;
	}
	
	/**
	 * renvoie le nombre d'enregistrements effectivement réalisés et la liste des erreurs
	 *
	 * @param $post : ensemble des informations provenant du formulaire de définition des heures de cours
	 * @return array : résultat de l'enregistrement
	 */
	 public function enregistrerHeures ($post) {
		$listeData = array();		
		foreach ($post as $champ=>$value) {
			$split = explode('_', $champ);
			$champ = isset($split[0])?$split[0]:Null;;

			if (in_array($champ,array('debut','fin','del'))) {
				$periode = $split[1];
				switch ($champ) {
					case 'del':
						$listeData[$periode] = array('debut'=>Null, 'fin'=>Null, 'del'=>true);
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
		$sql = "TRUNCATE TABLE ".PFX."presencesHeures";
		$resultat = $connexion->exec($sql);

		$ok = 0;
		$ko = array();
		$sql = "INSERT INTO ".PFX."presencesHeures ";
		$sql .= "SET debut=:debut, fin=:fin ";
		$requete = $connexion->prepare($sql);
		foreach ($listeData as $periode=>$data) {
			// on n'enregistre que si "del" n'est pas coché
			if (!(isset($data['del']))) {
				$debut = $data['debut'];
				$fin = $data['fin'];
				$dataPrep = array(':debut'=>$debut, ':fin'=>$fin);
				$resultat = $requete->execute($dataPrep);
				if ($resultat == 1) 
					$ok++;
					else $ko[] = $data;
			}
		}
		Application::deconnexionPDO($connexion);
		return array('ok'=>$ok, 'ko'=>$ko);
	 }

	 /**
	  * ajoute une période de cours dans la table de la base de données
	  *
	  * @param
	  * @return $nb  nombre de périodes ajoutées (normalement, une seule)
	  */
	public function ajoutPeriode () {
		$connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
		$sql = "INSERT INTO ".PFX."presencesHeures ";
		$sql .= "SET debut='', fin=''";
		$resultat = $connexion->exec($sql);
		Application::deconnexionPDO($connexion);
		return $resultat;
	}

	/*
	 * function periodeActuelle
	 * @param $listePeriodes : liste des périodes de cours, y compris les heures de début et de fin
	 *
	 * @return integer => numéro de la période en cours
	 */
	public function periodeActuelle($listePeriodes) {
		$heureActuelle = date("H:i");
		$trouve = false; $periode = 0;
		while (!($trouve) && ($periode < count($listePeriodes))) {
			$periode++;
			$trouve = ($heureActuelle < $listePeriodes[$periode]['fin']);
		}
		return $periode;
		}

	/* function enregistrerAbsences
	 *
	 * @param $post : ensemble des informations provenant du formulaire ad hoc
	 * @return integer : nombre d'enregistrements d'absences effectués
	 */
	public function enregistrerAbsences ($post, $listeEleves) {
		$connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);

		$periode = $post['periode'];
		
		$educ = $post['educ'];
		$date = Application::dateMysql($post['date']);
		$selectProf = $post['selectProf'];
		$coursGrp = $post['coursGrp'];
		$heure = date("H:i");
		
		// suppression de toutes les absences pour la période et pour tous les élèves du groupe
		// méthode drastique permettant les corrections immédiatement
		if ($listeEleves) {
			$listeEleves = implode(',',array_keys($listeEleves));
		
			$sql = "DELETE FROM ".PFX."presencesAbsences ";
			$sql .= "WHERE date='$date' AND matricule IN ($listeEleves) AND periode='$periode'";
			$resultat = $connexion->exec($sql);
			}

		// introduction des nouvelles notifications d'absences
		$sql = "INSERT INTO ".PFX."presencesAbsences ";
		$sql .= "SET date=:date, periode=:periode, heure=:heure, educ=:educ, coursGrp=:coursGrp, prof=:prof, ";
		$sql .= "matricule=:matricule";
		$requete = $connexion->prepare($sql);
		
		$resultat = 0;
		foreach ($post as $key=>$value) {
			$key = explode('_',$key);
			if ($key[0] == 'abs') {
				$matricule = $key[1];
				$data = array(':periode'=>$periode,':educ'=>$educ, ':date'=>$date, ':prof'=>$selectProf, ':coursGrp'=>$coursGrp,
							  ':matricule'=>$matricule, ':heure'=>$heure);
				$resultat += $requete->execute($data);
				}
			}
		Application::deconnexionPDO($connexion);
		return $resultat;
	}


	public function lireAbsences ($date, $coursGrp) {
		$date = Application::dateMysql($date);
		$connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
		$sql = "SELECT matricule, periode ";
		$sql .= "FROM ".PFX."presencesAbsences ";
		$sql .= "WHERE date='$date' AND coursGrp='$coursGrp' ";
		$sql .= "ORDER BY matricule, periode";
		$resultat = $connexion->query($sql);
		$listeAbsences = array();
		if ($resultat) {
			while ($ligne = $resultat->fetch()) {
				$matricule = $ligne['matricule'];
				$listeAbsences[$matricule][] = $ligne['periode'];
			}
		}
		Application::deconnexionPDO($connexion);
		return $listeAbsences;
		}
		
	/*
	 * function listeParDate
	 * @param $date : date au format ordinaire
	 *
	 * @return $listeAbsences : liste des absences pour la date indiquée
	 */
	public function listeParDate ($date) {
		$date = Application::dateMysql($date);
		$connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
		$sql = "SELECT ".PFX."presencesAbsences.matricule, nom, prenom, groupe, periode, heure, educ ";
		$sql .= "FROM ".PFX."presencesAbsences ";
		$sql .= "JOIN ".PFX."eleves ON (".PFX."presencesAbsences.matricule = ".PFX."eleves.matricule ) ";
		$sql .= "WHERE date = '$date' ";
		$sql .= "ORDER BY REPLACE(REPLACE(REPLACE(nom, ' ', ''),'''',''),'-',''), prenom, classe, periode";
		$resultat = $connexion->query($sql);
		$listeAbsences = array();
		if ($resultat) {
			$resultat->setFetchMode(PDO::FETCH_ASSOC);
			while ($ligne = $resultat->fetch()) {
				$matricule = $ligne['matricule'];
				$photo = Ecole::photo($matricule);
				$periode = $ligne['periode'];
				$heure = $ligne['heure'];
				$educ = $ligne['educ'];
				$nom = $ligne['nom'];
				$prenom = $ligne['prenom'];
				$groupe = $ligne['groupe'];
				if (!isset($listeAbsences[$matricule]))
					$listeAbsences[$matricule] = array('nom'=>$nom, 'prenom'=>$prenom, 'classe'=>$groupe, 'photo'=>$photo, 'periodes'=>array());
				$listeAbsences[$matricule]['periodes'][$periode] = array('heure'=>$heure, 'educ'=>$educ);
				}
			}
		Application::deconnexionPDO($connexion);
		return $listeAbsences;
	}
	
	/**
	 * retourne la liste des autorisations de sortie pour une période donnée entre $dateDebut et $dateFin
	 * @param $dateDebut
	 * @param $dateFin
	 * @return array
	 */
	public function listeParPeriode($dateDebut, $dateFin) {
		$dateDebut = Application::dateMysql($dateDebut);
		$dateFin = Application::dateMysql($dateFin);
		$connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
		$sql = "SELECT id, pa.matricule, nom, prenom, groupe, date, heure, educ ";
		$sql .= "FROM ".PFX."presencesAutorisations AS pa ";
		$sql .= "JOIN ".PFX."eleves AS e ON (pa.matricule = e.matricule ) ";
		if ($dateFin == '') 
			$sql .= "WHERE date = '$dateDebut' ";
			else $sql .= "WHERE (date >= '$dateDebut') AND (date <= '$dateFin') ";
		$sql .= "ORDER BY date, heure, REPLACE(REPLACE(REPLACE(nom, ' ', ''),'''',''),'-',''), prenom, classe";
		$resultat = $connexion->query($sql);
		$listeAutorisations = array();
		if ($resultat) {
			$resultat->setFetchMode(PDO::FETCH_ASSOC);
			while ($ligne = $resultat->fetch()) {
				$ligne['date'] = Application::datePHP($ligne['date']);
				$date = $ligne['date'];
				$heure = $ligne['heure'];
				$matricule = $ligne['matricule'];
				$listeAutorisations[$date][$matricule][$heure] = $ligne;
			}
		}
		Application::deconnexionPDO($connexion);
		return $listeAutorisations;
		}

	/**
	 * function absencesEleve
	 * @param $matricule : matricule de l'élève dont von veut connaître les dates d'absences
	 *
	 * @return array $listeAbsences : liste des absences de l'élève
	 */
	function absencesEleve ($matricule) {
		$connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
		$sql = "SELECT matricule, periode,date,coursGrp,periode, prof, educ, SUBSTR(coursGrp,1,LOCATE('-', coursGrp)-1) AS cours, ";
		$sql .= "libelle, nom, prenom  ";
		$sql .= "FROM ".PFX."presencesAbsences ";
		$sql .= "JOIN ".PFX."cours ON (".PFX."cours.cours = SUBSTR(coursGrp,1,LOCATE('-', coursGrp)-1)) ";
		$sql .= "JOIN ".PFX."profs ON (".PFX."profs.acronyme = prof) ";
		$sql .= "WHERE matricule = '$matricule' ";
		$sql .= "ORDER BY date, periode ";
		$resultat = $connexion->query($sql);
		$liste = array();
		if ($resultat) {
			$resultat -> setFetchMode(PDO::FETCH_ASSOC);
			$liste = $resultat->fetchAll();
			}
		Application::deconnexionPDO($connexion);
		$listeAbsences = array();
		foreach ($liste as $uneAbsence) {
			$date = 	Application::datePHP($uneAbsence['date']);
			$periode = $uneAbsence['periode'];
			$listeAbsences[$date][$periode] = $uneAbsence;
		}
		return $listeAbsences;
	}

	/**
	 * listes des autorisations de sorties pour un élève dont on fournit le matricule
	 * @param $matricule
	 * @return array
	 */
	public function listeAutorisations ($matricule) {
		$connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
		$sql = "SELECT id, matricule, educ, parent, media, date, heure ";
		$sql .= "FROM ".PFX."presencesAutorisations AS aut ";
		$sql .= "WHERE matricule = '$matricule' ";
		$sql .= "ORDER BY date, heure ";
		$resultat = $connexion->query($sql);
		$liste = array();
		if ($resultat) {
			$resultat -> setFetchMode(PDO::FETCH_ASSOC);
			while ($ligne = $resultat->fetch()) {
				$id = $ligne['id'];
				$date = $ligne['date'];
				$ligne['date'] = Application::datePHP($date);
				$liste[$id] = $ligne;
				}
			}
		Application::deconnexionPDO($connexion);
		return $liste;
	}

	/**
	 * enregistrement des données d'autorisation de sortie
	 * @param $post : données sortant d'un formulaire écran
	 * @return $nb : nombre de modifications dans la BD (normalement 1)
	 */
	public function saveAutorisation($post) {
		$id = isset($post['id'])?$post['id']:Null;
		$educ = isset($post['user'])?$post['user']:Null;
		$matricule = isset($post['matricule'])?$post['matricule']:Null;
		$parent = isset($post['parent'])?$post['parent']:Null;
		$media = isset($post['media'])?$post['media']:Null;
		$date = isset($post['date'])?Application::dateMysql($post['date']):Null;
		$heure = isset($post['heure'])?$post['heure']:Null;
		$connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
		$sql = "INSERT INTO ".PFX."presencesAutorisations ";
		$sql .= "SET id='$id', matricule='$matricule', educ='$educ', parent='$parent', media='$media', date='$date', heure='$heure' ";
		$sql .= "ON DUPLICATE KEY UPDATE educ='$educ', parent='$parent', media='$media', date='$date', heure='$heure' ";
		$nb = $connexion->exec($sql);
		Application::deconnexionPDO($connexion);
		return $nb;
	}
	
	/**
	 * renvoie les informations relatives à l'autorisation enregistrée sous $id dans la base de données
	 * @param $id
	 * @return array
	 */
	public function getAutorisation($id) {
		$connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
		$sql = "SELECT id, matricule, educ, parent, media, date, heure ";
		$sql .= "FROM ".PFX."presencesAutorisations ";
		$sql .= "WHERE id='$id' ";
		$sql .= "ORDER BY date, heure ";
		$resultat = $connexion->query($sql);
		$ligne = array();
		if ($resultat) {
			$resultat->setFetchMode(PDO::FETCH_ASSOC);
			$ligne = $resultat->fetch();
			$ligne['date'] = Application::datePHP($ligne['date']);
		}
		Application::deconnexionPDO($connexion);
		return $ligne;
	}
	
	/**
	 * Suppression de l'autorisation de sortie enregistrée sous $id dans la base de données
	 * @param $id
	 * @return $nb : nombre de suppressions
	 */
	public function delAutorisation($id) {
		$connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
		$sql = "DELETE FROM ".PFX."presencesAutorisations ";
		$sql .= "WHERE id='$id' ";
		$nb = $connexion->exec($sql);
		Application::deconnexionPDO($connexion);
		return $nb;
	}

	/**
	 * enregistrement du local, de la période, du jour de la semaine (numérique commençant par 1 pour lundi), du prof et du cours
	 * @param $local
	 * @param $periode
	 * @param $prof
	 * @param $coursGrp
	 * @return $nb : nombre d'enregistrements/updates réalisés
	 */
	public function saveLocalCoursGrp ($local, $periode, $prof, $coursGrp) {
		$date = strftime("%d/%m/%Y");
		$jourSemaine = strftime('%w',$Application->dateFR2Time($date));
		$connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
		$sql = "INSERT INTO ".PFX."locauxDatesCours ";
		$sql .= "SET local='$local', jour='$jourSemaine', periode='$periode', acronyme='$prof', coursGrp='$coursGrp' ";
		$sql .= "ON DUPLICATE KEY UPDATE acronyme='$prof', coursGrp='$coursGrp' ";
		$nb = $connexion->exec($sql);
		Application::deconnexionPDO($connexion);
		return $nb;
	}

	
}      

?>
