<?php

// les flashInfo sont destinés à apparaître sur la page d'accueil d'une application

class flashInfo {
	// private $id;
	// private $data;

	// --------------------------------------------
	// fonction constructeur
	function __construct() {

	}

	/**
	 * recherche dans la base de données le FlahsInfo correspondant à l'élément dont l'id est passé en paramètre
	 * @param $id : si Null, la fonction renvoie un flashInfo vide
	 *
	 * @return array
	 */
	public function getNewsData ($id = Null) {
		if ($id != Null) {
			$connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
			$sql = 'SELECT id, date, heure, titre, texte, application, developpe ';
			$sql .= 'FROM '.PFX.'flashInfos ';
			$sql .= 'WHERE id= :id ';
			$requete = $connexion->prepare($sql);

			$requete->bindParam(':id', $id, PDO::PARAM_INT);
			$resultat = $requete->execute();
			$data = array();
			if ($resultat) {
				$requete->setFetchMode(PDO::FETCH_ASSOC);
				$ligne = $requete->fetch();
				$data = $ligne;
				$data['date'] = Application::datePHP($data['date']);
				}
			Application::deconnexionPDO($connexion);
		}
		else {
			$data = array(
				'id' => '',
				'date' => date("d/m/Y"),
				'heure' => date("H:i"),
				'titre' => '',
				'texte' => '',
				'application' => Application::repertoireActuel(),
				'developpe' => 0,
			);
			}

		return $data;
		}


	/**
	 * Supprime de la base de données l'élémnet dont l'id est passé en paramètre
	 * retourne le nombre de suppressions effectuées (une ou aucune)
	 * @param $id
	 * @return integer : si tout s'est bien passé, on retourne l'id, sinon -1
	 */
	public function delFlashInfo ($id, $module) {

		$connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
		$sql = 'DELETE FROM '.PFX.'flashInfos ';
		$sql .= 'WHERE id = :id AND application = :module ';
		$requete = $connexion->prepare($sql);

		$requete->bindParam(':id', $id, PDO::PARAM_INT);
		$requete->bindParam(':module', $module, PDO::PARAM_STR, 12);

		$resultat = $requete->execute();

		$nb = $requete->rowCount();

		Application::deconnexionPDO($connexion);

		return $nb;
		}

	/**
	 * Enregistre les données passées dans le tableau $post dans la base de données
	 * retourne le nombre d'enregistrements effectués (un ou zéro si erreur ou inchangé)
	 * @param array $post
	 *
	 * @return int
	 */
	public function saveFlashInfo ($post) {
		$id = $post['id'];
		$date = Application::dateMysql($post['date']);
		$heure = $post['heure'];
		$module = $post['module'];
		$titre = $post['titre'];
		$texte = $post['texte'];
		$developpe = isset($post['developpe']) ? 1 : 0;

		$connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
		if ($id == Null) {
			$sql = 'INSERT INTO '.PFX.'flashInfos ';
			$sql .= 'SET date = :date, heure = :heure, application = :application, ';
			$sql .= 'titre = :titre, texte = :texte, developpe = :developpe ';
			$requete = $connexion->prepare($sql);
		}
		else {
			$sql = 'UPDATE '.PFX.'flashInfos ';
			$sql .= 'SET date = :date, heure = :heure, application = :application, ';
			$sql .= 'titre = :titre, texte = :texte, developpe = :developpe ';
			$sql .= 'WHERE id = :id ';
			$requete = $connexion->prepare($sql);
			$requete->bindParam(':id', $id, PDO::PARAM_INT);
		}

		$requete->bindParam(':date', $date, PDO::PARAM_STR, 12);
		$requete->bindParam(':heure', $heure, PDO::PARAM_STR, 12);
		$requete->bindParam(':application', $module, PDO::PARAM_STR, 12);
		$requete->bindParam(':titre', $titre, PDO::PARAM_STR, 60);
		$requete->bindParam(':texte', $post['texte'], PDO::PARAM_STR);
		$requete->bindParam(':developpe', $developpe, PDO::PARAM_INT);

		$nb = $requete->execute();

		Application::DeconnexionPDO($connexion);

		return $nb;
		}

	/**
	 * retourne la liste des flashInfos pour le module indiqué et par ordre de dates décroissantes
	 *
	 * @param string $module
	 *
	 * @return array
	 */
	public static function listeFlashInfos ($module) {
		$connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
		$sql = 'SELECT id, date, heure, application, titre, texte, developpe ';
		$sql .= 'FROM '.PFX.'flashInfos ';
		$sql .= 'WHERE application = :module ';
		$sql .= 'ORDER BY date DESC, titre ';
		$requete = $connexion->prepare($sql);

		$requete->bindParam(':module', $module, PDO::PARAM_STR, 12);
		$resultat = $requete->execute();

		$flashInfos = array();
		if ($resultat) {
			$requete->setFetchMode(PDO::FETCH_ASSOC);
			while ($ligne = $requete->fetch()) {
				$flashInfos[] = $ligne;
				}
			}

		Application::DeconnexionPDO($connexion);

		return $flashInfos;
		}

}
