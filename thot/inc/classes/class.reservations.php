<?php

/**
 *
 */
class Reservation
{

    function __construct()
    {
        // code...
    }

    /**
     * liste de toutes les pièces de matériel ou locaux disponibles
     * tri par type de matériel
     *
     * @param void
     *
     * @return array
     */
    public function getRessourceByType($idType) {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT types.idType, type, reservations.idType, reservations.description, reservations.reference, reservations.idRessource, ';
        $sql .= 'reservations.localisation, reservations.etat, reservations.hasCaution, reservations.caution ';
        $sql .= 'FROM '.PFX.'reservationsTypes AS types ';
        $sql .= 'JOIN '.PFX.'reservations AS reservations ON reservations.idType = types.idType ';
        $sql .= 'WHERE types.idType = :idType ';
        $sql .= 'ORDER BY description ';
        $requete = $connexion->prepare($sql);

        $requete->bindParam(':idType', $idType, PDO::PARAM_STR, 7);

        $resultat = $requete->execute();

        $liste = array();
        if ($resultat) {
            $requete->setFetchMode(PDO::FETCH_ASSOC);
            while ($ligne = $requete->fetch()){
                $id = $ligne['idRessource'];
                $liste[$id] = $ligne;

            }
        }

        Application::DeconnexionPDO($connexion);

        return $liste;
    }

    /**
     * Recherche la liste de tous les types de ressources disponibles
     *
     * @param void
     *
     * @return array
     */
    public function getTypesRessources(){
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT idType, type ';
        $sql .= 'FROM '.PFX.'reservationsTypes ';
        $requete = $connexion->prepare($sql);

        $liste = array();
        $resultat = $requete->execute();
        if ($resultat){
            $requete->setFetchMode(PDO::FETCH_ASSOC);
            while ($ligne = $requete->fetch()){
                $id = $ligne['idType'];
                $liste[$id] = $ligne['type'];
            }
        }

        Application::DeconnexionPDO($connexion);

        return $liste;
    }

    /**
     * Ajouter le type de ressources $type
     *
     * @param string $type
     *
     * @return int
     */
    public function addTypeRessource($type){
        // limiter le nombre de caractères
        $type = SUBSTR($type, 0, 30);
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT idType, type ';
        $sql .= 'FROM '.PFX.'reservationsTypes ';
        $sql .= 'WHERE type = :type ';
        $requete = $connexion->prepare($sql);

        $requete->bindParam(':type', $type, PDO::PARAM_STR, 30);

        $existe = 0;
        $resultat = $requete->execute();
        if ($resultat){
            $ligne = $requete->fetch();
            if ($ligne != Null)
                $existe = 1;
        }
        if ($existe == 0) {
            $sql = 'INSERT INTO '.PFX.'reservationsTypes ';
            $sql .= 'SET type = :type ';
            $requete = $connexion->prepare($sql);

            $requete->bindParam(':type', $type, PDO::PARAM_STR, 30);
            $resultat = $requete->execute();

            $id = $idCategorie = $connexion->lastInsertId();
        }

        Application::DeconnexionPDO($connexion);

        if (($existe == 0) || ($id != 0))
            return $id;
            else return 0;
    }

    /**
     * supprimer un type de ressource vide
     *
     * @param int $idType
     *
     * @return int
     */
    public function delTypeRessource($idType){
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'DELETE FROM '.PFX.'reservationsTypes  ';
        $sql .= 'WHERE idType = :idType ';
        $requete = $connexion->prepare($sql);

        $requete->bindParam(':idType', $idType, PDO::PARAM_INT);

        $resultat = $requete->execute();
        $n = $requete->rowCount();

        Application::DeconnexionPDO($connexion);

        return $n;
    }

    /**
     * suppression d'une ressource existante
     *
     * @param int $idRessource
     *
     * @return int
     */
    public function delRessource($idRessource){
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'DELETE FROM '.PFX.'reservations  ';
        $sql .= 'WHERE idRessource = :idRessource ';
        $requete = $connexion->prepare($sql);

        $requete->bindParam(':idRessource', $idRessource, PDO::PARAM_INT);

        $resultat = $requete->execute();
        $n = $requete->rowCount();

        Application::DeconnexionPDO($connexion);

        return $n;
    }

    /**
     * recherche la ressource $idRessource du type $idType
     *
     * @param int $idRessource
     * @param int $idType
     *
     * @return array
     */
    public function getRessource($idType, $idRessource){
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT idRessource, description, reference, idType, localisation, etat, ';
        $sql .= 'hasCaution, caution ';
        $sql .= 'FROM '.PFX.'reservations ';
        $sql .= 'WHERE idRessource = :idRessource AND idType = :idType ';
        $requete = $connexion->prepare($sql);

        $requete->bindParam(':idRessource', $idRessource, PDO::PARAM_INT);
        $requete->bindParam(':idType', $idType, PDO::PARAM_INT);

        $ligne = array();
        $resultat = $requete->execute();
        if ($resultat){
            $requete->setFetchMode(PDO::FETCH_ASSOC);
            $ligne = $requete->fetch();
        }

        Application::DeconnexionPDO($connexion);

        return $ligne;
    }

