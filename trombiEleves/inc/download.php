<?php

require_once '../../config.inc.php';

require_once INSTALL_DIR.'/inc/classes/classApplication.inc.php';
$Application = new Application();

// définition de la class USER utilisée en variable de SESSION
require_once INSTALL_DIR.'/inc/classes/classUser.inc.php';
session_start();
if (!(isset($_SESSION[APPLICATION]))) {
    echo "<script type='text/javascript'>document.location.replace('".BASEDIR."');</script>";
    exit;
}

$User = $_SESSION[APPLICATION];
$acronyme = $User->getAcronyme();

$dirFn = isset($_GET['dirFn']) ? $_GET['dirFn'] : Null;

$erreur = Null;
if ($dirFn == Null)
    $erreur = FILENOTFOUND;

if ($erreur == Null) {
    $path = substr($dirFn, 0, strrpos($dirFn, '/') + 1);
    $fileName = substr($dirFn, strrpos($dirFn, '/') + 1);
    // le fichier doit appartenir à l'utilisateur courant
    $proprio = $acronyme;
}

$ds = DIRECTORY_SEPARATOR;

if ($erreur != Null) {
    die('Erreur: '.$erreur);
}

/*
|-----------------
| Chip Download Class
|------------------
*/
require_once INSTALL_DIR.'/inc/classes/class.chip_download.php';

// répertoire global des fichiers pour l'utilisateur $proprio
$download_path = INSTALL_DIR.$ds.'upload'.$ds.$proprio.$ds;

$args = array(
        'download_path' => $download_path,
        'file' => $path.$fileName,
        'extension_check' => true,
        'referrer_check' => false,
        'referrer' => null,
        );

$download = new chip_download($args);

/*
|-----------------
| Pre Download Hook
|------------------
*/

$download_hook = $download->get_download_hook();

if ($download_hook['download'] != 1) {
    echo $download_hook['message'];
    echo " Une erreur inattendue s'est produite";
}
    // $download->chip_print($download_hook);
    // exit;

/*
|-----------------
| Download
|------------------
*/

if ($download_hook['download'] == true) {

    /* You can write your logic before proceeding to download */

    /* Let's download file */
    $download->get_download();
}
