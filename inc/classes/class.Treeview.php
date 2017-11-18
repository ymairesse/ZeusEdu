<?php

class Treeview
{
    // arborescence des fichiers et répertoires
    public $files;
    private $baseDir;

    public function __construct($dir)
    {
        $this->baseDir = $dir;
        $sharedFiles = $this->sharedFiles();
        $sharedDirs = $this->sharedDirs();
        $this->files = $this->scan($dir, $sharedFiles, $sharedDirs);
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
      * renvoie la liste de tous les fichiers partagés par l'utilisateur.
      *
      * @param void
      *
      * @return array
      */
     private function sharedFiles()
     {
         $base = $this->baseDir;
         $acronyme = substr($base, strrpos($base, '/') + 1);
         $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
         $sql = 'SELECT path, fileName ';
         $sql .= 'FROM '.PFX.'thotFiles AS files ';
         $sql .= 'JOIN '.PFX.'thotShares AS shares ON shares.fileId = files.fileId ';
         $sql .= "WHERE acronyme='$acronyme' AND fileName != '' ";
         $resultat = $connexion->query($sql);
         $liste = array();
         if ($resultat) {
             $resultat->setFetchMode(PDO::FETCH_ASSOC);
             while ($ligne = $resultat->fetch()) {
                 $path = $ligne['path'];
                 $liste[] = $ligne['path'].'/'.$ligne['fileName'];
             }
         }
         Application::DeconnexionPDO($connexion);

         return $liste;
     }

     /**
      * renvoie la liste de tous les répertoires partagés par l'utilsateur courant.
      *
      * @param void
      *
      * @return array
      */
     private function sharedDirs()
     {
         $base = $this->baseDir;
         $acronyme = substr($base, strrpos($base, '/') + 1);
         $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
         $sql = 'SELECT path ';
         $sql .= 'FROM '.PFX.'thotFiles AS files ';
         $sql .= 'JOIN '.PFX.'thotShares AS shares ON shares.fileId = files.fileId ';
         $sql .= "WHERE acronyme='$acronyme' AND fileName = '' ";
         $resultat = $connexion->query($sql);
         $liste = array();
         if ($resultat) {
             $resultat->setFetchMode(PDO::FETCH_ASSOC);
             while ($ligne = $resultat->fetch()) {
                 $path = $ligne['path'];
                 $liste[] = $path;
             }
         }
         Application::DeconnexionPDO($connexion);

         return $liste;
     }

     /**
      * construit l'arborescence des fichiers du répertoire $dir fourni.
      *
      * @param $dir : répertoire à lister
      *
      * @return array: arborescence
      */
     private function scan($dir, $sharedFiles, $sharedDirs)
     {
         // stockage séparé des fichiers ordinaires et des répertoires, chacun par ordre alphabétique
         $files = array('files' => array(), 'dir' => array());
         if (file_exists($dir)) {
             $listeFichiers = scandir($dir);
             foreach ($listeFichiers as $f) {
                 // Ignorer les fichiers cachés et les répertoires protégés par "#" initial
                 if (!$f || $f[0] == '.' || $f[0] == '#') {
                     continue;
                 }

                 if (is_dir($dir.'/'.$f)) {
                     // C'est un répertoire
                     $repertoire = ($f == '') ? '/' : '/'.$f.'/';
                     if (in_array($repertoire, $sharedDirs)) {
                         $shared = true;
                     }
                    else $shared = false;

                     $files['dir'][] = array(
                         'name' => $f,
                         'type' => 'folder',
                         'path' => substr($dir, strlen($this->baseDir) + 1),
                         'shared' => $shared,
                         'items' => $this->scan($dir.'/'.$f, $sharedFiles, $sharedDirs), // appel récursif dans le répertoire
                     );
                 } else {
                     // C'est un fichier ordinaire
                     $path = ($dir == $this->baseDir) ? '/' : substr($dir, strlen($this->baseDir) + 1);
                     $fileName = $path.'/'.$f;
                     $fileName = ($fileName[0] != '/') ? '/'.$fileName : $fileName;

                     if (in_array($fileName, $sharedFiles))
                        $shared = true;
                        else $shared = false;
                     $files['files'][] = array(
                         'name' => $f,
                         'type' => 'file',
                         'path' => $path,
                         'shared' => $shared,
                         'size' => $this->unitFilesize(filesize($dir.'/'.$f)),
                         'date' => strftime('%x %X', filemtime($dir.'/'.$f)),
                         'ext' => pathinfo($dir.'/'.$f)['extension'],
                     );

                 }
             }
             // fusion des deux tableaux, fichiers ordinaires et répetoires (d'abord les répertoires)
             $files = array_merge($files['dir'], $files['files']);
         }

         return $files;
     }

     /**
      * renvoie l'arborescence définie dans l'objet.
      *
      * @param void
      *
      * @return array
      */
     public function getTree()
     {
         return $this->files;
     }
}
