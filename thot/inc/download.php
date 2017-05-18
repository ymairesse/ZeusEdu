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

$type = isset($_GET['type']) ? $_GET['type'] : 'fileId';

require_once INSTALL_DIR.'/inc/classes/class.Files.php';
$Files = new Files();

define ('FILENOTFOUND', 'Document non identifié');
define ('NOTSHARED', 'Ce document n\'est pas partagé avec vous.');

$ds = DIRECTORY_SEPARATOR;

switch ($type) {
    case 'fileId':
        // une valeur de fileId a été passée
        // document provenant de la listes des "partagés avec moi"
        $fileId = isset($_GET['f']) ? $_GET['f'] : null;
        if ($fileId == null) {
            die(FILENOTFOUND);
        }
        $file = $Files->getSharedfileById($fileId);

        if (empty($file)) {
            die(NOTSHARED);
        }

        $path = $file['path'].$ds;
        $fileName = $file['fileName'];
        // le propriétaire a été trouvé dans la base de données
        $proprio = $file['acronyme'];
        break;

    case 'pfN':
        // le path et le nom du fichier ont été indiqués
        // documents dans l'arborescence des fichiers partagés
        $pfN = isset($_REQUEST['f']) ? $_REQUEST['f'] : null;

        if ($pfN == null) {
            die(FILENOTFOUND);
        }
        $path = substr($pfN, 0, strrpos($pfN, '/') + 1);
        $fileName = substr($pfN, strrpos($pfN, '/') + 1);
        // le fichier doit appartenir à l'utilisateur courant
        $proprio = $acronyme;
        break;
    case 'pfNid':
        // on a précisé le nom du fichier et le $fileId
        // documents dans un dossier partagé
        $fileId = isset($_GET['f']) ? $_GET['f'] : null;
        $fileName = isset($_GET['file']) ? $_GET['file'] : null;
        // recherche des informations sur le répertoire concerné
        $fileInfo = $Files->getSharedfileById($fileId);

        $shared = false;
        if ($fileInfo != Null) {
            // le fichier $fileId a été trouvé
            // on extrait la liste des partages
            $shareIds = $fileInfo['shareId'];
            $path = $fileInfo['path'];
            $proprio = $fileInfo['acronyme'];
            // liste des fichiers partagés avec $acronyme
            $sharedList = array_keys($Files->sharedWith($acronyme));
            // pour chacun des partages du fichier, on vérifie s'il existe dans la
            // liste des partages de l'utilisateur courant ($acronyme)
            foreach ($shareIds as $oneShare) {
                if (in_array($oneShare, $sharedList))
                    $shared = true;
            }
        }

        if ($shared == false) {
            die(NOTSHARED);
        }
        break;
    case 'pTrEl':
        // on a l'id du travail et le matricule de l'élève
        // il s'agit d'un travail d'élève à évaluer
        $matricule = isset($_GET['matricule']) ? $_GET['matricule'] : null;
        $idTravail = isset($_GET['idTravail']) ? $_GET['idTravail'] : null;
        $fileInfo = $Files->getFileInfos($matricule, $idTravail, $acronyme);
        $fileName = $fileInfo['fileName'];
        $proprio = $acronyme;
        $path = $ds.'#thot'.$ds.$idTravail.$ds.$matricule.$ds;
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
