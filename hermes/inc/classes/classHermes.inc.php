<?php

class hermes {

	/**
	 * établit une liste d'adresses mail à partir de la liste des noms#mail = listeDestinataires
	 * @param array $listeDestinataires
	 * @return array
	 */
	public function listeNomsFromDestinataires($listeDestinataires){
		$liste = array();
		foreach ($listeDestinataires as $unDestinataire) {
			// chaque destinataire est de la forme  "Prenom Nom#pnom@ecole.org"
			$dest = explode('#',$unDestinataire);
			$liste[] = $dest[0];
			}
		return $liste;
		}

	/**
	 * envoie un mail en tenant compte des différents paramètres
	 * @param array $post : tous les paramètres issus du formulaire de rédaction du mail
	 * @return boolean
	 */
	public function send_mail($post,$files) {
		$mailExpediteur = $post['mailExpediteur'];
		$nomExpediteur = ($mailExpediteur == NOREPLY)?NOMNOREPLY:$post['nomExpediteur'];

		$objet = $post['objet'];
		$texte = $post['texte'];

		// ajout de la signature
		$signature = file_get_contents('templates/signature.tpl');
		$signature = str_replace('##expediteur##',$nomExpediteur,$signature);
		$signature = str_replace('##mailExpediteur##',$mailExpediteur,$signature);
		$texte .= $signature;

		// ajout du disclaimer
		if ($post['disclaimer'] == 1){
			$disclaimer = "<div style='font-size:small'><a href='".DISCLAIMER."'>Clause de non responsabilité</a></div>";
			$texte .= "<hr> $disclaimer";
			}

		if (isset($post['mails']) && count($post['mails'])!='0')
			$listeMails = array_unique($post['mails']);
			else die('no mail');
		if (($objet == '') || ($mailExpediteur == '') || ($nomExpediteur == '') || ($texte == '') || (count($listeMails) == 0))
			die("parametres manquants");

		$mail = new PHPmailer();
		$mail->IsHTML(true);
		$mail->CharSet = 'UTF-8';
		$mail->From = $mailExpediteur;
		$mail->FromName = $nomExpediteur;

		$envoiMail = true;
		// envoyer le mail à l'expéditeur sauf si adresse NOREPLY
		if ($mailExpediteur != NOREPLY)
			$mail->AddAddress($mailExpediteur);

		$mail->Subject=$objet;
		$mail->Body=$texte;
		foreach ($listeMails as $unDestinataire) {
			$cible = explode('#',$unDestinataire);
			$nom = $cible[0];
			$unMail = $cible[1];
			$mail->AddBCC($unMail,$nom);
			}
		foreach ($files as $wtf=>$unFichier) {
			if (($unFichier['error'] == 0) && ($unFichier['size'] <= $post['MAX_FILE_SIZE']))
				$mail->AddAttachment($unFichier['tmp_name'],$unFichier['name']);
			}

		if(!$mail->Send())
			$envoiMail = false;

		return $envoiMail;
		}

	/**
	 * archivage d'un mail envoyé
	 * @param $post : formulaire post du mail
	 * @param $files : les fichiers joints
	 */
	public function archiveMail($acronyme,$post,$files) {
		// création éventuelle du répertoire au nom de l'utlilisateur
		if (!(file_exists("upload/$acronyme"))){
			mkdir("upload/$acronyme");
			$handle = fopen("upload/$acronyme/index.php", 'w') or die("can't open file");
			fclose($handle);
			}
		// sauvegarde des fichiers joints
		foreach ($files as $wtf=>$data) {
			if ($data['error'] == 0) {
				$tmp_name = $data['tmp_name'];
				$name = $data['name'];
				move_uploaded_file($tmp_name, "upload/$acronyme/$name");
				}
			}
		$connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
		$mailExpediteur = $post['mailExpediteur'];
		$objet = $post['objet'];
		$texte = htmlspecialchars($post['texte']);
		$nbDestinataires = count($post['mails']);
		if ($nbDestinataires > 4)
			$destinataires = "$nbDestinataires destinataires";
			else $destinataires = implode(',',$post['mails']);
		$pj = array();
		foreach ($files as $wtf=>$data){
			if ($data['error'] != 4) {
				$pj[] = $data['name'];
				}
			}
		$pj = implode(',',$pj);
		$sql = "INSERT INTO ".PFX."hermesArchives ";
		$sql .= "SET acronyme='$acronyme', mailExp='$mailExpediteur', objet='$objet', texte='$texte', destinataires='$destinataires', PJ='$pj', date=NOW(), heure=NOW() ";
		$resultat = $connexion->exec($sql);
		Application::DeconnexionPDO($connexion);
		return $resultat;

		}

