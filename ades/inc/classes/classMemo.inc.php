<?php
/*
 * class memoAdes
 */
class memoAdes {
    private $matricule;
    private $proprio;
    private $texte;
    
    /**
     * constructeur de la class
     * @param 
     */
    function __construct($matricule, $proprio) {
        if (isset($matricule)) {
            $this->matricule = $matricule;
            $this->proprio = 'ades';
            $this->setPadEleve();
            }
        }

    /**
     * recherche les informations sur l'élève $matricule dans la BD en limitant à celles qui appartiennent à 'ades'
     * @return text
     */
    private function setPadEleve () {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = "SELECT * FROM ".PFX."pad ";
        $sql .= "WHERE matricule='$this->matricule' AND proprio = 'ades'";
        $resultat = $connexion->query($sql);
        if ($resultat) {
			$resultat->setFetchMode(PDO::FETCH_ASSOC);
			$ligne = $resultat->fetch();
			$this->texte = stripslashes($ligne['texte']);
			}
        Application::DeconnexionPDO($connexion);
        }
        
    /**
     * renvoie le texte du bloc-notes
     * @param
     * @return string
     */
     public function getPadText() {
		 return $this->texte;
		 }

    /** 
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
        $sql .= "proprio='ades' ";
        $sql .= "ON DUPLICATE KEY UPDATE texte='$texte' ";
        $resultat = $connexion->exec($sql);
        Application::DeconnexionPDO($connexion);
        $this->texte = stripslashes($texte);
        return $resultat; // nombre de lignes modifiées dans la BD
        }

}      

?>
