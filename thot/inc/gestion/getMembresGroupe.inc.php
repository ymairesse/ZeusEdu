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

$ds = DIRECTORY_SEPARATOR;
require_once INSTALL_DIR.$ds.'inc/classes/classThot.inc.php';
$Thot = new Thot();

$ds = DIRECTORY_SEPARATOR;
require_once INSTALL_DIR.$ds.'inc/classes/classEcole.inc.php';
$listeNiveaux = Ecole::listeNiveaux();

$nomGroupe = isset($_POST['nomGroupe']) ? $_POST['nomGroupe'] : Null;
$intitule = isset($_POST['intitule']) ? $_POST['intitule'] : Null;

$listeMembres = $Thot->getListeMembresGroupe($nomGroupe, $acronyme);

require_once INSTALL_DIR.'/smarty/Smarty.class.php';
$smarty = new Smarty();
$smarty->template_dir = '../../templates';
$smarty->compile_dir = '../../templates_c';

$smarty->assign('nomGroupe', $nomGroupe);
$smarty->assign('listeNiveaux', $listeNiveaux);
$smarty->assign('intitule', $intitule);
$smarty->assign('listeMembres', $listeMembres);

$smarty->display('gestion/gestMembres.tpl');
