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

$module = $Application->getModule(2);

$cible = isset($_POST['cible']) ? $_POST['cible'] : null;
$classe = isset($_POST['classe']) ? $_POST['classe'] : null;
$coursGrp = isset($_POST['coursGrp']) ? $_POST['coursGrp'] : null;

$ds = DIRECTORY_SEPARATOR;
require_once INSTALL_DIR.$ds.$module.$ds.'inc/classes/class.trombiEleves.php';
$Trombi =  new trombiEleves();

switch ($cible) {
    case 'classe':
        $texteCSV = $Trombi->getFichierCSV($cible, $classe);
        $destinataire = $classe;
        break;
    case 'coursGrp':
        $texteCSV = $Trombi->getFichierCSV($cible, $coursGrp);
        $destinataire = $coursGrp;
        break;
    default:
        // wtf
        break;
}

// création éventuelle du répertoire au nom de l'utlilisateur
$chemin = INSTALL_DIR.$ds.'upload'.$ds.$acronyme.$ds.$module.$ds;

if (!(file_exists($chemin)))
    mkdir($chemin, 0700, true);

if (isset($texteCSV)) {
    if (!($fp = fopen($chemin.$destinataire.'.CSV', "w"))) die ("erreur à l'ouverture du fichier");
    fwrite ($fp, $texteCSV);
    fclose ($fp);
}

echo '<a href="inc/download.php?dirFn='.$module.$ds.$destinataire.'.CSV">'.$module.$ds.$destinataire.'.CSV</a>';
