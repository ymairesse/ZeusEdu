<?php

/**
 * class EleveAdes.
 */
class EleveAdes
{

    public function __construct() {
        }

    /**
     * renvoie la liste structurée des faits disciplinaires d'un élève donné.
     *
     * @param int : $matricule
     * @param string : année scolaire (sous la forme "2017-2018")
     *
     * @return array
     */
    public function getListeFaits($matricule, $anneeScolaire=Null)
    {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT af.*, nom, prenom, sexe ';
        $sql .= 'FROM '.PFX.'adesFaits AS af ';
        $sql .= 'JOIN '.PFX.'adesTypesFaits AS atf ON (af.type = atf.type) ';
        $sql .= 'LEFT JOIN '.PFX.'profs AS ap ON (ap.acronyme = af.professeur) ';
        $sql .= 'WHERE matricule = :matricule ';
        if ($anneeScolaire != Null)
            $sql .= 'AND anneeScolaire = :anneeScolaire ';
        $sql .= 'ORDER BY anneeScolaire DESC, atf.ordre, ladate, idFait ';
        $requete = $connexion->prepare($sql);

        $requete->bindParam(':matricule', $matricule, PDO::PARAM_INT);
        if ($anneeScolaire != Null)
            $requete->bindParam(':anneeScolaire', $anneeScolaire, PDO::PARAM_INT);

        $resultat = $requete->execute();
        $listeFaits = ($anneeScolaire == Null) ? array(ANNEESCOLAIRE => null) : array();
        if ($resultat) {
            $requete->setFetchMode(PDO::FETCH_ASSOC);
            while ($ligne = $requete->fetch()) {

                $anneeScolaire = $ligne['anneeScolaire'];
                $idfait = $ligne['idfait'];
                $type = $ligne['type'];
                $ligne['ladate'] = Application::datePHP($ligne['ladate']);
                if ($ligne['nom'] != Null) {
                    $ligne['professeur'] = $ligne['sexe']=='F' ? 'Mme' : 'M.';
                    $ligne['professeur'] .= sprintf(' %s. %s', substr($ligne['prenom'], 0, 1), $ligne['nom']);
                    }
                    // else $ligne['professeur'] = $ligne['acronyme'];
                $listeFaits[$anneeScolaire][$type][$idfait] = $ligne;
            }
        }
        Application::deconnexionPDO($connexion);

        return $listeFaits;
    }

    /**
     * renvoie la liste des idRetenues pour l'élève dont on fournit le matricule.
     *
     * @param int $matricule
     *
     * @return array
     */
    public function getListeRetenuesEleve($matricule)
    {
        // recherche de toutes les retenues dans la table des faits disciplinaires
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT idretenue ';
        $sql .= 'FROM '.PFX.'adesFaits ';
        $sql .= "WHERE matricule = '$matricule' AND idretenue != '' ";
        $sql .= 'ORDER BY ladate ';
        $resultat = $connexion->query($sql);
        $listeRetenues = array();
        if ($resultat) {
            $resultat->setFetchMode(PDO::FETCH_ASSOC);
            while ($ligne = $resultat->fetch()) {
                $idretenue = $ligne['idretenue'];
                $listeRetenues[] = $idretenue;
            }
        }

        // recherche des détails pratiques concernant ces retenues dans la table des retenues
        $listeRetenuesString = implode(',', $listeRetenues);
        $sql = 'SELECT type, idretenue, dateRetenue, heure, duree, local ';
        $sql .= 'FROM '.PFX.'adesRetenues ';
        $sql .= "WHERE idRetenue IN ($listeRetenuesString) ";
        $sql .= 'ORDER BY type, dateRetenue, heure ';

        $resultat = $connexion->query($sql);
        $listeRetenues = array();
        if ($resultat) {
            $resultat->setFetchMode(PDO::FETCH_ASSOC);
            while ($ligne = $resultat->fetch()) {
                $idretenue = $ligne['idretenue'];
                $ligne['dateRetenue'] = Application::datePHP($ligne['dateRetenue']);
                $listeRetenues[$idretenue] = $ligne;
            }
        }
        Application::DeconnexionPDO($connexion);

        return $listeRetenues;
    }

