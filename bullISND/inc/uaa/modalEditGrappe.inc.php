<?php

require_once '../../../config.inc.php';

// définition de la class Application
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

// voir si on est en édition
$idGrappe = isset($_POST['idGrappe']) ? $_POST['idGrappe'] : Null;


$ds = DIRECTORY_SEPARATOR;
require_once INSTALL_DIR.$ds.$module.'/inc/classes/classBulletin.inc.php';
$Bulletin = new Bulletin();


if ($idGrappe != Null) {
    $detailsGrappe = $Bulletin->getInfoGrappe($idGrappe);
    }
    else $detailsGrappe = Null;


require_once INSTALL_DIR.'/inc/classes/classEcole.inc.php';

$listeNiveaux = Ecole::listeNiveaux();


require_once INSTALL_DIR.'/smarty/Smarty.class.php';
$smarty = new Smarty();
$smarty->template_dir = '../../templates';
$smarty->compile_dir = '../../templates_c';

$smarty->assign('listeNiveaux', $listeNiveaux);

$smarty->assign('detailsGrappe', $detailsGrappe);
$smarty->assign('idGrappe', $idGrappe);


$smarty->display('uaa/modal/modalEditGrappe.tpl');
