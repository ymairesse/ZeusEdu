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
		
	/**
	* renvoie la liste des heures de cours données dans l'école
	* @param void()
	* @return array $listeHeures  
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
	 * Enregistrement des définitions des périodes de cours
	 * renvoie le nombre d'enregistrements effectivement réalisés et la liste des erreurs
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
	 * @param void()
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

	/**
	 * retourne le numéro de la période actuelle
	 * @param $listePeriodes : liste des périodes de cours, y compris les heures de début et de fin
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



// ******************************************************************************************************


	/** 
	 * retourne la liste des présences et absences pour un élève et pour une série de dates données
	 * @param integer : $matricule
	 * @param array|string: $listeDates (au format PHP)
	 * @return array
	 */
	public function listePresencesEleveMultiDates($listeDates, $matricule) {
		foreach ($listeDates as $k=>$uneDate) {
			$listeDatesSQL[$k] = Application::dateMysql($listeDates[$k]);
			}
		$listeDatesString = "'".implode("','",$listeDatesSQL)."'";

		$connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
		$sql = "SELECT educ, periode, statut, date, quand, heure, parent, media ";
		$sql .= "FROM ".PFX."presencesEleves AS dpe ";
		$sql .= "LEFT JOIN ".PFX."presencesLogs AS dpl ON dpl.id = dpe.id ";
		$sql .= "WHERE matricule = '$matricule' ";
		$sql .= "AND date IN ($listeDatesString) ";
		$sql .= "ORDER BY date ";

		$resultat = $connexion->query($sql);
		$liste = array();
		if ($resultat) {
			$resultat->setFetchMode(PDO::FETCH_ASSOC);
			while ($ligne = $resultat->fetch()) {
				$date=Application::datePHP($ligne['date']);
				$ligne['date']=$date;
				$ligne['quand'] = APPLICATION::datePHP($ligne['quand']);
				$periode = $ligne['periode'];
				$liste[$date][$periode]=$ligne;
				}
			}
		Application::deconnexionPDO($connexion);

		$listePeriodes = self::lirePeriodesCours();

		$listePresences = array();
		foreach ($liste as $uneDate=>$dataUneDate) {
			// on prépare une journée générique sans prise de présences
			foreach ($listePeriodes as $noPeriode=>$wtf) {
				$listePresences[$uneDate][$noPeriode] = array('educ'=>'', 'statut'=>'indetermine', 'quand'=>'', 'heure'=>'', 'parent'=>'', 'media'=>'');
				}
			// on ajoute les informations dont on dispose aux endroits ad hoc
			foreach ($dataUneDate as $noPeriode=>$data) {
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
	 * retourne la liste des présences et absences pour une liste d'élèves donnée et pour une date donnée
	 * @param string : $datePHP (au format PHP)
	 * @param array | string: $listeEleves
	 * @return array
	 */
	public function listePresencesElevesDate($datePHP, $listeEleves) {
		if (is_array($listeEleves))
			$listeElevesString = implode(',',array_keys($listeEleves));
			else $listeElevesString = $listeEleves;
		$date = Application::dateMysql($datePHP);
		$connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
		$sql = "SELECT dpe.matricule, nom, prenom, groupe, educ, periode, statut, date, quand, heure, parent, media ";
		$sql .= "FROM ".PFX."presencesEleves AS dpe ";
		$sql .= "JOIN ".PFX."eleves AS de ON de.matricule = dpe.matricule ";
		$sql .= "LEFT JOIN ".PFX."presencesLogs AS dpl ON dpl.id = dpe.id ";
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
				$ligne['quand']  = Application::datePHP($ligne['quand']);
				$liste[$matricule][$periode]=$ligne;
				}
			}
		Application::deconnexionPDO($connexion);

		$listePeriodes = self::lirePeriodesCours();
		// pour chaque élève, on prépare une journée sans prise de présences
		$journee = array();
		foreach ($listePeriodes as $noPeriode=>$wtf) {
			$journee[$noPeriode] = array('educ'=>'', 'statut'=>'indetermine', 'quand'=>'', 'heure'=>'', 'parent'=>'', 'media'=>'');
			}

		if (!(is_array($listeEleves)))
			$listeEleves = array($listeEleves=>'wtf');

		$listePresences = array();
		foreach ($listeEleves as $matricule=>$wtf) {
			$listePresences[$matricule] = $journee;	// initialisation de la journée vide (aucune présence prise)
			// on parcourt la liste des présences prises
			foreach ($liste as $matricule=>$dataJournee) {
				// et on y met les informations des présences prises
				foreach ($dataJournee as $periode=>$data) {
						$listePresences[$matricule][$periode] = array(
							'educ'=>$liste[$matricule][$periode]['educ'],
							'statut'=>$liste[$matricule][$periode]['statut'],
							'quand'=>$liste[$matricule][$periode]['quand'],
							'heure'=>$liste[$matricule][$periode]['heure'],
							'parent'=>$liste[$matricule][$periode]['parent'],
							'media'=>$liste[$matricule][$periode]['media']
							);
					}
				}
			}
		return $listePresences;
		}

	/** 
	 * retourne la liste des absences et des présences pour une date donnée pour l'ensemble de l'école
	 * @param $date
	 * @param array('liste1'=>...,'liste2'=>...)  $statutsAbs : les statuts des types d'absences qui doivent être recensées
	 * @return array $listeAbsences: deux listes des absences pour la date donnée et triées par statuts d'absences
	 */
	public function listePresencesDate($date, $statutsAbs) {
		$connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
		$date = Application::dateMysql($date);
		$sql = "SELECT date, periode, educ, dpe.matricule, statut, nom, prenom, groupe AS classe, quand, heure, parent, media ";
		$sql .= "FROM ".PFX."presencesEleves AS dpe ";
		$sql .= "JOIN ".PFX."eleves AS de ON de.matricule = dpe.matricule ";
		$sql .= "JOIN ".PFX."presencesLogs AS dpl ON dpl.id = dpe.id ";
		$sql .= "WHERE date = '$date' ";
		$sql .= "ORDER BY nom, prenom, classe, date ASC, periode ASC ";

		$resultat = $connexion->query($sql);
		$statutsAbsMerge = array_merge($statutsAbs['liste1'],$statutsAbs['liste2']);
		$liste = array();
		$absentsListe1 = $absentsListe2 = array();

		if ($resultat) {
			$resultat->setFetchMode(PDO::FETCH_ASSOC);
			while ($ligne = $resultat->fetch()) {
				$matricule = $ligne['matricule'];
				$periode = $ligne['periode'];
				$liste[$matricule]['identite']['nom']=$ligne['nom'].' '.$ligne['prenom'];
				$liste[$matricule]['identite']['classe']=$ligne['classe'];
				$liste[$matricule]['identite']['photo']=Ecole::photo($matricule);
				
				// il y a une mention de statut de présence dans la journée: il faudra que l'élève soit mentionné dans la liste des absents
				// est-ce autre chose qu'une mention de présence ou pas de prise de présence?
				if (in_array($ligne['statut'], $statutsAbsMerge)) {
					// dans ce cas, est-ce une absence de la liste 1?
					if (in_array($ligne['statut'],$statutsAbs['liste1']))
						$absentsListe1[$matricule][$periode] = true;
					// ou est-ce une absence de la liste 2?
					if (in_array($ligne['statut'], $statutsAbs['liste2']))
						$absentsListe2[$matricule][$periode] = true;
					}

				$ligne['date']=APPLICATION::datePHP($ligne['date']);
				$ligne['quand']=APPLICATION::datePHP($ligne['quand']);
				$liste[$matricule]['presences'][$periode] = $ligne;
				}
			}

		Application::deconnexionPDO($connexion);
		// on ne retient que les fiches pour lesquelles il y a une absence au moins
		$liste1 = array_intersect_key($liste, $absentsListe1);
		$liste2 = array_intersect_key($liste, $absentsListe2);		
		return array('liste1'=>$liste1,'liste2'=>$liste2);
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

	/** 
	 * fonction générale d'enregistrement des présences et des absences, quel que soit le statut
	 * @param array $post : données sortant d'un formulaire écran
	 * @return $nb : nombre de modifications dans la BD 
	 */
	public function savePresences($post, $listeEleves,$listePeriodes) {
		$educ = isset($post['educ'])?$post['educ']:Null;
		$matricule = isset($post['matricule'])?$post['matricule']:Null;
		$parent = isset($post['parent'])?$post['parent']:Null;
		$media = isset($post['media'])?$post['media']:Null;
		$date = isset($post['date'])?Application::dateMysql($post['date']):Null;
		$heure = date("H:i");
		$quand = date("Y-m-d");
		
		$connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
		// introduction dans la table des logs et récupération de l'id autoIncrementé
		$sql = "INSERT INTO ".PFX."presencesLogs ";
		$sql .= "SET educ='$educ', parent='$parent', media='$media', quand='$quand', heure='$heure' ";

		$resultat = $connexion->exec($sql);
		$id=$connexion->lastInsertId();

		$nb = 0;
		foreach ($listePeriodes as $noPeriode=>$wtf) {
			foreach ($listeEleves as $matricule=>$wtf) {
				// si pas de statut dans le formulaire, l'élève est marqué présent. Permet la prise de présence absent/présent en classe
				$statut = (isset($post['matr-'.$matricule.'_periode-'.$noPeriode]))?$post['matr-'.$matricule.'_periode-'.$noPeriode]:'present';
				$sql = "INSERT INTO ".PFX."presencesEleves ";
				$sql .= "SET id='$id', matricule='$matricule', date='$date', periode='$noPeriode', statut='$statut' ";
				$sql .= "ON DUPLICATE KEY UPDATE id='$id', periode='$noPeriode', statut='$statut' ";
				$resultat += $connexion->exec($sql);
				$nb++;  // ne compte les boucles qu'une seule fois alors que "ON DUPLICATE" signale 2 modifications dans la table
				}
			}
		Application::deconnexionPDO($connexion);
		return $nb;
	}
	
	/** 
	 * enregistrement des signalements d'absences (éventuellement sur plusieurs jours
	 * @param array $post : les informations provenant du formulaire de saisie
	 * @param int $matricule : le matricule de l'élève concerné
	 */
	public function saveAbsences($post, $matricule) {
		$educ = isset($post['educ'])?$post['educ']:Null;
		$matricule = isset($post['matricule'])?$post['matricule']:Null;
		$parent = isset($post['parent'])?$post['parent']:Null;
		$media = isset($post['media'])?$post['media']:Null;
		$heure = date("H:i");
		$quand = date("Y-m-d");
		
		$connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
		// introduction dans la table des logs et récupération de l'id autoIncrementé
		$sql = "INSERT INTO ".PFX."presencesLogs ";
		$sql .= "SET educ='$educ', parent='$parent', media='$media', quand='$quand', heure='$heure' ";
		$resultat = $connexion->exec($sql);
		$id=$connexion->lastInsertId();
		
		$nb = 0;
		foreach ($post as $champ=>$statut) {
			if (substr($champ, 0, 8) == 'periode-') {
				$pieces = explode('_',$champ,2);
				
				$noPeriode = explode('-',$pieces[0]); $noPeriode = $noPeriode[1];
				$date = explode('-',$pieces[1]); $date = $date[1];
				// on n'enregistre que ce qui a été modifié
				if ($post['modif-'.$noPeriode.'_date-'.$date] == 'oui') {
					$date = Application::dateMysql($date);
					$sql = "INSERT INTO ".PFX."presencesEleves ";
					$sql .= "SET id='$id', matricule='$matricule', date='$date', periode='$noPeriode', statut='$statut' ";
					$sql .= "ON DUPLICATE KEY UPDATE id='$id', periode='$noPeriode', statut='$statut' ";
					$resultat = $connexion->exec($sql);
					if ($resultat)
						$nb++;	// ne compte les boucles qu'une seule fois alors que "ON DUPLICATE" signale 2 modifications dans la table
					}
				}
			}
		Application::deconnexionPDO($connexion);
		return $nb;
		 }
	
	/** 
	 * enregistrement des autorisations de sorties
	 * @param array $post : les informations provenant du formulaire de saisie
	 * @param int $matricule : le matricule de l'élève concerné
	 */
	// public function saveSorties($post, $matricule) {
		//$educ = isset($post['educ'])?$post['educ']:Null;
		//$matricule = isset($post['matricule'])?$post['matricule']:Null;
		//$date = isset($post['date'])?Application::dateMysql($post['date']):Null;
		//$parent = isset($post['parent'])?$post['parent']:Null;
		//$media = isset($post['media'])?$post['media']:Null;
		//$heure = date("H:i");
		//$quand = date("Y-m-d");
		
		//$connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
		//// introduction dans la table des logs et récupération de l'id autoIncrementé
		//$sql = "INSERT INTO ".PFX."presencesLogs ";
		//$sql .= "SET educ='$educ', parent='$parent', media='$media', quand='$quand', heure='$heure' ";
		//$resultat = $connexion->exec($sql);
		//$id=$connexion->lastInsertId();
		
		//$nb = 0;
		//foreach ($post as $champ=>$statut) {
			//if (substr($champ, 0, 7) == 'statut_') {
				//$pieces = explode('_',$champ);
				//$noPeriode = $pieces[1];
				
				//// le champ a-t-il été modifié durant l'édition?
				//if ($post['modif_'.$noPeriode] == 'oui') {
					//// alors on enregistre la nouvelle valeur
					//$sql = "INSERT INTO ".PFX."presencesEleves ";
					//$sql .= "SET id='$id', matricule='$matricule', date='$date', periode='$noPeriode', statut='$statut' ";
					//$sql .= "ON DUPLICATE KEY UPDATE id='$id', periode='$noPeriode', statut='$statut' ";
					//$resultat = $connexion->exec($sql);
					//if ($resultat)
						//$nb++;	// ne compte les boucles qu'une seule fois alors que "ON DUPLICATE" signale 2 modifications dans la table
					//}
				//}
			//}
		//Application::deconnexionPDO($connexion);
		//return $nb;
		// }

	/** 
	 * retourne la liste des jours d'absences d'un élève dont on fournit le matricule
	 * @param $matricule
	 * @return array
	 */
	 public function listePresencesEleve($matricule) {
		$connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
		$sql = "SELECT date, periode, statut, educ, heure, quand, parent, media ";
		$sql .= "FROM ".PFX."presencesEleves AS dpe ";
		$sql .= "JOIN ".PFX."presencesLogs AS dpl ON dpl.id = dpe.id ";
		$sql .= "WHERE matricule='$matricule' ORDER BY date ";

		$resultat = $connexion->query($sql);
		$statutsAbs = array('absent','signale','justifie','sortie');
		$listePeriodes = $this->lirePeriodesCours();
		$empty = array('statut'=>'','quand'=>'','heure'=>'','educ'=>'','parent'=>'', 'media'=>'');
		$liste = array();
		$absents = array();
		if ($resultat) {
			$resultat->setFetchMode(PDO::FETCH_ASSOC);
			while ($ligne = $resultat->fetch()) {
				$date = Application::datePHP($ligne['date']);
				if (!(isset($liste[$date]))) {
					foreach ($listePeriodes as $noPeriode=>$bornes) {
						$liste[$date][$noPeriode]=$empty;
						}
					}
				$ligne['date']=$date;
				$quand = Application::datePHP($ligne['quand']);
				$ligne['quand']=$quand;
				// il y a une absence dans la ligne? On le note
				if (in_array($ligne['statut'],$statutsAbs))
					$absents[$date] = true;
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
	 * retourne la liste des autorisations de sortie pour une période donnée entre $dateDebut et $dateFin
	 * @param $dateDebut
	 * @param $dateFin
	 * @return array
	 */
	// public function listeParPeriode($dateDebut, $dateFin) {
		//$dateDebut = Application::dateMysql($dateDebut);
		//$dateFin = Application::dateMysql($dateFin);
		//$connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
		//$sql = "SELECT id, pa.matricule, nom, prenom, groupe, date, heure, educ ";
		//$sql .= "FROM ".PFX."presencesSorties AS pa ";
		//$sql .= "JOIN ".PFX."eleves AS e ON (pa.matricule = e.matricule ) ";
		//if ($dateFin == '') 
			//$sql .= "WHERE date = '$dateDebut' ";
			//else $sql .= "WHERE (date >= '$dateDebut') AND (date <= '$dateFin') ";
		//$sql .= "ORDER BY date, heure, REPLACE(REPLACE(REPLACE(nom, ' ', ''),'''',''),'-',''), prenom, classe";
		//$resultat = $connexion->query($sql);
		//$listeSorties = array();
		//if ($resultat) {
			//$resultat->setFetchMode(PDO::FETCH_ASSOC);
			//while ($ligne = $resultat->fetch()) {
				//$ligne['date'] = Application::datePHP($ligne['date']);
				//$date = $ligne['date'];
				//$heure = $ligne['heure'];
				//$matricule = $ligne['matricule'];
				//$listeSorties[$date][$matricule][$heure] = $ligne;
			//}
		//}
		//Application::deconnexionPDO($connexion);
		//return $listeSorties;
		// }


	/** 
	 * retourne les données de présences (et d'absences) d'un élève ou d'une liste d'élèves pour une date donnée
	 * @param $matricule
	 * @param $date
	 * @return array
	 */
	// public function presencesEleveDate($date,$listeEleves) {
		//if (is_array($listeEleves))
			//$listeElevesString = implode(",", array_keys($listeEleves));
		//else $listeElevesString = $listeEleves;
		//$dateSQL = Application::dateMysql($date);
		//$connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
		//$sql = "SELECT matricule, present, educ, periode ";
		//$sql .= "FROM ".PFX."presencesEleves  ";
		//$sql .= "WHERE date = '$dateSQL' AND matricule IN ($listeElevesString) ";
		//$sql .= "ORDER BY matricule, periode ";
//die($sql);
		//$resultat = $connexion->query($sql);
		//$listePresences = array();
		//if ($resultat) {
			//$resultat->setFetchMode(PDO::FETCH_ASSOC);
			//while ($ligne = $resultat->fetch()) {
				//$matricule = $ligne['matricule'];
				//$periode = $ligne['periode'];
				//$listePresences[$matricule][$periode]=$ligne;
				//}
			//}
		//Application::deconnexionPDO($connexion);
		//return $listePresences;
		// }


	/**
	 * listes des autorisations de sorties pour un élève dont on fournit le matricule
	 * @param $matricule
	 * @return array
	 */
	// public function listeSorties ($matricule) {
		//$connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
		//$sql = "SELECT matricule, educ, parent, media, date, heure ";
		//$sql .= "FROM ".PFX."presencesSorties AS aut ";
		//$sql .= "WHERE matricule = '$matricule' ";
		//$sql .= "ORDER BY date, heure ";
		//$resultat = $connexion->query($sql);
		//$liste = array();
		//if ($resultat) {
			//$resultat -> setFetchMode(PDO::FETCH_ASSOC);
			//while ($ligne = $resultat->fetch()) {
				//$matricule = $ligne['matricule'];
				//$date = APPLICATION::datePHP($ligne['date']);
				//$ligne['date'] = $date;
				//$liste[$matricule][$date] = $ligne;
				//}
			//}
		//Application::deconnexionPDO($connexion);
		//return $liste;
	// }


	/** 
	 * lecture de la liste des présences et des absences (tous statuts confondus) pour un jour donné pour une liste d'élèves donnée
	 * @param $date
	 * @param $periode ou Null pour toutes les périodes de la journée
	 * @param $listeEleves array | string : liste des matricules ou matricule d'un seul élève
	 * @return array
	 */
	//public function lirePresences($date, $listeEleves) {
		//if (is_array($listeEleves))
			//$listeElevesString = implode(',',array_keys($listeEleves));
			//else $listeElevesString = $listeEleves;
		//$date = Application::dateMysql($date);

		//$connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
		//$sql = "SELECT dpe.id, dpe.matricule, nom, prenom, groupe, date, periode, educ, quand, heure, statut, parent, media ";
		//$sql .= "FROM ".PFX."presencesEleves AS dpe ";
		//$sql .= "JOIN ".PFX."eleves AS de ON (de.matricule = dpe.matricule) ";
		//$sql .= "LEFT JOIN ".PFX."presencesLogs AS dpl ON (dpl.id = dpe.id) ";
		//$sql .= "WHERE date = '$date' AND dpe.matricule IN ($listeElevesString) ";
		//$sql .= "ORDER BY nom, prenom ";

		//$resultat = $connexion->query($sql);
		//// prépartion de la liste des présences pour tous les élèves concernés
		//if (is_array($listeEleves)) {
			//foreach ($listeEleves as $matricule=>$wtf) {
				//$listePresences[$matricule]=array();
				//}
			//}
			//else $listePresences[$listeEleves]=array();
		//if ($resultat) {
			//$resultat->setFetchMode(PDO::FETCH_ASSOC);
			//while ($ligne = $resultat->fetch()) {
				//$matricule = $ligne['matricule'];
				//$periode = $ligne['periode'];
				//$ligne['quand']=Application::datePHP($ligne['quand']);
				//$ligne['date']=Application::datePHP($ligne['date']);
				//$listePresences[$matricule][$periode] = $ligne;
				//}
			//}
		//Application::deconnexionPDO($connexion);
		//return $listePresences;
		//}


}      

?>
