<?php
//
// require_once '../../../config.inc.php';
//
// // définition de la class Application
// require_once INSTALL_DIR.'/inc/classes/classApplication.inc.php';
// $Application = new Application();
//
// session_start();
// if (!(isset($_SESSION[APPLICATION]))) {
//     echo "<script type='text/javascript'>document.location.replace('".BASEDIR."');</script>";
//     exit;
// }

echo(getcwd());

// require_once INSTALL_DIR.'/inc/classes/classEcole.inc.php';
// $Ecole = new Ecole();
//
// $listeClasses = $Ecole->listeGroupes();
// $classe = isset($_COOKIE['classe']) ? $_COOKIE['classe'] : Null;
// $matricule = isset($_COOKIE['matricule']) ? $_COOKIE['matricule'] : Null;
//
require_once INSTALL_DIR."/smarty/Smarty.class.php";
$smarty = new Smarty();
$smarty->template_dir = "../../templates";
$smarty->compile_dir = "../../templates_c";

$smarty->assign('listeClasses', $listeClasses);
$smarty->assign('classe', $classe);
$smarty->assign('matricule', $matricule);

$smarty->display('eleve/newEleveClasse.tpl');
