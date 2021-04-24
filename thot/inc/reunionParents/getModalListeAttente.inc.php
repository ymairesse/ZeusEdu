<?php

require_once '../../../config.inc.php';

require_once INSTALL_DIR.'/inc/classes/classApplication.inc.php';
$Application = new Application();

// définition de la class USER utilisée en variable de SESSION
require_once INSTALL_DIR.'/inc/classes/classUser.inc.php';
session_start();

if (!(isset($_SESSION[APPLICATION]))) {
    die("<div class='alert alert-danger'>".RECONNECT.'</div>');
}

$User = $_SESSION[APPLICATION];
$acronyme = $User->getAcronyme();

$matricule = isset($_POST['matricule']) ? $_POST['matricule'] : Null;
$idRP = isset($_POST['idRP']) ? $_POST['idRP'] : Null;
$abreviation = isset($_POST['acronyme']) ? $_POST['acronyme'] : $acronyme;

require_once INSTALL_DIR.'/inc/classes/classThot.inc.php';
$Thot = new Thot();

$listePeriodes = $Thot->getListePeriodes($idRP);

require_once(INSTALL_DIR."/smarty/Smarty.class.php");
$smarty = new Smarty();
$smarty->template_dir = "../../templates";
$smarty->compile_dir = "../../templates_c";

$smarty->assign('matricule', $matricule);
$smarty->assign('acronyme', $abreviation);
$smarty->assign('idRP', $idRP);
$smarty->assign('listePeriodes', $listePeriodes);

$smarty->display('reunionParents/modal/modalAttente.tpl');
