<?php
// require_once (INSTALL_DIR."/inc/fonctions.inc.php");

/*
 * class eleveInfirmerie
 */
class eleveInfirmerie {


    /*
     * function getMedicEleve
     * @param
     * 
     * recherche les informations médicales générales sur l'élève dans la BD
     */
    public function getMedicEleve ($matricule) {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = "SELECT * FROM ".PFX."infirmerie WHERE matricule='$matricule'";
        $resultat = $connexion->query($sql);
        if ($resultat) {
			$resultat->setFetchMode(PDO::FETCH_ASSOC);
			$ligne = $resultat->fetch();
			}
        Application::DeconnexionPDO($connexion);
		return $ligne;
        }
        

	/**
	 * retourne la liste des visites de l'élève à l'infirmerie et issue de la BD
     * @param $matricule : matricule de l'élève concerné
     * @param $consultID : identifiant de la visite concernée (sinon, toutes les visites)
     */
    public function getVisitesEleve ($matricule, $consultID=Null) {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = "SELECT * FROM ".PFX."infirmConsult ";
        $sql .= "WHERE matricule='$matricule' ";
		if ($consultID != Null)
			$sql .= "AND consultID = '$consultID' ";
		$sql .= "ORDER BY date";
        $resultat = $connexion->query($sql);
		$listeVisites = array();
		if ($resultat) {
			$resultat->setFetchMode(PDO::FETCH_ASSOC);
			while ($ligne = $resultat->fetch()) {
				$consultID = $ligne['consultID'];
				$date = $ligne['date'];
				$ligne['date'] = Application::datePHP($date);
				$listeVisites[$consultID] = $ligne;
				}
			}
        Application::DeconnexionPDO($connexion);
		return $listeVisites;
        }
        
	/* 
	 * function enregistrerMedical
	 * @param $data données $_POST provenant d'un formulaire
	 * 
	 * Enregistrement des données médicales d'un élève
	 * 
	 * */
    function enregistrerMedical ($data) {
        $medecin = addslashes($data['medecin']);
        $telMedecin = addslashes($data['telMedecin']);
        $sitFamiliale = addslashes($data['sitFamiliale']);
        $anamnese = addslashes($data['anamnese']);
        $medical = addslashes($data['medical']);
        $psy = addslashes($data['psy']);
        $traitement = addslashes($data['traitement']);
        $matricule = $data['matricule'];
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = "INSERT INTO ".PFX."infirmerie SET matricule='$matricule', medecin='$medecin', ";
        $sql .= "telMedecin='$telMedecin', sitFamiliale='$sitFamiliale', anamnese='$anamnese', psy='$psy', ";
        $sql .= "traitement = '$traitement', medical = '$medical' ";
        $sql .= "ON DUPLICATE KEY UPDATE medecin='$medecin', telMedecin='$telMedecin', sitFamiliale='$sitFamiliale', ";
        $sql .= "anamnese='$anamnese', medical='$medical', psy='$psy', traitement='$traitement'";
        $resultat = $connexion->exec($sql);
        Application::DeconnexionPDO($connexion);
        return $resultat; // nombre de lignes modifiées dans la BD
        }
    
    /**
     * Enregistrement des informations concernant une visite à l'infirmerie
     * @param $data données $_POST provenant d'un formulaire
     * @return integer : nombre de lignes modifiées dan sla BD
     */
    function enregistrerVisite($data) {
        $consultID=$data['consultID'];
        $acronyme = addslashes($data['acronyme']);
        $matricule=addslashes($data['matricule']);
        $date=addslashes($data['date']);
        $date = Application::dateMySql($date);
        $heure=addslashes($data['heure']);
        $motif=addslashes($data['motif']);
        $traitement=addslashes($data['traitement']);
        $aSuivre=addslashes($data['aSuivre']);
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        if ($consultID) {
            // c'est une mise à jour d'une visite précédente
            $sql = "UPDATE ".PFX."infirmConsult ";
            $sql .= "SET matricule='$matricule', date='$date', heure='$heure', acronyme='$acronyme', ";
            $sql .= "motif='$motif', traitement='$traitement', aSuivre='$aSuivre' ";
            $sql .= "WHERE consultID='$consultID'";
            }
            else {
                $sql = "INSERT INTO ".PFX."infirmConsult SET matricule='$matricule', date='$date', heure='$heure', ";
                $sql .= "acronyme='$acronyme', motif='$motif', traitement='$traitement', aSuivre='$aSuivre' ";
                }
        $resultat = $connexion->exec($sql);
        Application::DeconnexionPDO($connexion);
        return $resultat; // nombre de lignes modifiées dans la BD
        }

    /**
	 * Suppression des infos concernant une visite à l'infirmerie
	 * @param $consultID : identifiant de la visite
	 * @return integer : nombre de suppression effectivement réalisées
	 */
    function deleteVisite($consultID) {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        if ($consultID) {
            $sql = "DELETE FROM ".PFX."infirmConsult ";
            $sql .= "WHERE consultID = '$consultID'";
            $nbResultats = $connexion->exec($sql);
            }
        Application::DeconnexionPDO($connexion);
        return $nbResultats;
        }
}      

?>
