<?php	
	### --------------------------------------------------------------------###
	 function afficher ($tableau, $die=false) {
		if (count($tableau) == 0)
			echo "Tableau vide";
			else {
				echo "<pre>";
				print_r ($tableau);
				echo "</pre>";
				echo "<hr />";
			}
	if ($die) die(); 
	}
	
	### --------------------------------------------------------------------###
	 function afficher_silent ($tableau, $die=false) {
		echo "<!-- ";
		afficher($tableau, $die);
		echo "-->";
		}
	
	// --------------------------------------------------------------------
	// renvoi du mot de passe
	function renvoiMdp ($acronyme) {
		if (isset($acronyme)) {
		$connexion = connexion (NOM, MDP, BASE, SERVEUR);
		$sql = "SELECT nom, prenom, mail ";
		$sql .= "FROM ".PREFIXETABLES."profs ";
		$sql .= "WHERE acronyme='$acronyme'";
		$resultat = executeRequete($sql, $connexion);
		// cet acronyme existe. On a peut-etre une adresse e-mail
		$ligne = ligneSuivante($resultat);
		$mail = $ligne['mail'];
			
		if ($mail != "") {
			// génération d'un nouveau mot de passe
			$nouveauMotDePasse = generatePassword (8, 3);
			// encodage md5
			$md5Mdp = md5($nouveauMotDePasse);
			$sql = "UPDATE ".PREFIXETABLES."profs ";
			$sql .= "SET mdp = '$md5Mdp' ";
			$sql .= "WHERE acronyme='$acronyme'";
			$resultat = executeRequete($sql, $connexion);
			mail($mail, PWD." ".TITREGENERAL, sprintf(NEWPWD, $nouveauMotDePasse),
				 "From: ".ROBOT."@".DOMAIN);
			mail(MAILADMIN, PWD, "$acronyme : $mail");
			echo sprintf (NEWPWDSEND, $mail);
			Deconnexion($connexion);
			}
			else echo NOMAIL.ADMINISTRATOR;
		}
		else echo USERNAME;
		}
	
/*
	
	### --------------------------------------------------------------------###
	 function repertoireActuel () {
		$dir = array_reverse(explode("/",getcwd()));
		return $dir[0];
	}
	*/
	/*
	### --------------------------------------------------------------------###
	 function accesApplication ($nomApplication) {
		// vérifier que l'utilisateur est identifié pour l'application active
		return 	(
				isset($_SESSION['identite']['acronyme']) &&
				isset($_SESSION['identite']['mdp']) &&
				$_SESSION['applicationName'] == $nomApplication
				);
	}
	### --------------------------------------------------------------------###
	// Vérification de l'activation du module pour l'utilisateur actif
	 function accesModule($BASEDIR) {
		$applisAutorisees = array_keys($_SESSION['applications']);
		if (!(in_array(repertoireActuel(), $applisAutorisees)))
			header("Location: ".$BASEDIR."index.php");
			else return true;
	}
	
	*/
	/*
   ### --------------------------------------------------------------------###
   function generatePassword($length=9, $robustesse=0) {
	  $voyelles = "aeuy";
	  $consonnes = "bdghjmnpqrstvz";
	  if ($robustesse & 1) {
		 $consonnes .= "BDGHJLMNPQRSTVWXZ";
		 }
	  if ($robustesse & 2) {
		 $voyelles .= "AEUY";
		 }
	  if ($robustesse & 4) {
		 $consonnes .= "23456789";
		 }
	  if ($robustesse & 8) {
		 $consonnes .= "@#$%";
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
	}*/
	
	//### --------------------------------------------------------------------
	//// convertir les dates au format usuel jj/mm/AAAA en YY-mm-dd pour MySQL
	//## ---------------------------------------------------------------------
	//function dateMysql ($date) {
	//	$dateArray = explode("/",$date);
	//	$sqlArray=array_reverse($dateArray);
	//	$date = implode("-",$sqlArray);
	//	return $date;
	//	}
	//	
	//function dateMysqlGlue ($date, $glue) {
	//	$dateArray = explode($glue,$date);
	//	$sqlArray=array_reverse($dateArray);
	//	$date = implode('-',$sqlArray);
	//	return $date;
	//	}
	//
	//### --------------------------------------------------------------------
	//// converitr les date au format MySQL vers le format usuel
	//### --------------------------------------------------------------------
	//function datePHP ($dateMysql) {
	//	$dateArray = explode("-", $dateMysql);
	//	$phpArray = array_reverse($dateArray);
	//	$date = implode("/", $phpArray);
	//	return $date;
	//	}
	//	
	//function datePHPglue ($dateMysql, $glue) {
	//	$dateArray = explode('-', $dateMysql);
	//	$phpArray = array_reverse($dateArray);
	//	$date = implode($glue, $phpArray);
	//	return $date;
	//	}
	//	
	//function isNumericNotNull ($data) {
	//	return (($data != Null) && (is_numeric($data)) && ($data != ''));
	//	}
	//	
	//function heureMySQL ($heure) {
	//	$heureArray = explode(":",$heure);
	//	$sqlArray = array_reverse($heureArray);
	//	$heure = implode(":",$sqlArray);
	//	return $heure;
	//	}
	//	
	//function heurePHP ($heure) {
	//	$heureArray = explode(":",$heure);
	//	$sqlArray = array_reverse($heureArray);
	//	$heure = implode(":",$sqlArray);
	//	return $heure;
	//	}




?>