	/**
	 * renvoie la liste des archives pour l'utilisateur indiqué depuis la borne $debut et pour $nb enregistrements
	 * @param string $acronyme
	 * @param integer $debut : début de la liste
	 * @param integer $fin: fin de la liste
	 * @return array
	 */
	public function listeArchives ($acronyme, $debut, $nb) {
		$connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
		$sql = "SELECT id, mailExp, nom, prenom, date, heure, objet, texte, destinataires, PJ ";
		$sql .= "FROM ".PFX."hermesArchives AS ha ";
		$sql .= "LEFT JOIN ".PFX."profs AS dp ON (dp.acronyme = ha.acronyme) ";
		$sql .= "WHERE ha.acronyme='$acronyme' ";
		$sql .= "ORDER BY date DESC, heure DESC ";
		$sql .= "LIMIT $debut, $nb ";

		$resultat = $connexion->query($sql);
		$listeArchives = array();
		if ($resultat) {
			$resultat->setFetchMode(PDO::FETCH_ASSOC);
			while ($ligne = $resultat->fetch()) {
				$id = $ligne['id'];
				$ligne['date'] = Application::datePHP($ligne['date']);
				$ligne['texte'] = html_entity_decode($ligne['texte']);
				$listePersonnes = array();
				$ligne['destinataires'] = explode(',',$ligne['destinataires']);
				foreach ($ligne['destinataires'] as $unePersonne) {
					$unePersonne = explode('#',$unePersonne);
					$unePersonne = $unePersonne[0];
					$listePersonnes[] = $unePersonne;
					}

				$ligne['destinataires'] = implode(', ',$listePersonnes);
				$ligne['PJ'] = explode(',',$ligne['PJ']);
				$listeArchives[$id] = $ligne;
				}
			}
		Application::DeconnexionPDO($connexion);
		return $listeArchives;
		}

	/**
	 * retourne le nombre de mails archivés pour l'utilisateur indiqué
	 * @param $acronyme
	 * @return integer
	 */
	public function nbArchives($acronyme) {
		$connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
		$sql = "SELECT count(*) AS nb ";
		$sql .= "FROM ".PFX."hermesArchives ";
		$sql .= "WHERE acronyme = '$acronyme' ";
		$resultat = $connexion->query($sql);
		$nb = 0;
		if ($resultat) {
			$ligne = $resultat->fetch();
			$nb = $ligne['nb'];
			}
		Application::DeconnexionPDO($connexion);
		return $nb;
		}

	/**
	 * retourne l'archive dont on fournit le id
	 * @param $id
	 * @return array
	 */
	public function archive($id){
		$connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
		$sql = "SELECT * FROM ".PFX."hermesArchives ";
		$sql .= "WHERE id='$id' ";
		$resultat = $connexion->query($sql);
		$ligne = array();
		if ($resultat) {
			$resultat->setFetchMode(PDO::FETCH_ASSOC);
			$ligne = $resultat->fetch();
			}
		Application::DeconnexionPDO($connexion);
		return $ligne;
		}

