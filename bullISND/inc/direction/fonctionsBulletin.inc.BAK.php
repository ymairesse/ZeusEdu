<?php

function anneeDeClasse($classe) {
    return (int) substr($classe, 0, 1);
}

function anneePrecedenteDeClasse ($classe){
    $annee = anneeDeClasse($classe);
    return $annee-1;
}

function listeSimpleMentions($listeEleves, $periode, $anneeScolaire)
    {
        if (is_array($listeEleves)) {
            $listeElevesString = implode(',', array_keys($listeEleves));
        } else {
            $listeElevesString = $listeEleves;
        }
      $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
      $sql = 'SELECT matricule, mention, anscol, periode ';
      $sql .= 'FROM didac_bullMentions ';
      $sql .= "WHERE matricule IN ($listeElevesString) ";
      $sql .= "AND periode = $periode AND anscol= '$anneeScolaire' ";
      $sql .= "ORDER BY matricule ";

      $resultat = $connexion->query($sql);
      $liste = array();
      if ($resultat) {
        $resultat->setFetchMode(PDO::FETCH_ASSOC);
        while ($ligne = $resultat->fetch()) {
            $matricule = $ligne['matricule'];
            $mention = $ligne['mention'];
            $liste[$matricule] = $mention;
        }
      }

      Application::DeconnexionPDO($connexion);

      return $liste;
  }



/**
 * renvoie les cotes finales (de délibé) obtenues pour l'ensemble des cours pour l'année scolaire en cours
 * et pour les élèves sélectionnés
 *
 * @param array : liste des élèves par matricule
 *
 * @return array
 */
function resultatsTousCours($listeEleves, $periode) {
    if (is_array($listeEleves)) {
        $listeElevesString = implode(',', array_keys($listeEleves));
    } else {
        $listeElevesString = $listeEleves;
    }
    $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
    $sql = 'SELECT matricule, coursGrp, sitDelibe, libelle ';
    $sql .= 'FROM '.PFX.'bullSituations AS dbs ';
    $sql .= "LEFT JOIN ".PFX."cours AS dc ON dc.cours = substr(coursGrp, 1, LOCATE('-', coursGrp)-1) ";
    $sql .= "WHERE bulletin=$periode ";
    $sql .= "AND matricule IN ($listeElevesString) ";
    $sql .= 'ORDER BY matricule, nbHeures DESC, libelle ';

    $liste = array();
    $resultat = $connexion->query($sql);
    if ($resultat) {
        $resultat->setFetchMode(PDO::FETCH_ASSOC);
        while ($ligne = $resultat->fetch()) {
            $matricule = $ligne['matricule'];
            $coursGrp = $ligne['coursGrp'];
            $liste[$matricule][$coursGrp] = $ligne;
        }
    }

    Application::deconnexionPDO($connexion);

    return $liste;
}

/**
 * renvoie les cotes obtenues pour l'ensemble des cours durant l'année scolaire indiquée pour les élèves sélectionnés
 * les informations proviendront du dernier bulletin de l'année scolaire de cette année écoulée
 *
 * @param  int $matricule     identifiant de l'élève
 * @param  string  $anneeScolaire année scolaire concernée sous la forme YYYY-YYYY
 *
 * @return array
 */

function infoAnneePrecedente ($listeEleves, $anneeScolaire, $NBPERIODES) {
    if (is_array($listeEleves)) {
        $listeElevesString = implode(',', array_keys($listeEleves));
    } else {
        $listeElevesString = $listeEleves;
    }
    $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
    $sql = 'SELECT annee, matricule, coursGrp, sitDelibe, cours, libelle ';
    $sql .= 'FROM '.PFX.'bullSitArchives AS arch ';
    $sql .= 'JOIN '.PFX."cours AS dc ON dc.cours = substr(arch.coursGrp, 1, LOCATE('-', arch.coursGrp)-1) ";
    $sql .= 'JOIN '.PFX.'statutCours AS dsc ON dsc.cadre = dc.cadre ';
    $sql .= "WHERE annee LIKE :anneeScolaire AND matricule IN ($listeElevesString) AND bulletin =:periode ";
    $sql .= 'ORDER BY rang, nbheures DESC, libelle ';
    $requete = $connexion->prepare($sql);

    // $requete->bindParam(':matricule', $matricule, PDO::PARAM_INT);
    $requete->bindParam(':anneeScolaire', $anneeScolaire, PDO::PARAM_STR, 9);
    $requete->bindParam(':periode', $NBPERIODES, PDO::PARAM_INT);
    $resultat = $requete->execute();
    $liste = array();
    if ($resultat) {
        $requete->setFetchMode(PDO::FETCH_ASSOC);
        while ($ligne = $requete->fetch()) {
            $matricule = $ligne['matricule'];
            $coursGrp = $ligne['coursGrp'];
            $liste[$matricule][$coursGrp] = $ligne;
        }
    }

    Application::deconnexionPDO($connexion);

    return $liste;
}

