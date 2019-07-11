<?php

require_once '../config.inc.php';

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

// le $type 'fileId' est donné par défaut
$type = isset($_GET['type']) ? $_GET['type'] : Null;

$module = $Application->getModule(1);

$ds = DIRECTORY_SEPARATOR;
require_once INSTALL_DIR.$ds.$module.$ds.'inc/classes/classHermes.inc.php';
$Hermes = new Hermes();

define ('FILENOTFOUND', 'Document non identifié');
define ('NOTSHARED', 'Ce document n\'est pas partagé avec vous.');

switch ($type) {
    case 'idFile':
        $notif = isset($_GET['notif']) ? $_GET['notif'] : Null;
        $n = isset($_GET['n']) ? $_GET['n'] : Null;
        $fileName = isset($_GET['file']) ? $_GET['file'] : Null;

        // vérifier que l'utilisateur courant peut accéder à cette notification (et à ses PJ)
        if (!($Hermes->verifAcces($notif, $acronyme) || $Hermes->verifProprio($notif, $acronyme)))
            die(NOTSHARED);
        // rechercher le propriétaire de la notification $id
        $proprio = $Hermes->getNotifProprio($notif);
        // retrouver le path (caché) pour le fichier $n de nom $fileName de la notification $notif
        $fileInfos = $Hermes->getFileInfos($notif, $fileName, $n);

        if ($fileInfos == Null)
            die(FILENOTFOUND);
        $path = $fileInfos['path'];
        $fileName = $fileInfos['fileName'];
        break;

    default:
        // wtf
        break;
}


/*
|-----------------
| Chip Download Class
|------------------
*/

require_once INSTALL_DIR.'/inc/classes/class.chip_download.php';

/*
|-----------------
| Class Instance
|------------------
*/

// répertoire global des fichiers pour l'utilisateur $proprio
$download_path = INSTALL_DIR.$ds.'upload'.$ds.$proprio;

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
    echo "Une erreur inattendue s'est produite";

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