	/**
	 * efface l'enregistrement dont on fournit l'id de la base de données
	 * @param $id
	 * @return $nb : nombre d'enregistrements effacés (1)
	 */
	public function delArchive($id){
		$connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
		$sql = "DELETE FROM ".PFX."hermesArchives ";
		$sql .= "WHERE id='$id' ";
		$resultat = $connexion->exec($sql);
		Application::DeconnexionPDO($connexion);
		return $resultat;
		}

	/**
	 * retrouver les acronymes des membres d'une liste d'adresses mails (sous forme 'Nom Prénom#mail@ecole.org')
	 * @param array $listeMails
	 * @return array : liste des acronymes correspondants
	 */
	public function acronymeFromMails ($listeMails){
		// retrouver les adresses mail uniquement, extraites de 'Nom Prénom#mail@ecole.org'
		foreach ($listeMails as $key=>$unePersonne) {
			$unePersonne = explode('#',$unePersonne);
			$listeMails[$key]=$unePersonne[1];
			}
		// retour à une liste séparée par des virgules
		$listeMails = "'".implode("','",$listeMails)."'";
		$connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
		$sql = "SELECT acronyme ";
		$sql .= "FROM ".PFX."profs ";
		$sql .= "WHERE TRIM(mail) IN ($listeMails) ";
		$resultat = $connexion->query($sql);
		$liste = array();
		if ($resultat) {
			$resultat->setFetchMode(PDO::FETCH_ASSOC);
			while ($ligne = $resultat->fetch()) {
				$liste[] = $ligne['acronyme'];
				}
			}
		Application::DeconnexionPDO($connexion);
		return $liste;
		}

	/**
	 * retrouver le nom et le prenom d'une personne dont on donne l'adresse mail
	 * @param $mail
	 * @return string
	 */
	public function nameFromMail($mail) {
		$connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
		$sql = "SELECT nom, prenom ";
		$sql .= "FROM ".PFX."profs ";
		$sql .= "WHERE mail='$mail' ";

		$resultat = $connexion->query($sql);
		$nom = '';
		if ($resultat) {
			$resultat->setFetchMode(PDO::FETCH_ASSOC);
			$ligne = $resultat->fetch();
			$nom = $ligne['prenom'].' '.$ligne['nom'];
			}
		Application::DeconnexionPDO($connexion);
		return $nom;
		}

	/**
	 * création d'un groupe de mailing privé pour l'utilisateur indiqué avec les adresses indiquées
	 * @param $acronyme string : propriétaire du groupe
	 * @param $groupe string : nom du groupe
	 * @param $mails array : liste des mails à inclure dans le groupe (provenant de $_POST)
	 * @return boolean
	 */
	 public function creerGroupe($acronyme,$groupe,$listeMails=Null) {
		$connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
		// création du groupe
		if ($groupe != '') {
			// requête preparée pour permettre les liste dont le nom contient des guillemets
			$sql = "INSERT INTO ".PFX."hermesProprio ";
			$sql .= "SET proprio=:acronyme, nomListe=:groupe, statut='prive' ";
			$requete = $connexion->prepare($sql);
			$data = array(':acronyme'=>$acronyme, ':groupe'=>$groupe);
			$resultat = $requete->execute($data);
			$id = $connexion->lastInsertId();
			}
			else die('no mailing list name');

		if ($listeMails != Null) {
			$listeMails = self::acronymeFromMails($listeMails);
			$nb = 0;
			foreach ($listeMails as $mail) {
				$sql = "INSERT INTO ".PFX."hermesListes ";
				$sql .= "SET id='$id', membre='$mail' ";
				$nb += $connexion->exec($sql);
				}
			Application::DeconnexionPDO($connexion);
			return $nb;
			}
			else {
				Application::DeconnexionPDO($connexion);
				return $id;
				}
		}

