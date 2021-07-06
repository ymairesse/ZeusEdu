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
$module = $Application->getModule(3);

$qui = isset($_POST['qui']) ? $_POST['qui'] : Null;

if (is_numeric($qui)) {
    require_once INSTALL_DIR.'/inc/classes/classEcole.inc.php';
    $Ecole = new Ecole();
    $who = $Ecole->detailsDeListeEleves($qui)[$qui];
    }
    else {
        require_once INSTALL_DIR.'/inc/classes/classUser.inc.php';
        $User = new User();
        $who = $User->identiteProf($qui);
    }

if (is_array($who)){
    $groupe = isset($who['groupe']) ? $who['groupe'] : '';
    $nom = $who['nom'];
    $prenom = $who['prenom'];
    $texte = sprintf('%s %s %s', $groupe, $nom, $prenom);
    }
    else {
        if ($qui != '')
            $texte = "INCONNU";
            else $texte = '';
    }

echo $texte;
