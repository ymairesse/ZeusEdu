<?php

class Treeview
{
    // arborescence des fichiers et répertoires
    public $files;
    private $baseDir;

    /**
     *
     * Construction d'un Treeview du répertoire $dir avec sélection des fichiers $selectedFiles
     *
     * @param string $dir : le nom du répertoire dont on veut le TreeView
     * @param array $selectedFiles : tableau des fichiers sélectionnés dans le TreeView
     */
    public function __construct($dir, $selectedFiles)
    {
        $this->baseDir = $dir;
        $sharedFiles = $this->sharedFiles();
        $sharedDirs = $this->sharedDirs();
        $this->files = $this->scan($dir, $selectedFiles);
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
      * @param string $dir : répertoire à lister
      * @param array $selectedFiles : fichiers présélectionnés dans l'arborescence
      *
      * @return array: arborescence
      */
     private function scan($dir, $selectedFiles)
     {
        // stockage séparé des fichiers ordinaires et des répertoires, chacun par ordre alphabétique
        $files = array('files' => array(), 'dir' => array());
        $ds = DIRECTORY_SEPARATOR;
         if (file_exists($dir)) {
             $listeFichiers = scandir($dir);
             foreach ($listeFichiers as $f) {
                 // Ignorer les fichiers cachés et les répertoires protégés par "#" initial
                 if (!$f || $f[0] == '.' || $f[0] == '#') {
                     continue;
                 }

                 if (is_dir($dir.'/'.$f)) {
                     // C'est un répertoire
                     $files['dir'][] = array(
                         'fileName' => $f,
                         'type' => 'folder',
                         // suppression des // éventuels dans le path
                         'path' => preg_replace('~/+~', '/', $ds.SUBSTR($dir, strlen($this->baseDir) + 1).$ds.$f),
                         'items' => $this->scan($dir.'/'.$f, $selectedFiles), // appel récursif dans le répertoire
                     );
                 } else {
                     // C'est un fichier ordinaire
                     $path = substr($dir, strlen($this->baseDir) + 1);
                     // sauf pour la racine, pré-poser un $ds au nom du répertoire
                     $path = $ds.$path;
                     $path = ($path != $ds) ? $path.$ds : $path;
                     // Application::afficher($path.$f);
                     $selected = isset($selectedFiles) && in_array($path.$f, $selectedFiles) ? 1 : 0;
                     $files['files'][] = array(
                         'fileName' => $f,
                         'type' => 'file',
                         'path' => $path,
                         'size' => $this->unitFilesize(filesize($dir.'/'.$f)),
                         'date' => strftime('%x %X', filemtime($dir.'/'.$f)),
                         'ext' => pathinfo($dir.'/'.$f)['extension'],
                         'selected' => $selected,
                     );
                 }
             }
             // fusion des deux tableaux, fichiers ordinaires et répetoires (d'abord les répertoires)
             $files = array_merge($files['dir'], $files['files']);
         }

         return $files;
     }

     /**
      * récupère la liste des fichiers (sans les répertoires) dans $arborescence, à partir d'une racine
      *
      * @param $root : racine de l'arborescene à visiter
      * @param $dir : répertoire à lister
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
