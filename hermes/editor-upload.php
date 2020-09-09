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

$module = $Application->getModule(1);

$ds = DIRECTORY_SEPARATOR;

$imgUp = 'img-uploads';

// répertoire privé au module
$root = INSTALL_DIR.$ds.$module.$ds.$imgUp;

if(empty($_FILES['file']))
{
	exit();
}
$errorImgFile = INSTALL_DIR."/images/erreur.png";
$temp = explode(".", $_FILES["file"]["name"]);

$newfilename = $acronyme.'_' . round(microtime(true)) . '.' . end($temp);
$destinationFilePath = '.'.$ds.$imgUp.$ds.$newfilename;

if(!move_uploaded_file($_FILES['file']['tmp_name'], $destinationFilePath)){
	echo $errorImgFile;
}
else{
	echo BASEDIR.$module.$ds.$destinationFilePath;
}
