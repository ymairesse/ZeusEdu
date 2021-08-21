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

require_once INSTALL_DIR.'/inc/classes/class.Athena.php';
$Athena = new Athena();

$id = isset($_POST['id']) ? $_POST['id'] : Null;

$demande = $Athena->getDemandeAideEleve($id);
$matricule = $demande['matricule'];

$listeObjets = $Athena->getObjets4id($id);
$listeMedias = $Athena->getMedias4id($id);

$ds = DIRECTORY_SEPARATOR;
require_once INSTALL_DIR.'/smarty/Smarty.class.php';
$smarty = new Smarty();
$smarty->template_dir = INSTALL_DIR.$ds.$module.$ds.'templates';
$smarty->compile_dir = INSTALL_DIR.$ds.$module.$ds.'templates_c';

require_once INSTALL_DIR.'/inc/classes/classEcole.inc.php';
$smarty->assign('photo', Ecole::photo($matricule));
require_once INSTALL_DIR.'/inc/classes/classEleve.inc.php';
$dataEleve = Eleve::staticGetDataPwd($matricule);
$smarty->assign('mailScolaire', sprintf('%s@%s', $dataEleve['user'], $dataEleve['mailDomain']));

$listeCoaches = $Athena->getCoachesDe($matricule);

$smarty->assign('listeCoaches', $listeCoaches);
$smarty->assign('demande', $demande);
$smarty->assign('listeObjets', $listeObjets);
$smarty->assign('listeMedias', $listeMedias);

$smarty->display('eleves/modal/modalLookEleve.tpl');