	/**
	 * renvoie les listes d'adresses personnelles de l'utilisateur $acronyme
	 * @param string $acronyme
	 * @return array de array
	 */
	public function listesPerso($acronyme, $abonne=false){
		$connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
		$sql = "SELECT hp.id, proprio, nomListe, hp.statut, membre, nom, prenom, mail ";
		$sql .= "FROM ".PFX."hermesProprio AS hp ";
		$sql .= "LEFT JOIN ".PFX."hermesListes AS hl ON (hl.id = hp.id) ";
		$sql .= "LEFT JOIN ".PFX."profs AS dp ON (dp.acronyme = hl.membre) ";
		$sql .= "WHERE proprio = '$acronyme' ";
		if ($abonne == true)
			$sql .= "AND hp.statut != 'abonne' ";
		$sql .= "ORDER BY nomListe ";
		$resultat = $connexion->query($sql);
		$liste = array();
		if ($resultat) {
			$resultat->setFetchMode(PDO::FETCH_ASSOC);
			while ($ligne = $resultat->fetch()){
				$id = $ligne['id'];
				$nomListe = $ligne['nomListe'];
				$statut = $ligne['statut'];
				$membre = $ligne['membre'];
				$proprio = $ligne['proprio'];
				if (!(isset($liste[$id])))
					$liste[$id]=array('nomListe'=>$nomListe, 'proprio'=>$proprio, 'membres'=>array(), 'statut'=>$statut);
				if ($membre != Null) {  // si la liste n'est pas vide...
					$liste[$id]['nomListe']=$nomListe;
					$liste[$id]['statut']=$ligne['statut'];
					$liste[$id]['membres'][$membre] = array(
							'nom'=>$ligne['nom'],
							'prenom'=>$ligne['prenom'],
							'acronyme'=>$ligne['membre'],
							'mail'=>$ligne['mail']
							);
					}
				}
			}
		Application::DeconnexionPDO($connexion);
		return $liste;
		}

	/**
	 * suppression de listes de mailing si elle sont vides
	 * @param array $listeId : liste des identifiants des listes
	 * @param string $acronyme: acronyme du propriétaire, par sécurité
	 * @return integer $resultat: nombre de suppressions effectuées
	 */
	public function delListes($listeId, $acronyme) {
		if (count($listeId) > 0) {
			$connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
			// vérification que les listes sont vides
			$listes = implode(',', $listeId);
			$sql = "SELECT id, COUNT(*) AS nbMembres FROM ".PFX."hermesListes ";
			$sql .= "WHERE  id IN ($listes) ";
			$listesVides = array();
			$resultat = $connexion->query($sql);
			if ($resultat) {
				while ($ligne = $resultat->fetch()) {
					$id = $ligne['id'];
					$listesVides[]=$id;
					}
				}
			// calcul des listes effaçables (= vides)
			$listeId = implode(',',array_diff($listeId, $listesVides));
			// effacement, pour les propriétaires respectifs et pour les abonnés
			if (count($listeId) > 0) {
				$sql = "DELETE FROM ".PFX."hermesProprio ";
				$sql .= "WHERE id IN ($listeId) ";
				$resultat = $connexion->exec($sql);
				}
				else $resultat = 0;
			Application::DeconnexionPDO($connexion);
			return $resultat;
			}
		return 0;
		}

	/**
	 * suppression d'une série de membres d'une liste de mailing personnalisée
	 * @param array $liste : tableau de couples id, acronyme correspondant aux membres des listes à supprimer
	 * @return integer : nombre de suppressions
	 */
	public function delMembresListe ($liste){
		$connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
		$sql = "DELETE FROM ".PFX."hermesListes ";
		$sql .= "WHERE id=:id AND membre=:acronyme ";
		$requete = $connexion->prepare($sql);
		$resultat = 0;
		foreach ($liste as $unProf) {
			$unProf = array(':id'=>$unProf['id'],':acronyme'=>$unProf['acronyme']);
			$resultat += $requete->execute($unProf);
			}
		Application::DeconnexionPDO($connexion);
		return $resultat;
		}

