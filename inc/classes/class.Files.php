<?php

class Files
{
    public function __construct()
    {
        setlocale(LC_ALL, 'fr_FR.utf8');
    }

    /**
     * Effacement complet d'un répertoire et des fichiers/répertoires contenus.
     *
     * @param $dir : le répertoire à effacer
     *
     * @return bool : 1 si OK, 0 si pas OK
     */
    public function delTree($dir)
    {
        $files = glob($dir.'*', GLOB_MARK);
        $resultat = true;
        foreach ($files as $file) {
            if (substr($file, -1) == '/') {
                if ($resultat == true) {
                    $resultat = $this->delTree($file);
                }
            } else {
                $resultat = unlink($file);
            }
        }

        if (is_dir($dir) && ($resultat == true)) {
            $resultat = rmdir($dir);
        }

        return ($resultat == true) ? 1 : 0;
    }

     /**
      * recherche de le fileId existant d'un fichier dont on fournit le nom et le path
      * ou insère les données et retourne le nouveau fileId.
      *
      * findFileId($path, $fileName, $acronyme, false);
      *
      * @param string $fileName : le nom du fichier
      * @param string $path : le path
      * @param string $acronyme : l'abréviation de l'utilisateur actif
      * @param boolean $create : si false, on ne crée pas l'enregistrement en cas d'échec de la recherche
      *
      * @return int
      */
     public function findFileId($path, $fileName, $dirOrFile, $acronyme, $create = false) {

         $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
         // recherche d'un éventuel 'fileId' existant pour le fichier
         $sql = 'SELECT fileId ';
         $sql .= 'FROM '.PFX.'thotFiles ';
         $sql .= 'WHERE path = :path AND fileName = :fileName AND acronyme = :acronyme ';
         $requete = $connexion->prepare($sql);

         $requete->bindParam(':acronyme', $acronyme, PDO::PARAM_STR, 7);
         $requete->bindParam(':path', $path, PDO::PARAM_STR, 255);
         $requete->bindParam(':fileName', $fileName, PDO::PARAM_STR, 255);
         $resultat = $requete->execute();
         $fileId = Null;
         if ($resultat) {
             $ligne = $requete->fetch();
             $fileId = $ligne['fileId'];
         }

         // si on n'a pas trouvé d'enregistrement dans la BD, on crée éventuellement cet enregistrement
         if (($fileId == Null) && ($create == true)) {
             $sql = 'INSERT INTO '.PFX.'thotFiles ';
             $sql .= 'SET acronyme=:acronyme, path=:path, fileName=:fileName, dirOrFile=:dirOrFile ';
             $requete = $connexion->prepare($sql);
             $data = array(':acronyme' => $acronyme, ':path' => $path, ':fileName' => $fileName, ':dirOrFile' => $dirOrFile);
             $resultat = $requete->execute($data);
             $fileId = $connexion->lastInsertId();
         }

         Application::DeconnexionPDO($connexion);

         return $fileId;
     }

     /**
      * retourne la liste des partages d'un fichier dont on fournit le propriétaire, le path et le fileName.
      *
      * @param  string $path
      * @param string $fileName
      * @param string $dirOrFile 'dir' || 'file'
      * @param string $acronyme
      *
      * @return array
      */
     public function getSharesByFileName($path, $fileName, $dirOrFile, $acronyme) {
         $fileId = $this->findFileId($path, $fileName, $dirOrFile, $acronyme, false);  // ne pas créer l'enregistrement
         return $this->getSharesByFileId($fileId);
     }

     /**
      * renvoie la liste des shareIds correspondant au fichiers de la liste linéaire $fileList
      * passée en argument
      *
      * @param array $fileList
      *
      * @return array : la liste linéaire des fileIds
      */
     public function getShareIdsFromFileList($fileList, $acronyme){
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT shareId, files.fileId, path, fileName ';
        $sql .= 'FROM '.PFX.'thotFiles AS files ';
        $sql .= 'JOIN '.PFX.'thotShares AS shares ON files.fileId = shares.fileId ';
        // dans certains cas, le $path dans la BD est suivi d'un "/" mais pas toujours...
        // on vérifie donc les deux possibilités
        $sql .= 'WHERE (CONCAT(path, "/", fileName) = :file OR CONCAT(path, fileName) = :file) ';
        $sql .= 'AND acronyme = :acronyme ';
        $requete = $connexion->prepare($sql);

        $requete->bindParam(':acronyme', $acronyme, PDO::PARAM_STR, 7);

        $shareIdsList = array();
        $ds = DIRECTORY_SEPARATOR;
        foreach ($fileList as $oneFile) {
            if ($oneFile['dirOrFile'] == 'file')
                $file = $oneFile['path'].$ds.$oneFile['fileName'];
                else $file =  $oneFile['path'];
            // suppression d'éventuelles doubles occurences de "/"
            $file = preg_replace('~/+~', '/', $file);
            $requete->bindParam(':file', $file, PDO::PARAM_STR);

            $resultat = $requete->execute();
            if ($resultat) {
                $requete->setFetchMode(PDO::FETCH_ASSOC);
                while ($ligne = $requete->fetch()){
                    $shareId = $ligne['shareId'];
                    $shareIdsList[$shareId] = $ligne;
                }
            }
        }

         Application::DeconnexionPDO($connexion);

         return $shareIdsList;
     }

     /**
      * retourne les détails fileId, shareId, path, filename d'un fichier dont on fournit le nom, le path et l'acronyme du propriétaire
      * renvoie 'null' si pas trouvé.
      *
      * @param $fileName : le nom du fichier
      * @param $path : le path
      * @param $acronyme : l'abréviation de l'utilisateur actif
      *
      * @return int | null
      */
     public function requestFileDetails($path, $fileName, $acronyme)
     {
         $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
         $sql = 'SELECT files.fileId, share.shareId, acronyme, fileName, path ';
         $sql .= 'FROM '.PFX.'thotFiles AS files ';
         $sql .= 'JOIN '.PFX.'thotShares AS share ON share.fileId = files.fileId ';
         $sql .= "WHERE acronyme='$acronyme' AND path='$path' AND fileName='$fileName' ";

         //$requete = $connexion->prepare($sql);
         // $data = array(':acronyme' => $acronyme, ':path' => $path, ':fileName' => $fileName);

         //$resultat = $requete->execute($data);
         $resultat = $connexion->query($sql);
         $liste = array();
         if ($resultat) {
             // $requete->setFetchMode(PDO::FETCH_ASSOC);
             $resultat->setFetchMode(PDO::FETCH_ASSOC);
             //while ($ligne = $requete->fetch()) {
             while ($ligne = $resultat->fetch()) {
                 $liste[] = $ligne;
             }

             return $liste;
         }
     }

    /**
     * retourne la liste des partages d'un fichier dont on founrnit le fileId dans la table des fichiers.
     *
     * @param int $fileId
     *
     * @return array
     */
    public function getSharesByfileId($fileId) {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT type, share.groupe, destinataire, commentaire, fileId, shareId, ';
        $sql .= 'dp.nom AS nomProf, dp.prenom AS prenomProf, de.nom AS nomEleve, de.prenom AS prenomEleve, ';
        $sql .= 'de.groupe AS classe, dc.libelle, pc.nomCours ';
        $sql .= 'FROM '.PFX.'thotShares as share ';
        $sql .= 'LEFT JOIN '.PFX.'profs AS dp ON dp.acronyme = share.destinataire ';
        $sql .= 'LEFT JOIN '.PFX.'eleves AS de ON de.matricule = share.destinataire ';
        $sql .= 'LEFT JOIN '.PFX."cours AS dc ON dc.cours = SUBSTR(share.groupe, 1, LOCATE ('-', share.groupe)-1) ";
        $sql .= 'LEFT JOIN '.PFX.'profsCours AS pc ON pc.coursGrp = share.groupe ';
        $sql .= 'WHERE fileId = :fileId ';
        $sql .= 'ORDER BY type, share.groupe, destinataire ';
        $requete = $connexion->prepare($sql);

        $requete->bindParam(':fileId', $fileId, PDO::PARAM_INT);

        $resultat = $requete->execute();
        $liste = array();
        if ($resultat) {
            $requete->setFetchMode(PDO::FETCH_ASSOC);
            while ($ligne = $requete->fetch()) {
                $fileId = $ligne['fileId'];
                $shareId = $ligne['shareId'];
                $liste[$shareId] = $ligne;
            }
        }
        Application::DeconnexionPDO($connexion);

        return $liste;
    }

    /**
     * renvoie le path, fileName, acronyme du propriétaire et les shareId d'un document dont on fournit le fileId.
     *
     * @param int $fileId
     *
     * @return array
     */
    public function getSharedfileById($fileId) {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT path, fileName, acronyme, shareId ';
        $sql .= 'FROM '.PFX.'thotFiles AS file ';
        $sql .= 'JOIN '.PFX.'thotShares AS share ON share.fileId = file.fileId ';
        $sql .= 'WHERE file.fileId =:fileId ';

        $requete = $connexion->prepare($sql);
        $data = array(':fileId' => $fileId);
        $resultat = $requete->execute($data);
        $file = array();
        if ($resultat) {
            $requete->setFetchMode(PDO::FETCH_ASSOC);
            while ($ligne = $requete->fetch()) {
                if (!isset($file['path'])) {
                    $file = array(
                        'path' => $ligne['path'],
                        'fileName' => $ligne['fileName'],
                        'acronyme' => $ligne['acronyme']);
                }
                $file['shareId'][] = $ligne['shareId'];
            }
        }
        Application::deconnexionPDO($connexion);

        return $file;
    }

    /**
     * retourne la liste des fichiers partagés pour un utilisateur $acronyme
     *
     * @param string $acronyme
     *
     * @return array
     */
    public function listSharesByUser($acronyme) {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT spyId, tss.shareId, tss.isDir,   tss.fileId ';
        $sql .= 'FROM '.PFX.'thotSharesSpy AS tss ';
        $sql .= 'JOIN '.PFX.'thotShares AS ts ON ts.shareId = tss.shareId ';
        $sql .= 'JOIN '.PFX.'thotFiles AS tf ON tf.fileId = ts.fileId ';
        $sql .= 'WHERE acronyme=:acronyme ';
        $requete = $connexion->prepare($sql);

        $requete->bindParam(':acronyme', $acronyme, PDO::PARAM_STR, 7);
        $liste = array();
        $resultat = $requete->execute();
        if ($resultat) {
            $requete->setFetchMode(PDO::FETCH_ASSOC);
            while ($ligne = $requete->fetch()) {
                $shareId = $ligne['shareId'];
                $liste[$shareId] = $ligne;
            }
        Application::deconnexionPDO($connexion);

        return $liste;
        }
    }

    /**
     * Enregistrement du partage d'un fichier
     *
     * @param array $post : contenu du formulaire
     * @param string $acronyme
     *
     * @return array : liste des shareIds du ficher partagé
     */
    public function share($post, $acronyme) {
        $fileName = $post['fileName'];
        $path = $post['path'];
        $dirOrFile = $post['dirOrFile'];

        // retrouver le fileId existant ou définir un fileId -paramètre "true"
        $fileId = $this->findFileId($path, $fileName, $dirOrFile, $acronyme, true);

        // types possibles
        // 'classes', 'prof', 'coursGrp', 'niveau', 'ecole', 'eleves' (isolés), 'groupeArbitraire'
        $type = $post['type'];

        // groupes possibles (EXEMPLES)
        // 'ecole', 'niveau', '2C:INFO2-03', '1C2', '8246' (matricule de l'élève), 'prof', 'cineclub'
        $groupe = $post['groupe'];
        // commentaire du partage
        $commentaire = $post['commentaire'];
        // si cibles séparées: voir le champ 'membres' (pour les profs et pour les élèves)
        $membres = isset($post['membres']) ? $post['membres'] : Null;

        // si le destinataire est tout le groupe
        if ($membres == Null) {
            // destinataire = 'all' si tout le groupe est concerné, sinon, acronyme ou matricule
            // la fonction getShareIdsForFile demande un tableau pour le(s) destinataire(s)
            $destinataire = 'all';
            $shareIds = $this->getShareIdsForFile($fileId, $type, $groupe, $destinataire, $commentaire);
        } else {
            // sinon, indiquer chaque membre du groupe comme destinataire
            // s'il s'agit d'un partage avec des élèves isolés d'un sous-groupe, on change le $type
            if (in_array($type, array('coursGrp','classes', 'groupeAny')))
                $type = 'eleves';
            $shareIds = $this->getShareIdsForFile($fileId, $type, $groupe, $membres, $commentaire);
            }

        return $shareIds;
    }

    /**
     * Partage du document (file ou dir) dont les caractéristiques sont passées dans le $formulaire
     *
     * @param array $formulaire : formulaire de la boîte de dialogue "modalShare.tpl"
     * @param string $acronyme : propriétaire
     *
     * @return int : shareId du document
     */
    // public function shareFile($formulaire, $acronyme) {
    //     $fileName = $formulaire['fileName'];
    //     $path = $formulaire['path'];
    //     $dirOrFile = $formulaire['dirOrFile'];
    //     $fileId = $this->findFileId($path, $fileName, $dirOrFile, $acronyme, true);
    //
    //     $type = $formulaire['type'];
    //     $groupe = $formulaire['groupe'];
    //     $commentaire = $formulaire['commentaire'];
    //
    //     // le document est-il partagé avec tout le groupe concerné?
    //     if (isset($formulaire['TOUS']) && $formulaire['TOUS'] == 'tous' ) {
    //         $destinataire = $groupe;
    //         $shareId = $this->getShareIdForFile ($fileId, $type, $groupe, $destinataire, $commentaire);
    //         }
    //         else {
    //             $membres = $formulaire['membres'];
    //             foreach ($membres as $destinataire) {
    //                 $shareId = $this->getShareIdForFile ($fileId, $type, $groupe, $destinataire, $commentaire);
    //             }
    //         }
    //
    //     return $fileId;
    // }

    /**
     * note un fichier "partagé" et retourne le shareId correspondant pour chaque destinataire
     *
     * @param int $fileId: identifiant du fichier à partager
     * @param string $type: type de partage (coursGrp, classes, niveau,...)
     * @param string $groupe: groupe avec lequel le document est partagé (classe 2CA, cineclub,...)
     * @param array $destinataires : fichier partagé avec qui, dans le groupe (éventuellement, "all")?
     * @param string $commentaire : commentaire du partage
     *
     * @return int
     */
    public function getShareIdsForFile ($fileId, $type, $groupe, $destinataires, $commentaire){
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        // enregistrer les partages
        $sql = 'INSERT INTO '.PFX.'thotShares ';
        $sql .= 'SET fileId = :fileId, type = :type, groupe = :groupe, destinataire = :destinataire, commentaire = :commentaire ';
        $sql .= 'ON DUPLICATE KEY UPDATE commentaire = :commentaire ';
        $requete = $connexion->prepare($sql);

        $requete->bindParam(':fileId', $fileId, PDO::PARAM_INT);
        $requete->bindParam(':type', $type, PDO::PARAM_STR, 12);
        $requete->bindParam(':groupe', $groupe, PDO::PARAM_STR, 15);
        $requete->bindParam(':commentaire', $commentaire, PDO::PARAM_STR, 30);

        $shareIds = array();
        if ($destinataires == 'all')
            $destinataires = array('all');
        foreach ($destinataires as $destinataire) {
            $requete->bindParam(':destinataire', $destinataire, PDO::PARAM_STR, 15);
            $resultat = $requete->execute();
            $shareIds[$destinataire] = $connexion->lastInsertId();
        }

        Application::DeconnexionPDO($connexion);

        return $shareIds;
    }