    /**
     * lecture d'un seul fait disciplinaire en vue d'édition.
     *
     * @param $idfait integer
     *
     * @return array
     */
    public function lireUnFait($idfait)
    {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT idfait, anneeScolaire, matricule, type, ladate, motif, professeur, idretenue, travail, materiel, sanction, nopv, qui ';
        $sql .= 'FROM '.PFX.'adesFaits ';
        $sql .= "WHERE idfait = '$idfait' ";

        $resultat = $connexion->query($sql);
        $liste = array();
        if ($resultat) {
            $resultat->setFetchMode(PDO::FETCH_ASSOC);
            $liste = $resultat->fetch();
            $liste['ladate'] = Application::datePHP($liste['ladate']);
        }
        Application::DeconnexionPDO($connexion);

        return $liste;
    }

    /**
     * création d'un nouveau fait vide.
     *
     * @param array $prototype : prototype du fait provenant de la class Ades
     *
     * @return $faitVide : structure du fait avec les noms des champs, mais vide
     */
    public function faitVide($prototype, $type, $acronyme)
    {
        $lesChamps = $prototype['champs'];
        $structure = array();
        foreach ($lesChamps as $champ => $data) {
            if (in_array('formulaire', explode(',', $data['contextes']))) {
                // quatre champs peuvent contenir des données par défaut
                if (!in_array($champ, array('ladate', 'qui', 'type', 'anneeScolaire'))) {
                    $structure[$champ] = '';
                } else {
                    switch ($champ) {
                        case 'ladate':
                            // la date du jour
                            $structure[$champ] = date('d/m/Y');
                            break;
                        case 'qui':
                            // le nom de l'utilisateur
                            $structure[$champ] = $acronyme;
                            break;
                        case 'type':
                            // le type de fait disciplinaire
                            $structure[$champ] = $type;
                            break;
                        case 'anneeScolaire':
                            // l'année scolaire en cours
                            $structure[$champ] = ANNEESCOLAIRE;
                            break;
                    }
                }
            }
        }

        return $structure;
    }

    /**
     * Enregistrement d'un fait disciplinaire nouveau ou édité.
     *
     * @param array $post : données provenant d'un formulaire
     * @param $prototype : description de ce type de fait disciplinaire (rubriques)
     *
     * @return int : nombre de fiches enregistrées (normalement, une seule)
     */
    public function enregistrerFaitDisc($post, $prototype, $retenue, $acronyme)
    {
        if ($prototype['structure']['typeRetenue'] != 0) {
            // c'est une retenue

            // dans le cas d'une édition, $oldIdretenue retient l'ancien $id de la retenue en cours d'édition (changement de date éventuel)
            $oldIdretenue = isset($post['oldIdretenue']) ? $post['oldIdretenue'] : null;
            $idretenue = isset($post['idretenue']) ? $post['idretenue'] : null;
            if ($idretenue == null) {
                die('retenue manquante');
            }
            // Est-ce une nouvelle retenue et non une édition
            if ($oldIdretenue == null) {
                // c'est une nouvelle retenue et il faut la comptabiliser
                $this->occupePlaceRetenue($idretenue);
            } else {
                // c'est une édition; il faut libérer la place dans l'ancienne retenue et prendre une place dans la nouvelle
                $this->liberePlaceRetenue($oldIdretenue);
                $this->occupePlaceRetenue($idretenue);
            }
        }  // fin du traitment de la retenue
        // pour le fait de ce prototype, trouver la liste des champs à considérer
        $listeChamps = $prototype['structure']['listeChamps'];
        $idfait = null;
        $listeSQL = array();
        // on passe tous les champs du $post en revue et on retient ceux qui sont pertinents
        foreach ($post as $unChamp => $value) {
            // ce champ est-il à enregistrer?
            if (in_array($unChamp, $listeChamps)) {
                $value = addslashes(htmlspecialchars($value));
                // si c'est une date, modifier le format en MySQL
                if ($unChamp == 'ladate') {
                    $value = Application::dateMySQL($value);
                }
                if ($unChamp == 'qui') {
                    $value = $acronyme;
                }
                // si c'est $idfait (clef primaire) et qu'il est connu, le retenir mais ne pas l'insérer dans les champs à enregistrer
                if (($unChamp == 'idfait')) {
                    $idfait = $value;
                } else {
                    $listeSQL[] = "$unChamp='".$value."'";
                }
            }
        }
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $listeSQL = implode(',', $listeSQL);
        if ($idfait != '') {
            $sql = 'UPDATE '.PFX.'adesFaits ';
            $sql .= 'SET '.$listeSQL.' ';
            $sql .= "WHERE idfait = '$idfait' ";
        } else {
            $sql = 'INSERT INTO '.PFX.'adesFaits ';
            $sql .= 'SET '.$listeSQL.' ';
        }

        $resultat = $connexion->exec($sql);
        Application::DeconnexionPDO($connexion);

        return $resultat;
    }