	/**
	 * ajout d'une série d'utilisateurs à une liste de mailing personnalisée
	 * @param integer $id : id de la liste
	 * @param array : liste des acronymes à ajouter
	 * @return integer : nombre d'ajouts
	 */
	public function addMembresListe ($id,$listeAcronymes){
		$connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
		$resultat = 0;
		foreach ($listeAcronymes as $acronyme) {
			$sql = "INSERT IGNORE INTO ".PFX."hermesListes ";
			$sql .= "SET id='$id', membre='$acronyme' ";
			$resultat += $connexion->exec($sql);
			}
		Application::DeconnexionPDO($connexion);
		return $resultat;
		}

	/**
	 * ajout d'un co-propriétaire à une liste de mailing personnalisée
	 * @param integer $id : id de la liste
	 * @param string $acronyme : acronyme du nouveau co-propriétaire
	 * @return integer : nombre d'insertion (1, normalement...)
	 */
	 public function addProprio ($id, $proprio, $acronyme){
		$connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
		$sql = "SELECT nomListe ";
		$sql .= "FROM ".PFX."hermesProprio ";
		$sql .= "WHERE id='$id' AND proprio='$proprio' ";
		$resultat = $connexion->query($sql);
		if ($resultat) {
			$ligne = $resultat->fetch();
			$nomListe = $ligne['nomListe'];

			$sql = "INSERT IGNORE INTO ".PFX."hermesProprio ";
			$sql .= "SET id='$id', proprio='$acronyme', nomListe='$nomListe' ";
			$resultat = $connexion->exec($sql);
			}
		Application::DeconnexionPDO($connexion);
		return $resultat;
		}

	/**
	 * retourne la liste de mailing des utilisateurs (table 'profs' de la BD)
	 * @param void()
	 * @return array
	 */
	public function listeMailingProfs(){
		$connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = "SELECT acronyme, nom, prenom, mail FROM ".PFX."profs ";
        $sql .= "ORDER BY REPLACE(REPLACE(REPLACE(nom, ' ', ''),'''',''),'-',''), prenom";
        $resultat = $connexion->query($sql);
        $listeProfs = array('nomListe'=>'Tous', 'membres'=>array());
        if ($resultat) {
			while ($ligne = $resultat->fetch()) {
				$acronyme = $ligne['acronyme'];
				$listeProfs['membres'][$acronyme] = array(
					'nom'=>$ligne['nom'],
					'prenom'=>$ligne['prenom'],
					'mail'=>$ligne['mail']
					);
				}
			}
		Application::DeconnexionPDO($connexion);
		return $listeProfs;
		}

	/**
	 * retourne la liste de mailing des titulaires (profs principaux)
	 * @param void()
	 * @return array
	 */
	public function listeMailingTitulaires(){
		$connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
		$sql = "SELECT ".PFX."titus.acronyme, classe, nom, prenom, mail ";
		$sql .= "FROM ".PFX."titus ";
		$sql .= "JOIN ".PFX."profs ON (".PFX."profs.acronyme = ".PFX."titus.acronyme ) ";
		$sql .= "ORDER BY classe, nom, prenom ";
		$resultat = $connexion->query($sql);
		$listeTitus = array('nomListe'=>'Titulaires', 'membres'=>array());
		if ($resultat) {
			while ($ligne = $resultat->fetch()) {
				$acronyme = $ligne['acronyme'];
				$listeTitus['membres'][$acronyme] = array(
					'nom'=>$ligne['nom'],
					'prenom'=>$ligne['prenom'] ,
					'mail'=>$ligne['mail'],
					'classe'=>$ligne['classe']
					);
				}
			}
        Application::DeconnexionPDO ($connexion);
        return $listeTitus;
		}