    /**
     * note un fichier "partagé" et retourne le shareId correspondant pour le destinataire
     * @param int $fileId: identifiant du fichier à partager
     * @param string $type: type de partage (coursGrp, classes, niveau,...)
     * @param string $groupe: groupe avec lequel le document est partagé (classe 2CA,...)
     * @param string $destinataire : ficher partagé avec qui (destinataire unique)
     * @param string $commentaire : commentaire du partage
     *
     * @return int
     */
    public function getShareIdForFile ($fileId, $type, $groupe, $destinataire, $commentaire) {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        // enregistrer les partages
        $sql = 'INSERT INTO '.PFX.'thotShares ';
        $sql .= 'SET fileId = :fileId, type = :type, groupe = :groupe, destinataire = :destinataire, commentaire = :commentaire ';

        $requete = $connexion->prepare($sql);

        $requete->bindParam(':fileId', $fileId, PDO::PARAM_INT);
        $requete->bindParam(':type', $type, PDO::PARAM_STR, 12);
        $requete->bindParam(':groupe', $groupe, PDO::PARAM_STR, 15);
        $requete->bindParam(':destinataire', $destinataire, PDO::PARAM_STR, 15);
        $requete->bindParam(':commentaire', $commentaire, PDO::PARAM_STR, 30);

        $resultat = $requete->execute();
        $shareId = $connexion->lastInsertId();

        Application::DeconnexionPDO($connexion);

        return $shareId;
    }

    /**
     * supprimer tous les partages d'un fichier dont on fournit le path, le fileName et l'acronyme de l'utilisateur.
     *
     * @param $path
     * @param $fileName
     * @param $acronyme
     *
     * @return int : le nombre d'effacements dans la BD
     */
    public function delAllShares($path, $fileName, $dirOrFile, $acronyme) {
        $fileId = $this->findFileId($path, $fileName, $dirOrFile, $acronyme, false);

        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'DELETE FROM '.PFX.'thotShares ';
        $sql .= 'WHERE fileId = :fileId ';
        $requete = $connexion->prepare($sql);

        $requete->bindParam(':fileId', $fileId, PDO::PARAM_INT);

        $resultat = $requete->execute();

        Application::DeconnexionPDO($connexion);

        return $resultat;
    }

    /**
     * Suppression de la référence à des fichiers désignés par leur $fileId dans la BD
     *
     * @param int $fileId
     *
     * @return int : nombre d'effacements (0 ou 1)
     */
    public function delFileByFileId($fileId){
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'DELETE FROM '.PFX.'thotFiles ';
        $sql .= 'WHERE fileId = :fileId ';
        $requete = $connexion->prepare($sql);

        $requete->bindParam(':fileId', $fileId, PDO::PARAM_INT);

        $resultat = $requete->execute();

        Application::DeconnexionPDO($connexion);

        return $resultat;
    }

    /**
     * Vérifier que l'utilisateur $acronyme est propriétaire du document $fileId.
     *
     * @param $fileId : l'identifiant du document dans la BD
     * @param $acronyme : l'identifiant du possible propriétaire
     *
     * @return bool
     */
    private function verifProprietaire($fileId, $acronyme)
    {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT fileId, acronyme ';
        $sql .= 'FROM '.PFX.'thotFiles ';
        $sql .= "WHERE fileId='$fileId' AND acronyme='$acronyme' ";
        $resultat = $connexion->query($sql);
        $verif = false;
        if ($resultat) {
            $ligne = $resultat->fetch();
            if (($ligne['fileId'] == $fileId) && ($ligne['acronyme'] == $acronyme)) {
                $verif = true;
            } else {
                $verif = false;
            }
        }
        Application::DeconnexionPDO($connexion);

        return $verif;
    }

    /**
     * Vérifier que l'utilisateur $acronyme est propriétaire du partage $shareId.
     *
     * @param $acronyme : identifaint de l'utilisateur
     * @param $shareId : identifiant du partage
     *
     * @return $bool
     */
    public function verifProprietaireShare($shareId, $acronyme)
    {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT acronyme, shareId ';
        $sql .= 'FROM '.PFX.'thotShares AS share ';
        $sql .= 'JOIN '.PFX.'thotFiles AS files ON files.fileId = share.fileId ';
        $sql .= "WHERE shareId = '$shareId' AND acronyme = '$acronyme' ";

        $resultat = $connexion->query($sql);
        $verif = false;
        if ($resultat) {
            $resultat->setFetchMode(PDO::FETCH_ASSOC);
            $ligne = $resultat->fetch();
            if ($ligne['acronyme'] == $acronyme) {
                $verif = true;
            }
        }
        Application::DeconnexionPDO($connexion);

        return $verif;
    }

    /**
     * Enregistrement d'une édition d'un commentaire de fichier dont on fournit le shareId.
     *
     * @param string $commentaire
     * @param int $shareId : l'identifiant du partage
     *
     * @return string : le commentaire enregistré
     */
    public function saveEditedComment($commentaire, $shareId)
    {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'UPDATE '.PFX.'thotShares ';
        $sql .= 'SET commentaire=:commentaire ';
        $sql .= 'WHERE shareId=:shareId ';
        $requete = $connexion->prepare($sql);

        $requete->bindParam(':shareId', $shareId, PDO::PARAM_INT);
        $requete->bindParam(':commentaire', $commentaire, PDO::PARAM_STR, 100);
        //  $data = array(':commentaire' => $commentaire, ':shareId' => $shareId);
        $resultat = $requete->execute();
        Application::DeconnexionPDO($connexion);
        if ($resultat == 1) {
            return $commentaire;
        } else {
            return '';
        }
    }

    /**
     * clôture le partage d'un fichier dont on fournit l'identifiant et l'acronyme du propriétaire.
     *
     * @param $shareId : identifiant du fichier partagé
     * @param $acronyme : identifiant du propriétaire
     *
     * @return bool : true si l'opération s'est bien passée
     */
    public function endShare($shareId, $acronyme)
    {
        $end = false;
        if ($this->verifProprietaire($shareId, $acronyme)) {
            $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
            $sql = 'DELETE FROM '.PFX.'thotShares ';
            $sql .= "WHERE shareId='$shareId' ";
            $resultat = $connexion->exec($sql);
            if ($resultat == 1) {
                $end = true;
            }
        }
        Application::DeconnexionPDO($connexion);

        return $end;
    }

    /**
     * supprime la mention d'un fichier dans la BD, après effacement du fichier.
     *
     * @param $path: chemin vers le fichier
     * @param $fileName
     * @param $acronyme : sécurité
     *
     * @return int : le nombre de fichiers supprimés (0 ou 1)
     */
    public function clearBD($path, $fileName, $acronyme)
    {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'DELETE FROM '.PFX.'thotFiles ';
        $sql .= 'WHERE path = :path AND fileName = :fileName AND acronyme = :acronyme ';
        $requete = $connexion->prepare($sql);

        $requete->bindParam(':path', $path, PDO::PARAM_STR, 255);
        $requete->bindParam(':fileName', $fileName, PDO::PARAM_STR, 255);
        $requete->bindParam(':acronyme', $acronyme, PDO::PARAM_STR, 7);

        $resultat = $requete->execute();
        Application::DeconnexionPDO($connexion);

        return $resultat;
    }

    /**
     * vérifie que le ficher référencé par $fileId est partagé et détenu par l'utilisateur $acronyme.
     *
     * @param $fileId
     * @param $acronyme
     *
     * @return bool
     */
    public function fileIdIsSharedBy($fileId, $acronyme)
    {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT shares.fileId, acronyme ';
        $sql .= 'FROM '.PFX.'thotShares AS shares ';
        $sql .= 'JOIN '.PFX.'thotFiles AS files ON shares.fileId = files.fileId ';
        $sql .= "WHERE shares.fileId = '$fileId' AND acronyme = '$acronyme' ";
        $resultat = $connexion->query($sql);
        $test = false;
        if (resultat) {
        }
        Application::DeconnexionPDO($connexion);

        return;
    }

    /**
     * clôture le partage d'un fichier dont on fournit l'identifiant de partage ($shareId);.
     *
     * @param $shareId
     * @param $acronyme (pour vérifier que le fichier appartient bien à l'utilisateur actif)
     *
     * @return int : le shareId du partage qui vient d'être clôturé
     */
    public function unShareByShareId($shareId, $acronyme)
    {
        if ($this->verifProprietaireShare($shareId, $acronyme)) {
            $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
            $sql = 'DELETE FROM '.PFX.'thotShares ';
            $sql .= "WHERE shareId = $shareId ";

            $resultat = $connexion->exec($sql);

            Application::DeconnexionPDO($connexion);

            if ($resultat) {
                return $shareId;
                }
        } else {
            die('Ce fichier ne vous appartient pas');
        }
    }

    /**
     * clôture le partage d'une liste de fichiers dont on passe le fileId (et autres infos)
     *
     * @param array $fileList (array($fileId, $fileName, $path))
     *
     * @return int : nombre de fin de partages
     */
    public function unShareFileList($fileList) {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'DELETE FROM '.PFX.'thotShares ';
        $sql .= 'WHERE fileId = :fileId ';
        $requete = $connexion->prepare($sql);

        $resultat = 0;
        foreach ($fileList as $n => $file) {
            $fileId = $file['fileId'];
            $requete->bindParam(':fileId', $fileId, PDO::PARAM_INT);
            $resultat += $requete->execute();
        }
        Application::DeconnexionPDO($connexion);

        return $resultat;
    }


    /**
     * clôture le partage d'un fichier dont on fournit l'identifiant $fileId.
     *
     * @param $fileId
     *
     * @return bool : opération réussie?
     */
    public function unShareByFileId($fileId)
    {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'DELETE FROM '.PFX.'thotShares ';
        $sql .= "WHERE fileId = '$fileId' ";
        $resultat = $connexion->exec($sql);
        Application::DeconnexionPDO($connexion);

        return $resultat;
    }

    /**
     * clôture le partage de tous les fichiers de la liste fournie.
     *
     * @param $fileList : liste des fichiers array('path'=>..., 'fileName'=>...)
     * @param $acronyme : propriétaire du fichier (sécurité)
     *
     * @return int : nombre de clôtures réalisées
     */
    public function unShareAllFiles($fileList, $acronyme)
    {
        $nb = 0;
        $ds = DIRECTORY_SEPARATOR;
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql1 = 'DELETE FROM '.PFX.'thotShares ';
        $sql1 .= 'WHERE fileId=:fileId, shareId=:shareId, acronyme=:acronyme ';
        $requeteShares = $connexion->prepare($sql1);

        $sql2 = 'DELETE FROM '.PFX.'thotFiles ';
        $sql2 .= 'WHERE fileId=:fileId ';
        $requeteFile = $connexion->prepare($sql2);
        foreach ($fileList as $share) {
            $path = substr($share['path'], strpos($share['path'], 'upload'.$ds.$acronyme) + strlen('upload'.$ds.$acronyme));
            $shareList = $this->requestFileDetails($path, $share['fileName'], $acronyme);
            if ($shareList != null) {
                foreach ($shareList as $oneShare) {
                    $data = array(
                            ':fileId' => $oneShare['fileId'],
                            ':shareId' => $oneShare['shareId'],
                            ':acronyme' => $acronyme,
                        );
                    $nb += $requeteShares->execute($data);
                }
                $data = array(
                    ':fileId' => $oneShare['fileId'],
                );
                $nb += $requeteFile->execute($data);
            }
        }
        Application::DeconnexionPDO($connexion);

        return $nb;
    }

    /**
     * retourne la liste des partages pour un fichier dont on indique le path et le fileName pour l'utilisateur donné.
     *
     * @param $path
     * @param $fileName
     * @param $acronyme
     *
     * @return array
     */
    public function listShares($path, $fileName, $acronyme)
    {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT files.fileId, type, share.groupe, destinataire, commentaire, de.nom, de.prenom, ';
        $sql .= 'profs.nom AS nomProf, profs.prenom AS prenomProf ';
        $sql .= 'FROM '.PFX.'thotFiles AS files ';
        $sql .= 'JOIN '.PFX.'thotShares AS share ON files.fileId = share.fileId ';
        $sql .= 'LEFT JOIN '.PFX.'eleves AS de ON de.matricule = share.destinataire ';
        $sql .= 'LEFT JOIN '.PFX.'profs AS profs ON profs.acronyme = share.destinataire ';
        $sql .= 'WHERE files.acronyme=:acronyme AND path=:path AND fileName=:fileName ';
        $sql .= 'ORDER BY type, groupe, destinataire ';
        $requete = $connexion->prepare($sql);
        $data = array(':acronyme' => $acronyme, ':path' => $path, ':fileName' => $fileName);
        $resultat = $requete->execute($data);

        $liste = array();
        if ($resultat) {
            $requete->setFetchMode(PDO::FETCH_ASSOC);
            while ($ligne = $requete->fetch()) {
                $type = $ligne['type'];
                switch ($type) {
                    case 'ecole':
                        $liste[] = 'Tous les élèves';
                        break;
                    case 'niveau':
                        $liste[] = 'Tous les élèves de '.$ligne['destinataire'].'e';
                        break;
                    case 'prof':
                        if ($ligne['destinataire'] == 'all') {
                            $liste[] = 'Tous les collègues';
                        } else {
                            $liste[] = sprintf('collègue: %s %s', $ligne['prenomProf'], $ligne['nomProf']);
                        }
                        break;
                    case 'classes':
                        if ($ligne['destinataire'] == 'all') {
                            $liste[] = 'Tous les élèves de '.$ligne['groupe'];
                        } else {
                            $liste[] = sprintf('%s: %s %s', $ligne['groupe'], $ligne['nom'], $ligne['prenom']);
                        }
                        break;
                    case 'coursGrp':
                        if ($ligne['destinataire'] == 'all') {
                            $liste[] = 'Tous les élèves du cours '.$ligne['groupe'];
                        } else {
                            $liste[] = sprintf('%s: %s %s', $ligne['groupe'], $ligne['nom'], $ligne['prenom']);
                        }
                        break;
                    default:
                        // wtf;
                        break;
                    }
            }
        }
        Application::DeconnexionPDO($connexion);

        return $liste;
    }

    /**
     * retourne la liste des fichiers partagés en les triant par groupes de destinataires
     *
     * @param string $acronyme : le propriétaire
     * @param string $groupe : si l'on souhaite un groupe en particulier
     *
     * @return array
     */
    public function getSharedByGroups ($acronyme, $groupe=Null) {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT dtf.fileId, fileName, path, dirOrFile, shareId, type, dts.groupe, destinataire, commentaire, ';
        $sql .= 'de.nom, de.prenom, profs.nom AS nomProf, profs.prenom AS prenomProf, ';
        $sql .= 'de.nom AS nomEleve, de.prenom AS prenomEleve, de.groupe AS classe ';
        $sql .= 'FROM '.PFX.'thotFiles AS dtf ';
        $sql .= 'JOIN '.PFX.'thotShares AS dts ON dtf.fileId = dts.fileId ';
        $sql .= 'LEFT JOIN '.PFX.'eleves AS de ON de.matricule = dts.destinataire ';
        $sql .= 'LEFT JOIN '.PFX.'profs AS profs ON profs.acronyme = dts.destinataire ';
        $sql .= 'WHERE dtf.acronyme =:acronyme ';
        if ($groupe != Null)
            $sql .= 'AND groupe=:groupe ';
        $sql .= 'ORDER BY type, groupe, destinataire, fileName ';

        $requete = $connexion->prepare($sql);

        $requete->bindParam(':acronyme', $acronyme, PDO::PARAM_STR, 7);
        if ($groupe != Null)
            $requete->bindParam(':groupe', $groupe, PDO::PARAM_STR, 15);
        $resultat = $requete->execute();
        $liste = array();
        if ($resultat) {
            $requete->setFetchMode(PDO::FETCH_ASSOC);
            while ($ligne = $requete->fetch()) {
                $type = $ligne['type'];
                $shareId = $ligne['shareId'];
                $groupe = $ligne['groupe'];
                if ($groupe == $type)
                    $groupe = ($ligne['destinataire'] == 'all') ? '[TOUS]' : $ligne['destinataire'];
                switch ($type) {
                    case 'ecole':
                        $libelle = 'Tous les élèves';
                        break;
                    case 'niveau':
                        $libelle = 'Tous les élèves de '.$ligne['destinataire'].'e';
                        break;
                    case 'prof':
                        if ($ligne['destinataire'] == 'all') {
                            $libelle = 'Tous les collègues';
                        } else {
                            $libelle = sprintf('Collègue: %s %s', $ligne['prenomProf'], $ligne['nomProf']);
                        }
                        break;
                    case 'classes':
                        if ($ligne['destinataire'] == 'all') {
                            $libelle = 'Tous les élèves de '.$ligne['groupe'];
                        } else {
                            $libelle = sprintf('%s: %s %s', $ligne['groupe'], $ligne['nom'], $ligne['prenom']);
                        }
                        break;
                    case 'coursGrp':
                        if ($ligne['destinataire'] == 'all') {
                            $libelle = 'Tous les élèves du cours '.$ligne['groupe'];
                        } else {
                            $libelle = sprintf('%s: %s %s', $ligne['groupe'], $ligne['nom'], $ligne['prenom']);
                        }
                        break;
                    case 'eleves':

                        $libelle = 'Matricule '.$ligne['groupe'].$ligne['nomEleve'];
                        break;
                    default:
                        // wtf;
                        break;
                    }
                $ligne['libelle'] = $libelle;

                $liste[$type][$groupe][$shareId] = $ligne;
            }
        }

        Application::DeconnexionPDO($connexion);

        foreach ($liste as $type => $shares) {
            ksort($liste[$type]);
        }

        return $liste;
    }

