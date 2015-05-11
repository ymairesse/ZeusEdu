<?php
/*
 * class padEleve
 */
class padEleve {

	private $matricule;
	private $proprio;	// propriétaire du pad (utilisateur ou application)
	private $pads = array('proprio'=>array(), 'guest'=>array());
    
    /**
	 * constructeur de la class
	 * @param $matricule
	 * @param $proprio
	 */
	function __construct($matricule, $proprio) {
		if (isset($matricule)) {
			$this->matricule = $matricule;
			$this->proprio = $proprio;
			$this->setPadsEleve();
			}
		}
    
    /**
     * recherche les informations sur l'élève dans la BD en limitant celles qui appartiennent à $proprio
     * @param $proprio
     * @return void()
     */
    private function setPadsEleve () {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        // création d'un pad pour l'utilisateur et le matricule donné si celui-ci n'existe pas encore
        $sql = "INSERT IGNORE INTO ".PFX."pad ";
        $sql .= "SET matricule='$this->matricule', proprio='$this->proprio' ";
        $resultat = $connexion->exec($sql);
        
		// sélection du pad propriétaire (y compris celui qui vient éventuellement d'être créé)
		$sql = "SELECT id, proprio, texte ";
		$sql .= "FROM ".PFX."pad ";
		$sql .= "WHERE proprio = '$this->proprio' AND matricule = '$this->matricule' ";

		$resultat = $connexion->query($sql);
		$resultat->setFetchMode(PDO::FETCH_ASSOC);

		$ligneProprio = $resultat->fetch();
		$id = $ligneProprio['id'];
		$texte = $ligneProprio['texte'];
		$this->pads['proprio'][$id]=array('proprio'=>$this->proprio, 'mode'=>'rw', 'texte'=>$texte);

		// sélection des pads dont l'utilisateur est "guest" pour le matricule d'élève courant
		$sql = "SELECT dpg.id, proprio, mode, texte ";
		$sql .= "FROM ".PFX."padGuest AS dpg ";
		$sql .= "JOIN ".PFX."pad AS dp ON dp.id = dpg.id ";
		$sql .= "WHERE dpg.id IN (SELECT id FROM ".PFX."pad WHERE matricule='$this->matricule') AND guest='$this->proprio' ";
		$sql .= "ORDER BY proprio ";
		
		$resultat = $connexion->query($sql);
		$guest = array();
		if ($resultat) {
			$resultat->setFetchMode(PDO::FETCH_ASSOC);
			while ($ligne = $resultat->fetch()) {
				$id = $ligne['id'];
				$mode = $ligne['mode'];
				$texte = stripslashes($ligne['texte']);
				$proprio = $ligne['proprio'];
				$this->pads['guest'][$id] = array('proprio'=>$proprio, 'mode'=>$mode, 'texte'=>$texte);
				}
			}
		Application::DeconnexionPDO($connexion);
        }
        
    /**
     * renvoie les textes du bloc-notes
     * @param void()
     * @return string
     */
    public function getPads() {
		return $this->pads;
		}

    /** 
     * enregistrement des données élèves
     * $POST provient du $_POST de la fiche et peut contenir diverses données
     * on en extrait:
     *  - le matricule de l'élève concerné
     *  - le champ texte_ID dont le nom comtien l'ID du texte éventuellement existant
     * @param $post
     * @return integer
     */
    public function savePadEleve ($post) {
		$connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
		$matricule = $post['matricule'];
		$nb=0;
		foreach ($post as $field => $value) {
			// on enregistre les champs nommés "texte_"
			if (substr($field,0,6) == 'texte_') {
				$id = explode('_',$field);
				$id = $id[1];
				$texte = addslashes($value);
				$sql = "UPDATE ".PFX."pad ";
				$sql .= "SET texte = '$texte' ";
				$sql .= "WHERE id='$id' ";
				$nb += $connexion->exec($sql);
				$this->texte = $texte;
				}
			}
		Application::DeconnexionPDO($connexion);
		return $nb; // nombre de lignes modifiées dans la BD
        }
        