	/**
	 * retourne la liste des membres d'une liste
	 * @param $id : id de la liste visée
	 * @return string : la liste prête à être affichée en HTML
	 */
	public function membresListe($id){
		$connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
		$sql = "SELECT membre, nom, prenom ";
		$sql .= "FROM ".PFX."hermesListes AS hl ";
		$sql .= "JOIN ".PFX."profs AS dp ON (dp.acronyme = hl.membre) ";
		$sql .= "WHERE id = '$id' ";
		$sql .= "ORDER BY REPLACE(REPLACE(REPLACE(nom,' ',''),'-',''),'\'',''), prenom ";
		$resultat = $connexion->query($sql);
		$liste = array();
		if ($resultat) {
			while ($ligne = $resultat->fetch()) {
				$acronyme = $ligne['membre'];
				$nom = $ligne['nom'];
				$prenom = $ligne['prenom'];
				$liste[$acronyme] = array('nom'=>$nom, 'prenom'=>$prenom);
				}
			}
		Application::DeconnexionPDO ($connexion);
        return $liste;
		}

	/**
	 * fournit la liste des utilisateurs privilégiés "direction"
	 * @param void()
	 * @return array
	 */
	public function listeDirection() {
		$connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
		$sql = "SELECT pa.acronyme, nom, prenom, mail ";
		$sql .= "FROM ".PFX."profsApplications AS pa ";
		$sql .= "JOIN ".PFX."profs AS p ON (p.acronyme = pa.acronyme) ";
		$sql .= "WHERE application = 'hermes' AND (userStatus = 'direction' or userStatus = 'admin') ";
		$resultat = $connexion->query($sql);
		$liste = array();
		if ($resultat) {
			while ($ligne = $resultat->fetch()) {
				$acronyme = $ligne['acronyme'];
				$nom = $ligne['prenom'].' '.$ligne['nom'];
				$mail = $ligne['mail'];
				$liste[$acronyme] = array('nom'=>$nom, 'mail'=>$mail);
				}
			}
		Application::DeconnexionPDO ($connexion);
        return $liste;
		}


	/**
	 * enregistre le nouveau statut des listes (outil de gestion)
	 * @param array $post : informations issues du formulaire d'enregistrement des statuts
	 * @return integer : nombre d'enregistrements dans la BD
	 */
	public function saveListStatus ($post, $acronyme) {
		$listeStatus = array();
		$listeNoms = array();
		foreach ($post as $field=>$value) {
			if (substr($field, 0, 6) == 'statut') {
				$id = explode('_',$field);
				$id = $id[1];
				$listeStatus[$id]=$value;
				}
			if (substr($field, 0, 8) == 'nomListe') {
				$id = explode('_',$field);
				$id = $id[1];
				$listeNoms[$id]=$value;
				}
			}
		$resultat = 0;
		if (count($listeStatus) > 0) {
			$connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
			$sql = "UPDATE ".PFX."hermesProprio ";
			$sql .= "SET statut=:statut, nomListe=:nomListe ";
			$sql .= "WHERE id=:id AND proprio='$acronyme' ";
			$requete = $connexion->prepare($sql);
			foreach ($listeStatus as $id=>$statut) {
				$newName = $listeNoms[$id];
				$data = array(':statut'=>$statut, ':nomListe'=>$newName, ':id'=>$id);
				$resultat += $requete->execute($data);
				}
			Application::DeconnexionPDO ($connexion);
			}
        return $resultat;

		}

