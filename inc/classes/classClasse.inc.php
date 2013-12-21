<?php
require_once ("../config/BD/paramPDO.inc.php");

/*
 * class classe
 */

class classe {
    public $nomClasse;
    public $groupes;
    
    /*
     * __construct
     * @param $nomClasse = nom de la classe
     */
    
    function __construct($nomClasse) {
        $this->nomClasse = $nomClasse;
    }
    
    function listeEleves(){
        $connexion = connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = "SELECT ";
    
        }
    
    function listeElevesString(){
    
        }
        
    function listeCours(){
    
        }
    
    function listeCoursString(){
        
        }
        
    function listeProfs(){
    
        }
    /*
     * function listeTitus
     * @param 
     */
    function listeTitus(){
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = "SELECT acronyme FROM ".PREFIXETABLES."titus ";
        $sql .= "WHERE classe = '$this->nomClasse' ";
        $sql .= "ORDER BY classe";
        $resultat = $connexion->query($sql);
        $resultat->setFetchMode(PDO::FETCH_ASSOC);
        $listeTitus = array();
        while ($ligne = $resultat->fetch()) {
            array_push($listeTitus, $ligne['acronyme']);
        Application::DeconnexionPDO ($connexion);
        return $listeTitus;
        }

    function degre(){
    
        }
        
    function annee(){
    
    
        }
        
    function filiere(){
    
        }
}

?>
