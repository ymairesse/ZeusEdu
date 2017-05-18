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
      * recherche de le fileId existant d'un fichier dont on fournit le nom et le path ou insère les données et retourne le nouveau fileId.
      *
      * @param $fileName : le nom du fichier
      * @param $path : le path
      * @param $acronyme : l'abréviation de l'utilisateur actif
      * @param $create : si false, on ne crée pas l'enregistrement en cas d'échec de la recherche
      *
      * @return int
      */
     public function findFileId($path, $fileName, $acronyme, $create = false)
     {
         $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
         // recherche d'un éventuel 'fileId' existant pour le fichier
         $sql = 'SELECT fileId ';
         $sql .= 'FROM '.PFX.'thotFiles ';
         $sql .= 'WHERE path=:path AND fileName=:fileName AND acronyme=:acronyme ';
         $requete = $connexion->prepare($sql);

         $data = array(':path' => $path, ':fileName' => $fileName, ':acronyme' => $acronyme);
         $resultat = $requete->execute($data);
         $fileId = null;
         if ($resultat) {
             $ligne = $requete->fetch();
             $fileId = $ligne['fileId'];
         }

         // si on n'a pas trouvé d'enregistrement dans la BD, on crée éventuellement cet enregistrement
         if (($fileId == null) && ($create == true)) {
             $sql = 'INSERT INTO '.PFX.'thotFiles ';
             $sql .= 'SET acronyme=:acronyme, path=:path, fileName=:fileName ';
             $requete = $connexion->prepare($sql);
             $data = array(':acronyme' => $acronyme, ':path' => $path, ':fileName' => $fileName);
             $resultat = $requete->execute($data);
             $fileId = $connexion->lastInsertId();
         }

         Application::DeconnexionPDO($connexion);

         return $fileId;
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
     * retourne la liste des partages d'un fichier dont on fournit le propriétaire, le path et le fileName.
     *
     * @param $path
     * @param $fileName
     * @param $acronyme
     *
     * @return array
     */
    public function getSharesByFileName($path, $fileName, $acronyme)
    {
        $fileId = $this->findFileId($path, $fileName, $acronyme, false);  // ne pas créer l'enregistrement
        return $this->getSharesByFileId($fileId);
    }

    /**
     * retourne la liste des partages d'un fichier dont on founrnit le fileId dans la table des fichiers.
     *
     * @param $fileId
     *
     * @return array
     */
    public function getSharesByfileId($fileId)
    {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT type, share.groupe, destinataire, commentaire, fileId, shareId, ';
        $sql .= 'dp.nom AS nomProf, dp.prenom AS prenomProf, de.nom AS nomEleve, de.prenom AS prenomEleve, ';
        $sql .= 'de.groupe AS classe, dc.libelle, pc.nomCours ';
        $sql .= 'FROM '.PFX.'thotShares as share ';
        $sql .= 'LEFT JOIN '.PFX.'profs AS dp ON dp.acronyme = share.destinataire ';
        $sql .= 'LEFT JOIN '.PFX.'eleves AS de ON de.matricule = share.destinataire ';
        $sql .= 'LEFT JOIN '.PFX."cours AS dc ON dc.cours = SUBSTR(share.groupe, 1, LOCATE ('-', share.groupe)-1) ";
        $sql .= 'LEFT JOIN '.PFX.'profsCours AS pc ON pc.coursGrp = share.groupe ';
        $sql .= "WHERE fileId = '$fileId' ";
        $sql .= 'ORDER BY type, share.groupe, destinataire ';

        $resultat = $connexion->query($sql);
        $liste = array();
        if ($resultat) {
            $resultat->setFetchMode(PDO::FETCH_ASSOC);
            while ($ligne = $resultat->fetch()) {
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
    public function getSharedfileById($fileId)
    {
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
     * Enregistrement du partage d'un fichier.
     *
     * @param $post : contenu du formulaire
     *
     * @return int : identifiant de l'enregistrement du ficher partagé
     */
    public function share($post, $acronyme)
    {
        $fileName = $post['fileName'];
        $path = $post['path'];
        // retrouver le fileId existant ou définir un fileId -paramètre "true"
        $fileId = $this->findFileId($path, $fileName, $acronyme, true);

        $type = $post['type'];
        $groupe = $post['groupe'];
        $commentaire = $post['commentaire'];
        $tous = isset($post['TOUS']) ? $post['TOUS'] : null;
        $membres = isset($post['membres']) ? $post['membres'] : null;

        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        // enregistrer les partages
        $sql = 'INSERT INTO '.PFX.'thotShares ';
        $sql .= 'SET fileId=:fileId, type=:type, groupe=:groupe, destinataire=:destinataire, commentaire=:commentaire ';
        $sql .= 'ON DUPLICATE KEY UPDATE commentaire=:commentaire ';

        $requete = $connexion->prepare($sql);
        $resultat = 0;
        $data = array(':fileId' => $fileId, ':type' => $type, ':groupe' => $groupe, ':commentaire' => $commentaire);

        // si le destinataire est tout le groupe
        if ($tous != null) {
            $data[':destinataire'] = 'all';
            $resultat = $requete->execute($data);
        } else {
            // sinon, indiquer chaque membre du groupe comme destinataire
            if ($membres != null) {
                foreach ($membres as $unMembre) {
                    $data[':destinataire'] = $unMembre;
                    $resultat += $requete->execute($data);
                }
            }
        }
        Application::DeconnexionPDO($connexion);

        return $fileId;
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
    public function delAllShares($path, $fileName, $acronyme)
    {
        $fileId = $this->findFileId($path, $fileName, $acronyme, false);

        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'DELETE FROM '.PFX.'thotShares ';
        $sql .= "WHERE fileId='$fileId' ";
        $resultat = $connexion->exec($sql);
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
     * @param $commentaire : stringType
     * @param $shareId : l'identifiant du partage
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
        $data = array(':commentaire' => $commentaire, ':shareId' => $shareId);
        $resultat = $requete->execute($data);
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
        $sql .= 'WHERE path=:path AND fileName=:fileName AND acronyme=:acronyme ';
        $requete = $connexion->prepare($sql);
        $data = array(':path' => $path, ':fileName' => $fileName, ':acronyme' => $acronyme);
        $resultat = $requete->execute($data);
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
            $sql .= "WHERE shareId = '$shareId' ";
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
                    case 'classe':
                        if ($ligne['destinataire'] == 'all') {
                            $liste[] = 'Tous les élèves de '.$ligne['groupe'];
                        } else {
                            $liste[] = sprintf('%s: %s %s', $ligne['groupe'], $ligne['nom'], $ligne['prenom']);
                        }
                        break;
                    case 'cours':
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
     * renvoie tous les noms de fichiers (avec les répertoires) inclus dans l'arboresence indiquée.
     *
     * @param $root : emplacement du répertoire d'upload sur le serveur
     * @param $upload:
     *
     * @return array
     */
    public function getAllFilesFrom($root, $upload)
    {
        $path = $root.$upload;
        $directory = new \RecursiveDirectoryIterator($path);
        $iterator = new \RecursiveIteratorIterator($directory);
        $files = array();
        foreach ($iterator as $info) {
            $dir = $info->getPath();
            $fileName = $info->getFilename();
            if ($fileName != '..') {
                $files[] = array('path' => $dir, 'fileName' => $fileName);
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
        $sql = 'SELECT share.shareId, share.fileId, groupe, destinataire, commentaire, path, fileName, ';
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
                        // 'fileId'=>$fileId,
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
     * retourne la liste des travaux pour l'utilisateur dont on fournit l'acronyme.
     *
     * @param $acronyme
     *
     * @return array
     */
    public function listeTravaux($acronyme, $coursGrp)
    {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT idTravail, tt.coursGrp, titre, consigne, dateDebut, dateFin, statut, libelle, nomCours, nbheures ';
        $sql .= 'FROM '.PFX.'thotTravaux AS tt ';
        $sql .= 'JOIN '.PFX."cours AS dc ON SUBSTR(coursGrp, 1, LOCATE('-', coursGrp) -1) = dc.cours ";
        $sql .= 'JOIN '.PFX.'profsCours AS pc ON tt.coursGrp = pc.coursGrp AND tt.acronyme = pc.acronyme ';
        $sql .= "WHERE tt.acronyme='$acronyme' AND tt.coursGrp = '$coursGrp' ";
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
            $sql = 'SELECT idTravail, coursGrp, titre, consigne, dateDebut, dateFin, statut ';
            $sql .= 'FROM '.PFX.'thotTravaux ';
            $sql .= 'WHERE idTravail=:idTravail AND acronyme=:acronyme ';
            $requete = $connexion->prepare($sql);
            $data = array(':idTravail' => $idTravail, ':acronyme' => $acronyme);
            $resultat = $requete->execute($data);
            if ($resultat) {
                $requete->setFetchMode(PDO::FETCH_ASSOC);
                $dataTravail = $requete->fetch();
                $dataTravail['dateDebut'] = Application::datePHP($dataTravail['dateDebut']);
                $dataTravail['dateFin'] = Application::datePHP($dataTravail['dateFin']);
                $dataTravail['max'] = null;
            }

            // recherche des infos % competences évaluées
            $sql = 'SELECT  idCompetence, max, formCert, idCarnet ';
            $sql .= 'FROM '.PFX.'thotTravauxCompetences ';
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
                    $dataTravail['max'] += $ligne['max'];
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
     * @param $post : informations provenant du formulaire
     *
     * @return array ('idTravail', 'coursGrp')
     */
    public function saveDataTravail($post, $acronyme)
    {
        $idTravail = isset($post['idTravail']) ? $post['idTravail'] : null;
        $coursGrp = isset($post['coursGrp']) ? $post['coursGrp'] : null;
        $titre = isset($post['titre']) ? $post['titre'] : null;
        $consigne = isset($post['consigne']) ? $post['consigne'] : null;
        $dateDebut = isset($post['dateDebut']) ? Application::dateMysql($post['dateDebut']) : null;
        $dateFin = isset($post['dateFin']) ? Application::dateMysql($post['dateFin']) : null;
        $statut = isset($post['statut']) ? $post['statut'] : null;

        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        if ($idTravail == null) {
            $sql = 'INSERT INTO '.PFX.'thotTravaux ';
            $sql .= 'SET acronyme=:acronyme, coursGrp=:coursGrp, titre=:titre, ';
            $sql .= 'consigne=:consigne, dateDebut=:dateDebut, dateFin=:dateFin, statut=:statut ';

            $requete = $connexion->prepare($sql);
            $data = array(
                ':acronyme' => $acronyme,
                ':coursGrp' => $coursGrp,
                ':titre' => $titre,
                ':consigne' => $consigne,
                ':dateDebut' => $dateDebut,
                ':dateFin' => $dateFin,
                ':statut' => $statut,
            );
            $resultat = $requete->execute($data);
            if ($resultat) {
                $idTravail = $connexion->lastInsertId();
            }
        } else {
            $sql = 'UPDATE '.PFX.'thotTravaux ';
            $sql .= 'SET acronyme=:acronyme, coursGrp=:coursGrp, titre=:titre, ';
            $sql .= 'consigne=:consigne, dateDebut=:dateDebut, dateFin=:dateFin, statut=:statut ';
            $sql .= 'WHERE idTravail=:idTravail AND acronyme=:acronyme ';

            $requete = $connexion->prepare($sql);
            $data = array(
                ':idTravail' => $idTravail,
                ':acronyme' => $acronyme,
                ':coursGrp' => $coursGrp,
                ':titre' => $titre,
                ':consigne' => $consigne,
                ':dateDebut' => $dateDebut,
                ':dateFin' => $dateFin,
                ':statut' => $statut,
            );

            $resultat = $requete->execute($data);
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
        $sql .= 'SET idTravail=:idTravail, idCompetence=:idCompetence, max=:max, formCert=:formCert ';
        $sql .= 'ON DUPLICATE KEY UPDATE ';
        $sql .= 'idCompetence=:idCompetence, max=:max, formCert=:formCert ';

        $requete = $connexion->prepare($sql);
        foreach ($competences as $n => $uneCompetence) {
            $idCompetence = $uneCompetence['idCompetence'];
            if ($idCompetence != null) {
                $max = $uneCompetence['max'];
                $formCert = $uneCompetence['formCert'];
                $data = array(':idTravail' => $idTravail, ':idCompetence' => $idCompetence, ':max' => $max, ':formCert' => $formCert);
                $resultat = $requete->execute($data);
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
    public function listeTravauxRemis($idTravail, $acronyme)
    {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT dttr.idTravail, dttr.matricule, remis, nom, prenom, groupe, dtte.idCompetence, dtte.cote ';
        $sql .= 'FROM '.PFX.'thotTravauxRemis AS dttr ';
        $sql .= 'JOIN '.PFX.'thotTravaux AS dtt ON dtt.idTravail = dttr.idTravail ';
        $sql .= 'JOIN '.PFX.'eleves AS de ON de.matricule = dttr.matricule ';
        $sql .= 'LEFT JOIN '.PFX.'thotTravauxEvaluations AS dtte ON dtte.matricule = dttr.matricule AND dtte.idTravail = dttr.idTravail ';
        $sql .= 'WHERE dttr.idTravail=:idTravail AND acronyme=:acronyme ';
        $sql .= "ORDER BY REPLACE(REPLACE(REPLACE(nom,' ',''),'-',''),'\'',''), prenom ";
        $requete = $connexion->prepare($sql);
        $data = array(':idTravail' => $idTravail, 'acronyme' => $acronyme);

        $resultat = $requete->execute($data);
        $liste = array();
        if ($resultat) {
            $requete->setFetchMode(PDO::FETCH_ASSOC);
            while ($ligne = $requete->fetch()) {
                $matricule = $ligne['matricule'];
                if (isset($liste[$matricule])) {
                    $liste[$matricule]['total'] += Application::sansVirg($ligne['cote']);
                } else {
                    $liste[$matricule] = $ligne;
                    $liste[$matricule]['total'] = Application::sansVirg($ligne['cote']);
                }
            }
        }
        Application::DeconnexionPDO($connexion);

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
        $statutEleve = 'evalue';

        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        // informations générales sur l'évaluation
        $sql = 'INSERT INTO '.PFX.'thotTravauxRemis ';
        $sql .= 'SET idTravail=:idTravail, matricule=:matricule, ';
        $sql .= 'evaluation=:evaluation, statutEleve=:statutEleve ';
        $sql .= 'ON DUPLICATE KEY UPDATE ';
        $sql .= 'evaluation=:evaluation, statutEleve=:statutEleve ';

        $requete = $connexion->prepare($sql);
        $data = array(
                ':idTravail' => $idTravail,
                ':matricule' => $matricule,
                ':evaluation' => $evaluation,
                ':statutEleve' => $statutEleve,
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
        $competencesTravail = $this->getCompetencesTravail($idTravail);
        // liste des compétences pour ce cours
        $competencesCoursGrp = $this->getCompetencesCoursGrp($coursGrp);

        return array_diff_key($competencesCoursGrp, $competencesTravail);
    }

    /**
     * recherche les évaluations de tous les élèves par compétence pour un travail donné.
     *
     * @param $idCompetence
     * @param $idTravail
     *
     * @return array
     */
    public function getEvaluations4Competence($idTravail, $idCompetence)
    {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
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
        $sql = 'SELECT dttr.matricule, dttr.idTravail, remarque, evaluation, remis, statutEleve, dtte.idCompetence, cote, dttc.max ';
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
        // le premier fichier significatif est le numéro 2 (.. et . ont été supprimés)
        $infos = array('fileName' => null, 'size' => '', 'dateRemise' => 'Non remis');
        if (isset($files[2])) {
            $file = $files[2];
            $infos = array(
                'fileName' => $file,
                'size' => $this->unitFilesize(filesize($dir.'/'.$file)),
                'dateRemise' => strftime('%x %X', filemtime($dir.'/'.$file)),
            );
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
    public function creerEnteteCarnetCotes($dataTravail, $form, $idCompetence)
    {
        // Application::afficher($dataTravail,true);
        $idCarnet = $dataTravail['competences'][$idCompetence]['idCarnet'];
        $coursGrp = isset($dataTravail['coursGrp']) ? $dataTravail['coursGrp'] : null;
        $idTravail = isset($dataTravail['idTravail']) ? $dataTravail['idTravail'] : null;
        $libelle = $dataTravail['titre'];
        $date = Application::dateMysql(Application::dateNow());
        $max = Application::sansVirg($dataTravail['competences'][$idCompetence]['max']);
        $formCert = $dataTravail['competences'][$idCompetence]['formCert'];
        $bulletin = $form['bulletin'];

        if (($coursGrp == null) || ($bulletin == null) || ($max == null) || !(is_numeric($max))) {
            die("Erreur d'encodage");
        }

        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        if ($idCarnet != null) {
            $sql = 'UPDATE '.PFX.'bullCarnetCotes ';
            $sql .= 'SET coursGrp=:coursGrp, bulletin=:bulletin, date=:date, ';
            $sql .= 'idComp=:idComp, formCert=:formCert, ';
            $sql .= 'max=:max, libelle=:libelle,  ';
            $sql .= 'WHERE idCarnet=:idCarnet, remarque=:remarque ';
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
        $sql = 'SELECT dtc.idTravail, dtc.idCompetence, dte.cote, dtc.max, remarque, evaluation, dte.matricule ';
        $sql .= 'FROM '.PFX.'thotTravauxCompetences AS dtc ';
        $sql .= 'JOIN '.PFX.'thotTravauxEvaluations AS dte ON dtc.idTravail = dte.idTravail  AND dte.idCompetence = dtc.idCompetence ';
        $sql .= 'JOIN '.PFX.'thotTravauxRemis AS dtr ON dtr.matricule = dte.matricule AND dtr.idTravail = dte.idTravail ';
        $sql .= 'WHERE dte.idTravail=:idTravail AND dte.matricule=:matricule ';

        $requete = $connexion->prepare($sql);
        $requete->bindParam(':matricule', $matricule, PDO::PARAM_INT);
        $requete->bindParam(':idTravail', $idTravail, PDO::PARAM_INT);

        $resultat = $requete->execute();
        $liste = array();
        if ($resultat) {
            $requete->setFetchMode(PDO::FETCH_ASSOC);
            while ($ligne = $requete->fetch()) {
                if (!(isset($liste['data']))) {
                    $liste['data'] = array(
                        'idTravail' => $ligne['idTravail'],
                        'remarque' => $ligne['remarque'],
                        'evaluation' => $ligne['evaluation'],
                        'matricule' => $ligne['matricule'],
                    );
                }
                $idCompetence = $ligne['idCompetence'];
                $liste['cotes'][$idCompetence] = array(
                    'cote' => $ligne['cote'],
                    'max' => $ligne['max'],
                );
            }
        }

        return $liste;
    }
}
