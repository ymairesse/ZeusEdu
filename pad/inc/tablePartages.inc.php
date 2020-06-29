<?php

require_once '../../config.inc.php';

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

$module = $Application->getModule(2);

$mode = isset($_POST['mode']) ? $_POST['mode'] : Null;
$groupe = isset($_POST['groupe']) ? $_POST['groupe'] : Null;

require_once INSTALL_DIR.'/inc/classes/classEcole.inc.php';
$Ecole = new Ecole();

require_once INSTALL_DIR.'/inc/classes/classPad.inc.php';

if ($mode == 'parClasse') {
    $listeEleves = $Ecole->listeEleves($groupe, 'groupe');
    }
    else {
        $listeEleves = $Ecole->listeElevesCours($groupe, 'alpha');
    }

$listePartages = PadEleve::listePartages($acronyme, $listeEleves);

$listeProfs = $Ecole->listeProfs();

require_once(INSTALL_DIR."/smarty/Smarty.class.php");
$smarty = new Smarty();
$smarty->template_dir = "../templates";
$smarty->compile_dir = "../templates_c";

$smarty->assign('listeEleves', $listeEleves);
$smarty->assign('listePartages', $listePartages);
$smarty->assign('listeProfs',$listeProfs);  

$smarty->display('tableauPartages.tpl');
