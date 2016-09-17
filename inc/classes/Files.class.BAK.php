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

    private static function generateTree($preTree, $path, $tree) {
        foreach ($preTree as $n => $unFicher) {
            if (count($preTree) == 0)
                return Null;
            $bourgeon = array_shift($preTree);
            echo "<pre>";
            var_dump($bourgeon);
            $dir = $bourgeon['path'];
            if ($dir == $path) {
                $tree[] = $bourgeon['fileName'];
            }
            else {
                $subTree = self::generateTree($preTree, $dir, $tree);
                $tree[] = $subTree;
            }
        }
        return $tree;
    }

    /**
    * retourne l'arboresence des fichiers à partir des informations en BD pour l'utilisateur dont on précise l'acronyme
    *
    * @param $acronyme
    *
    * @return array
    */
    public function getBDtree($acronyme){
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT path, fileName ';
        $sql .= 'FROM '.PFX.'alexandrieFiles ';
        $sql .= "WHERE acronyme = '$acronyme' ";
        $sql .= 'ORDER BY path, fileName ';
        $resultat = $connexion->query($sql);
        $tree = array();
        if ($resultat) {
            $preTree = array();
            $resultat->setFetchMode(PDO::FETCH_ASSOC);
            while ($ligne = $resultat->fetch()){
                $preTree[] = $ligne;
            }
        }

        Application::DeconnexionPDO($connexion);

        return $preTree;

    }

    /**
     * recherche de l'id d'un fichier dont on fournit le nom et le path.
     *
     * @param $fileName : le nom du fichier
     * @param $path : le path
     * @param $acronyme : l'abréviation de l'utilisateur actif
     *
     * @return is_integer
     */
    public function findFileId($path, $fileName, $acronyme)
    {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT id FROM '.PFX.'alexandrieFiles ';
        $sql .= 'WHERE acronyme=:acronyme AND path=:path AND fileName=:fileName ';
        $requete = $connexion->prepare($sql);
        $data = array(':acronyme' => $acronyme, ':path' => $path, ':fileName' => $fileName);

        $resultat = $requete->execute($data);
        $id = null;
        if ($resultat) {
            $ligne = $requete->fetch();
            $id = $ligne['id'];
        }

        Application::DeconnexionPDO($connexion);

        return $id;
    }

    /**
     * rechercher les caractéristiques d'un fichier dont on donne l'id (nom, path) et l'acronyme du propriétaire.
     *
     * @param $id
     *
     * @return array
     */
    public function getFileById($id, $acronyme)
    {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT fileName, path, commentaire, shareId ';
        $sql .= 'FROM '.PFX.'alexandrieFiles AS files ';
        $sql .= 'JOIN '.PFX.'alexandrieShare AS share ON share.id = files.id ';
        $sql .= "WHERE files.id='$id' AND acronyme='$acronyme' ";

        $resultat = $connexion->query($sql);
        $data = array();
        if ($resultat) {
            $resultat->setFetchMode(PDO::FETCH_ASSOC);
            $ligne = $resultat->fetch();
            $data = array(
                'path' => $ligne['path'],
                'fileName' => $ligne['fileName'],
                'id' => $id,
                'commentaire' => $ligne['commentaire'],
                'shareId' => $ligne['shareId'],
             );
        }
        Application::DeconnexionPDO($connexion);

        return $data;
    }

    /**
     * recherche les caractéristiques d'un document dont on donne le shareId.
     *
     * @param $shareId : identifiant du partage
     *
     * @return array
     */
    public function getFileByShareId($shareId)
    {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT files.id, fileName, path, acronyme, commentaire, shareId ';
        $sql .= 'FROM '.PFX.'alexandrieShare AS share ';
        $sql .= 'JOIN '.PFX.'alexandrieFiles AS files ON files.id = share.id ';
        $sql .= "WHERE shareId = '$shareId' ";
        $ligne = array();
        $resultat = $connexion->query($sql);
        if ($resultat) {
            $resultat->setFetchMode(PDO::FETCH_ASSOC);
            $ligne = $resultat->fetch();
        }
        Application::DeconnexionPDO($connexion);

        return $ligne;
    }

    /**
     * Enregistrement du partage d'un fichier.
     *
     * @param $post : contenu du formulaire
     *
     * @return int : nombre d'enregistrements de partage
     */
    public function share($post, $acronyme)
    {
        $fileName = $post['fileName'];
        $path = $post['path'];
        $type = $post['type'];
        $groupe = $post['groupe'];
        $commentaire = $post['commentaire'];
        $tous = isset($post['TOUS']) ? $post['TOUS'] : null;
        $membres = isset($post['membres']) ? $post['membres'] : null;

        $id = $this->findFileId($path, $fileName, $acronyme);

        $resultat = null;
        if ($id != 0) {
            $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
            // enregistrer les partages
            $sql = 'INSERT IGNORE INTO '.PFX.'alexandrieShare ';
            $sql .= 'SET id=:id, type=:type, groupe=:groupe, commentaire=:commentaire, destinataire=:destinataire ';
            $requete = $connexion->prepare($sql);
            $resultat = 0;
            $data = array(':id' => $id, ':type' => $type, ':groupe' => $groupe, ':commentaire' => $commentaire);
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
        }

        return $resultat;
    }

    /**
     * retourne le nombre de partages d'un fichier dont on fournit l'identifiant en BD.
     *
     * @param $id
     *
     * @return int
     */
    public function nbShares($id)
    {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT count(*) AS nb ';
        $sql .= 'FROM '.PFX.'alexandrieShare ';
        $sql .= "WHERE id='$id' ";
        $resultat = $connexion->query($sql);
        $nb = 0;
        if ($resultat) {
            $ligne = $resultat->fetch();
            $nb = $ligne['nb'];
        }
        Application::DeconnexionPDO($connexion);

        return $nb;
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
        $id = $this->findFileId($path, $fileName, $acronyme);

        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'DELETE FROM '.PFX.'alexandrieShare ';
        $sql .= "WHERE id='$id' ";
        $resultat = $connexion->exec($sql);
        Application::DeconnexionPDO($connexion);

        return $resultat;
    }

    /**
     * Enregistre un fichier dans la BD.
     *
     * @param $path : le chemin vers le fichier
     * @param $fileName : le nom du fichier
     * @param $acronyme : l 'acronyme du propriétaire
     *
     * @return int : l'id de l'enregistrement (ou 0 si pas d'enregistrement)
     */
    public function saveInBD($path, $fileName, $acronyme)
    {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'INSERT IGNORE INTO '.PFX.'alexandrieFiles ';
        $sql .= 'SET acronyme=:acronyme, path=:path, fileName=:fileName ';
        $requete = $connexion->prepare($sql);

        $data = array(':acronyme' => $acronyme, ':path' => $path, ':fileName' => $fileName);
        $resultat = $requete->execute($data);
        $id = $connexion->lastInsertId();
        Application::DeconnexionPDO($connexion);

        return $id;
    }

    /**
     * Enregistre la création d'un nouveau répertoire dans la BD.
     *
     * @param $activeDir : le répertoire dans lequel se fait la création
     * @param $dirName : le nom du répertoire
     * @param $acronyme : l'acronyme de l'utilisateur
     *
     * @return bool
     */
    public function dirInBD($activeDir, $dirName, $acronyme)
    {
        $path = $activeDir.$dirName;
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'INSERT IGNORE INTO '.PFX.'alexandrieFiles ';
        $sql .= 'SET acronyme=:acronyme, path=:path, fileName=:fileName ';
        $requete = $connexion->prepare($sql);

        $data = array(':acronyme' => $acronyme, ':path' => $path, ':fileName' => '');
        $resultat = $requete->execute($data);

        $id = $connexion->lastInsertId();
        Application::DeconnexionPDO($connexion);

        return $id;
    }

    /**
     * retourne la liste des partages de l'utilisateur indiqué.
     *
     * @param $acronyme : acronyme de l'utilisateur
     *
     * @return array
     */
    public function listUserShares($acronyme)
    {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT f.id, path, fileName, commentaire, type, s.groupe, destinataire, shareId, ';
        $sql .= 'el.nom AS nomEleve, el.prenom AS prenomEleve, el.classe, ';
        $sql .= 'p.nom AS nomProf, p.prenom AS prenomProf, ';
        $sql .= 'pc.nomCours ';
        $sql .= 'FROM '.PFX.'alexandrieFiles AS f ';
        $sql .= 'JOIN '.PFX.'alexandrieShare AS s ON f.id = s.id ';
        $sql .= 'LEFT JOIN '.PFX.'eleves AS el ON el.matricule = destinataire ';
        $sql .= 'LEFT JOIN '.PFX.'profs AS p ON p.acronyme = destinataire ';
        $sql .= 'LEFT JOIN '.PFX.'profsCours AS pc ON pc.coursGrp = s.groupe ';
        $sql .= "WHERE f.acronyme = '$acronyme' ";
        $sql .= 'ORDER BY path, fileName, type, groupe, destinataire ';
        $resultat = $connexion->query($sql);
        $liste = array();
        if ($resultat) {
            $resultat->setFetchMode(PDO::FETCH_ASSOC);
            while ($ligne = $resultat->fetch()) {
                $type = $ligne['type'];
                $groupe = $ligne['groupe'];
                $destinataire = $ligne['destinataire'];
                $id = $ligne['id'];
                switch ($type) {
                    // pas de subdivision dans le type 'ecole'
                    case 'ecole':
                        $liste[$type][$id] = $ligne;
                        break;
                    // pas de subdivision dans le type 'prof'
                    case 'prof':
                        $liste[$type][$id] = $ligne;
                        break;
                    // seulement la subdivision par niveau
                    case 'niveau':
                        $liste[$type][$destinataire][$id] = $ligne;
                        break;
                    // subdivision par classe/cours et élève (éventuellement)
                    default:
                        $liste[$type][$groupe][$destinataire][$id] = $ligne;
                        break;
                }
            }
        }
        Application::DeconnexionPDO($connexion);

        return $liste;
    }

    /**
     * Vérifier que l'utilisateur $acronyme est propriétaire du document $id.
     *
     * @param $id : l'identifiant du document dans la BD
     * @param $acronyme : l'identifiant du possible propriétaire
     *
     * @return bool
     */
    private function verifProprietaire($id, $acronyme)
    {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT id, acronyme ';
        $sql .= 'FROM '.PFX.'alexandrieFiles ';
        $sql .= "WHERE id='$id' AND acronyme='$acronyme' ";
        $resultat = $connexion->query($sql);
        $verif = false;
        if ($resultat) {
            $ligne = $resultat->fetch();
            if (($ligne['id'] == $id) && ($ligne['acronyme'] == $acronyme)) {
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
        $sql = 'SELECT acronyme, files.id ';
        $sql .= 'FROM '.PFX.'alexandrieShare AS share ';
        $sql .= 'JOIN '.PFX.'alexandrieFiles AS files ON files.id = share.id ';
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
        $sql = 'UPDATE '.PFX.'alexandrieShare ';
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
     * clôture le partage d'un fichie dont on fournit l'identifiant, le destinataire et l'acronyme du propriétaire.
     *
     * @param $id : identifiant du fichier partagé
     * @param $destinataire : partagé avec qui?
     * @param $acronyme : identifiant du propriétaire
     *
     * @return bool : true si l'opération s'est bien passée
     */
    public function endShare($id, $destinataire, $acronyme)
    {
        $end = false;
        if ($this->verifProprietaire($id, $acronyme)) {
            $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
            $sql = 'DELETE FROM '.PFX.'alexandrieShare ';
            $sql .= "WHERE id='$id' AND destinataire = '$destinataire' ";
            $resultat = $connexion->exec($sql);
            if ($resultat == 1) {
                $end = true;
            }
        }
        Application::DeconnexionPDO($connexion);

        return $end;
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
        $sql = 'SELECT files.id, type, share.groupe, destinataire, commentaire, de.nom, de.prenom, ';
        $sql .= 'profs.nom AS nomProf, profs.prenom AS prenomProf ';
        $sql .= 'FROM '.PFX.'alexandrieFiles AS files ';
        $sql .= 'JOIN '.PFX.'alexandrieShare AS share ON files.id = share.id ';
        $sql .= 'LEFT JOIN '.PFX.'eleves AS de ON de.matricule = share.destinataire ';
        $sql .= 'LEFT JOIN '.PFX.'profs AS profs ON profs.acronyme = share.destinataire ';
        $sql .= "WHERE files.acronyme='$acronyme' AND path='$path' AND fileName='$fileName' ";
        $sql .= 'ORDER BY type, groupe, destinataire ';

        $liste = array();
        $resultat = $connexion->query($sql);
        if ($resultat) {
            $resultat->setFetchMode(PDO::FETCH_ASSOC);
            while ($ligne = $resultat->fetch()) {
                $type = $ligne['type'];
                switch ($type) {
                    case 'ecole':
                        $liste[] = 'Tous les élèves';
                        break;
                    case 'niveau':
                        $liste[] = 'eleves de '.$ligne['destinataire'].'e';
                        break;
                    case 'prof':
                        if ($ligne['destinataire'] == 'all') {
                            $liste[] = 'Tous les collègues';
                        } else {
                            $liste[] = sprintf('collègue: %s %s',$ligne['prenomProf'],$ligne['nomProf']);
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
}
