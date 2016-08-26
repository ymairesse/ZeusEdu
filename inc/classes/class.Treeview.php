<?php

class Treeview
{
    // arborescence des fichiers et répertoires
    public $files;
    private $baseDir;

    public function __construct($dir)
    {
        $this->baseDir = $dir;
        $this->files = $this->scan($dir);
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
      * @param $dir : répertoire à lister
      *
      * @return array: arborescence
      */
     public function scan($dir)
     {
         // stockage séparé des fichiers ordinaires et des répertoires, chacun par ordre alphabétique
         $files = array('files' => array(), 'dir' => array());
         if (file_exists($dir)) {
             $listeFichiers = scandir($dir);
             foreach ($listeFichiers as $f) {
                 if (!$f || $f[0] == '.') {
                     continue; // Ignorer les fichiers cachés
                 }

                 if (is_dir($dir.'/'.$f)) {
                     // C'est un répertoire
                     $files['dir'][] = array(
                         'name' => $f,
                         'type' => 'folder',
                         'path' => substr($dir, strlen($this->baseDir) + 1),
                         'items' => $this->scan($dir.'/'.$f), // appel récursif dans le répertoire
                     );
                 } else {
                     // C'est un fichier ordinaire
                     $files['files'][] = array(
                         'name' => $f,
                         'type' => 'file',
                         'path' => substr($dir, strlen($this->baseDir) + 1),
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
