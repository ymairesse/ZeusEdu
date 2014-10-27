<?php
/*
 * class padEleve
 */
class padEleve {

	private $matricule;
	private $proprio;
    private $texte;
    private $id;
    
    /**
	 * constructeur de la class
	 * @param $matricule
	 * @param $proprio
	 */
	function __construct($matricule, $proprio) {
		if (isset($matricule)) {
			$this->matricule = $matricule;
			$this->proprio = $proprio;
			$this->setPadEleve();
			}
	}
    
    /*
     * function setPadEleve
     * @param $proprio
     * 
     * recherche les informations  sur l'élève dans la BD en limitant celles qui appartiennent à $proprio
     */
    private function setPadEleve () {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
		$sql = "SELECT dp.id, texte ";
		$sql .= "FROM ".PFX."pad AS dp ";
		$sql .= "JOIN ".PFX."padProprio AS dpp ON dpp.id = dp.id ";
		$sql .= "WHERE matricule='$this->matricule' AND dpp.proprio = '$this->proprio' ";
		$resultat = $connexion->query($sql);
		if ($resultat) {
			$ligne = $resultat->fetch();
			$this->texte = stripslashes($ligne['texte']);
			$this->id = $ligne['id'];
		}
		Application::DeconnexionPDO($connexion);
        }
        
    /**
     * renvoie le texte du bloc-notes
     * @param void()
     * @return string
     * 
     */
    public function getPadText() {
		return $this->texte;
		}

    /** 
     * enregistrement des données élèves
     * $POST provient du $_POST de la fiche et peut contenir diverses données
     * @param $POST
     * @return integer
     */
    function savePadEleve ($post) {
		$texte = addslashes($post['texte']);
		$matricule = $post['matricule'];
		$connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
		if ($this->id == Null) {
			$sql = "INSERT INTO ".PFX."pad ";
			$sql .= "SET matricule='$matricule', texte='$texte' ";
			$resultat = $connexion->exec($sql);
			$id = $connexion->lastInsertId();
			// on prend note de l'identité du propriétaire dans la table des proprios
			$sql = "INSERT INTO ".PFX."padProprio ";
			$sql .= "SET id='$id', proprio='$this->proprio' ";
			$resultat = $connexion->exec($sql);
			}
		else {
			// ce n'est qu'une mise à jour du contenu du pad
			$sql = "UPDATE ".PFX."pad ";
			$sql .= "SET texte = '$texte' ";
			$sql .= "WHERE id='$this->id' ";
			$resultat = $connexion->exec($sql);
			}
		Application::DeconnexionPDO($connexion);
		$this->texte = stripslashes($texte);
		return $resultat; // nombre de lignes modifiées dans la BD
        }

}      

?>
