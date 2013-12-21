<?php

	
class visiteInfirmerie {
	public $consultID;
	public $acronyme;
	public $date, $heure;
	public $codeInfo;
	public $motif;
	public $traitement;
	public $aSuivre;
	
	function __construct ($consultID, $codeInfo="") {
		if ($consultID == '') {
			$this->date = date("d/m/Y");
			$this->heure = date("H:i");
			$this->matricule = $matricule;
			$this->acronyme = $this->motif = $this->traitement = $this->asuivre = '';
			}
			else {
				$connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
				$sql = "SELECT * FROM ".PFX."infirmConsult ";
				$sql .= "WHERE consultID = '$consultID'";
				$resultat = $connexion->query($sql);
				$ligne = $resultat->fetch();
				$this->consultID = $consultID;
				$this->date = datePHP($ligne['date']);
				$this->codeInfo = $ligne['codeInfo'];
				$this->heure = $ligne['heure'];
				$this->acronyme = $ligne['acronyme'];
				$this->motif = $ligne['motif'];
				$this->traitement = $ligne['traitement'];
				$this->aSuivre = $ligne['aSuivre'];
				Application::DeconnexionPDO($connexion);
				}
		}
	public static function saveVisite ($post) {
		$consultID = ($post['consultID'])?$post['consultID']:Null;
		$acronyme = addslashes($post['acronyme']);
		$codeInfo=addslashes($post['codeInfo']);
		$date = dateMySql($post['date']);
		$heure=addslashes($post['heure']);
		$motif=addslashes($post['motif']);
		$traitement=addslashes($post['traitement']);
		$aSuivre=addslashes($post['aSuivre']);
		$connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
		if ($consultID) {
			// c'est une mise à jour d'une visite précédente
			$sql = "UPDATE ".PFX."infirmConsult ";
			$sql .= "SET codeInfo='$codeInfo', acronyme='$acronyme', date='$date', heure='$heure', ";
			$sql .= "motif='$motif', traitement='$traitement', aSuivre='$aSuivre' ";
			$sql .= "WHERE consultID='$consultID'";
			}
			else {
				// c'est une nouvelle visite
				$sql = "INSERT INTO ".PFX."infirmConsult SET codeInfo='$codeInfo', date='$date', heure='$heure', ";
				$sql .= "acronyme='$acronyme', motif='$motif', traitement='$traitement', aSuivre='$aSuivre' ";
				}
		$resultat = $connexion->exec($sql);
		Application::DeconnexionPDO($connexion);
		}
		
	/*
	 * function listeVisitesParDate
	 * @param $dateDebut
	 * @param $dateFin
	 * 
	 * liste des visites à l'infirmerie classées par date
	 * dans une période entre $dateDebut et $dateFin
	 * 
	 * */
	 public static function listeVisitesParDate ($dateDebut, $dateFin) {
		$listeConsultations = array();
		if ($dateDebut && $dateFin) {
			$connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
			$sql = "SELECT consultID, ".PFX."infirmConsult.matricule, date, heure, nom, prenom, classe, motif, traitement, aSuivre ";
			$sql .= "FROM ".PFX."infirmConsult ";
			$sql .= "JOIN ".PFX."eleves ON (".PFX."eleves.matricule = ".PFX."infirmConsult.matricule) ";
			$sql .= "WHERE ((date >= '$dateDebut') AND (date <= '$dateFin')) ";
			$sql .= "ORDER BY date, classe, heure, nom";
			$resultat = $connexion->query($sql);
			if ($resultat) 
				$resultat->setFetchMode(PDO::FETCH_ASSOC);
			while ($ligne = $resultat->fetch()) {
				$date = $ligne['date'];
				$matricule = $ligne['matricule'];
				$consultID = $ligne['consultID'];
				$listeConsultations[$date][$matricule][$consultID] = $ligne;
			}
			Application::DeconnexionPDO($connexion);
			}
		return $listeConsultations;		 
		 }
	 
}

?>
