<?php

require_once '../../config.inc.php';

require_once INSTALL_DIR.'/inc/classes/classApplication.inc.php';
$Application = new Application();

$module = $Application->getModule(2);

// définition de la class USER utilisée en variable de SESSION
require_once INSTALL_DIR.'/inc/classes/classUser.inc.php';
session_start();
if (!(isset($_SESSION[APPLICATION]))) {
    echo "<script type='text/javascript'>document.location.replace('".BASEDIR."');</script>";
    exit;
}
$User = $_SESSION[APPLICATION];
$acronyme = $User->getAcronyme();

$type = isset($_GET['type']) ? $_GET['type'] : 'fileId';

require_once INSTALL_DIR.'/inc/classes/class.Files.php';
$Files = new Files();

$fileNotFound = 'Document non identifié';
$ds = DIRECTORY_SEPARATOR;


switch ($type) {
    case 'fileId':
        // une valeur de fileId a été passée
        $fileId = isset($_GET['f']) ? $_GET['f'] : null;
        if ($fileId == null) {
            die($fileNotFound);
        }
        $file = $Files->getSharedfileById($fileId);

        if (empty($file)) {
            die('Ce document n\'est pas partagé avec vous.');
        }

        $path = $file['path'].$ds;
        $fileName = $file['fileName'];
        // le propriétaire a été trouvé dans la base de données
        $proprio = $file['acronyme'];
        break;

    case 'pfN':
        // le path et le nom du fichier ont été indiqués
        $pfN = isset($_REQUEST['f']) ? $_REQUEST['f'] : null;
        if ($pfN == null) {
            die($fileNotFound);
        }
        $path = substr($pfN, 0, strrpos($pfN, '/') + 1);
        $fileName = substr($pfN, strrpos($pfN, '/') + 1);
        // le fichier doit appartenir à l'utilisateur courant
        $proprio = $acronyme;
        break;
    case 'pfNid':
        $fileId = isset($_GET['f']) ? $_GET['f'] : null;
        $fileName = isset($_GET['file']) ? $_GET['file'] : null;
        // recherche des informations sur le répertoire concerné
        $fileInfo = $Files->getSharedfileById($fileId);
        $shareId = $fileInfo['shareId'];
        $path = $fileInfo['path'];
        $proprio = $fileInfo['acronyme'];

        $sharedList = array_keys($Files->sharedWith($acronyme));
        // Application::afficher($shareId);
        // Application::afficher(($sharedList));
        if (!in_array($shareId, $sharedList)) {
            die('Ce document n\'est pas partagé avec vous.');
        }

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
    echo "Ce type de fichier n'est pas autorisé";
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
