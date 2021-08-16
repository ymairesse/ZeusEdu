<?php


class visiteInfirmerie {

	function __construct(){

	}

	public static function saveVisite ($post) {
		$consultID = isset($post['consultID']) ? $post['consultID'] : Null;
		$acronyme = $post['acronyme'];
		$codeInfo=$post['codeInfo'];
		$date = dateMySql($post['date']);
		$heure = $post['heure'];
		$motif = $post['motif'];
		$traitement = $post['traitement']);
		$aSuivre = $post['aSuivre'];

		$connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
		if ($consultID) {
			// c'est une mise à jour d'une visite précédente
			$sql = "UPDATE ".PFX."infirmConsult ";
			$sql .= "SET codeInfo = :codeInfo, acronyme = :acronyme, date = :date, heure = :heure, ";
			$sql .= "motif = :motif, traitement = :traitement, aSuivre = :aSuivre ";
			$sql .= "WHERE consultID = :consultID ";
			$requete = $connexion->prepare($sql);
			$requete->bindParam(':consultID', $consultID, PDO::PARAM_INT);
			}
			else {
				// c'est une nouvelle visite
				$sql = "INSERT INTO ".PFX."infirmConsult SET codeInfo = :codeInfo, date = :date, heure = :heure, ";
				$sql .= "acronyme = :acronyme, motif = :motif, traitement = :traitement, aSuivre = :aSuivre ";
				$requete = $connexion->prepare($sql);
				}
		$requete->bindParam(':acronyme', $acronyme, PDO::PARAM_STR, 7);


		$resultat = $connexion->exec($sql);
		Application::DeconnexionPDO($connexion);
		}

	/**
	 * recherche toutes les visites à l'infirmerie entre deux dates
	 *
	 * @param string $dateDebut
	 * @param string  $dateFin
	 *
	 * @return array
	 *
	 * */
	 public function listeVisitesParDate ($dateDebut, $dateFin) {
		$listeConsultations = array();
		if ($dateDebut && $dateFin) {
			$connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
			$sql = 'SELECT consultID, consult.matricule, date, heure, nom, prenom, classe, motif, traitement, aSuivre ';
			$sql .= 'FROM '.PFX.'infirmConsult AS consult ';
			$sql .= 'JOIN '.PFX.'eleves AS eleves ON eleves.matricule = consult.matricule ';
			$sql .= 'WHERE date BETWEEN :dateDebut AND :dateFin ';
			$sql .= 'ORDER BY date, classe, heure, nom ';
			$requete = $connexion->prepare($sql);

			$requete->bindParam(':dateDebut', $dateDebut, PDO::PARAM_STR, 10);
			$requete->bindParam(':dateFin', $dateFin, PDO::PARAM_STR, 10);

			$liste = array();

			$resultat = $requete->execute();
			if ($resultat) {
				$requete->setFetchMode(PDO::FETCH_ASSOC);
				while ($ligne = $requete->fetch()) {
					$date = $ligne['date'];
					$matricule = $ligne['matricule'];
					$consultID = $ligne['consultID'];
					$liste[$date][$matricule][$consultID] = $ligne;
				}
				}
			Application::DeconnexionPDO($connexion);
			}

		return $liste;
		 }

}