    /**
     * renvoie un dictionnaire en "français" des noms des différents groupes de partages de documents
     *
     * @param void
     *
     * @return array
     */
    public function getDicoShareGroups(){
        return array(
            'ecole' => 'Élèves de l\'école',
            'niveau' => 'Élèves d\'un niveau d\'étude',
            'classes' => 'Élèves d\'une classe',
            'coursGrp' => 'Élèves d\'un cours',
            'groupe' => 'Élèves d\'un groupe',
            'eleves' => 'Élèves isolés',
            'prof' => 'Collègues',
        );
    }

    /**
     * renvoie un dictionnaire en "français" des statuts possibles pour les travaux dans les casiers
     *
     * @param void
     *
     * @return array
     */
    public function getDicoStatuts(){
        return array(
            'hidden' => 'Caché aux élèves',
            'readonly' => 'Lecture seule',
            'readwrite' => 'Travail en cours',
            'termine' => 'Travail terminé',
            'archive' => 'Travail archivé',
        );
    }

    /**
     * retourne les caractéristiques d'un fichier dont on donne le shareId
     *
     * @param int $shareId
     * @param string $acronyme : acronyme du propriétaire
     *
     * @return array
     */
    public function getFileInfoByShareId($shareId, $acronyme=Null) {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT shareId, dts.fileId, type, dts.groupe, destinataire, commentaire, path, fileName, dirOrFile, ';
        $sql .= ' dtf.acronyme, de.nom, de.prenom, profs.nom AS nomProf, profs.prenom AS prenomProf ';
        $sql .= 'FROM '.PFX.'thotShares AS dts ';
        $sql .= 'JOIN '.PFX.'thotFiles AS dtf ON dtf.fileId = dts.fileId ';
        $sql .= 'LEFT JOIN '.PFX.'eleves AS de ON de.matricule = dts.destinataire ';
        $sql .= 'LEFT JOIN '.PFX.'profs AS profs ON profs.acronyme = dts.destinataire ';
        $sql .= 'WHERE dts.shareId =:shareId ';
        if ($acronyme != Null)
            $sql .= 'AND dtf.acronyme=:acronyme ';
        $requete = $connexion->prepare($sql);

        $ligne = array();
        if ($acronyme != Null)
            $requete->bindParam(':acronyme', $acronyme, PDO::PARAM_STR, 7);
        $requete->bindParam(':shareId', $shareId, PDO::PARAM_INT);
        $resultat = $requete->execute();
        if ($resultat) {
            $requete->setFetchMode(PDO::FETCH_ASSOC);
            $ligne = $requete->fetch();
            $type = $ligne['type'];
            switch ($type) {
                case 'ecole':
                    $ligne['libelle'] = 'Tous les élèves';
                    break;
                case 'niveau':
                    $ligne['libelle'] = 'Tous les élèves de '.$ligne['destinataire'].'e';
                    break;
                case 'prof':
                    if ($ligne['destinataire'] == 'all') {
                        $ligne['libelle'] = 'Tous les collègues';
                    } else {
                        $ligne['libelle'] = sprintf('collègue: %s %s', $ligne['prenomProf'], $ligne['nomProf']);
                    }
                    break;
                case 'classe':
                    if ($ligne['destinataire'] == 'all') {
                        $ligne['libelle'] = 'Tous les élèves de '.$ligne['groupe'];
                    } else {
                        $ligne['libelle'] = sprintf('%s: %s %s', $ligne['groupe'], $ligne['nom'], $ligne['prenom']);
                    }
                    break;
                case 'coursGrp':
                    if ($ligne['destinataire'] == 'all') {
                        $ligne['libelle'] = 'Tous les élèves du cours '.$ligne['groupe'];
                    } else {
                        $ligne['libelle'] = sprintf('%s: %s %s', $ligne['groupe'], $ligne['nom'], $ligne['prenom']);
                    }
                    break;
                default:
                    // wtf;
                    break;
                }
        }

        Application::DeconnexionPDO($connexion);

        return $ligne;
    }

    /**
     * renvoie le contenu d'un répertoire de manière non-récursive
     *
     * @param string $dir : le répertoire, y compris le path
     *
     * @return array : liste des fichiers commençant par les répertoires
     */
    public function flatDirectory($dir) {
        $results = scandir($dir);
        $listFiles = array('dir' => array(), 'file' => array());
        $ds = DIRECTORY_SEPARATOR;
        foreach ($results as $entry) {
            // éviter les répertoires "." et ".." ainsi que les répertoires de service (Ex: "#thot")
            if (!(in_array($entry, array('.', '..'))) && (substr($entry,0,1) != '#')){
                $type = is_dir($dir.$ds.$entry) ? 'dir' : 'file';
                $ext = pathinfo($dir.$ds.$entry, PATHINFO_EXTENSION);
                $listFiles[$type][] = array(
                    'fileName' => $entry,
                    'type' => $type,
                    'size' => $this->unitFilesize(filesize($dir.$ds.$entry)),
                    'dateTime' => strftime('%x %X', filemtime($dir.$ds.$entry)),
                    'ext' => $ext,
                );
            }
        }

        return array_merge($listFiles['dir'], $listFiles['file']);
    }

    /**
     * récupère la liste des fichiers (sans les répertoires) dans $arborescence, à partir d'une racine
     *
     * @param $dir : répertoire à lister
     * @param $root : racine de l'arborescene à visiter
     *
     * @return array: contenu du répertoire
     */
    public function onlyFilesList($root, $dir)
    {
        // stockage séparé des fichiers ordinaires et des répertoires, chacun par ordre alphabétique
        $files = array();
        if (file_exists($root.$dir)) {
            // liste plate des fichiers et répertoires
            $listeFichiers = scandir($root.$dir);

            foreach ($listeFichiers as $f) {
                // Ignorer les fichiers cachés et les répertoires protégés par "#" initial
                if (!$f || $f[0] == '.' || $f[0] == '#') {
                    continue;
                }
                if (is_dir($root.$dir.'/'.$f)) {
                    continue;
                }
                // C'est un fichier ordinaire
                $fileName = $dir.'/'.$f;
                $fileName = ($fileName[0] != '/') ? '/'.$fileName : $fileName;

                $files['files'][] = array(
                    'name' => $f,
                    'type' => 'file',
                    'path' => preg_replace('~/+~', '/', $dir),
                    'size' => $this->unitFilesize(filesize($root.$dir.'/'.$f)),
                    'date' => strftime('%x %X', filemtime($root.$dir.'/'.$f)),
                    'ext' => pathinfo($dir.'/'.$f)['extension'],
                );
            }
        }

        return $files;
    }

    /**
     * renvoie tous les noms de fichiers (avec les répertoires) inclus dans l'arboresence indiquée.
     *
     * @param string $userDir : emplacement du répertoire de l'utilisateur
     * @param string $upload : sous-répertoire à examiner
     *
     * @return array
     */
    public function getAllFilesFrom($userDir, $upload){
        $path = $userDir.$upload;
        $directory = new \RecursiveDirectoryIterator($path);
        $iterator = new \RecursiveIteratorIterator($directory);
        $n = strlen($userDir);

        $files = array();
        foreach ($iterator as $info) {
            $dir = substr($info->getPath(), $n);
            $fileName = $info->getFilename();
            if ($fileName != '..') {
                $dirOrFile = ($fileName == '.') ? 'dir' : 'file';
                $lastSlash = strrpos($fileName, '/');
                $path = substr($fileName, 0, $lastSlash + 1);
                if ($dirOrFile == 'dir') {
                    $fileName = substr($fileName, $lastSlash + 1);
                    $path = trim($path,'/');
                    }
                    else $fileName = substr($fileName, $lastSlash);
                $files[] = array(
                    'path' => $dir,
                    'fileName' => $fileName,
                    'dirOrFile' => $dirOrFile
                );
            }
        }

        return $files;
    }

    /**
     * renvoie le catalogue des fichiers partagés avec un prof classés par shareId.
     *
     * @param $acronyme
     *
     * @return array
     */
    public function sharedWith($acronyme)
    {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT share.shareId, share.fileId, groupe, destinataire, commentaire, path, fileName, dirOrFile, ';
        $sql .= 'files.acronyme, nom, prenom ';
        $sql .= 'FROM '.PFX.'thotShares AS share ';
        $sql .= 'JOIN '.PFX.'thotFiles AS files ON files.fileId = share.fileId ';
        $sql .= 'JOIN '.PFX.'profs AS p ON p.acronyme = files.acronyme ';
        $sql .= "WHERE (share.groupe = 'prof' AND destinataire = 'all') ";
        $sql .= "OR destinataire = '$acronyme' ";
        $sql .= 'ORDER BY commentaire, fileName, nom, prenom ';

        $resultat = $connexion->query($sql);
        $liste = array();
        if ($resultat) {
            $resultat->setFetchMode(PDO::FETCH_ASSOC);
            while ($ligne = $resultat->fetch()) {
                $shareId = $ligne['shareId'];
                $liste[$shareId] = $ligne;
            }
        }
        Application::DeconnexionPDO($connexion);

        return $liste;
    }

    /**
     * ajoute l'information de l'extension aux informations de la liste des fichiers passés
     *
     * @param array $listeFichiers
     * @param string $root : INSTALL_DIR
     * @param string $acronyme
     *
     * @return array
     */
    public function addExtension($listeFichiers, $root, $acronyme) {
        $ds = DIRECTORY_SEPARATOR;
        foreach ($listeFichiers as $key => $unFichier) {
            $path = $root.$ds.'upload'.$ds.$acronyme.$unFichier['path'].$ds.$unFichier['fileName'];
            // rustine
            $path = preg_replace('~/+~', '/', $path);
            $listeFichiers[$key]['ext'] = pathinfo($path, PATHINFO_EXTENSION);
        }
        return $listeFichiers;
    }

    /**
     * retourne la liste des fileId des partages avec l'utilisateur dont on fournit l'acronyme.
     *
     * @param $acronyme
     *
     * @return array : liste des fileId partagés avec cet utilisateur
     */
    public function getFilesSharedWith($acronyme)
    {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT share.fileId ';
        $sql .= 'FROM '.PFX.'thotShares AS share ';
        $sql .= 'JOIN '.PFX.'thotFiles AS files ON files.fileId = share.fileId ';
        $sql .= "WHERE (share.groupe = 'prof' AND destinataire = 'all') ";
        $sql .= "OR destinataire = '$acronyme' ";
        $resultat = $connexion->query($sql);
        $liste = array();
        if ($resultat) {
            $resultat->setFetchMode(PDO::FETCH_ASSOC);
            while ($ligne = $resultat->fetch()) {
                $fileId = $ligne['fileId'];
                array_push($liste, $fileId);
            }
        }
        Application::DeconnexionPDO($connexion);

        return $liste;
    }

    /**
     * retourne les fileId d'une liste de fichiers  array($path, $filename)
     * pour un propriétaire $acronyme donné
     *
     * @param array $fileList
     *
     * @return array array($fileId, $path, $fileName)
     */
    public function getFileIdForFileList ($fileList, $acronyme) {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $fileIdList = array();
        foreach ($fileList as $n => $file) {
            $fileName = $file['fileName'];
            $path = $file['path'];
            $sql = 'SELECT fileId, path, fileName ';
            $sql .= 'FROM '.PFX.'thotFiles ';
            $sql .= 'WHERE path = :path AND fileName = :fileName AND acronyme = :acronyme ';
            $requete = $connexion->prepare($sql);

            $requete->bindParam(':path', $path, PDO::PARAM_STR, 255);
            $requete->bindParam(':fileName', $fileName, PDO::PARAM_STR, 255);
            $requete->bindParam(':acronyme', $acronyme, PDO::PARAM_STR, 7);

            $fileIdList = array();
            $resultat = $requete->execute();
            if ($resultat) {
                $requete->setFetchMode(PDO::FETCH_ASSOC);
                $ligne = $requete->fetch();

                $fileId = $ligne['fileId'];
                $fileIdList[$fileId] = $ligne;
            }
        }

        Application::DeconnexionPDO($connexion);

        return $fileIdList;
    }

    /**
     * renvoie la liste des shareIds correspondant à la liste des $fileIds passés en argument
     *
     * @param array $listeFileIds
     *
     * @return array : la liste de tous les shareIds pour ces fileIds
     */
    public function getShareIdForFileIds($allFileIds){
        // array_filter pour supprimer les fichiers sans shareId (non partagés)
        $listFileIdsString = implode(',', array_keys(array_filter($allFileIds)));
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT shareId ';
        $sql .= 'FROM '.PFX.'thotShares ';
        $sql .= 'WHERE fileId IN ('.$listFileIdsString.') ';
        $requete = $connexion->prepare($sql);

        $liste = array();
        $resultat = $requete->execute();
        if ($resultat) {
            $requete->setFetchMode(PDO::FETCH_ASSOC);
            while ($ligne = $requete->fetch()) {
                $shareId = $ligne['shareId'];
                array_push($liste, $shareId);
            }
        }
        Application::DeconnexionPDO($connexion);

        return $liste;
    }

    /**
     * retourne la liste des partages pour un utilisateur dont on fournit l'acronyme.
     *
     * @param $acronyme
     *
     * @return array
     */
    public function getUserShares($acronyme)
    {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT share.fileId, type, share.groupe, destinataire, commentaire, shareId, path, fileName, CONCAT(de.nom," ",de.prenom) AS nomEleve,  de.groupe AS classe, CONCAT(dp.prenom," ", dp.nom) AS nomProf, dc.libelle, pc.nomCours ';
        $sql .= 'FROM '.PFX.'thotShares AS share ';
        $sql .= 'JOIN '.PFX.'thotFiles AS files ON files.fileId = share.fileId ';
        $sql .= 'LEFT JOIN '.PFX.'profs AS dp ON dp.acronyme = share.destinataire ';
        $sql .= 'LEFT JOIN '.PFX."cours AS dc ON dc.cours = SUBSTR(share.groupe, 1, LOCATE ('-', share.groupe)-1) ";
        $sql .= 'LEFT JOIN '.PFX.'profsCours AS pc ON pc.coursGrp = share.groupe ';
        $sql .= 'LEFT JOIN '.PFX.'eleves AS de ON de.matricule = share.destinataire ';
        $sql .= 'WHERE files.acronyme =:acronyme ';
        $sql .= 'ORDER BY path, fileName ';

        $requete = $connexion->prepare($sql);
        $data = array(':acronyme' => $acronyme);
        $liste = array();
        $resultat = $requete->execute($data);
        if ($resultat) {
            $requete->setFetchMode(PDO::FETCH_ASSOC);
            while ($ligne = $requete->fetch()) {
                $fileId = $ligne['fileId'];
                $shareId = $ligne['shareId'];
                if (!(isset($liste[$fileId]))) {
                    $liste[$fileId] = array(
                        'path' => $ligne['path'],
                        'fileName' => $ligne['fileName'],
                        'share' => array(), );
                }
                $liste[$fileId]['share'][$shareId] = $ligne;
            }
        }
        Application::DeconnexionPDO($connexion);

        return $liste;
    }

