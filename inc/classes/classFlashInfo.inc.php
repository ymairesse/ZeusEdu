<?php

// les flashInfo sont destinés à apparaître sur la page d'accueil d'une application

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

	/**
	 * recherche dans la base de données le FlahsInfo correspondant à l'élément dont l'id est passé en paramètre
	 * @param $id
	 * @return array
	 */
	public function getData ($id=Null) {
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
					'date'=>date("d/m/Y"),
					'heure'=>'',
					'titre'=>'',
					'texte'=>'',
					'application'=>Application::repertoireActuel());
				}

		return $data;
		}

	/**
	 * Supprime de la base de données l'élémnet dont l'id est passé en paramètre
	 * retourne le nombre de suppressions effectuées (une ou aucune)
	 * @param $id
	 * @return integer : nombre de suppression (en principe, une seule)
	 */
	public function delFlashInfo ($id,$module) {
		$connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
		$sql = "DELETE FROM ".PFX."flashInfos ";
		$sql .= "WHERE id = '$id' AND application='$module' ";
		$resultat = $connexion->exec($sql);
		Application::deconnexionPDO($connexion);
		return $resultat;
		}

	/**
	 * Enregistre les données passées dans le tableau $data dans la base de données
	 * retourne le nombre d'enregistrements effectués (un ou zéro si erreur ou inchangé)
	 * @param $data
	 *
	 */
	public function saveFlashInfo ($data) {
		$id = $data['id'];
		$date = Application::dateMysql($data['date']);
		$heure = $data['heure'];

		$connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
		if ($id == Null) {
			$sql = 'INSERT INTO '.PFX.'flashInfos ';
			$sql .= 'SET date=:date, heure=:heure, application=:application, ';
			$sql .= 'titre=:titre, texte=:texte ';
			$requete = $connexion->prepare($sql);
		}
		else {
			$sql = 'UPDATE '.PFX.'flashInfos ';
			$sql .= 'SET date=:date, heure=:heure, application=:application, ';
			$sql .= 'titre=:titre, texte=:texte ';
			$sql .= 'WHERE id=:id ';
			$requete = $connexion->prepare($sql);
			$requete->bindParam(':id', $id, PDO::PARAM_INT);
		}

		$requete->bindParam(':date', $date, PDO::PARAM_STR, 12);
		$requete->bindParam(':heure', $heure, PDO::PARAM_STR, 12);
		$requete->bindParam(':application', $data['application'], PDO::PARAM_STR, 12);
		$requete->bindParam(':titre', $data['titre'], PDO::PARAM_STR, 60);
		$requete->bindParam(':texte', $data['texte'], PDO::PARAM_STR);

		$nb = $requete->execute();

		Application::DeconnexionPDO($connexion);

		return $nb;
		}

	/**
	 * retourne la liste des flashInfos pour le module indiqué et par ordre de dates décroissantes
	 * @param $module
	 * @return array()
	 */
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
