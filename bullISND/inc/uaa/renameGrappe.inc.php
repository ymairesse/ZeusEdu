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

$libelle = isset($_POST['libelle']) ? trim($_POST['libelle']) : Null;
$idGrappe = isset($_POST['idGrappe']) ? $_POST['idGrappe'] : Null;

if ($libelle != '') {
    $ds = DIRECTORY_SEPARATOR;
    require_once INSTALL_DIR.$ds.$module.'/inc/classes/classBulletin.inc.php';
    $Bulletin = new Bulletin();

    $nb = $Bulletin->renameGrappe($idGrappe, $libelle);

    require_once INSTALL_DIR.'/smarty/Smarty.class.php';
    $smarty = new Smarty();
    $smarty->template_dir = '../../templates';
    $smarty->compile_dir = '../../templates_c';

    $listeGrappes = $Bulletin->getListeGrappes();
    $smarty->assign('listeGrappes', $listeGrappes);

    $html = $smarty->fetch('uaa/selectGrappe.tpl');

    echo json_encode(array('nb' => $nb, 'html' => $html));
}
