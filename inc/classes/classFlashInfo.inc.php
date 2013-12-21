<?php

class flashInfo {
	private $id;
	private $data;
	
	// --------------------------------------------
	// fonction constructeur
	function __construct($id=Null) {
	if (isset($id)) {
		$this->id = $id;
		$this->data = $this->getData();
		}
	}
	
	/* 
	 * function getData
	 * @param $id
	 * 
	 * recherche dans la base de données, 
	 * les informations correspondant à l'élément dont l'id est passé en paramètre
	 * */

	public static function getData ($id=Null) {
		if ($id) {
			$connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
			$sql = "SELECT * FROM ".PFX."flashInfos ";
			$sql .= "WHERE id='$id'";
			$resultat = $connexion->query($sql);
			$data = array();
			if ($resultat) {
				$resultat->setFetchMode(PDO::FETCH_ASSOC);
				$ligne = $resultat->fetch();
				$data = $ligne;
				$data['date'] = Application::datePHP($data['date']);
				}
			Application::deconnexionPDO($connexion);
		}
		else {
				$data = array(
					'id'=>'',
					'date'=>'',
					'heure'=>'',
					'titre'=>'',
					'texte'=>'',
					'application'=>Application::repertoireActuel());
				}

		return $data;
		}

	/* 
	 * function delFlashInfo
	 * @param $id
	 * 
	 * Supprime de la base de données l'élémnet dont l'id est passé en paramètre
	 * retourne le nombre de suppressions effectuées (une ou aucune)
	 * */
	public static function delFlashInfo ($id) {
		$connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
		$sql = "DELETE FROM ".PFX."flashInfos ";
		$sql .= "WHERE id = '$id' ";
		$resultat = $connexion->exec($sql);
		Application::deconnexionPDO($connexion);
		return $resultat;
		}
		
	/* 
	 * function saveFlashInfo
	 * @param $data
	 * 
	 * Enregistre les données passées dans le tableau $data dans la base de données
	 * retourne le nombre d'enregistrements effectués (un ou zéro si erreur ou inchangé)
	 * */
	public static function saveFlashInfo ($data) {
		$connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
		$id = $data['id'];
		$date = Application::dateMysql($data['date']);
		$heure = $data['heure'];
		$application = $data['application'];
		$urgence = isset($data['urgence'])?$data['urgence']:Null;;
		$titre = addslashes($data['titre']);
		$texte = addslashes($data['texte']);
		$sql = "INSERT INTO ".PFX."flashInfos ";
		$sql .= "SET id='$id', date='$date', heure='$heure', application='$application', ";
		$sql .= "urgence = '$urgence', titre='$titre', texte='$texte' ";
		$sql .= "ON DUPLICATE KEY UPDATE date='$date', heure='$heure', application='$application', ";
		$sql .= "urgence = '$urgence', titre='$titre', texte='$texte' ";
		$nb = $connexion->exec($sql);
		Application::DeconnexionPDO($connexion);
		return $nb;
		}

	/*
	 * function listeFlashInfos
	 * @param $module
	 * 
	 * retourne la liste des flashInfos pour le module indiqué et par ordre de dates décroissantes
	 * */
	public static function listeFlashInfos ($module) {
		$connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
		$sql = "SELECT * FROM ".PFX."flashInfos ";
		$sql .= "WHERE application = '$module' ";
		$sql .= "ORDER BY date DESC";
		$resultat = $connexion->query($sql);
	
		$flashInfos = array();
		if ($resultat) {
			$resultat->setFetchMode(PDO::FETCH_ASSOC);
			while ($ligne = $resultat->fetch()) {
				$flashInfos[] = $ligne;
				}
			}
		Application::DeconnexionPDO($connexion);
	return $flashInfos;
	}


}
?>