	/** 
	 * enregistrement des partages des fiches "élèves" entre utilisateurs
	 * @param $acronyme
	 * @param $moderw : mode de partage ('r','rw','release')
	 * @param $listeEleves : liste des élèves 
	 * @param $listeProfs : liste des profs
	 * @return nb : nombre de modifications dans la BD
	 */
	static function savePartages ($acronyme, $moderw, $listeEleves, $listeProfs) {
		$nbAjouts = 0;
		if ((count($listeEleves)!= 0) && (count($listeProfs)!= 0)){
			$listeAcronymes = "'".implode("','",$listeProfs)."'";
			$listeMatricules = implode(',',$listeEleves);
			$connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
			
			// on traite d'abord le cas des autorisations de partage, on verra les "releases" après
			if (in_array($moderw, array('r','rw'))) {
				foreach ($listeEleves as $matricule) {
					// on s'assure qu'il existe une fiche ou on la crée pour le couple acronyme/matricule
					$sql = "INSERT IGNORE INTO ".PFX."pad ";
					$sql .= "SET matricule='$matricule', proprio='$acronyme', texte=Null ";
					$resultat = $connexion->exec($sql);
					}

				// on recherche les id's des fiches pour les couples acronyme/matricules à partager ou dé-partager
				$sql = "SELECT id FROM ".PFX."pad ";
				$sql .= "WHERE proprio ='$acronyme' AND matricule IN ($listeMatricules) ";
				$resultat = $connexion->query($sql);
				$resultat->setFetchMode(PDO::FETCH_ASSOC);
				$listeIds = $resultat->fetchAll();			

				// on crée les guests dans la table padGuest
				foreach ($listeProfs as $unAcronyme) {
					foreach ($listeIds as $wtf=>$idArray) {
						$id = $idArray['id'];
						$sql = "INSERT INTO ".PFX."padGuest ";
						$sql .= "SET id='$id', guest='$unAcronyme', mode='$moderw' ";
						$sql .= "ON DUPLICATE KEY UPDATE mode='$moderw' ";
						$nbAjouts += $connexion->exec($sql);
						}
					}
				}
			else {
				// on recherche les id's des fiches pour les couples acronymes/matricules à partager ou dé-partager
				$sql = "SELECT id FROM ".PFX."pad ";
				$sql .= "WHERE proprio = '$acronyme' AND matricule IN ($listeMatricules) ";
				$resultat = $connexion->query($sql);
				$resultat->setFetchMode(PDO::FETCH_ASSOC);
				$listeIds = $resultat->fetchAll();
				// il s'agit de supprimer des guests => release
				foreach ($listeProfs as $unAcronyme) {
					foreach ($listeIds as $wtf=>$idArray) {
						$id = $idArray['id'];
						$sql = "DELETE FROM ".PFX."padGuest ";
						$sql .= "WHERE id='$id' AND guest='$unAcronyme' ";
						$nbAjouts -= $connexion->exec($sql);
						}
					}
				}
			Application::DeconnexionPDO($connexion);
			}
		return $nbAjouts;
		}

	/** 
	 * renvoie la liste des partages (noms des profs) pour une liste d'élèves donnée pour un propriétaire donné
	 * @param $acronyme : string
	 * @param $listeEleves : array|string
	 * @return array
	 */
	static function listePartages ($acronyme, $listeEleves) {
		if (is_array($listeEleves))
			$listeElevesString = implode(",",array_keys($listeEleves));
			else $listeElevesString = $listeEleves;
		$connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
		$sql = "SELECT matricule, dp.id,guest,mode ";
		$sql .= "FROM ".PFX."pad AS dp ";
		$sql .= "JOIN ".PFX."padGuest AS dpg ON dp.id = dpg.id ";
		$sql .= "WHERE matricule IN ($listeElevesString) AND proprio = '$acronyme' ";
		$resultat = $connexion->query($sql);
		$liste = array();
		if ($resultat) {
			$resultat->setFetchMode(PDO::FETCH_ASSOC);
			while ($ligne = $resultat->fetch()) {
				$matricule = $ligne['matricule'];
				$guest = $ligne['guest'];
				$mode = $ligne['mode'];
				$liste[$matricule][$guest] = $mode;
				}
			}
		Application::DeconnexionPDO($connexion);
		return $liste;
		}

}      

?>
