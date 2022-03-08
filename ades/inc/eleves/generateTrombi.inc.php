<?php

require_once '../../../config.inc.php';

// définition de la class Application
require_once INSTALL_DIR.'/inc/classes/classApplication.inc.php';
$Application = new Application();

session_start();
if (!(isset($_SESSION[APPLICATION]))) {
    echo "<script type='text/javascript'>document.location.replace('".BASEDIR."');</script>";
    exit;
}

$classe = isset($_POST['classe']) ? $_POST['classe'] : Null;

if ($classe != Null) {
    require_once INSTALL_DIR.'/inc/classes/classEcole.inc.php';
    $Ecole = new Ecole();

    $listeElevesClasse = $Ecole->listeEleves($classe, 'groupe');

    require_once INSTALL_DIR."/smarty/Smarty.class.php";
    $smarty = new Smarty();
    $smarty->template_dir = "../../templates";
    $smarty->compile_dir = "../../templates_c";

    $smarty->assign('classe', $classe);
    $smarty->assign('tableauEleves', $listeElevesClasse);

    $smarty->display('eleve/trombinoscope.tpl');
}
