<?php

/**
 *
 */
class TrombiEleves
{

    function __construct()
    {
        // code...
    }

    /**
     * Création du fichier PDF du trombinoscope des élèves
     * @param  string $cible
     * @param  string $groupe : la classe ou le coursGrp
     *
     * @return string
     */
    function getFichierCSV($cible, $groupe) {
    	$connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
    	$sql = 'SELECT matricule, groupe, nom, prenom, DateNaiss, nomResp, telephone1, telephone2, telephone3 ';
    	$sql .= 'FROM '.PFX.'eleves ';
        if ($cible == 'classe') {
            $sql .= 'WHERE matricule IN (SELECT matricule FROM '.PFX.'eleves WHERE groupe = :groupe) ';
            $sql .= 'AND section != "PARTI" ';
            }
            else {
            $sql .= 'WHERE matricule IN (SELECT matricule FROM '.PFX.'elevesCours WHERE coursGrp = :groupe) ';
            $sql .= 'AND section != "PARTI" ';
            }
    	$sql .= "ORDER BY REPLACE(REPLACE(REPLACE(nom,' ',''),'-',''),'\'',''), prenom, groupe ";
    	$requete = $connexion->prepare($sql);

        $requete->bindParam(':groupe', $groupe, PDO::PARAM_STR, 15);

    	$resultat = $requete->execute();
    	$texteCSV = '';
    	if ($resultat) {
    		$texteCSV = "\"Matricule\", \"Classe\",\"Nom\",\"Prénom\",\"Date de Naissance\", \"Responsable\",\"telephone1\",\"telephone2\",\"telephone3\"".chr(10);
    		while ($ligne = $requete->fetch()) {
    			$matricule = $ligne['matricule'];
    			$groupe = $ligne['groupe'];
    			$nom = $ligne['nom'];
    			$prenom = $ligne['prenom'];
    			$dateNaissance = Application::datePHP($ligne['DateNaiss']);
    			$nomResp = $ligne['nomResp'];
    			$telephone1 = $ligne['telephone1'];
    			$telephone2 = $ligne['telephone2'];
    			$telephone3 = $ligne['telephone3'];
    			$texteCSV .= "\"$matricule\",\"$groupe\",\"$nom\",\"$prenom\", \"$dateNaissance\", \"$nomResp\",\"$telephone1\",\"$telephone2\",\"$telephone3\"".chr(10);
    			}
    		}

    	Application::DeconnexionPDO($connexion);

    	return $texteCSV;
    }



    /**
     * Création du fichier PDF du trombinoscope des élèves
     * @param  string $cible
     * @param  string $groupeCours : la classe ou le coursGrp
     * @param string $acronyme : propriétaire
     *
     * @return string
     */
    function getFichierPDF ($cible, $groupe, $acronyme) {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT matricule, groupe, nom, prenom ';
        $sql .= 'FROM '.PFX.'eleves ';
        if ($cible == 'classe') {
            $sql .= 'WHERE matricule IN (SELECT matricule FROM '.PFX.'eleves WHERE groupe = :groupe) ';
            $sql .= 'AND section != "PARTI" ';
            }
            else {
            $sql .= 'WHERE matricule IN (SELECT matricule FROM '.PFX.'elevesCours WHERE coursGrp = :groupe) ';
            $sql .= 'AND section != "PARTI" ';
            }
        $sql .= "ORDER BY REPLACE(REPLACE(REPLACE(nom,' ',''),'-',''),'\'',''), prenom, groupe ";
        $requete = $connexion->prepare($sql);

        $requete->bindParam(':groupe', $groupe, PDO::PARAM_STR, 15);

        $listeEleves = array();
        $resultat = $requete->execute();
        if ($resultat){
            $requete->setFetchMode(PDO::FETCH_ASSOC);
            while ($ligne = $requete->fetch()){
                $matricule = $ligne['matricule'];
                $listeEleves[$matricule] = $ligne;
            }
        }

        Application::DeconnexionPDO($connexion);

        return $listeEleves;
    	}

}
