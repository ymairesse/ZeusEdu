
    /**
     * renvoie la liste de toutes les UAA existantes
     *
     * @param void
     *
     * @return array
     */
    public function getListeUAA(){
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT idUAA, libelle ';
        $sql .= 'FROM '.PFX.'bullUAA ';
        $sql .= 'ORDER BY libelle ';
        $requete = $connexion->prepare($sql);

        $liste = array();
        $resultat = $requete->execute();
        if ($resultat){
            $requete->setFetchMode(PDO::FETCH_ASSOC);
            while ($ligne = $requete->fetch()){
                $idUAA = $ligne['idUAA'];
                $liste[$idUAA] = $ligne['libelle'];
            }
        }

        Application::deconnexionPDO($connexion);

        return $liste;
    }

    /**
     * modifie le texte d'une UAA dont on fournit le $idUAA
     *
     * @param int $idUAA
     * @param string $libelle
     *
     * @return int : nombre d'enregistrement 0 | 1
     */
    public function saveUAAtext($idUAA, $libelle){
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'UPDATE IGNORE '.PFX.'bullUAA ';
        $sql .= 'SET libelle = :libelle ';
        $sql .= 'WHERE idUAA = :idUAA ';
        $requete = $connexion->prepare($sql);

        $requete->bindParam(':libelle', $libelle, PDO::PARAM_STR, 100);
        $requete->bindParam(':idUAA', $idUAA, PDO::PARAM_INT);

        $resultat = $requete->execute();

        $nb = $requete->rowCount();

        Application::deconnexionPDO($connexion);

        return $nb;
    }

    /**
     * enregistre une nouvelle UAA dont on fournit le $libelle
     *
     * @param string $libelle
     *
     * @return int
     */
    public function saveUAA($libelle){
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'INSERT IGNORE INTO '.PFX.'bullUAA ';
        $sql .= 'SET libelle = :libelle ';
        $requete = $connexion->prepare($sql);

        $requete->bindParam(':libelle', $libelle, PDO::PARAM_STR, 100);

        $resultat = $requete->execute();

        $idUAA = $connexion->lastInsertId();

        Application::deconnexionPDO($connexion);

        return $idUAA;
    }

    /**
     * retrouve le libelle d'une UAA depuis son idUAA
     *
     * @param int $idUAA
     *
     * @return string
     */
    public function getUAAformId($idUAA){
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT idUAA, libelle ';
        $sql .= 'FROM '.PFX.'bullUAA ';
        $sql .= 'WHERE idUAA = :idUAA ';
        $requete = $connexion->prepare($sql);

        $requete->bindParam(':idUAA', $idUAA, PDO::PARAM_INT);

        $texte = Null;
        $resultat = $requete->execute();
        if ($resultat){
            $ligne = $requete->fetch();
            $texte = $ligne['libelle'];
        }

        Application::deconnexionPDO($connexion);

        return $texte;
    }

    /**
     * vérifie si une UAA est déjà liée à des cours
     *
     * @param int $idUAA
     *
     * @return bool
     */
    public function isUsedUAA($idUAA){
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT idUAA, idGrappe ';
        $sql .= 'FROM '.PFX.'bullUAAlink ';
        $sql .= 'WHERE idUAA = :idUAA ';
        $requete = $connexion->prepare($sql);

        $requete->bindParam(':idUAA', $idUAA, PDO::PARAM_INT);

        $resultat = $requete->execute();
        $id = Null;
        if ($resulat){
            $ligne = $requete->fetch();
            $id = $ligne['idUAA'];
        }

        Application::deconnexionPDO($connexion);

        return $id != Null;
    }

    /**
     * Suppression d'une liste d'UAA par leur $idUAA
     *
     * @param array $listeUAA
     *
     * @return int : nombre de suppressions
     */
    public function delUAAlist($listeUAA){
        $listeUAAstring = implode(',', $listeUAA);
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql =' DELETE FROM '.PFX.'bullUAA ';
        $sql .= 'WHERE idUAA IN ('.$listeUAAstring.') ';
        $requete = $connexion->prepare($sql);

        $resultat = $requete->execute();

        $nb = $requete->rowCount();

        Application::deconnexionPDO($connexion);

        return $nb;
    }

    /**
     * recherche la liste de toutes les grappes de cours
     *
     * @param void
     *
     * @return array
     */
    public function getListeGrappes(){
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT COUNT(cours) AS nbCours, gr.idGrappe, grappe ';
        $sql .= 'FROM '.PFX.'bullUAAGrappes AS gr ';
        $sql .= 'LEFT JOIN '.PFX.'bullUAAGrappeCours AS gc ON gc.idGrappe = gr.idGrappe ';
        $sql .= 'GROUP BY grappe ';
        $sql .= 'ORDER BY grappe ';
        $requete = $connexion->prepare($sql);

        $liste = array();

        $resultat = $requete->execute();
        if ($resultat) {
            $requete->setFetchMode(PDO::FETCH_ASSOC);
            while ($ligne = $requete->fetch()){
                $idGrappe = $ligne['idGrappe'];
                $liste[$idGrappe] = $ligne;
            }
        }

        Application::deconnexionPDO($connexion);

        return $liste;
    }

    /**
     * recherche les infos à propos de la grappe $idGrappe
     * 
     * @param int $idGrappe
     * 
     * @return array
     */
    public function getInfoGrappe($idGrappe){
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT grappes.idGrappe, grappe, idUAA, gc.cours, libelle, nbheures, statut ';
        $sql .= 'FROM '.PFX.'bullUAAGrappes AS grappes ';
        $sql .= 'LEFT JOIN '.PFX.'bullUAAGrappeCours AS gc ON gc.idGrappe = grappes.idGrappe ';
        $sql .= 'LEFT JOIN '.PFX.'bullUAAlink AS link ON link.idGrappe = grappes.idGrappe ';
        $sql .= 'LEFT JOIN '.PFX.'cours AS cours ON cours.cours = gc.cours ';
        $sql .= 'LEFT JOIN '.PFX.'statutCours AS sc ON sc.cadre = cours.cadre ';
        $sql .= 'WHERE grappes.idGrappe = :idGrappe ';
        $requete = $connexion->prepare($sql);

        $requete->bindParam(':idGrappe', $idGrappe, PDO::PARAM_INT);

        $liste = array();
        $resultat = $requete->execute();
        if ($resultat){
            $requete->setFetchMode(PDO::FETCH_ASSOC);
            $liste['cours'] = array();
            while ($ligne = $requete->fetch()){
                $liste['idGrappe'] = $ligne['idGrappe'];
                $liste['grappe'] = $ligne['grappe'];
                $idUAA = $ligne['idUAA'];
                $liste['idUAA'] = $idUAA;
                $liste['cours'][] = array(
                    'cours' => $ligne['cours'], 
                    'libelle' => $ligne['libelle'],
                    'nbheures' => $ligne['nbheures'],
                    'statut' => $ligne['statut']);
                }
        }

        Application::deconnexionPDO($connexion);

        return $liste;
    }

     /**
      * enregistre le cours $cours dans la grappe $idGrappe
      * s'il n'y est pas déjà
      * 
      * @param string $cours
      * @param int $idGrappe
      * 
      * @return int : nombre d'enregistrements
      */
     public function saveCours2grappe($cours, $idGrappe){
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'INSERT IGNORE INTO '.PFX.'bullUAAGrappeCours ';
        $sql .= 'SET cours = :cours, idGrappe = :idGrappe ';
        $requete = $connexion->prepare($sql);

        $requete->bindParam(':idGrappe', $idGrappe, PDO::PARAM_INT);
        $requete->bindParam(':cours', $cours, PDO::PARAM_STR, 20);

        $resultat = $requete->execute();

        $nb = $requete->rowCount();

        Application::deconnexionPDO($connexion);

        return $nb;
     }

     /**
      * supprime un $cours de la grappe $idGrappe
      * 
      * @param int $idGrappe
      * @param string $cours
      * 
      * @return int
      */
     public function delCoursGrappe($idGrappe, $cours){
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'DELETE FROM '.PFX.'bullUAAGrappeCours ';
        $sql .= 'WHERE idGrappe = :idGrappe AND cours = :cours ';
        $requete = $connexion->prepare($sql);

        $requete->bindParam(':idGrappe', $idGrappe, PDO::PARAM_INT);
        $requete->bindParam(':cours', $cours, PDO::PARAM_STR, 20);

        $resultat = $requete->execute();

        $nb = $requete->rowCount();

        Application::deconnexionPDO($connexion);

        return $nb;
     }

     /**
      * enregistre le nom de la nouvelle $newGrappe de cours
      * 
      * @param string $newGrappe
      * 
      * @return int
      */
     public function saveNewGrappe($newGrappe){
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'INSERT IGNORE INTO '.PFX.'bullUAAGrappes ';
        $sql .= 'SET grappe = :newGrappe ';
        $requete = $connexion->prepare($sql);

        $requete->bindParam(':newGrappe', $newGrappe, PDO::PARAM_STR, 20);

        $resultat = $requete->execute();

        $nb = $requete->rowCount();

        Application::deconnexionPDO($connexion);

        return $nb;
     }

     /**
      * modifier le nom $libelle d'une grappe de cours $idGrappe
      * 
      * @param string $libelle
      * @param int $idGrappe
      * 
      * @return int : nombre d'enregistrements
      */
     public function renameGrappe($idGrappe, $libelle){
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'UPDATE IGNORE '.PFX.'bullUAAGrappes ';
        $sql .= 'SET grappe = :libelle ';
        $sql .= 'WHERE idGrappe = :idGrappe ';
        $requete = $connexion->prepare($sql);

        $requete->bindParam(':libelle', $libelle, PDO::PARAM_STR, 20);
        $requete->bindParam(':idGrappe', $idGrappe, PDO::PARAM_INT);

        $resultat = $requete->execute();

        $nb = $requete->rowCount();

        Application::deconnexionPDO($connexion);

        return $nb;  
     }