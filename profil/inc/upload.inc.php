<?php

require_once '../../config.inc.php';

require_once INSTALL_DIR.'/inc/classes/classApplication.inc.php';
$Application = new Application();

// définition de la class USER utilisée en variable de SESSION
require_once INSTALL_DIR.'/inc/classes/classUser.inc.php';
session_start();
if (!(isset($_SESSION[APPLICATION]))) {
    die("<div class='alert alert-danger'>Votre session a expiré. Veuillez vous reconnecter.</div>");
}

$User = $_SESSION[APPLICATION];
$acronyme = $User->getAcronyme();

// supprimer la photo existante
$User->delPhoto();

require_once INSTALL_DIR.'/inc/classes/class.Files.php';
$Files = new Files();

$finfo = finfo_open(FILEINFO_MIME_TYPE);
$mime = finfo_file($finfo, $_FILES['file']['tmp_name']);

switch ($mime) {
    case 'image/jpeg':
        $ext = '.jpg';
        $imagetype = IMAGETYPE_JPEG;
        break;
    case 'image/gif':
        $ext = '.gif';
        $imagetype = IMAGETYPE_GIF;
        break;
    case 'image/png':
        $ext = '.png';
        $imagetype = IMAGETYPE_PNG;
        break;
    default:
        $ext = null;
        $imagetype = null;
        break;
    }

if (!empty($_FILES) && ($ext != null)) {
    $tempFile = $_FILES['file']['tmp_name'];

    $ds = DIRECTORY_SEPARATOR;

    $targetPath = INSTALL_DIR.$ds.'photosProfs';
    // fichier intermédiaire pour le traitement
    $interFile = $targetPath.$ds.'xxx'.$acronyme.$ext;

    move_uploaded_file($tempFile, $interFile);

    require_once INSTALL_DIR.'/inc/classes/class.image.php';
    $image = new SimpleImage($interFile);
    $image->maxarea(200);

    $targetFile = $targetPath.$ds.$acronyme.$ext;

    $image->save($targetFile, $imagetype);
    // effacement du fichier intermédiaire
    @unlink ($interFile);
}