/**
 * retourne les classes dont le prof est titulaire et qui sont des "fins de degré"
 *
 * @param array $listeClasses : liste des classes dont le prof est titulaire
 * @param array $anneesDegre : liste des années d'étude de fin de degré (typiquement 2, 4, 6)
 *
 * @return array
 */
 function listeClassesFinDegre ($listeClasses, $anneesDegre) {
     $listeClassesDegre = array();
     foreach ($listeClasses as $uneClasse) {
         $annee = substr($uneClasse, 0, 1);
         if (in_array($annee, $anneesDegre)){
             $listeClassesDegre[$uneClasse] = $uneClasse;
         }
     }

     return $listeClassesDegre;
 }

// /**
//  * "calcule" l'expression de l'année scolaire précédente à partir de l'année scolaire en cours
//  * donnée sous la forme YYYY-YYYY
//  *
//  * @param  string $anneeEnCours
//  *
//  * @return string
//  */
// function anneePrecedente($anneeEnCours) {
//     $split = explode('-', $anneeEnCours);
//     if (is_numeric($split[0]) && is_numeric($split[1]))
//         {
//         $split0 = $split[0]-1;
//         $split1 = $split[1]-1;
//
//         return sprintf('%s-%s', $split0, $split1);
//         }
//      else return Null;
// }
//

/**
 * recherche dans la base de données en quelle année scolaire (du type "2016-2017") l'élève dont on fournit le matricule
 * se trouvait dans l'année d'étude donnée
 *
 * @param int : $matricule
 * @param int : $anneeEtude
 *
 * @return string l'année scolaire pour cette année d'étude ou Null si pas d'informations dans la BD
 */
function anneePrecedente($matricule, $anneeEtude) {
    $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
    $sql = 'SELECT annee ';
    $sql .= 'FROM '.PFX.'bullSitArchives ';
    $sql .= 'WHERE matricule =:matricule AND SUBSTR(coursGrp, 1, 1) =:anneeEtude ';
    $sql .= 'LIMIT 1 '
}

/**
 * recherche le numéro de la dernière période de l'année scolaire passée en paramètre
 *
 * @param string $anneeScolaire
 *
 * @return int
 */
function nbPeriodesAnnee($anneeScolaire) {
    $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
    $sql = 'SELECT MAX(bulletin) AS nb ';
    $sql .= 'FROM '.PFX.'bullSitArchives ';
    $sql .= 'WHERE annee LIKE :anneeScolaire ';
    $requete = $connexion->prepare($sql);

    $requete->bindParam(':anneeScolaire', $anneeScolaire, PDO::PARAM_STR, 9);
    $resultat = $requete->execute();
    $nb = 0;
    if ($resultat) {
        $requete->setFetchMode(PDO::FETCH_ASSOC);
        $ligne = $requete->fetch();
        $nb = $ligne['nb'];
    }
    Application::deconnexionPDO($connexion);

    return $nb;
}

// fonction à replace aussi vite que possible, avec la modification, dans la class Bulletin
//
function getResultatsExternes($classe, $anneeScolaire)
{
    $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
    $sql = 'SELECT DISTINCT classe, coursGrp, libelle, nbheures, ext.matricule, coteExterne, nom, prenom ';
    $sql .= 'FROM '.PFX.'bullEprExterne AS ext ';
    $sql .= 'JOIN '.PFX.'eleves AS de ON de.matricule = ext.matricule ';
    $sql .= 'JOIN '.PFX."cours AS cours ON cours.cours = SUBSTR(coursGrp,1, LOCATE('-', coursGrp)-1) ";
    $sql .= "WHERE anscol = '$anneeScolaire' ";
    $sql .= 'AND de.matricule IN (SELECT matricule FROM '.PFX."eleves WHERE groupe = '$classe') ";
    $sql .= 'ORDER BY nom, prenom, libelle ';
    $resultat = $connexion->query($sql);
    $liste = array();
    if ($resultat) {
        $resultat->setFetchMode(PDO::FETCH_ASSOC);
        while ($ligne = $resultat->fetch()) {
            $matricule = $ligne['matricule'];
            $coursGrp = $ligne['coursGrp'];
            $liste[$matricule][$coursGrp] = $ligne;
        }
    }

    Application::DeconnexionPDO($connexion);

    return $liste;
}
