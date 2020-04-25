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

$post = isset($_POST['post']) ? $_POST['post'] : null;

// retour du contenu du formulaire qui a été serializé
$formulaire = array();
parse_str($post, $formulaire);

$type = $formulaire['type'];
$TOUS = isset($formulaire['TOUS']) ? 'TOUS' : Null;

$destinataires = 'wtf';

switch ($type){
    case 'ecole':
        $formulaire['groupe'] = 'ecole';
        $destinataires = 'all';
        break;

    case 'niveau':
        $formulaire['groupe'] = $formulaire['niveau'];
        $destinataires = 'all';
        break;

    case 'classes':
        $formulaire['groupe'] = $formulaire['classe'];
        $destinataires = ($TOUS == 'TOUS') ? 'all' : $formulaire['membres'];
        break;

    case 'coursGrp':
        $formulaire['groupe'] = $formulaire['coursGrp'];
        $destinataires = ($TOUS == 'TOUS') ? 'all' : $formulaire['membres'];
        break;

    case 'cours':
        $formulaire['groupe'] = $formulaire['membres'];
        $destinataires = 'all';
        break;

    case 'groupe':
        $formulaire['groupe'] = $formulaire['groupe'];
        $destinataires = ($TOUS == 'TOUS') ? 'all' : $formulaire['membres'];
        break;

    case 'prof':
        $formulaire['groupe'] = 'profs';
        $destinataires = ($TOUS == 'TOUS') ? 'all' : $formulaire['membres'];
        break;
}

$formulaire['destinataires'] = $destinataires;

require_once INSTALL_DIR.'/inc/classes/class.Files.php';
$Files = new Files();

// retourne les shareId's du fichier partagé, mais on s'en fiche
var_dump($Files->share($formulaire, $acronyme));
