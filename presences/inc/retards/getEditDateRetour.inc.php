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

$module = $Application::getmodule(3);

$matricule = isset($_POST['matricule']) ? $_POST['matricule'] : Null;
$idTraitement = isset($_POST['idTraitement']) ? $_POST['idTraitement'] : Null;

$ds = DIRECTORY_SEPARATOR;
require_once INSTALL_DIR.'/inc/classes/classEcole.inc.php';
$Ecole = new Ecole();

$dataEleve = $Ecole->nomPrenomClasse($matricule);

require_once INSTALL_DIR.$ds.$module.$ds.'inc/classes/classPresences.inc.php';
$Presences = new Presences();

$dataTraitement = $Presences->getDataTraitement($idTraitement);

require_once INSTALL_DIR.'/smarty/Smarty.class.php';
$smarty = new Smarty();
$smarty->template_dir = INSTALL_DIR.$ds.$module.$ds.'templates';
$smarty->compile_dir = INSTALL_DIR.$ds.$module.$ds.'templates_c';

$smarty->assign('dataEleve', $dataEleve);
$smarty->assign('dataTraitement', $dataTraitement);
$smarty->assign('idTraitement', $idTraitement);
$smarty->assign('matricule', $matricule);

$smarty->display('retards/modal/modalDateRetour.tpl');