    /**
     * retourne le commentaire associé à un partage $shareId pour l'utilisateur dont on fournit l'acronyme.
     *
     * @param $shareId
     * @param $acronyme
     *
     * @return string
     */
    public function getCommentaire($shareId, $acronyme)
    {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT commentaire ';
        $sql .= 'FROM '.PFX.'thotShares AS share ';
        $sql .= 'JOIN '.PFX.'thotFiles AS files ON files.fileId = share.fileId ';
        $sql .= "WHERE shareId='$shareId' AND acronyme = '$acronyme' ";
        $resultat = $connexion->query($sql);
        $commentaire = '';
        if ($resultat) {
            $ligne = $resultat->fetch();
            $commentaire = $ligne['commentaire'];
        }

        Application::DeconnexionPDO($connexion);

        return $commentaire;
    }

    /**
     * retourne les caractéristiques d'un éventuel espion sur le fichier shareId
     * @param  int $shareId
     *
     * @return array
     */
    public function getSpyInfo4ShareId ($shareId) {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT spyId, dtss.shareId, dtss.isDir, dtss.fileId, acronyme ';
        $sql .= 'FROM '.PFX.'thotSharesSpy AS dtss ';
        $sql .= 'JOIN '.PFX.'thotShares AS dts ON dtss.shareId = dts.shareId ';
        $sql .= 'JOIN '.PFX.'thotFiles AS dtf ON dtf.fileId = dts.fileId ';
        $sql .= 'WHERE dtss.shareId = :shareId ';
        $requete = $connexion->prepare($sql);

        $requete->bindParam(':shareId', $shareId, PDO::PARAM_INT);
        $resultat = $requete->execute();
        $ligne = Null;
        if ($resultat) {
            $requete->setFetchMode(PDO::FETCH_ASSOC);
            $ligne = $requete->fetch();
        }

        Application::DeconnexionPDO($connexion);

        return $ligne;
    }

    /**
     * reourne la liste des accès à un fichier partagé $shareId donné pour un utilisateur donné
     *
     * @param int $shareId
     * @param string acronyme : utilisateur, controle de sécurité
     *
     * @return array
     */
    public function getSpyList4ShareId ($shareId, $acronyme) {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);

        $sql = 'SELECT dp.nom AS nomProf, dp.prenom AS prenomProf, de.groupe, de.nom, de.prenom, dtp.formule, ';
        $sql .= 'dtp.nom AS nomParent, dtp.prenom AS prenomParent, tss.spyId, tss.shareId, tss.isDir, ';
        $sql .= 'tss.fileId, tssu.userName, date, tssu.path, tssu.fileName ';
        $sql .= 'FROM '.PFX.'thotSharesSpy AS tss ';
        $sql .= 'LEFT JOIN '.PFX.'thotSharesSpyUsers AS tssu ON tssu.spyId = tss.spyId ';
        $sql .= 'JOIN '.PFX.'thotShares AS ts ON ts.shareId = tss.shareId ';
        $sql .= 'JOIN '.PFX.'thotFiles AS tf ON tf.fileId = ts.fileId ';
        $sql .= 'LEFT JOIN didac_profs AS dp ON dp.acronyme = userName ';
        $sql .= 'LEFT JOIN didac_passwd AS dpw ON dpw.user = tssu.userName ';
        $sql .= 'LEFT JOIN didac_eleves AS de ON de.matricule = dpw.matricule ';
        $sql .= 'LEFT JOIN didac_thotParents AS dtp ON dtp.userName = tssu.userName ';
        $sql .= 'WHERE tss.shareId = :shareId AND tf.acronyme = :acronyme ORDER BY date, userName ';

        $requete = $connexion->prepare($sql);

        $requete->bindParam(':shareId', $shareId, PDO::PARAM_INT);
        $requete->bindParam(':acronyme', $acronyme, PDO::PARAM_STR, 7);
        $liste = array();
        $resultat = $requete->execute();
        if ($resultat) {
            $requete->setFetchMode(PDO::FETCH_ASSOC);
            while ($ligne = $requete->fetch()) {
                $date = explode(' ', $ligne['date']);
                $date[0] = Application::datePHP($date[0]);
                $ligne['date'] = implode(' ', $date);
                $liste[] = $ligne;
                }
            }

        Application::DeconnexionPDO($connexion);