    /**
     * Vérifier si un référence existe déjà pour une ressource de type $idType
     *
     * @param int $idType
     * @param string $reference
     *
     * @return bool
     */
    public function referenceExiste($idType, $reference){
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT reference, idType ';
        $sql .= 'FROM '.PFX.'reservations ';
        $sql .= 'WHERE idType = :idType AND UPPER(reference) = :reference ';
        $requete = $connexion->prepare($sql);

        $reference = strtoupper($reference);
        $requete->bindParam(':reference', $reference, PDO::PARAM_STR, 32);
        $requete->bindParam(':idType', $idType, PDO::PARAM_INT);

        $resultat = $requete->execute();
        if ($resultat){
            $ligne = $requete->fetch();
        }

        Application::DeconnexionPDO($connexion);

        return $ligne != Null;
    }

    /**
     * enregistrer une ressource
     *
     * @param array $post : le formulaire qui va bien
     *
     * @return int
     */
    public function saveRessource($post){
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'INSERT INTO didac_reservations  ';
        $sql .= 'SET idRessource = :idRessource, description = :description, reference = :reference, idType = :idType, ';
        $sql .= 'localisation = :localisation, etat = :etat, hasCaution = :hasCaution, caution = :caution ';
        $sql .= 'ON DUPLICATE KEY UPDATE ';
        $sql .= 'description = :description, localisation = :localisation, etat = :etat, hasCaution = :hasCaution, caution = :caution ';
        $requete = $connexion->prepare($sql);

        $idRessource = isset($post['idRessource']) ? $post['idRessource'] : Null;
        $description = isset($post['description']) ? $post['description'] : Null;
        $reference = isset($post['reference']) ? $post['reference'] : Null;
        $idType = isset($post['idType']) ? $post['idType'] : Null;
        $localisation = isset($post['localisation']) ? $post['localisation'] : Null;
        $etat = isset($post['etat']) ? $post['etat'] : Null;
        $hasCaution = isset($post['hasCaution']) ? $post['hasCaution'] : 0;
        $caution = isset($post['caution']) ? $post['caution'] : Null;

        $requete->bindParam(':idRessource', $idRessource, PDO::PARAM_INT);
        $requete->bindParam(':description', $description, PDO::PARAM_STR, 32);
        $requete->bindParam(':reference', $reference, PDO::PARAM_STR, 32);
        $requete->bindParam(':idType', $idType, PDO::PARAM_INT);
        $requete->bindParam(':localisation', $localisation, PDO::PARAM_STR, 32);
        $requete->bindParam(':etat', $etat, PDO::PARAM_STR);
        $requete->bindParam(':hasCaution', $hasCaution, PDO::PARAM_INT);
        $requete->bindParam(':caution', $caution, PDO::PARAM_INT);

        $resultat = $requete->execute();

        $rowCount = $requete->rowCount();

        if ($rowCount == 1) { // une seule ligne a été ajoutée -> pas un UPDATE
            $idRessource = $connexion->lastInsertId();
        }

        Application::DeconnexionPDO($connexion);

        return $idRessource;
    }

    /**
     * recherche les ressources d'une liste données qui sont libres entre deux dates données
     *
     * @param array $idRessourcesList
     * @param string $dateDebut
     * @param string $dateFin
     *
     * @return array
     */
    public function ressourcesLibres4liste ($idRessourcesList, $dateDebut, $dateFin, $libre = true){
        $idRessourcesListString = implode(',', $idRessourcesList);
        // Application::afficher($idRessourcesListString, true);
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT res.idRessource, description ';
        $sql .= 'FROM '.PFX.'reservations AS res ';
        $sql .= 'LEFT JOIN '.PFX.'reservationsUser AS user ON user.idRessource = res.idRessource ';
        if ($libre == true)
            $sql .= 'WHERE user.dateDebut NOT BETWEEN :dateDebut AND :dateFin AND user.dateFin NOT BETWEEN :dateDebut AND :dateFin ';
            else $sql .= 'WHERE dateDebut BETWEEN :dateDebut AND :dateFin ';
        $sql .= 'AND res.idRessource IN ('.$idRessourcesListString.') ';
        $sql .= 'ORDER BY description ';
        $requete = $connexion->prepare($sql);
echo($sql);
        $requete->bindParam(':dateDebut', $dateDebut, PDO::PARAM_STR, 20);
        $requete->bindParam(':dateFin', $dateFin, PDO::PARAM_STR, 20);
Application::afficher(array($dateDebut, $dateFin));
        $liste = array();
        $resultat = $requete->execute();
        if ($resultat){
            $requete->setFetchMode(PDO::FETCH_ASSOC);
            while ($ligne = $requete->fetch()){
                $idRessource = $ligne['idRessource'];
                $liste[$idRessource] = $ligne;
            }
        }

        Application::deconnexionPDO($connexion);

        return $liste;
    }

}
