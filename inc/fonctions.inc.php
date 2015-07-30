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

	// // --------------------------------------------------------------------
	// // renvoi du mot de passe
	// function renvoiMdp ($acronyme) {
	// 	if (isset($acronyme)) {
	// 	$connexion = connexion (NOM, MDP, BASE, SERVEUR);
	// 	$sql = "SELECT nom, prenom, mail ";
	// 	$sql .= "FROM ".PREFIXETABLES."profs ";
	// 	$sql .= "WHERE acronyme='$acronyme'";
	// 	$resultat = executeRequete($sql, $connexion);
	// 	// cet acronyme existe. On a peut-etre une adresse e-mail
	// 	$ligne = ligneSuivante($resultat);
	// 	$mail = $ligne['mail'];
	//
	// 	if ($mail != "") {
	// 		// génération d'un nouveau mot de passe
	// 		$nouveauMotDePasse = generatePassword (8, 3);
	// 		// encodage md5
	// 		$md5Mdp = md5($nouveauMotDePasse);
	// 		$sql = "UPDATE ".PREFIXETABLES."profs ";
	// 		$sql .= "SET mdp = '$md5Mdp' ";
	// 		$sql .= "WHERE acronyme='$acronyme'";
	// 		$resultat = executeRequete($sql, $connexion);
	// 		mail($mail, PWD." ".TITREGENERAL, sprintf(NEWPWD, $nouveauMotDePasse),
	// 			 "From: ".ROBOT."@".DOMAIN);
	// 		mail(MAILADMIN, PWD, "$acronyme : $mail");
	// 		echo sprintf (NEWPWDSEND, $mail);
	// 		Deconnexion($connexion);
	// 		}
	// 		else echo NOMAIL.ADMINISTRATOR;
	// 	}
	// 	else echo USERNAME;
	// 	}

?>
