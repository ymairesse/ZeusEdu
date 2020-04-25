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

$module = $Application->getModule(3);

$ds = DIRECTORY_SEPARATOR;

$type = isset($_POST['type']) ? $_POST['type'] : Null;
$classe = isset($_POST['classe']) ? $_POST['classe'] : Null;
$coursGrp = isset($_POST['coursGrp']) ? $_POST['coursGrp'] : Null;
$groupe = isset($_POST['groupe']) ? $_POST['groupe'] : Null;

require_once(INSTALL_DIR.'/inc/classes/classEcole.inc.php');
$Ecole = new Ecole();

switch ($type) {
    case 'classes':
        $listeEleves = $Ecole->listeElevesClasse($classe);
        break;
    case 'coursGrp':
        $listeEleves = $Ecole->listeElevesCours($coursGrp, 'alpha');
        break;
    case 'groupe':
        $listeEleves = $Ecole->listeElevesGroupe($groupe);
        break;
}

require_once(INSTALL_DIR."/smarty/Smarty.class.php");
$smarty = new Smarty();
$smarty->template_dir = "../../templates";
$smarty->compile_dir = "../../templates_c";

$smarty->assign('listeEleves', $listeEleves);
$smarty->display('../templates/selecteurs/selectElevesAjax.tpl');
