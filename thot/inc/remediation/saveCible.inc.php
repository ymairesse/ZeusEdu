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

$ds = DIRECTORY_SEPARATOR;
require_once INSTALL_DIR.$ds.$module.$ds.'inc/classes/class.remediation.inc.php';
$remediation = new Remediation();

$formulaire = isset($_POST['formulaire']) ? $_POST['formulaire'] : Null;

$form = array();
parse_str($formulaire, $form);

$type = $form['type'];
$niveau = $form['niveau'];
$classe = $form['classe'];
$matiere = $form['matiere'];
$coursGrp = $form['coursGrp'];
$idOffre = $form['idOffre'];

switch ($type) {
    case 'ecole':
        $cible = 'ecole';
    case 'niveau':
        $cible = $niveau;
        break;
    case 'classe':
        $cible = $classe;
        break;
    case 'matiere':
        $cible = $matiere;
        break;
    case 'coursGrp':
        $cible = $coursGrp;
        break;
    default:
        $cible = Null;
        break;
}

$nb = $remediation->saveCibleOffre($idOffre, $type, $cible, $acronyme);

echo json_encode(array(
        'idOffre' => $idOffre,
        'nombre' => $nb,
        'groupe' => $cible
    ));
