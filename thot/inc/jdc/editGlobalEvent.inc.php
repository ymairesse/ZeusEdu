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
require_once INSTALL_DIR.$ds.$module.$ds."inc/classes/classJdc.inc.php";
$Jdc = new Jdc();

$categories = $Jdc->categoriesTravaux();

$id = isset($_POST['id']) ? $_POST['id'] : null;
$editable = isset($_POST['editable']) ? $_POST['editable'] : null;
$heure = isset($_POST['heure']) ? $_POST['heure'] : null;
$date = isset($_POST['date']) ? $_POST['date'] : null;
$type = isset($_POST['type']) ? $_POST['type'] : null;
$cible = isset($_POST['cible']) ? $_POST['cible'] : null;

if ($id != null) {
    $travail = $Jdc->getTravail($id);
    $cible = $travail['destinataire'];
    $type = $travail['type'];
    switch ($type) {
        case 'coursGrp':
            $info = $User->listeCoursProf();
            break;
        case 'eleve':
            require_once INSTALL_DIR.'/inc/classes/classEleve.inc.php';
            $info = Eleve::staticGetDetailsEleve($cible);
            break;
        default:
            $info = Null;
            break;
    }
}
else {
    switch ($type) {
        case 'coursGrp':
            $info = $User->listeCoursProf();
            break;
        case 'eleve':
            require_once INSTALL_DIR.'/inc/classes/classEleve.inc.php';
            $info = Eleve::staticGetDetailsEleve($cible);
            break;
        default:
            $info = Null;
            break;
        }
    $travail = array(
        'idCategorie' => Null,
        'destinataire' => $cible,
        'proprietaire' => $acronyme,
        'idCategorie' => $type,
        'startDate' => $date,
        'heure' => $heure,
        'type' => $type
        );
    }

require_once INSTALL_DIR.'/smarty/Smarty.class.php';
$smarty = new Smarty();
$smarty->template_dir = INSTALL_DIR.$ds.$module.$ds.'templates';
$smarty->compile_dir = INSTALL_DIR.$ds.$module.$ds.'templates_c';

$smarty->assign('INSTALL_DIR', INSTALL_DIR);
$smarty->assign('categories', $categories);

$listePeriodes = $Jdc->lirePeriodesCours();
$smarty->assign('listePeriodes', $listePeriodes);

$lblDestinataire = $Jdc->getLabel($type, $cible, $info);
$smarty->assign('lblDestinataire', $lblDestinataire);

$smarty->assign('travail', $travail);
$smarty->assign('editable', $editable);

$smarty->display('jdc/jdcEdit.tpl');
