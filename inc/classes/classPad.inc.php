<?php
/*
 * class padEleve
 */
class padEleve {
    private $matricule;
    private $proprio;
    private $texte;
    
    /*
     * __construct
     * @param 
     */
    function __construct($matricule, $proprio) {
        if (isset($matricule)) {
            $this->matricule = $matricule;
            $this->proprio = $proprio;
            $this->setPadEleve();
            }
        }

    /**
     * recherche les informations sur l'élève $matricule dans la BD en limitant à celles qui appartiennent à $proprio
     * @param $proprio
     * @return text
     */
    private function setPadEleve () {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = "SELECT * FROM ".PFX."pad ";
        $sql .= "WHERE matricule='$this->matricule' AND proprio = '$this->proprio'";
        $resultat = $connexion->query($sql);
        if ($resultat) {
			$resultat->setFetchMode(PDO::FETCH_ASSOC);
			$ligne = $resultat->fetch();
			$this->texte = stripslashes($ligne['texte']);
			}
        Application::DeconnexionPDO($connexion);
        }
        
    /* 
     * function getPadText
     * @param
     * renvoie le texte du bloc-notes
     * 
     * */
     public function getPadText() {
		 return $this->texte;
		 }

    /* 
     * enregistrement des données élèves
     * $POST provient du $_POST de la fiche et peut contenir diverses données
     * @param $POST
     * @return integer : nombre de lignes modifiées dans la BD
     */
    function savePadEleve ($post) {
		$texte = addslashes($post['texte']);
        $matricule = $post['matricule'];
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = "INSERT INTO ".PFX."pad SET matricule='$matricule', texte='$texte', ";
        $sql .= "proprio='$this->proprio' ";
        $sql .= "ON DUPLICATE KEY UPDATE texte='$texte' ";
        $resultat = $connexion->exec($sql);
        Application::DeconnexionPDO($connexion);
        $this->texte = stripslashes($texte);
        return $resultat; // nombre de lignes modifiées dans la BD
        }

	/*
	 * function prevNext
	 *
	 * @param $matricule
	 * @param $listeEleves
	 *
	 * return array ('prev', 'next')
	 *
	 * renvoie un tableau contenant l'élève précédent, l'élève courant et l'élève suivant
	 * celui dont le matricule est passé en argument
	 * */
	public function prevNext($matricule, $listeEleves) {
		$listeEleves = array_keys($listeEleves);
		$pos = array_search($matricule, $listeEleves);
		$prev = ($pos > 0)?$listeEleves[$pos-1]:Null;
		$next = ($pos < count($listeEleves))?$listeEleves[$pos+1]:Null;
		return (array('prev'=>$prev, 'next'=>$next));
		}


}      

?>
