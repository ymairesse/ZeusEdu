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

$coursGrp = isset($_POST['coursGrp']) ? $_POST['coursGrp'] : Null;
$matricule = isset($_POST['matricule']) ? $_POST['matricule'] : Null;
$periode = isset($_POST['periode']) ? $_POST['periode'] : Null;

require_once INSTALL_DIR."/bullISND/inc/classes/classBulletin.inc.php";
$Bulletin = new Bulletin();

// la fonction getCotes4listeCoursGrp ne fonctionne qu'avec des array's
$listeCoursGrp = array($coursGrp => $coursGrp);
$listeCotes = $Bulletin->getCotes4listeCoursGrp($listeCoursGrp, $matricule);

$ds = DIRECTORY_SEPARATOR;
require_once INSTALL_DIR.'/smarty/Smarty.class.php';
$smarty = new Smarty;
$smarty->template_dir = INSTALL_DIR.$ds.$module.$ds.'templates';
$smarty->compile_dir = INSTALL_DIR.$ds.$module.$ds.'templates_c';

if (isset($listeCotes[$coursGrp]))
    $listeCotes = $listeCotes[$coursGrp];
    else $listeCotes = Null;
$smarty->assign('listeCotes', $listeCotes);

if ($listeCotes != Null) {
    $listePeriodes = array_keys($listeCotes);
    if (!(in_array($periode, $listePeriodes))) {
        $periode = array_shift($listePeriodes);
        }
    }

$smarty->assign('periode', $periode);
$smarty->display('carnet/listeCotesEleve.tpl');