	/**
	 * recherche des listes auxquelles l'utilisateur $acronyme est abonné ou auxquelles il peut s'abonner
	 * il ne peut pas s'abonner à ses propres listes
	 * @param string : $acronyme
	 * @return array
	 */
	public function listesDisponibles ($acronyme, $statut) {
		$connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
		if ($statut == 'publie') {
			// toutes les listes publiées sauf celles de l'utilisateur actuel
			$sql = "SELECT id, proprio, nomListe, statut ";
			$sql .= "FROM ".PFX."hermesProprio ";
			$sql .= "WHERE (statut = 'publie' AND proprio != '$acronyme') ";
			$sql .= "AND id NOT IN (SELECT id FROM ".PFX."hermesProprio ";
			$sql .= "WHERE proprio = '$acronyme' and statut = 'abonne') ";
			}
			else {
			// toutes les listes auxquelles l'utilisateur actuel est abonné avec le nom du propriétaire de ces listes
			$sql = "SELECT hp.id, hp2.proprio, hp.nomListe, hp.statut ";
			$sql .= "FROM ".PFX."hermesProprio AS hp ";
			$sql .= "JOIN ".PFX."hermesProprio AS hp2 ON (hp.id = hp2.id) ";
			$sql .= "WHERE (hp.statut='abonne' AND hp.proprio = '$acronyme') AND hp2.proprio != '$acronyme' ";
			}
		$sql .= "ORDER  BY nomListe ";

		$resultat = $connexion->query($sql);
		$liste = array();
		if ($resultat) {
			while ($ligne = $resultat->fetch()) {
				$id = $ligne['id'];
				$proprio = $ligne['proprio'];
				$nomListe = $ligne['nomListe'];
				$liste[$id] = array('nomListe'=>$nomListe, 'proprio'=>$proprio);
				}
			}
		Application::DeconnexionPDO ($connexion);
		return $liste;
		}

	/**
	 * gestion des abonnements, désabonnements et appropriations des listes
	 * @input array $post : provenant du formulaire idoine
	 * @input string $acronyme : de l'utilisateur
	 * @return integer : nombre d'enregistrements dans la BD
	 */
	public function gestAbonnements ($post, $acronyme) {
		$connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
		$resultat = 0;
		foreach ($post as $field => $listValues) {
			switch ($field) {
				case 'abonner':
					foreach ($listValues as $id) {
						$nomListe = $post['liste_'.$id];
						$nomListe = $connexion::quote($nomListe);
						$sql = "INSERT IGNORE INTO ".PFX."hermesProprio ";
						$sql .= "SET id='$id', proprio='$acronyme', nomListe='$nomListe', statut='abonne' ";
						die($sql);
						$resultat += $connexion->exec($sql);
						}
					break;
				case 'approprier':
					foreach ($listValues as $id) {
						$nomListe = $post['liste_'.$id];
						$proprio = $post['proprio_'.$id];
						// ajout dans la table des propriétaires
						$sql = "INSERT INTO ".PFX."hermesProprio ";
						$sql .= "SET proprio='$acronyme', nomListe='$nomListe', statut='prive' ";
						$resultat += $connexion->exec($sql);
						$newId = $connexion->lastInsertId();

						// recopie des abonnés dans la nouvelle liste
						$sql = "INSERT IGNORE INTO ".PFX."hermesListes (id, membre) ";
						$sql .= "SELECT '$newId', membre FROM ".PFX."hermesListes ";
						$sql .= "WHERE id='$id' ";
						$nb = $connexion->exec($sql);
					}
					break;
				case 'desabonner':
					foreach ($listValues as $id) {
						$sql = "DELETE FROM ".PFX."hermesProprio ";
						$sql .= "WHERE proprio='$acronyme' AND id='$id' AND statut='abonne' ";
						$resultat += $connexion->exec($sql);
						}
					break;
				}
			}
		Application::DeconnexionPDO ($connexion);
		return $resultat;
		}

