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

$classe = isset($_POST['classe']) ? $_POST['classe'] : Null;
$matricule = isset($_POST['matricule']) ? $_POST['matricule'] : Null;
$listePlus = isset($_POST['listePlus']) ? $_POST['listePlus'] : Null;

$listeElevesPlus = array();
parse_str($listePlus, $listeElevesPlus);
if (isset($listeElevesPlus['elevesPlus']))
    $listeElevesPlus = $listeElevesPlus['elevesPlus'];

require_once INSTALL_DIR.'/inc/classes/classEcole.inc.php';
$Ecole = new Ecole();

$listeClasses = $Ecole->listeClasses();
if (isset($classe)) {
    $listeEleves = $Ecole->listeEleves($classe);
    }
    else $listeEleves = Null;


require_once INSTALL_DIR.'/smarty/Smarty.class.php';
$smarty = new Smarty();
$smarty->template_dir = '../../templates';
$smarty->compile_dir = '../../templates_c';

$smarty->assign('listeClasses', $listeClasses);
$smarty->assign('classe', $classe);
$smarty->assign('listeEleves', $listeEleves);
$smarty->assign('matricule', $matricule);
$smarty->assign('listeElevesPlus', $listeElevesPlus);

$smarty->display('detailSuivi/modalPlusEleves.tpl');
