<?php

require_once '../../../config.inc.php';

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
$type = isset($_GET['type']) ? $_GET['type'] : 'shareId';

require_once INSTALL_DIR.'/inc/classes/class.Files.php';
$Files = new Files();

define ('FILENOTFOUND', 'Document non identifié');
define ('NOTSHARED', 'Ce document n\'est pas partagé avec vous.');

$ds = DIRECTORY_SEPARATOR;

$erreur = Null;

switch ($type) {
    // le fichier est référencé par son shareId
    case 'shareId':
        $shareId = isset($_GET['f']) ? $_GET['f'] : null;
        if ($shareId == null) {
            $erreur = FILENOTFOUND;
            // die(FILENOTFOUND);
        }
        if ($erreur == Null) {
            $fileInfo = $Files->getFileInfoByShareId($shareId);
            // vérifier que le fichier est effectivement partagé avec l'utilisateur actif
            $sharedFiles = array_keys($Files->sharedWith($acronyme));
            if (!(in_array($fileInfo['shareId'], $sharedFiles))) {
                $erreur = NOTSHARED;
                // die(NOTSHARED);
                }
        }

        if ($erreur == Null) {
            $path = $fileInfo['path'].$ds;
            $fileName = $fileInfo['fileName'];
            // le propriétaire a été trouvé dans la base de données
            $proprio = $fileInfo['acronyme'];
        }
        break;

    case 'pfN':
        // le path et le nom du fichier ont été indiqués
        // documents dans l'arborescence des fichiers partagés
        $pfN = isset($_REQUEST['f']) ? $_REQUEST['f'] : null;

        if ($pfN == null) {
            $erreur = FILENOTFOUND;
            // die(FILENOTFOUND);
        }
        if ($erreur == Null) {
            $path = substr($pfN, 0, strrpos($pfN, '/') + 1);
            $fileName = substr($pfN, strrpos($pfN, '/') + 1);
            // le fichier doit appartenir à l'utilisateur courant
            $proprio = $acronyme;
        }
        break;

    case 'pfNid':
        // le lien cliqué contient le nom du fichier et le $shareId
        // documents dans un dossier partagé
        $shareId = isset($_GET['f']) ? $_GET['f'] : null;
        // le $fileName contient le path et le nom du fichier
        $fileName = isset($_GET['file']) ? $_GET['file'] : null;

        // $fileInfo = informations relatives au répertoire partagé de base (pas d'infos sur le fichier ou sur les sous-répertoires)
        $fileInfo = $Files->getFileInfoByShareId($shareId);

        $sharedDir = $fileInfo['fileName'];
        // le fichier qui sera réellement téléchargé dans le répertoire partagé
        $downloadedFileInfo = array(
            'path' => substr($fileName, 0, strrpos($fileName, '/')+1),
            'fileName' => substr($fileName, strrpos($fileName, '/') + 1),
        );

        $sharedFiles = array_keys($Files->sharedWith($acronyme));
        if (!(in_array($fileInfo['shareId'], $sharedFiles))) {
            $erreur = NOTSHARED;
            //die(NOTSHARED);
            }
        if ($erreur == Null) {
            if ($fileInfo != Null) {
                $path = $fileInfo['path'].$ds.$sharedDir;
                $proprio = $fileInfo['acronyme'];
                }
                else {
                    $serreur = NOTSHARED;
                    // die(NOTSHARED);
                }
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

if ($erreur != Null) {
    die('Erreur: '.$erreur);
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

    if (isset($shareId)) {
        // enregistrement du suivi de téléchargement pour le document
        $spyInfo = $Files->getSpyInfo4ShareId($shareId);
        // il y a un espion sur le fichier ou le répertoire
        if (!(empty($spyInfo))) {
            $spyId = $spyInfo['spyId'];
            $path = (isset($downloadedFileInfo['path'])) ? $downloadedFileInfo['path'] : Null;
            $fileName = (isset($downloadedFileInfo['fileName'])) ? $downloadedFileInfo['fileName'] : Null;
            $Files->setSpiedDownload ($acronyme, $spyId, $path, $fileName);
        }
    }

    /* Let's download file */
    $download->get_download();
}