	/**
	 * retourne la liste des abonnés pour chacun des listes d'un utilisateur
	 * @param string $acronyme : de l'utilisateur
	 * return array
	 */
	public function abonnesDe($acronyme) {
		$connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
		$sql = "SELECT id, proprio, nomListe, statut ";
		$sql .= "FROM ".PFX."hermesProprio ";
		$sql .= "WHERE statut = 'abonne' AND id IN (SELECT id FROM ".PFX."hermesProprio WHERE proprio = '$acronyme' AND statut = 'publie') ";
		$sql .= "ORDER BY nomListe ";
		$resultat = $connexion->query($sql);
		$liste = array();
		if ($resultat) {
			while ($ligne = $resultat->fetch()) {
				$id = $ligne['id'];
				$nomListe = $ligne['nomListe'];
				if (!(isset($liste[$id])))
					$liste[$id] = array('nomListe'=>$nomListe, 'abonnes'=>array());
				$proprio = $ligne['proprio'];
				$liste[$id]['abonnes'][] = $proprio;
				}
			}
		Application::DeconnexionPDO ($connexion);
		return $liste;
		}

	/**
	 * nettoyage des listes de membres suite à suppression éventuelle d'un prof
	 * @param void()
	 * @return integer : nombre de suppression de membres de listes
	 */
	public static function nettoyerListes() {
		$connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);

		// suppression des pièces jointes des utilisateurs supprimés
		$sql = "SELECT acronyme FROM ".PFX."hermesArchives ";
		$sql .= "WHERE acronyme NOT IN (SELECT acronyme FROM ".PFX."profs) ";
		$resultat = $connexion->exec($sql);
		$liste = array();
		if ($resultat) {
			$liste = $resultat->fetchAll();
			while ($ligne = $resultat->fetch()) {
				$liste[]=$acronyme;
				}
			}
		foreach ($liste as $acronyme) {
			Application::rmdir("upload/$acronyme");
			}

		$sql = "DELETE FROM ".PFX."hermesListes ";
		$sql .= "WHERE membre NOT IN (SELECT acronyme FROM ".PFX."profs) ";
		$resultat = $connexion->exec($sql);
		$sql = "DELETE FROM ".PFX."hermesArchives ";
		$sql .= "WHERE acronyme NOT IN (SELECT acronyme FROM ".PFX."profs) ";
		$resultat += $connexion->exec($sql);
		$sql = "DELETE FROM ".PFX."hermesProprio ";
		$sql .= "WHERE acronyme NOT IN (SELECT acronyme FROM ".PFX."profs) ";
		$resultat += $connexion->exec($sql);

		Application::DeconnexionPDO ($connexion);
		return $resultat;
		}

	/**
	 * fonction de suppression des utilisateurs; appelée par l'admin général lors du départ d'un collègue
	 * @param string: $acronyme
	 * @return integer: nombre de suppressions dans les tables de l'application
	 */
	public static function hermesDelUser($acronyme){
		$connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
		$sql = "DELETE FROM ".PFX."hermesProprio ";
		$sql .= "WHERE proprio='$acronyme' ";
		$resultat = $connexion->exec($sql);

		$sql = "DELETE FROM ".PFX."hermesListes ";
		$sql .= "WHERE membre='$acronyme' ";
		$resultat += $connexion->exec($sql);

		$sql .= "DELETE FROM ".PFX."hermesArchives ";
		$sql .= "WHERE acronyme='$acronyme' ";
		$resultat += $connexion->exec($sql);

		Application::DeconnexionPDO ($connexion);
		return $resultat;
		}

	/**
	 * fonction de nettoyage de la base de données: suppression de tous les membres des listes qui ne figurent plus parmi les utilisateurs
	 * @param void()
	 * @return integer : nombre de suppression dans la BD
	 */
	public static function cleanTables(){
		$connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
		$sql = "DELETE FROM ".PFX."hermesListes ";
		$sql .= "WHERE membre NOT IN (SELECT acronyme FROM ".PFX."profs) ";
		$nb = $connexion->exec($sql);

		$sql = "DELETE FROM ".PFX."hermesProprio ";
		$sql .= "WHERE proprio NOT IN (SELECT acronyme FROM ".PFX."profs) ";
		$nb += $connexion->exec($sql);

		Application::DeconnexionPDO ($connexion);
		return $nb;

	}

}
?>