    /**
     * recherche les caractéristiques d'un fait disciplinaire dont on fournit le $idfait.
     *
     * @param $idfait
     *
     * @return array
     */
    public function infosFait($idfait)
    {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT '.PFX.'adesFaits.type, matricule, ladate, motif, professeur, idretenue, travail, materiel, ';
        $sql .= 'sanction, nopv, qui, typeRetenue, titreFait ';
        $sql .= 'FROM '.PFX.'adesFaits ';
        $sql .= 'JOIN '.PFX.'adesTypesFaits	ON ('.PFX.'adesTypesFaits.type = '.PFX.'adesFaits.type) ';
        $sql .= 'WHERE idfait =:idfait ';

        $requete = $connexion->prepare($sql);
        $requete->bindParam(':idfait', $idfait, PDO::PARAM_INT);

        $resultat = $requete->execute();
        $infoFaits = array();
        if ($resultat) {
            $requete->setFetchMode(PDO::FETCH_ASSOC);
            $infosFait = $requete->fetchAll();
        }
        Application::DeconnexionPDO($connexion);

        return $infosFait[0];
    }

    /**
     * Suppression d'un fait de la fiche disciplinaire.
     *
     * @param int $idfait : $id du fait disciplinaire
     *
     * @return int : nombre de suppressions dans la base de données (normalement une seule)
     */
    public function supprFait($idfait)
    {
        $fait = $this->lireUnFait($idfait);
        if (isset($fait['idretenue']) && ($fait['idretenue'] > 0)) {
            $this->liberePlaceRetenue($fait['idretenue']);
        }
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'DELETE FROM '.PFX.'adesFaits ';
        $sql .= 'WHERE idfait =:idfait ';
        $requete = $connexion->prepare($sql);

        $requete->bindParam(':idfait', $idfait, PDO::PARAM_INT);
        $resultat = $requete->execute();

        Application::DeconnexionPDO($connexion);

        return $resultat;
    }

    /**
     * incrémentation du nombre d'inscriptions à une retenue.
     *
     * @param int $idretenue
     * @return boolean: true si tout s'est bien passé
     */
    public function occupePlaceRetenue($idretenue)
    {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'UPDATE '.PFX.'adesRetenues ';
        $sql .= 'SET occupation = occupation+1 ';
        $sql .= 'WHERE idretenue =:idretenue ';
        $requete = $connexion->prepare($sql);

        $requete->bindParam(':idretenue', $idretenue, PDO::PARAM_INT);
        $resultat = $requete->execute();
        Application::DeconnexionPDO($connexion);
        if ($resultat) {
            return true;
        }
    }

    /**
     * décrémentation du nombre d'inscriptions à une retenue.
     *
     * @param int $idretenue
     * @return boolean: true si tout s'est bien passé
     */
    public function liberePlaceRetenue($idretenue)
    {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'UPDATE '.PFX.'adesRetenues ';
        $sql .= 'SET occupation = occupation-1 ';
        $sql .= 'WHERE idretenue =:idretenue ';
        $requete = $connexion->prepare($sql);

        $requete->bindParam(':idretenue', $idretenue, PDO::PARAM_INT);
        $resultat = $requete->execute();
        Application::DeconnexionPDO($connexion);
        if ($resultat) {
            return true;
        }
    }

    /**
     * renvoie le nombre de faits disciplinaires pour un élèves donné durant l'année scolaire donnée.
     *
     * @param $matricules
     * @param $anneeScolaire
     *
     * @return interger
     */
    public function nbFaits($matricule, $anneeScolaire)
    {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT count(*) AS nb ';
        $sql .= 'FROM '.PFX.'adesFaits ';
        $sql .= "WHERE matricule = '$matricule' AND anneeScolaire = '$anneeScolaire' ";

        $resultat = $connexion->query($sql);
        $nb = 0;
        if ($resultat) {
            $ligne = $resultat->fetch();
            $nb = $ligne['nb'];
        }
        Application::DeconnexionPDO($connexion);

        return $nb;
    }

}
