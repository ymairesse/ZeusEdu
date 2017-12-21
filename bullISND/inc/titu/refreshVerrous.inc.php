<?php

require_once '../../../config.inc.php';

// définition de la class Application
require_once INSTALL_DIR.'/inc/classes/classApplication.inc.php';
$Application = new Application();

// répertoire du module actuel
$module = $Application->getModule(3);

// durée de validité pour les Cookies
$unAn = time() + 365 * 24 * 3600;

// définition de la class USER utilisée en variable de SESSION
require_once INSTALL_DIR.'/inc/classes/classUser.inc.php';

session_start();
if (!(isset($_SESSION[APPLICATION]))) {
    echo "<script type='text/javascript'>document.location.replace('".BASEDIR."');</script>";
    exit;
}

$classe = isset($_POST['classe']) ? $_POST['classe'] : null;
$periode = isset($_POST['periode']) ? $_POST['periode'] : null;

$ds = DIRECTORY_SEPARATOR;
$module = $Application::getModule(3);
require_once INSTALL_DIR.$ds.$module.$ds.'inc/classes/classBulletin.inc.php';
$Bulletin = new Bulletin();

require_once INSTALL_DIR.$ds.'inc/classes/classEcole.inc.php';
$Ecole = new Ecole();
$listeEleves = $Ecole->listeEleves($classe, 'groupe');

$listeCoursGrpClasse = $Ecole->listeCoursGrpClasse($classe);
$listeCoursGrpEleves = $Bulletin->listeCoursGrpEleves($listeEleves, $periode);
$listeVerrous = $Bulletin->listeLocksBulletin($listeEleves, $listeCoursGrpClasse, $periode);

require_once INSTALL_DIR."/smarty/Smarty.class.php";
$smarty = new Smarty();
$smarty->template_dir = INSTALL_DIR.$ds.$module.$ds.'templates';
$smarty->compile_dir = INSTALL_DIR.$ds.$module.$ds.'templates_c';

$smarty->assign('classe', $classe);
$smarty->assign('listeEleves', $listeEleves);
$smarty->assign('listeCoursGrpEleves', $listeCoursGrpEleves);
$smarty->assign('listeCoursGrpClasse', $listeCoursGrpClasse);
$smarty->assign('listeVerrous', $listeVerrous);

$smarty->display('titu/verrouMainForm.tpl');