        return $liste;
    }

    /**
     * création d'un espion pour le fichier shareId
     *
     * @param int $shareId
     * @param boolean $isDir : 1 si le fichier à espionner est un répertoire, sinon 0
     *
     * @return int : nombre d'espions créés (0 ou 1 si tout s'est bien passé)
     */
    public function setSpyForShareId ($shareId, $fileId, $isDir) {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'INSERT INTO '.PFX.'thotSharesSpy ';
        $sql .= 'SET shareId=:shareId, fileId=:fileId, isDir=:isDir ';
        $requete = $connexion->prepare($sql);

        $requete->bindParam(':shareId', $shareId, PDO::PARAM_INT);
        $requete->bindParam(':isDir', $isDir, PDO::PARAM_INT);
        $requete->bindParam(':fileId', $fileId, PDO::PARAM_INT);
        $resultat = $requete->execute();

        Application::DeconnexionPDO($connexion);

        return $resultat;
    }

    /**
     * Suppression d'un espion sur le fichier $shareId appartenant à $acronyme
     *
     * @param int $shareId : identifiant du partage
     * @param string $acronyme : identifiant du propriétaire (sécurité)
     *
     * @return int nombre d'informations supprimées
     */
    public function delSpy4ShareId ($shareId, $acronyme) {
        // recherche du spyId pour le partage $shareId
        $fileInfos = $this->getSpyInfo4ShareId ($shareId, $acronyme);
        $spyId = $fileInfos['spyId'];

        // suppression du partage dans la table thotSharesSpy
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'DELETE FROM '.PFX.'thotSharesSpy ';
        $sql .= 'WHERE spyId= :spyId ';
        $requete = $connexion->prepare($sql);
        $requete->bindParam(':spyId', $spyId, PDO::PARAM_INT);
        $requete->execute();

        // suppression des informations récoltées dans la table thotSharesSpyUser
        $sql = 'DELETE FROM '.PFX.'thotSharesSpyUsers ';
        $sql .= 'WHERE spyId= :spyId ';
        $requete = $connexion->prepare($sql);
        $requete->bindParam(':spyId', $spyId, PDO::PARAM_INT);
        $resultat = $requete->execute();

        Application::DeconnexionPDO($connexion);

        return $resultat;
    }

    /**
     * note le téléchargement d'un fichier référence par $spyId par l'utilisateur $acronyme
     * s'il s'agit d'un fichier dans un dossier, $fileId indique le fichier correspondant
     *
     * @param string $acronyme
     * @param int $spyId
     * @param int $fileId (éventuellement Null)
     *
     * @return void()
     */
    public function setSpiedDownload ($acronyme, $spyId, $path=Null, $fileName=Null) {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'INSERT INTO '.PFX.'thotSharesSpyUsers ';
        $sql .= 'SET spyId=:spyId, userName=:acronyme, date=NOW(), userType="prof", ';
        $sql .= 'path=:path, fileName=:fileName ';
        $sql .= 'ON DUPLICATE KEY UPDATE date=NOW() ';

        $path = ($path != Null) ? $path : '';
        $fileName = ($fileName != Null) ? $fileName : '';

        $requete = $connexion->prepare($sql);
        $requete->bindParam(':spyId', $spyId, PDO::PARAM_INT);
        $requete->bindParam(':acronyme', $acronyme, PDO::PARAM_STR, 7);
        $requete->bindParam(':path', $path, PDO::PARAM_STR, 255);
        $requete->bindParam(':fileName', $fileName, PDO::PARAM_STR, 255);
        $resultat = $requete->execute();

        Application::DeconnexionPDO($connexion);

        return ;
    }

    /**
     * retourne la liste des travaux pour l'utilisateur dont on fournit l'acronyme.
     *
     * @param $acronyme
     *
     * @return array
     */
    public function listeTravaux($acronyme, $coursGrp, $statuts=Null)
    {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT idTravail, tt.coursGrp, titre, consigne, dateDebut, dateFin, statut, libelle, nomCours, nbheures ';
        $sql .= 'FROM '.PFX.'thotTravaux AS tt ';
        $sql .= 'JOIN '.PFX."cours AS dc ON SUBSTR(coursGrp, 1, LOCATE('-', coursGrp) -1) = dc.cours ";
        $sql .= 'JOIN '.PFX.'profsCours AS pc ON tt.coursGrp = pc.coursGrp AND tt.acronyme = pc.acronyme ';
        $sql .= "WHERE tt.acronyme='$acronyme' AND tt.coursGrp = '$coursGrp' ";
        if ($statuts != Null) {
            $listeStatuts = "'".implode("','", $statuts)."'";
            $sql .= "AND statut IN ($listeStatuts) ";
        }
        $sql .= 'ORDER BY dateDebut, dateFin,  tt.coursGrp, libelle ';

        $resultat = $connexion->query($sql);
        $liste = array();
        if ($resultat) {
            $resultat->setFetchMode(PDO::FETCH_ASSOC);
            while ($ligne = $resultat->fetch()) {
                $idTravail = $ligne['idTravail'];
                $ligne['dateDebut'] = Application::datePHP($ligne['dateDebut']);
                $ligne['dateFin'] = Application::datePHP($ligne['dateFin']);
                $liste[$idTravail] = $ligne;
            }
        }
        Application::DeconnexionPDO($connexion);

        return $liste;
    }

    /**
     * retourne les caractéristiques générales d'un travail déjà défini dont on fournit le $idTravail ou une structure vide.
     *
     * @param $idTravail : un identifiant ou null
     * @param $acronyme : propriétaire du travail (sécurité)
     * @param $coursGrp : le cours correspondant (nécessaire pour un nouveau travail)
     *
     * @return array
     */
    public function getDataTravail($idTravail, $acronyme, $coursGrp = null)
    {
        $dataTravail = null;
        if ($idTravail != null) {
            $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
            $sql = 'SELECT idTravail, coursGrp, titre, consigne, dateDebut, dateFin, statut, nbPJ ';
            $sql .= 'FROM '.PFX.'thotTravaux ';
            $sql .= 'WHERE idTravail=:idTravail AND acronyme=:acronyme ';
            $requete = $connexion->prepare($sql);
            $data = array(':idTravail' => $idTravail, ':acronyme' => $acronyme);
            $resultat = $requete->execute($data);
            if ($resultat) {
                $requete->setFetchMode(PDO::FETCH_ASSOC);
                $dataTravail = $requete->fetch();
                // le $_COOKIE peut éventuellement contenir l'idTravail d'un travail supprimé
                if (empty($dataTravail)) {
                    return Null;
                }
                $dataTravail['dateDebut'] = Application::datePHP($dataTravail['dateDebut']);
                $dataTravail['dateFin'] = Application::datePHP($dataTravail['dateFin']);
                $dataTravail['max'] = null;
            }

            // recherche des infos % competences évaluées
            $sql = 'SELECT  idCompetence, max, formCert, idCarnet, libelle ';
            $sql .= 'FROM '.PFX.'thotTravauxCompetences AS dtc ';
            $sql .= 'JOIN '.PFX.'bullCompetences AS dbc ON dbc.id = dtc.idCompetence ';
            $sql .= 'WHERE idTravail=:idTravail ';
            $requete = $connexion->prepare($sql);
            $data = array(':idTravail' => $idTravail);
            $resultat = $requete->execute($data);
            $competences = array();
            if ($resultat) {
                $requete->setFetchMode(PDO::FETCH_ASSOC);
                while ($ligne = $requete->fetch()) {
                    $idCompetence = $ligne['idCompetence'];
                    unset($ligne['idCompetence']);
                    $competences[$idCompetence] = $ligne;
                    $dataTravail['max'] += (float) $ligne['max'];
                }
            }

            Application::DeconnexionPDO($connexion);
        }
        if ($dataTravail == null) {
            $dataTravail = array(
                'idTravail' => null,
                'coursGrp' => $coursGrp,
                'consigne' => '',
                'titre' => '',
                'dateDebut' => Application::dateNow(),
                'dateFin' => '',
                'statut' => 'readwrite',
                'competences' => null,
                'formCert' => 'form',
                'libelle' => '',
            );
        } else {
            $dataTravail['competences'] = $competences;
        }

        return $dataTravail;
    }

    /**
     * définition des caractéristqiues d'un nouveau travail.
     *
     * @param $coursGrp : le cours correspondant
     *
     * @return array
     */
    public function setNewTravail($coursGrp)
    {
        $dataTravail = array(
            'idTravail' => null,
            'coursGrp' => $coursGrp,
            'consigne' => '',
            'titre' => '',
            'dateDebut' => Application::dateNow(),
            'dateFin' => '',
            'statut' => 'readwrite',
            'competences' => null,
            'formCert' => 'form',
        );

        return $dataTravail;
    }

    /**
     * retourne la liste de tous les statuts possibles pour un travail
     *
     * @param void
     *
     * @return array
     */
    public function getStatutsTravail () {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = "SHOW COLUMNS FROM '.PFX.'thotTravaux WHERE Field = 'statut' ";
        $resultat = $connexion->query($sql);
        $liste = array();
        if ($resultat) {
            $resultat->setFetchMode(PDO::FETCH_ASSOC);
            $ligne = $resultat->fetch();

            preg_match("/^enum\(\'(.*)\'\)$/", $ligne['Type'], $matches);
            $liste = explode('\',\'', $matches[1]);
        }

        Application::DeconnexionPDO($connexion);

        return $liste;
    }

    /**
     * enregistre les modifications de statuts depuis la boîte modale 'modalArchives.tpl'
     *
     * @param array $form : le formulaire sérializé et parsé
     *
     * @return int : le nombre de modifications enregistrées
     */
    public function saveStatutsFromForm($form) {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'UPDATE '.PFX.'thotTravaux SET statut=:statut ';
        $sql .= 'WHERE idTravail=:idTravail ';
        $requete = $connexion->prepare($sql);

        $resultat = 0;
        foreach ($form AS $field => $statut) {
            $field = explode('_', $field);
            $idTravail = $field[1];
            $requete->bindParam(':idTravail', $idTravail, PDO::PARAM_INT);
            $requete->bindParam(':statut', $statut, PDO::PARAM_STR);
            $resultat += $requete->execute();
        }

        Application::DeconnexionPDO($connexion);

        return $resultat;
    }

    /**
     * Enregistre les nouvelles compétences pour un travail.
     *
     * @param int   $idTravail
     * @param array $idCompetences
     *
     * @return int : nombre de compétences enregistrées
     */
    public function saveNewCompetences ($idTravail, $idCompetences) {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'INSERT INTO '.PFX.'thotTravauxCompetences ';
        $sql .= 'SET idTravail=:idTravail, idCompetence=:idCompetence, max=:max, formCert=:formCert ';
        $sql .= 'ON DUPLICATE KEY UPDATE ';
        $sql .= 'idCompetence=:idCompetence, max=:max, formCert=:formCert ';
        $requete = $connexion->prepare($sql);

        $resultat = 0;
        foreach ($idCompetences as $idCompetence) {
            $max = '';
            $formCert = 'form';
            $data = array(':idTravail' => $idTravail, ':idCompetence' => $idCompetence, ':max' => $max, ':formCert' => $formCert);
            $resultat += $requete->execute($data);
        }

        Application::DeconnexionPDO($connexion);

        return $resultat;
    }

    /**
     * Enregistre les informations générales relatives à un travail.
     *
     * @param array $post : informations provenant du formulaire
     * @param string $acronyme
     *
     * @return array ('idTravail', 'coursGrp', 'date')
     */
    public function saveDataTravail($post, $acronyme) {
        $idTravail = isset($post['idTravail']) ? $post['idTravail'] : null;
        $coursGrp = isset($post['coursGrp']) ? $post['coursGrp'] : null;
        $titre = isset($post['titre']) ? $post['titre'] : null;
        $consigne = isset($post['consigne']) ? $post['consigne'] : null;
        $dateDebut = isset($post['dateDebut']) ? Application::dateMysql($post['dateDebut']) : null;
        $dateFin = isset($post['dateFin']) ? Application::dateMysql($post['dateFin']) : null;
        $statut = isset($post['statut']) ? $post['statut'] : null;
        $nbPJ = isset($post['nbPJ']) ? $post['nbPJ'] : null;

        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        if ($idTravail == null) {
            $sql = 'INSERT INTO '.PFX.'thotTravaux ';
            $sql .= 'SET acronyme = :acronyme, coursGrp = :coursGrp, titre = :titre, ';
            $sql .= 'consigne = :consigne, dateDebut = :dateDebut, dateFin = :dateFin, ';
            $sql .= 'statut = :statut, nbPJ = :nbPJ ';
            $requete = $connexion->prepare($sql);

            $requete->bindParam(':acronyme', $acronyme, PDO::PARAM_STR, 7);
            $requete->bindParam(':coursGrp', $coursGrp, PDO::PARAM_STR, 15);
            $requete->bindParam(':titre', $titre, PDO::PARAM_STR, 40);
            $requete->bindParam(':consigne', $consigne, PDO::PARAM_STR);
            $requete->bindParam(':dateDebut', $dateDebut, PDO::PARAM_STR, 10);
            $requete->bindParam(':dateFin', $dateFin, PDO::PARAM_STR, 10);
            $requete->bindParam(':statut', $statut, PDO::PARAM_STR, 10);
            $requete->bindParam(':nbPJ', $nbPJ, PDO::PARAM_INT);

            $resultat = $requete->execute();
            if ($resultat) {
                $idTravail = $connexion->lastInsertId();
            }
        } else {
            $sql = 'UPDATE '.PFX.'thotTravaux ';
            $sql .= 'SET acronyme = :acronyme, coursGrp = :coursGrp, titre = :titre, ';
            $sql .= 'consigne = :consigne, dateDebut = :dateDebut, dateFin = :dateFin, ';
            $sql .= 'statut = :statut, nbPJ = :nbPJ ';
            $sql .= 'WHERE idTravail = :idTravail AND acronyme = :acronyme ';
            $requete = $connexion->prepare($sql);

            $requete->bindParam(':idTravail', $idTravail, PDO::PARAM_INT);
            $requete->bindParam(':acronyme', $acronyme, PDO::PARAM_STR, 7);
            $requete->bindParam(':coursGrp', $coursGrp, PDO::PARAM_STR, 15);
            $requete->bindParam(':titre', $titre, PDO::PARAM_STR, 40);
            $requete->bindParam(':consigne', $consigne, PDO::PARAM_STR);
            $requete->bindParam(':dateDebut', $dateDebut, PDO::PARAM_STR, 10);
            $requete->bindParam(':dateFin', $dateFin, PDO::PARAM_STR, 10);
            $requete->bindParam(':statut', $statut, PDO::PARAM_STR, 10);
            $requete->bindParam(':nbPJ', $nbPJ, PDO::PARAM_INT);

            $resultat = $requete->execute();
        }

        // lecture des différentes compétences, des cotes max et des formCert
        $competences = array();
        foreach ($post as $champ => $value) {
            if (substr($champ, 0, 10) == 'competence') {
                $competence = explode('_', $champ);
                $n = $competence[1];
                $competences[$n]['idCompetence'] = $value;
            }
            if (substr($champ, 0, 3) == 'max') {
                $max = explode('_', $champ);
                $n = $max[1];
                $competences[$n]['max'] = $value;
            }
            if (substr($champ, 0, 8) == 'formCert') {
                $formCert = explode('_', $champ);
                $n = $formCert[1];
                $competences[$n]['formCert'] = $value;
            }
        }

        // enregistrement des compétences
        $sql = 'INSERT INTO '.PFX.'thotTravauxCompetences ';
        $sql .= 'SET idTravail = :idTravail, idCompetence = :idCompetence, max = :max, formCert = :formCert ';
        $sql .= 'ON DUPLICATE KEY UPDATE ';
        $sql .= 'idCompetence = :idCompetence, max = :max, formCert = :formCert ';
        $requete = $connexion->prepare($sql);

        $requete->bindParam(':idTravail', $idTravail, PDO::PARAM_INT);

        foreach ($competences as $n => $uneCompetence) {
            $idCompetence = $uneCompetence['idCompetence'];
            if ($idCompetence != null) {
                $max = $uneCompetence['max'];
                $formCert = $uneCompetence['formCert'];

                $requete->bindParam(':max', $max, PDO::PARAM_INT);
                $requete->bindParam(':formCert', $formCert, PDO::PARAM_STR, 4);
                $requete->bindParam(':idCompetence', $idCompetence, PDO::PARAM_INT);

                $resultat = $requete->execute();
            }
        }

        Application::DeconnexionPDO($connexion);

        if ($idTravail != null) {
            return array(
                'idTravail' => $idTravail,
                'coursGrp' => $coursGrp,
                'date' => sprintf('%s à %s', Application::dateNow(), Application::timeNow()),
                );
        } else {
            return;
        }
    }

    /**
     * initialise les informations pour la remise des travaux dans la table thotTravauxRemis et dans le répertoire UPLOAD.
     *
     * @param $acronyme : identifiant du prof propriétaire
     * @param $idTravail : l'identifiant du travail
     * @param $listeEleves : array -> la liste des élèves du coursGrp
     *
     * @return int : le nombre d'enregistrements réussis
     */
    public function initTravauxEleves($acronyme, $idTravail, $listeEleves)
    {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'INSERT IGNORE INTO '.PFX.'thotTravauxRemis ';
        $sql .= 'SET matricule=:matricule, idTravail=:idTravail ';
        $requete = $connexion->prepare($sql);
        $nb = 0;

        $ds = DIRECTORY_SEPARATOR;
        $targetPath = INSTALL_DIR.$ds.'upload'.$ds.$acronyme.$ds.'#thot'.$ds.$idTravail.$ds;

        foreach ($listeEleves as $matricule => $data) {
            $data = array(':matricule' => $matricule, ':idTravail' => $idTravail);
            $resultat = $requete->execute($data);
            if ($resultat) {
                // creation des répertoires correspondants pour les dépôts
                @mkdir($targetPath.$matricule, 0700, true);
                ++$nb;
            }
        }
        Application::DeconnexionPDO($connexion);

        return $nb;
    }

    /**
     * retourne la liste des élèves pour un travail dont on fournit le $idTravail;
     * renvoie aussi la cote totale (sommes pour toutes compétences).
     *
     * @param $idTravail
     * @param $acronyme : identité de l'utilisateur (pour la sécurité)
     *
     * @return array
     */
    public function listeTravauxRemis($coursGrp, $idTravail, $acronyme)
    {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT coursGrp, dttr.idTravail, dttr.matricule, remarque, remis, nom, prenom, groupe ';
        $sql .= 'FROM '.PFX.'thotTravauxRemis AS dttr ';
        $sql .= 'JOIN '.PFX.'thotTravaux AS dtt ON dtt.idTravail = dttr.idTravail ';
        $sql .= 'JOIN '.PFX.'eleves AS de ON de.matricule = dttr.matricule ';
        $sql .= 'LEFT JOIN '.PFX.'thotTravauxEvaluations AS dtte ON dtte.matricule = dttr.matricule AND dtte.idTravail = dttr.idTravail ';
        $sql .= 'WHERE dttr.idTravail=:idTravail AND acronyme=:acronyme AND coursGrp=:coursGrp ';
        $sql .= "ORDER BY REPLACE(REPLACE(REPLACE(nom,' ',''),'-',''),'\'',''), prenom ";

        $requete = $connexion->prepare($sql);

        $data = array(':idTravail' => $idTravail, 'acronyme' => $acronyme, 'coursGrp' => $coursGrp);

        $resultat = $requete->execute($data);
        $liste = array();
        if ($resultat) {
            $requete->setFetchMode(PDO::FETCH_ASSOC);
            while ($ligne = $requete->fetch()) {
                $matricule = $ligne['matricule'];
                $liste[$matricule] = $ligne;
            }
        }
        Application::DeconnexionPDO($connexion);

        return $liste;
    }

    /**
     * recherche les sommes des évaluations de tous les élèves pour un travail donné
     *
     * @param $idTravail
     *
     * @return array
     */
    public function getEvaluations4Travail($idTravail)
    {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT dtte.matricule, dtte.idTravail, dtte.idCompetence, dtte.cote, dttc.max, evaluation ';
        $sql .= 'FROM '.PFX.'thotTravauxEvaluations AS dtte ';
        $sql .= 'JOIN '.PFX.'thotTravauxCompetences AS dttc ON dttc.idTravail = dtte.idTravail AND dtte.idCompetence = dttc.idCompetence ';
        $sql .= 'JOIN '.PFX.'thotTravauxRemis AS dttr ON dttr.idTravail = dtte.idTravail AND dttr.matricule = dtte.matricule ';
        $sql .= 'WHERE dtte.idTravail =:idTravail ';

        $requete = $connexion->prepare($sql);

        $requete->bindParam(':idTravail', $idTravail, PDO::PARAM_INT);

        $resultat = $requete->execute();
        $liste = array();
        if ($resultat) {
            $requete->setFetchMode(PDO::FETCH_ASSOC);
            while ($ligne = $requete->fetch()) {
                $matricule = $ligne['matricule'];
                $liste[$matricule]['evaluation'] = $ligne['evaluation'];
                $idCompetence = $ligne['idCompetence'];
                $liste[$matricule]['competences'][$idCompetence] = array('cote' => $ligne['cote'], 'max' => $ligne['max']);
            }
        }

        Application::DeconnexionPDO($connexion);

        $coteNulle = explode(',', COTENULLE);
        // totalisation par compétence
        foreach ($liste as $matricule => $data) {
            foreach ($data['competences'] as $idCompetence => $cotation) {
                if (!(isset($liste[$matricule]['total']))) {
                    $liste[$matricule]['total'] = array('cote' => Null, 'max' => Null);
                    }
                if (is_numeric($cotation['max'])) {
                    if (is_numeric($cotation['cote'])){
                        $liste[$matricule]['total']['cote'] += (float) $cotation['cote'];
                        $liste[$matricule]['total']['max'] += (float) $cotation['max'];
                        }
                    else if (in_array($cotation['cote'], $coteNulle)) {
                        $liste[$matricule]['total']['cote'] += 0;
                        $liste[$matricule]['total']['max'] += (float) $cotation['max'];
                        }
                    }
                }
            }

        return $liste;

    }

    /**
     * enregistre le résultat de l'évaluation d'un travail pour un élève.
     *
     * @param $post : array contenant les informations à enregistrer
     * @param $acronyme : identifiant de l'utilisateur courant (sécurité)
     *
     * @return string : date d'enregistrement
     */
    public function saveEvaluation($post, $evaluation)
    {
        $idTravail = isset($post['idTravail']) ? $post['idTravail'] : null;
        $matricule = isset($post['matricule']) ? $post['matricule'] : null;

        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        // informations générales sur l'évaluation
        $sql = 'INSERT INTO '.PFX.'thotTravauxRemis ';
        $sql .= 'SET idTravail=:idTravail, matricule=:matricule, ';
        $sql .= 'evaluation=:evaluation ';
        $sql .= 'ON DUPLICATE KEY UPDATE ';
        $sql .= 'evaluation=:evaluation ';

        $requete = $connexion->prepare($sql);
        $data = array(
                ':idTravail' => $idTravail,
                ':matricule' => $matricule,
                ':evaluation' => $evaluation,
            );
        $resultat = $requete->execute($data);

        // enregistrement des cotes par compétence
        $sql = 'INSERT INTO '.PFX.'thotTravauxEvaluations ';
        $sql .= 'SET matricule=:matricule, idTravail=:idTravail, idCompetence=:idCompetence, cote=:cote ';
        $sql .= 'ON DUPLICATE KEY UPDATE ';
        $sql .= 'cote=:cote ';

        $requete = $connexion->prepare($sql);
        // on passe tous les champs en revue, à la recherche des cote_xxxxx
        foreach ($post as $field => $value) {
            if (substr($field, 0, 5) == 'cote_') {
                $field = explode('_', $field);
                $idCompetence = $field[1];
                $value = Application::sansVirg($value);
                $data = array(
                    ':idTravail' => $idTravail,
                    ':matricule' => $matricule,
                    ':idCompetence' => $idCompetence,
                    ':cote' => $value,
                );
                $resultat = $requete->execute($data);
            }
        }

        Application::DeconnexionPDO($connexion);

        if ($resultat) {
            return sprintf('%s à %s', Application::dateNow(), Application::timeNow());
        } else {
            return "Problème durant l'enregistremnt";
        }
    }

    /**
     * vérifie que l'utilisateur dont on fournit l'acronyme est propriétaire du travail dont on fournit le $idTravail.
     *
     * @param $acronyme
     * @param $idTravail
     *
     * @return $idTravail : l'identifiant du travail s'il a été trouvé
     */
    public function verifProprietaireTravail($acronyme, $idTravail)
    {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT * FROM '.PFX.'thotTravaux ';
        $sql .= 'WHERE acronyme=:acronyme AND idTravail=:idTravail ';
        $requete = $connexion->prepare($sql);

        $data = array(':acronyme' => $acronyme, ':idTravail' => $idTravail);
        $resultat = $requete->execute($data);
        if ($resultat) {
            $requete->setFetchMode(PDO::FETCH_ASSOC);
            $ligne = $requete->fetch();
        }
        Application::DeconnexionPDO($connexion);

        return $ligne['idTravail'];
    }

    /**
     * retourne le total des cotes max pour un travail donné.
     *
     * @param $idTravail
     *
     * @return array
     */
    public function getCotesMaxTravail($idTravail)
    {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT idCompetence, max ';
        $sql .= 'FROM '.PFX.'thotTravauxCompetences ';
        $sql .= 'WHERE idTravail=:idTravail ';
        $requete = $connexion->prepare($sql);
        $data = array(':idTravail' => $idTravail);
        $resultat = $requete->execute($data);
        $max = null;
        if ($resultat) {
            $requete->setFetchMode(PDO::FETCH_ASSOC);
            while ($ligne = $requete->fetch()) {
                $max += Application::sansVirg($ligne['max']);
            }
        }
        Application::DeconnexionPDO($connexion);

        return $max;
    }

    /**
     * recherche les compétences (et les max cotes) associées à un travail donné.
     *
     * @param $idCompetence
     *
     * @return array
     */
    public function getCompetencesTravail($idTravail)
    {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT idCompetence, libelle, max, idCarnet, formCert, idCarnet ';
        $sql .= 'FROM '.PFX.'thotTravauxCompetences  AS dttc ';
        $sql .= 'JOIN '.PFX.'bullCompetences AS dbc ON dbc.id = dttc.idCompetence ';
        $sql .= 'WHERE idTravail =:idTravail ';
        $sql .= 'ORDER BY ordre, libelle ';

        $requete = $connexion->prepare($sql);
        $liste = array();
        $data = array(':idTravail' => $idTravail);
        $resultat = $requete->execute($data);
        if ($resultat) {
            $requete->setFetchMode(PDO::FETCH_ASSOC);
            while ($ligne = $requete->fetch()) {
                $idCompetence = $ligne['idCompetence'];
                $liste[$idCompetence] = $ligne;
            }
        }

        Application::DeconnexionPDO($connexion);

        return $liste;
    }

    /**
     * recherche des compétences pas encore utilisées pour un travail donné dans un cours donné
     *
     * @param  int  $idTravail
     * @param  int  $coursGrp
     *
     * @return array liste des compétences encore attribuables
     */
    public function listeCompetencesLibresTravail ($idTravail, $coursGrp) {
        // liste des compétences déjà existantes pour ce travail (par $idCompetence)
        if ($idTravail != Null)
            $competencesTravail = $this->getCompetencesTravail($idTravail);
            else $competencesTravail = array();
        // liste des compétences pour ce cours
        $competencesCoursGrp = $this->getCompetencesCoursGrp($coursGrp);

        return array_diff_key($competencesCoursGrp, $competencesTravail);
    }

    /**
     * recherche les informations d'évaluations d'un travail pour un élève donné.
     *
     * @param $idTravail
     * @param $matricule
     *
     * @return array
     */
    public function getEvaluationsTravail($idTravail, $matricule)
    {
        $evaluation = array();

        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT dttr.matricule, dttr.idTravail, remarque, evaluation, remis, dtte.idCompetence, cote, dttc.max ';
        $sql .= 'FROM '.PFX.'thotTravauxRemis AS dttr ';
        $sql .= 'LEFT JOIN '.PFX.'thotTravauxEvaluations AS dtte ON dtte.idTravail = dttr.idTravail AND dtte.matricule = dttr.matricule ';
        $sql .= 'LEFT JOIN '.PFX.'thotTravauxCompetences AS dttc ON dttc.idTravail = dtte.idTravail AND dttc.idCompetence = dtte.idCompetence ';
        $sql .= 'WHERE dttr.idTravail =:idTravail AND dttr.matricule =:matricule ';

        $requete = $connexion->prepare($sql);
        $data = array(':idTravail' => $idTravail, ':matricule' => $matricule);
        $resultat = $requete->execute($data);
        if ($resultat) {
            $requete->setFetchMode(PDO::FETCH_ASSOC);
            // $evaluation = $requete->fetchAll();
            while ($ligne = $requete->fetch()) {
                $evaluation['data'] = $ligne;
                $idCompetence = $ligne['idCompetence'];
                $evaluation['cotes'][$idCompetence] = array('cote' => $ligne['cote'], 'max' => $ligne['max']);
            }
        }

        Application::DeconnexionPDO($connexion);

        return $evaluation;
    }

    /**
     * recherche les détails relatifs à un fichier déposé par l'élève $matricule pour un $idTravail donné.
     *
     * @param $matricule
     * @param $idTravail
     *
     * @return array
     */
    public function getFileInfos($matricule, $idTravail, $acronyme)
    {
        $ds = DIRECTORY_SEPARATOR;
        $dir = INSTALL_DIR.$ds.'upload'.$ds.$acronyme.$ds.'#thot'.$ds.$idTravail.$ds.$matricule;
        $files = @array_diff(scandir($dir), array('..', '.'));

        if ($files != NULL){
            foreach ($files AS $wtf => $oneFile) {
                $infos[] = array(
                    'fileName' => $oneFile,
                    'size' => $this->unitFilesize(filesize($dir.'/'.$oneFile)),
                    'dateRemise' => strftime('%x %X', filemtime($dir.'/'.$oneFile)),
                );
            }
        }
        else {
            $infos = NULL;
        }

        return $infos;
    }

    /**
     * convertit les tailles de fichiers en valeurs usuelles avec les unités.
     *
     * @param $bytes : la taille en bytes
     *
     * @return string : la taille en unités usuelles
     */
    public function unitFilesize($size)
    {
        $precision = ($size > 1024) ? 2 : 0;
        $units = array('octet(s)', 'Ko', 'Mo', 'Go', 'To', 'Po', 'Eo', 'Zo', 'Yo');
        $power = $size > 0 ? floor(log($size, 1024)) : 0;

        return number_format($size / pow(1024, $power), $precision, '.', ',').' '.$units[$power];
    }

    /**
     * construit l'arborescence des fichiers du répertoire $dir fourni.
     *
     * @param string $root : la racine du téléchargement (a priori INSTALL_DIR/upload/$acronyme)
     * @param string $path : le répertoire où se trouve un fichier ou le sous-répertoire à lister
     * @param string $dirName: le sous-répertoire
     * @param string $originalPath : racine locale de l'arborescence
     * Exemple:
     * Array
     *      (
     *      [root] => /home/yves/www/sio2/peda/upload/$acronyme
     *      [path] => /Administration/test
     *      [dirName] => test2
     *      [$originalPath] => /Administration/test/test2
     *      )
     *
     * @return array: arborescence
     */
    public function treeview($root, $path, $dirName, $originalPath)
    {
        // supprimer toutes les occurrences de '/' multiples
        $originalPath = preg_replace('~/+~', '/', $originalPath);
        $path = preg_replace('~/+~', '/', $path);

        $ds = DIRECTORY_SEPARATOR;
        // dans le répertoire upload de l'utilisateur, $chemin désigne le répertoire actuel, sans $root
        $chemin = $path.($path == $ds ? '' : $ds).$dirName;
        $chemin = substr($chemin, strlen($originalPath));

        // stockage séparé des fichiers ordinaires et des répertoires, chacun par ordre alphabétique
        $files = array('files' => array(), 'dir' => array());

        if (file_exists($root.$ds.$path.$ds.$dirName)) {
            $listeFichiers = scandir($root.$ds.$path.$ds.$dirName);

            foreach ($listeFichiers as $unFichier) {
                // Ignorer les fichiers cachés et les répertoires protégés par "#" initial
                if ($unFichier[0] == '.' || $unFichier[0] == '#') {
                    continue;
                }

                $fileName = ($unFichier[0] == $ds ? '' : $ds).$root.$path.($path == $ds ? '' : $ds).$dirName.$ds.$unFichier;
                // rustine
                // $fileName = preg_replace('~/+~', '/', $fileName);

                if (is_dir($fileName)) {
                    // C'est un répertoire
                    $fileInfo = pathinfo($root.$ds.$path.$ds.$unFichier);
                    $files['dir'][] = array(
                        'name' => $fileInfo['basename'],
                        'type' => 'folder',
                        'path' => $chemin,
                        'items' => $this->treeview($root, $path.$ds.$dirName, $unFichier, $originalPath), // appel récursif dans le répertoire
                    );
                } else {
                    // C'est un fichier ordinaire
                    // $fileName = ($fileName[0] != $ds) ? $ds.$fileName : $fileName;
                    $fileInfo = pathinfo($fileName);
                    $files['files'][] = array(
                        'name' => $fileInfo['basename'],
                        'type' => 'file',
                        'path' => $chemin,
                        'size' => $this->unitFilesize(filesize($fileName)),
                        'date' => strftime('%x %X', filemtime($root.$ds.$path.$ds.$dirName.$ds.$fileInfo['basename'])),
                        'ext' => $fileInfo['extension'],
                        'orig' => $originalPath,
                    );
                }
            }
            // fusion des deux tableaux, fichiers ordinaires et répetoires (d'abord les répertoires)
            $files = array_merge($files['dir'], $files['files']);
        }

        return $files;
    }

    /**
     * suppression complète d'un travail d'un prof propriétaire, y compris les documents des élèves.
     *
     * @param $idTravail : identifiant du travail
     * @param $acronyme : identifiant du propriétaire
     *
     * @return bool : true si tout s'est bien passé
     */
    public function delTravail($acronyme, $idTravail)
    {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        // suppression de la liste des travaux après vérification de l'identité du propriétaire
        $sql = 'DELETE FROM '.PFX.'thotTravaux ';
        $sql .= 'WHERE idTravail =:idTravail AND acronyme=:acronyme ';
        $requete = $connexion->prepare($sql);
        $requete->bindParam(':idTravail', $idTravail, PDO::PARAM_INT);
        $requete->bindParam(':acronyme', $acronyme, PDO::PARAM_STR, 7);
        $resultat = $requete->execute();

        if ($resultat) {
            // suppresion de la liste des travaux remis
            $sql = 'DELETE FROM '.PFX.'thotTravauxRemis ';
            $sql .= 'WHERE idTravail =:idTravail ';
            $requete = $connexion->prepare($sql);
            $requete->bindParam(':idTravail', $idTravail, PDO::PARAM_INT);
            $requete->execute();

            // suppression de la liste des travaux évalués
            $sql = 'DELETE FROM '.PFX.'thotTravauxEvaluations ';
            $sql .= 'WHERE idTravail =:idTravail ';
            $requete = $connexion->prepare($sql);
            $requete->bindParam(':idTravail', $idTravail, PDO::PARAM_INT);
            $requete->execute();

            // suppression des compétences affectées à ce travail
            $sql = 'DELETE FROM '.PFX.'thotTravauxCompetences ';
            $sql .= 'WHERE idTravail =:idTravail ';
            $requete = $connexion->prepare($sql);
            $requete->bindParam(':idTravail', $idTravail, PDO::PARAM_INT);
            $requete->execute();

            // effacement des répertoires et des fichiers des élèves
            $ds = DIRECTORY_SEPARATOR;
            $dir = INSTALL_DIR.$ds.'upload'.$ds.$acronyme.$ds.'#thot'.$ds.$idTravail;
        }
        Application::DeconnexionPDO($connexion);

        return $this->delTree($dir);
    }

    /**
     * retourne le nombre de travaux rendus pour un travail dont on fournit le $idTravail.
     *
     * @param $idTravail
     *
     * @return int
     */
    public function getNbTravaux($idTravail)
    {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT count(*) AS nb FROM '.PFX.'thotTravauxRemis ';
        $sql .= "WHERE idTravail = '$idTravail' AND remis = '1' ";

        $resultat = $connexion->query($sql);
        $ligne = $resultat->fetch();
        Application::DeconnexionPDO($connexion);

        return $ligne['nb'];
    }

    /**
     * renvoie la liste des compétences pour un coursGrp donné.
     *
     * @param $coursGrp
     *
     * @return array
     */
    public function getCompetencesCoursGrp($coursGrp)
    {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT id, libelle ';
        $sql .= 'FROM '.PFX.'bullCompetences ';
        $sql .= 'WHERE cours=:cours ';
        $sql .= 'ORDER BY ordre, libelle ';
        $requete = $connexion->prepare($sql);
        $cours = substr($coursGrp, 0, strpos($coursGrp, '-'));

        $data = array(':cours' => $cours);
        $liste = array();
        $resultat = $requete->execute($data);
        if ($resultat) {
            $requete->setFetchMode(PDO::FETCH_ASSOC);
            while ($ligne = $requete->fetch()) {
                $id = $ligne['id'];
                $liste[$id] = $ligne['libelle'];
            }
            Application::DeconnexionPDO($connexion);

            return $liste;
        }
    }

    /**
     * vérifie si une compétence donnée a été cotée pour un travail donné (avant effacement).
     *
     * @param $idTravail : l'identifiant du travail
     * @param $idCompetence: l'identifiant de la compétence
     *
     * @return int le nombre d'occurrence de l'évaluation
     */
    public function nbCompetenceEvaluees($idTravail, $idCompetence)
    {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT count(cote) AS nb ';
        $sql .= 'FROM '.PFX.'thotTravauxEvaluations ';
        $sql .= 'WHERE TRIM(cote) != "" AND idTravail =:idTravail AND idCompetence =:idCompetence ';

        $requete = $connexion->prepare($sql);
        $data = array(':idTravail' => $idTravail, ':idCompetence' => $idCompetence);
        $resultat = $requete->execute($data);
        $nb = 0;
        if ($resultat) {
            $requete->setFetchMode(PDO::FETCH_ASSOC);
            $ligne = $requete->fetch();
            $nb = $ligne['nb'];
        }

        Application::DeconnexionPDO($connexion);

        return $nb;
    }

    /**
     * effacement de la compétence dans la table des travaux remis.
     *
     * @param $idTravail
     * @param $idCompetence
     *
     * @return int : le nombre d'effacements réalisés
     */
    public function delCompTravauxEvaluations($idTravail, $idCompetence)
    {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'DELETE FROM '.PFX.'thotTravauxEvaluations ';
        $sql .= 'WHERE idTravail=:idTravail AND idCompetence=:idCompetence ';
        $requete = $connexion->prepare($sql);
        $data = array(':idTravail' => $idTravail, ':idCompetence' => $idCompetence);
        $resultat = $requete->execute($data);

        Application::DeconnexionPDO($connexion);

        return $resultat;
    }

    /**
     * Effecement des competences dans la table competencesTravaux.
     *
     * @param $idTravail
     * @param $idCompetence
     *
     * @return int
     */
    public function delCompTravaux($idTravail, $idCompetence)
    {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'DELETE FROM '.PFX.'thotTravauxCompetences ';
        $sql .= 'WHERE idTravail=:idTravail AND idCompetence=:idCompetence ';
        $requete = $connexion->prepare($sql);
        $data = array(':idTravail' => $idTravail, ':idCompetence' => $idCompetence);
        $resultat = $requete->execute($data);

        Application::DeconnexionPDO($connexion);

        return $resultat;
    }

    /**
     * création ou récriture de l'entête dans le carnet de cotes pour une compétence donnée.
     *
     * @param $dataTravail : les informations générales concernant le travail, y compris les différentes compétences
     * @param $form : le formulaire de transfert
     *
     * @return int : nombre d'enregistrements
     * */
    public function creerEnteteCarnetCotes($dataTravail, $bulletin, $idCompetence)
    {
        $idCarnet = $dataTravail['competences'][$idCompetence]['idCarnet'];
        $coursGrp = isset($dataTravail['coursGrp']) ? $dataTravail['coursGrp'] : null;
        $idTravail = isset($dataTravail['idTravail']) ? $dataTravail['idTravail'] : null;
        $libelle = $dataTravail['titre'];
        $date = Application::dateMysql(Application::dateNow());
        $max = Application::sansVirg($dataTravail['competences'][$idCompetence]['max']);
        $formCert = $dataTravail['competences'][$idCompetence]['formCert'];

        if (($coursGrp == null) || ($bulletin == null) || ($max == null) || !(is_numeric($max))) {
            die("Erreur d'encodage");
        }

        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        if ($idCarnet != null) {
            $sql = 'INSERT INTO '.PFX.'bullCarnetCotes ';
            $sql .= 'SET idCarnet=:idCarnet, coursGrp=:coursGrp, bulletin=:bulletin, date=:date, ';
            $sql .= 'idComp=:idComp, formCert=:formCert, ';
            $sql .= 'max=:max, libelle=:libelle ';
            $sql .= 'ON DUPLICATE KEY UPDATE ';
            $sql .= 'coursGrp=:coursGrp, bulletin=:bulletin, date=:date, ';
            $sql .= 'idComp=:idComp, formCert=:formCert, ';
            $sql .= 'max=:max, libelle=:libelle, remarque=:remarque ';
        } else {
            $sql = 'INSERT INTO '.PFX.'bullCarnetCotes ';
            $sql .= 'SET coursGrp=:coursGrp, bulletin=:bulletin, date=:date, ';
            $sql .= 'idComp=:idComp, formCert=:formCert, ';
            $sql .= 'max=:max, libelle=:libelle, remarque=:remarque ';
        }

        $requete = $connexion->prepare($sql);
        $data = array(
                ':idComp' => $idCompetence,
                ':coursGrp' => $coursGrp,
                ':bulletin' => $bulletin,
                ':date' => $date,
                ':formCert' => $formCert,
                ':max' => $max,
                ':libelle' => $libelle,
                ':remarque' => 'Depuis le Casier Virtuel'
            );
        if ($idCarnet != null) {
            $data[':idCarnet'] = $idCarnet;
        }

        $resultat = $requete->execute($data);

        if ($idCarnet == null) {
            // noter la valeur de idCarnet pour cette compétence du travail
            $idCarnet = $connexion->lastInsertId();
            $sql = 'UPDATE '.PFX.'thotTravauxCompetences ';
            $sql .= 'SET idCarnet=:idCarnet ';
            $sql .= 'WHERE idCompetence=:idCompetence AND idTravail=:idTravail ';
            $requete = $connexion->prepare($sql);
            $data = array(
                        ':idCarnet' => $idCarnet,
                        ':idCompetence' => $idCompetence,
                        ':idTravail' => $idTravail,
                    );
            $resultat = $requete->execute($data);
        }

        Application::DeconnexionPDO($connexion);

        return $idCarnet;
    }

    /**
     * renvoie un tableau des cotes du Carnet deCotes pour le travail donné et la compétence donnée
     * avec le $idCarnet indiqué (pour être sûr?)
     *
     * @param int $idTravail
     * @param int $idCompetence
     * @param int $idCarnet
     *
     * @return array
     */
    public function getCotes($idTravail, $idCompetence, $idCarnet)
    {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT matricule, cote, max, dtte.idCompetence, dttc.idTravail, idCarnet ';
        $sql .= 'FROM '.PFX.'thotTravauxEvaluations AS dtte ';
        $sql .= 'JOIN '.PFX.'thotTravauxCompetences AS dttc ON dttc.idTravail = dtte.idTravail ';
        $sql .= 'WHERE dtte.idTravail=:idTravail AND dtte.idCompetence =:idCompetence AND idCarnet =:idCarnet ';

        $requete = $connexion->prepare($sql);
        $data = array(
                ':idTravail' => $idTravail,
                ':idCompetence' => $idCompetence,
                ':idCarnet' => $idCarnet,
            );

        $liste = array();
        $resultat = $requete->execute($data);
        if ($resultat) {
            $requete->setFetchMode(PDO::FETCH_ASSOC);
            $liste = $requete->fetchAll();
        }

        Application::DeconnexionPDO($connexion);

        return $liste;
    }

    /**
     * Enregistre les cotes pour toutes les colonnes déverrouillées.
     *
     * @param $listeCotes : tableau des cotes pour le travail
     *
     * @return array liste des erreurs
     */
    public function saveCarnetCotes($listeCotes)
    {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'INSERT INTO '.PFX.'bullCarnetEleves ';
        $sql .= 'SET idCarnet=:idCarnet, matricule=:matricule, cote=:cote ';
        $sql .= 'ON DUPLICATE KEY UPDATE cote=:cote ';
        $requete = $connexion->prepare($sql);

        $n = 0;
        foreach ($listeCotes as $uneCote) {
            $matricule = $uneCote['matricule'];
            $cote = $uneCote['cote'];
            $idCarnet = $uneCote['idCarnet'];
            $requete->bindParam(':idCarnet', $idCarnet, PDO::PARAM_INT);
            $requete->bindParam(':matricule', $matricule, PDO::PARAM_INT);
            $requete->bindParam(':cote', $cote, PDO::PARAM_STR, 6);
            $data = array(':idCarnet' => $idCarnet, ':matricule' => $matricule, ':cote' => $cote);

            $n += $requete->execute();
        }
        Application::DeconnexionPDO($connexion);

        return $n;
    }

    /**
     * retourne les caractéristiques du travail idTravail pour l'élève matricule.
     *
     * @param $idTravail
     * @param $matricule
     *
     * @return array
     */
    public function getResultatTravail($idTravail, $matricule)
    {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);

        // recherche des compétences et des maximas pour ce travail
        $sql = 'SELECT idCompetence, max ';
        $sql .= 'FROM '.PFX.'thotTravauxCompetences ';
        $sql .= 'WHERE idTravail =:idTravail ';

        $requete = $connexion->prepare($sql);
        $requete->bindParam(':idTravail', $idTravail, PDO::PARAM_INT);
        $resultat = $requete->execute();

        $listeCompetences = array();
        if ($resultat) {
            $requete->setFetchMode(PDO::FETCH_ASSOC);
            while ($ligne = $requete->fetch()){
                $idCompetence = $ligne['idCompetence'];
                $listeCompetences[$idCompetence] = $ligne['max'];
            }
        }

        if(count($listeCompetences) != 0)
            {
            // recherche des cotes obenues pour chaque compétences
            $sql = 'SELECT idCompetence, cote ';
            $sql .= 'FROM '.PFX.'thotTravauxEvaluations ';
            $sql .= 'WHERE matricule =:matricule AND idTravail =:idTravail ';

            $requete = $connexion->prepare($sql);
            $requete->bindParam(':matricule', $matricule, PDO::PARAM_INT);
            $requete->bindParam(':idTravail', $idTravail, PDO::PARAM_INT);

            $resultat = $requete->execute();
            $listeResulats = array();
            if ($resultat) {
                $requete->setFetchMode(PDO::FETCH_ASSOC);
                while ($ligne = $requete->fetch()) {
                    $idCompetence = $ligne['idCompetence'];
                    $listeResultats['cotes'][$idCompetence] = array(
                        'cote' => $ligne['cote'],
                        'max' => $listeCompetences[$idCompetence]
                    );
                    }
                }
            }

        // recherche du commentaire professeur pour cette évaluation
        $sql = 'SELECT evaluation, remarque ';
        $sql .= 'FROM '.PFX.'thotTravauxRemis ';
        $sql .= 'WHERE idTravail = :idTravail AND matricule =:matricule ';

        $requete = $connexion->prepare($sql);
        $requete->bindParam(':idTravail', $idTravail, PDO::PARAM_INT);
        $requete->bindParam(':matricule', $matricule, PDO::PARAM_INT);

        $resultat = $requete->execute();
        $commentaire = '';
        if ($resultat) {
            $requete->setFetchMode(PDO::FETCH_ASSOC);
            $ligne = $requete->fetch();
            $commentaire = $ligne['evaluation'];
            $remarque = $ligne['remarque'];
        }
        $listeResultats['commentaire'] = $commentaire;
        $listeResultats['remarque'] = $remarque;

        return $listeResultats;
    }

    /**
     * transformation du chemin contentant "|//|" en array('path'=> ..., 'fileName'=> ...)
     *
     * @param string : $fn
     *
     * @return array
     */
    public function getPathFileName($fn){
        $pfn = explode('|//|', $fn);
        // si le premier élément est un shareId (il y a alors trois composants)
        if (count($pfn) == 3)
            return $pfn[1].$pfn[2];
            else
            return $pfn[0].$pfn[1];
        }

    /**
     * lier des PJ à un journal de classe
     *
     * @param int $idJdc : identifiant du Jdc
     * @param array $post : le formulaire contenant des champs "files'
     * @param string $acronyme : acronyme de l'utilisateur (pour la sécurité)
     *
     * @return int : nombre d'écritures dans la BD
     */
    public function linkFilesJdc($idJdc, $post, $acronyme){
        $files = $post['files'];
        // arrive avec la liste des documents joints (à l'exception de ceux qui ont été dis-joints durant l'édition)
        // et sous la forme $shareId|//|$path|//|$fileName
        // Exemple:
        //     [0] => 1993|//|/|//|10349351_300_451.jpg
        //     [1] => -1|//|/|//|blackhat.png   (nouveau document car s$hareId = -1)

        // recherche des fichiers déjà liés à ce JDC $idJdc avant l'édition
        $linkedFiles = $this->getFileNames4jdc($idJdc, $acronyme);

        // Exemple: avec [$shareId] => $path |//| $fileName
        // [1993] => /|//|10349351_300_451.jpg
        // [1997] => /|//|20140808_144404.jpg

        $toUnShare = $linkedFiles;
        // lesquels peut-on supprimer car dis-joints?
        foreach ($files as $oneFile){
            // le premier élément séparé par |//| est le $shareId
            $shareId = explode('|//|', $oneFile)[0];
            if (in_array($shareId, array_keys($linkedFiles))) {
                unset($toUnShare[$shareId]);
                }
        }

        // à la fin, il ne reste que les fichiers qui n'étaient pas dans le $post
        $this->unlinkShares4Jdc($idJdc, $toUnShare);

        // supprimer de $post['files'] toutes les PJ qui sont déjà liées
        foreach ($files as $n => $fileName) {
            $fileName = explode("|//|", $fileName);
            // suppression du shareId: on ne conserver que le nom du fichier
            unset($fileName[0]);
            $fileName = implode('|//|', $fileName);
            // si le fichier est déjà partagé, on le retire des futures demandes de shareIds
            if (in_array($fileName, $linkedFiles)) {
                unset($files[$n]);
            }
        }

        // rechercher les fileIds pour les fichiers restants à lier ou les créer s'ils n'existent pas encore
        $fileIds = $this->findFileId4FileList($files, $acronyme);
        // Exemple de $fileIds:
        // [0] => 994
        // [1] => 993
        // [2] => 974

        $type = $post['type']; // coursGrp, cours, classe, niveau, ecole...
        $groupe = $post['destinataire'];
        $shareIds = array();

        // établir la liste des shareIds pour les fichiers relatifs à la notification $idJdc
        $shareIds = $this->setShareIds4FileIds($fileIds, $type, $groupe, 'all', 'jdc', $post['date']);

        // Exemple de $shareIds
        //     [994] => 2003
        //     [993] => 2004
        //     [974] => 1994
        //     $fileId => $shareId

        $nb = $this->linkFilesJDCinBD($idJdc, $shareIds);

        return $nb;
    }

    /**
     * lier les PJ à des annonces
     *
     * @param array $listeNotifsIds : liste des notifications ventilées par $matricule des destinataires
     * ou liée au groupe (cours, classe, niveau,...)
     * @param array $post : le formulaire de rédaction de la notification
     * @param string $acronyme : acronyme de l'utilisateur (pour la sécurité)
     *
     * @return array la liste des $shareIds  corresondant aux notifications
     */
    public function linkFilesNotifications($listeNotifId, $post, $acronyme){
        // $listeNotifId est un array contentant
        // $matricule => $notifId
        // $matricule => $notifId
        // ...                      (s'il s'agit d'une édition, un seul élément)
        // ou
        // $groupe => $notifId (dans ce cas, tableau d'un seul élément)

        // on prend le premier élément de la liste des notifIds
        // suffisant pour examiner les fichiers joints, même à une liste d'Élèves
        // qui accéderont aux mêmes documents ensuite
        // s'il s'agit d'une édition, il n'y aura, de toute façon, qu'un seul $notifId
        // dans la liste
        $notifId = current($listeNotifId);
        // la liste des documents joints au formulaire
        $files = $post['files'];
        // arrive avec la liste des documents joints (à l'exception de ceux qui ont
        // été dis-joints durant l'édition) et sous la forme $shareId|//|$path|//|$fileName
        // array (
        //   0 => '4877|//|/img/|//|1587981840.gif',
        //   1 => '4878|//|/img/|//|1587982057.jpeg',
        //   2 => '-1|//|/thot/|//|blabla.pdf',
        // )

        // recherche des fichiers déjà liés à cette $notifId *avant* l'édition
        // ils ont déjà un $shareId, c'est OK pour eux.
        // si ce n'est pas une édition, $linkedFiles revient vide
        $linkedFiles = $this->getFileNames4notifId($notifId, $acronyme);
        // Exemple: $shareId|//|$path|//|$fileName
        // array (
        //   0 => '4877|//|/img/|//|1587981840.gif',
        //   1 => '4878|//|/img/|//|1587982057.jpeg',
        // )

        // tous les fichiers qui étaient liés mais qui ont été enlevés après édition
        // il va falloir supprimer le lien entre le fichier et la notification
        $toUnshare = array_diff($linkedFiles, $files);
        foreach ($toUnshare as $oneFile) {
            // comme il s'agit d'une édition (la preuve, c'est qu'on a supprimé des PJ),
            // un seul $notifId est à considérer
            $shareId = explode('|//|', $oneFile)[0];
            // le shareId est propre à cette notification; aucun autre partage n'est supprimé
            $this->unlinkSharedFiles4Notif($notifId, $shareId);
        }

        // on isole tous les nouveaux fichiers non liés avant l'édition
        // il va falloir leur attribuer un shareId pour la notification
        $newFiles = array_diff($files, $linkedFiles);
        // dans tous les cas, créer un $shareId pour ce nouveau document lié
        // on obtien un tableau du type
        // array (
        //   2 => '-1|//|/repertoire/|//|abc.pdf',
        //   3 => '-1|//|/repertoire/|//|def.pdf',
        // )

        // rechercher les fileIds pour les fichiers à lier
        // ou les créer s'ils n'existent pas encore
        $fileIds = $this->findFileId4FileList($newFiles, $acronyme);

        // où $post['leType'] désigne groupe de destinataires ou, éventuellement, 'eleves' isolés
        $leType = $post['leType']; // groupe, coursGrp, cours, classe, niveau, ecole...

        // $groupe désigne l'identité précise du groupe de destination Ex: "1C1", "1C:INFO2-01", "1234" (pour un élève)
        $groupe = $post['destinataire'];

        $listeShareIds = array();
        // on s'occupe maintenant de chaque notification (dans le cas d'envoi à plusieurs élèves de la même notif)
        // sinon, la listeNotifId ne contient qu'un seul élément
        foreach ($listeNotifId as $destinataire => $notifId) {
            // $listeNotifId se présente sous la forme
            // array (
            //   1234 => '17181',
            //   9999 => '17182',
            // )
            // matricule => notifId
            // ou encore
            // array (
            //   '3Z' => '17183',
            // )
            // 'groupe' => notifId
            //
            // ici, $destinataire est donc soit l'identité du groupe ("3Z", "1C:INFO2-01"),
            // soit un matricule d'élève
            //
            // établir la liste des shareIds pour les fichiers relatifs à ces notifications $listeNotifsIds
            $listeShareIds[$notifId] = $this->setShareIds4FileIds($fileIds, $leType, $groupe, $destinataire, 'annonce', $post['dateDebut']);
        }

        $nb = $this->linkFilesNotifInBD($listeShareIds);

        return $listeShareIds;
    }

    /**
     * renvoie les path/fileName des fichiers liés à un JDC dont on fournit le $idJdc
     *
     * @param int $idJdc : identifiant du jdc
     * @param string $acronyme : identifiant du propriétaire
     *
     * @return array
     */
    public function getFileNames4jdc ($idJdc, $acronyme) {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT dts.shareId, dts.fileId, path, fileName, acronyme ';
        $sql .= 'FROM '.PFX.'thotJdcPJ AS dtjdcpj ';
        $sql .= 'JOIN '.PFX.'thotShares AS dts ON dts.shareId = dtjdcpj.shareId ';
        $sql .= 'JOIN '.PFX.'thotFiles AS dtf ON dtf.fileId = dts.fileId ';
        $sql .= 'WHERE idJdc = :idJdc AND acronyme = :acronyme ';
        $requete = $connexion->prepare($sql);

        $requete->bindParam(':idJdc', $idJdc, PDO::PARAM_INT);
        $requete->bindParam(':acronyme', $acronyme, PDO::PARAM_STR, 7);

        $liste = array();
        $resultat = $requete->execute();
        if ($resultat) {
            $requete->setFetchMode(PDO::FETCH_ASSOC);
            $separator = '|//|';
            while ($ligne = $requete->fetch()){
                $shareId = $ligne['shareId'];
                $liste[$shareId] = $ligne['path'].$separator.$ligne['fileName'];
            }
        }

        Application::deconnexionPDO($connexion);

        return $liste;
    }

    /**
     * renvoie les path/fileName des fichiers liés à une notification dont on fournit le notifId
     *
     * @param int $notifId : identifiant de la notification
     * @param string $acronyme : identifiant du propriétaire
     *
     * @return array
     */
    public function getFileNames4notifId ($notifId, $acronyme) {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT dtnp.shareId, dts.fileId, path, fileName, acronyme ';
        $sql .= 'FROM '.PFX.'thotNotifPJ AS dtnp ';
        $sql .= 'JOIN '.PFX.'thotShares AS dts ON dts.shareId = dtnp.shareId ';
        $sql .= 'JOIN '.PFX.'thotFiles AS dtf ON dtf.fileId = dts.fileId ';
        $sql .= 'WHERE notifId = :notifId AND acronyme = :acronyme ';
        $requete = $connexion->prepare($sql);

        $requete->bindParam(':notifId', $notifId, PDO::PARAM_INT);
        $requete->bindParam(':acronyme', $acronyme, PDO::PARAM_STR, 7);

        $liste = array();
        $resultat = $requete->execute();
        if ($resultat) {
            $requete->setFetchMode(PDO::FETCH_ASSOC);
            $separator = '|//|';
            while ($ligne = $requete->fetch()){
                $shareId = $ligne['shareId'];
                $liste[] = $shareId.$separator.$ligne['path'].$separator.$ligne['fileName'];
            }
        }

        Application::deconnexionPDO($connexion);

        return $liste;
    }

    /**
     * suppresion des liens entre une notification donnée et les fichiers qui n'y sont plus liés
     *
     * @param  int $notifId  la notification impliquée
     * @param  array $shares tableau des shareIds
     *
     * @return void()
     */
    public function unlinkSharedFiles4Notif($notifId, $shareId) {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'DELETE FROM '.PFX.'thotNotifPJ ';
        $sql .= 'WHERE notifId = :notifId AND shareId = :shareId ';
        $requete = $connexion->prepare($sql);

        $requete->bindParam(':notifId', $notifId, PDO::PARAM_INT);
        $requete->bindParam(':shareId', $shareId, PDO::PARAM_INT);

        $resultat = $requete->execute();

        // suppression de la table des partages didac_thotShares
        $sql = 'DELETE FROM '.PFX.'thotShares ';
        $sql .= 'WHERE shareId = :shareId ';
        $requete = $connexion->prepare($sql);

        $requete->bindParam(':shareId', $shareId, PDO::PARAM_INT);

        $resultat = $requete->execute();

        Application::deconnexionPDO($connexion);
    }

    /**
     * suppression des liens entre un JDC et les fichiers qui n'y sont plus liés
     *
     * @param int $idJdc : l'identifiant du JDC impliqué
     * @param array $toUnShare : liste des fichiers à dé-lier sous la forme
     * [1997] => /|//|20140808_144404.jpg
     * [2004] => /|//|6E-2.pdf
     * [$shareId]] => $path|//|$fileName
     *
     * @return int le nombre de liens rompus
     */
    public function unlinkShares4Jdc($idJdc, $toUnShare){
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'DELETE FROM '.PFX.'thotJdcPJ ';
        $sql .= 'WHERE idJdc = :idJdc AND shareId = :shareId ';
        $requete = $connexion->prepare($sql);

        $requete->bindParam(':idJdc', $idJdc, PDO::PARAM_INT);
        $nb = 0;
        foreach ($toUnShare as $shareId => $wtf){
            $requete->bindParam(':shareId', $shareId, PDO::PARAM_INT);
            $nb += $requete->execute();
        }
        $nb = 0;
        // suppression des fichiers partagés
        $sql = 'DELETE FROM '.PFX.'thotShares ';
        $sql .= 'WHERE shareId = :shareId ';
        $requete = $connexion->prepare($sql);
        foreach ($toUnShare as $shareId => $wtf){
            $requete->bindParam(':shareId', $shareId, PDO::PARAM_INT);
            $nb += $requete->execute();
        }

        Application::deconnexionPDO($connexion);

        return $nb;
    }

    /**
     * retourne les fileId's (en les créant éventuellement) pour la liste des fichiers données
     * Les noms des fichiers sont donnés sous la forme path|//|fileName
     * Le tableau renvoyé est du type
     *         [0] => fileId 1
     *         [1] => fileId 2
     *         [2] => fileId 3
     *
     * @param array $fileList : liste des fichiers
     * @param string $acronyme : le propriétaire
     *
     * @return array liste des fileIds correspondant aux fichiers
     */
    public function findFileId4FileList($fileList, $acronyme) {
        $fileIds = array();
        foreach ($fileList as $pathFileName) {
            $pathFileName = explode('|//|', $pathFileName);
            // si le fichier n'a pas encore de $fileId
            if ($pathFileName[0] == -1) {
                $path = $pathFileName[1];
                $fileName = $pathFileName[2];
                // retrouver le fileId existant ou définir un fileId -paramètre "true"
                $fileIds[] = $this->findFileId($path, $fileName, 'file', $acronyme, true);
            }
            else $fileIds[] = $pathFileName[0];
        }

        return $fileIds;
    }

    /**
     * renvoie la liste des shareIds pour la liste des fileIds passée en argument.
     * le cas échéant, les shareIds sont créés (sauf s'ils existent déjà)
     * @param array $fileIds      liste des fileIds
     * @param string $type        type de partage (coursGrp, classe, niveau,...)
     * @param string $groupe      groupe impliqué dans le partage (2CA, 2C:INFO2-07,...)
     * @param string $destinataire destinataire précis dans le groupe (son matricule) ou le groupe en entier (all)
     * @param string $appli : 'jdc' ou 'annonce'
     *
     * @return array la lsite des shareIds pour chaque $fileId
     */
    public function setShareIds4FileIds($fileIds, $type, $groupe, $destinataire, $appli, $date) {
        // recherche des shareIds existants
        $shareIds = $this->getExistingShares4FileIds($fileIds, $type, $groupe, $destinataire);
        // ajout des shareIds nouveaux
        $shareIds = $this->setNewShares4FilesIds($shareIds, $type, $groupe, $destinataire, $appli, $date);
        return $shareIds;
    }

    /**
     * recherche les shareIds déjà existants dans la BD pour le fileIds donnés avec les caractéristiques données
     * @param  array $fileIds       liste des fileIds
     * @param  string $type         type de partage de fichiers (coursGrp, classe, niveau,...)
     * @param  string $groupe       groupe impliqué dans le partage (2CA, 2C:INFO2-07,...)
     * @param  string $destinataire destinataire précis dans le groupe (son matricule) ou le groupe en entier (2CA, 2C:INFO2-07,...)
     *
     * @return array liste des shareIds indexés sur les filesIds
     */
    public function getExistingShares4FileIds($fileIds, $type, $groupe, $destinataire) {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT fileId, shareId, type, groupe, destinataire ';
        $sql .= 'FROM '.PFX.'thotShares ';
        $sql .= 'WHERE fileId = :fileId AND type = :type AND groupe = :groupe AND destinataire = :destinataire ';

        $requete = $connexion->prepare($sql);
        $shareIds = array();
        $requete->bindParam(':type', $type, PDO::PARAM_STR, 15);
        $requete->bindParam(':groupe', $groupe, PDO::PARAM_STR, 15);
        $requete->bindParam(':destinataire', $destinataire, PDO::PARAM_STR, 15);

        foreach ($fileIds as $fileId) {
            $requete->bindParam(':fileId', $fileId, PDO::PARAM_INT);
            $shareIds[$fileId] = Null;
            $resultat = $requete->execute();
            if ($resultat) {
                $requete->setFetchMode(PDO::FETCH_ASSOC);
                $ligne = $requete->fetch();
                $shareId = $ligne['shareId'];
                $shareIds[$fileId] = $shareId;
            }
        }

        Application::deconnexionPDO($connexion);

        return $shareIds;
    }

    /**
     * création de nouveaux shareIds pour les fileIds passés en argument avec les caractéristiques données
     *
     * @param array $shareIds     liste des shareIds indexées sur les fileIds déjà construite avec les shareIds déjà en BD
     * @param  string $type         type de partage de fichiers (coursGrp, classe, niveau,...)
     * @param  string $groupe       groupe impliqué dans le partage (2CA, 2C:INFO2-07,...)
     * @param  string $destinataire destinataire précis dans le groupe (son matricule) ou le groupe en entier (all)
     *
     * @return array la liste des shareIds indexées sur les fileIds
     */
    public function setNewShares4FilesIds($shareIds, $type, $groupe, $destinataire, $appli, $date) {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'INSERT INTO '.PFX.'thotShares ';
        $sql .= 'SET fileId = :fileId, type = :type, groupe = :groupe, destinataire = :destinataire, commentaire = :commentaire ';

        $requete = $connexion->prepare($sql);
        switch ($appli) {
            case 'jdc':
                $commentaire = sprintf('Document lié au JDC du %s de %s', $date, $groupe);
                break;
            case 'annonce':
                $commentaire = sprintf('Document lié à une annonce du %s de %s', $date, $groupe);
                break;
            default:  // ne devrait jamais se produire
                $commentaire = Null;
                break;
        }

        // bidouille ------------------------------------------------------------------------------
        // la table thotShares admet le type "classeS" plutôt que "classe" (au singulier)
        if ($type == 'classe')
            $type = 'classes';
        // bidouille ------------------------------------------------------------------------------
        //
        if ($groupe == $destinataire)
            $destinataire = 'all';
        $requete->bindParam(':type', $type, PDO::PARAM_STR, 15);
        $requete->bindParam(':groupe', $groupe, PDO::PARAM_STR, 15);
        $requete->bindParam(':destinataire', $destinataire, PDO::PARAM_STR, 15);
        $requete->bindParam(':commentaire', $commentaire, PDO::PARAM_STR, 35);
        foreach ($shareIds as $fileId => $data) {
            // si on n'a pas encore de valeur de shareId (nouveau fichier)
            if ($data == NULL) {
                $requete->bindParam(':fileId', $fileId, PDO::PARAM_INT);
                $resultat = $requete->execute();
                $shareId = $connexion->lastInsertId();
                $shareIds[$fileId] = $shareId;
            }
        }

        Application::deconnexionPDO($connexion);

        return $shareIds;
    }

    /**
     * note les liens entres le fichiers joints et les notifications dans la BD
     *
     * @param array $shareIds : liste des $notifIds et des shareIds correspondants
     *
     * @return int : nombre d'écritures dans la BD
     */
    public function linkFilesNotifInBD($shareIds) {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);

        $sql = 'INSERT INTO '.PFX.'thotNotifPJ ';
        $sql .= 'SET notifId= :notifId, shareId= :shareId ';
        $requete = $connexion->prepare($sql);

        $nb = 0;
        foreach ($shareIds AS $notifId => $listeShares) {
            $requete->bindParam(':notifId', $notifId, PDO::PARAM_INT);
            foreach ($listeShares AS $wtf => $shareId) {
                $requete->bindParam(':shareId', $shareId, PDO::PARAM_INT);
                $resultat = $requete->execute();
                if ($resultat == true)
                    $nb++;
                }
            }

        Application::DeconnexionPDO($connexion);

        return $nb;
    }

    /**
     * note les liens entres le fichiers joints et le JDC dans la BD
     *
     * @param array $shareIds : liste des $notifIds et des shareIds correspondants
     *
     * @return int : nombre d'écritures dans la BD
     */
    public function linkFilesJDCinBD($idJdc, $shareIds) {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);

        $sql = 'INSERT INTO '.PFX.'thotJdcPJ ';
        $sql .= 'SET idJdc= :idJdc, shareId= :shareId ';
        $requete = $connexion->prepare($sql);

        $requete->bindParam(':idJdc', $idJdc, PDO::PARAM_INT);
        $nb = 0;
        foreach ($shareIds AS $fileId => $shareId) {
                $requete->bindParam(':shareId', $shareId, PDO::PARAM_INT);
                $resultat = $requete->execute();
                if ($resultat == true)
                    $nb++;
            }

        Application::DeconnexionPDO($connexion);

        return $nb;
    }

    /**
     * suppression de toutes les PJ liées à un JDC
     *
     * @param int $idJdc : l'identifiant du JDC
     *
     * @return int le nombre de suppressions
     */
    public function unlinkAllFiles4Jdc($idJdc){
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'DELETE FROM '.PFX.'thotJdcPJ ';
        $sql .= 'WHERE idJdc = :idJdc ';
        $requete = $connexion->prepare($sql);

        $requete->bindParam(':idJdc', $idJdc, PDO::PARAM_INT);

        $nb = $requete->execute();
        // combien de suppressions?
        $n = $requete->rowCount();

        Application::DeconnexionPDO($connexion);

        return $n;
    }

    /**
     * suppression de toutes les PJ liées aux annonces dont on fournit la liste des identifiants
     *
     * @param array $listeNotifId
     *
     * @return bool
     */
    public function unlinkAllFiles4Notif($listeNotifId, $acronyme) {
        $listeNotifIdString = implode(',', array_keys($listeNotifId));
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);

        // recherche préalable des $shareId pour les fichiers joints à la notification $notifId
        $sql = 'SELECT shareId FROM '.PFX.'thotNotifPJ ';
        $sql .= 'WHERE notifId IN ('.$listeNotifIdString.') ';
        $requete = $connexion->prepare($sql);

        $resultat = $requete->execute();
        $listeShareIds = array();
        if ($resultat) {
            $requete->setFetchMode(PDO::FETCH_ASSOC);
            while ($ligne = $requete->fetch()){
                $shareId = $ligne['shareId'];
                $listeShareIds[$shareId] = $shareId;
            }
        }
        $listeShareIdsString = implode(',', $listeShareIds);

        // suppression des shares pour la notification $notifId
        // les $shareIds sont propres aux notifications; aucun autre partage n'est supprimé
        $sql = 'DELETE FROM '.PFX.'thotShares ';
        $sql .= 'WHERE shareId IN ('.$listeShareIdsString.') ';
        $requete = $connexion->prepare($sql);

        $resultat = $requete->execute();
        $nb = $requete->rowCount();

        // suppression des témoins de téléchargement des fichiers joints
        // recherche des spyIds des fichiers en suivi de téléchargement pour cette notif
        // la liste des fichiers est dans $listeShareIdsString
        $sql = 'SELECT spyId FROM '.PFX.'thotSharesSpy ';
        $sql .= 'WHERE shareId IN ('.$listeShareIdsString.') ';
        $requete = $connexion->prepare($sql);

        $resultat = $requete->execute();
        $listeSpyIds = array();
        if ($resultat) {
            $requete->setFetchMode(PDO::FETCH_ASSOC);
            while ($ligne = $requete->fetch()){
                $spyId = $ligne['spyId'];
                $listeSpyIds[$shareId] = $spyId;
            }
        }
        $listeSpyIdsString = implode(',', $listeSpyIds);

        // suppression des témoins dans la table thotSharesSpyUsers
        $sql = 'DELETE FROM '.PFX.'thotSharesSpyUsers ';
        $sql .= 'WHERE spyId IN ('.$listeSpyIdsString.') ';
        $requete = $connexion->prepare($sql);

        $resultat = $requete->execute();

        // suppression des demandes de témoins
        $sql = 'DELETE FROM '.PFX.'thotSharesSpy ';
        $sql .= 'WHERE shareId IN ('.$listeShareIdsString.') ';
        $requete = $connexion->prepare($sql);

        $resultat = $requete->execute();

        Application::DeconnexionPDO($connexion);

        return $nb;
    }

    /**
     * renvoie la listes des shareId correspondant à chacun des fichiers paratages sur
     * une notification
     *
     * @param array $listeNotifId
     *
     * @return array $listeShares
     */
    public function getListeShares4listeNotifId($listeNotifId) {
        $listeNotifIdString = implode(',', $listeNotifId);
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT shareId FROM '.PFX.'thotNotifPJ ';
        $sql .= 'WHERE notifId IN ('.$listeNotifIdString.') ';
        $requete = $connexion->prepare($sql);

        $liste = array();
        $resultat = $requete->execute();
        if ($resultat) {
            $requete->setFetchMode(PDO::FETCH_ASSOC);
            while ($ligne = $requete->fetch()){
                $liste[] = $ligne['shareId'];
            }
        }

        Application::DeconnexionPDO($connexion);

        return $liste;
    }

    /**
     * nettoie le nom d'un fichier de ses caractères accentués
     *
     * @param srting : $fileName
     *
     * @return string
     */
    public function cleanFileName($fileName){
        $unwanted_array = array(
            'Š'=>'S', 'š'=>'s', 'Ž'=>'Z', 'ž'=>'z', 'À'=>'A', 'Á'=>'A', 'Â'=>'A', 'Ã'=>'A', 'Ä'=>'A', 'Å'=>'A', 'Æ'=>'A', 'Ç'=>'C', 'È'=>'E', 'É'=>'E',
            'Ê'=>'E', 'Ë'=>'E', 'Ì'=>'I', 'Í'=>'I', 'Î'=>'I', 'Ï'=>'I', 'Ñ'=>'N', 'Ò'=>'O', 'Ó'=>'O', 'Ô'=>'O', 'Õ'=>'O', 'Ö'=>'O', 'Ø'=>'O', 'Ù'=>'U',
            'Ú'=>'U', 'Û'=>'U', 'Ü'=>'U', 'Ý'=>'Y', 'Þ'=>'B', 'ß'=>'Ss', 'à'=>'a', 'á'=>'a', 'â'=>'a', 'ã'=>'a', 'ä'=>'a', 'å'=>'a', 'æ'=>'a', 'ç'=>'c',
            'è'=>'e', 'é'=>'e', 'ê'=>'e', 'ë'=>'e', 'ì'=>'i', 'í'=>'i', 'î'=>'i', 'ï'=>'i', 'ð'=>'o', 'ñ'=>'n', 'ò'=>'o', 'ó'=>'o', 'ô'=>'o', 'õ'=>'o',
            'ö'=>'o', 'ø'=>'o', 'ù'=>'u', 'ú'=>'u', 'û'=>'u', 'ý'=>'y', 'þ'=>'b', 'ÿ'=>'y' );
        $str = strtr( $str, $unwanted_array );
        return $str;
    }

    /**
     * renvoie les caractéristiques du fichier (type = 'dir'|'file', path, filename) dont on donne le fileId
     *
     * @param int $fileId
     *
     * @return array
     */
    public function getFileFromfileId ($fileId) {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT acronyme, path, fileName, dirOrFile ';
        $sql .= 'FROM '.PFX.'thotFiles ';
        $sql .= 'WHERE fileId = :fileId ';
        $requete = $connexion->prepare($sql);

        $requete->bindParam(':fileId', $fileId, PDO::PARAM_INT);

        $file = array();
        $resultat = $requete->execute();
        if ($resultat) {
            $requete->setFetchMode(PDO::FETCH_ASSOC);
            $file = $requete->fetch();
        }

        Application::DeconnexionPDO($connexion);

        return $file;
    }

}
