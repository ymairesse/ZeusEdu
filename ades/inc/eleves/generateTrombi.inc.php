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

require_once INSTALL_DIR.'/inc/classes/classEcole.inc.php';
$Ecole = new Ecole();

// durée de validité pour les Cookies
$unAn = time() + 365 * 24 * 3600;
$classe = Application::postOrCookie('classe', $unAn);
$listeElevesClasse = $Ecole->listeEleves($classe,'groupe');

require_once INSTALL_DIR."/smarty/Smarty.class.php";
$smarty = new Smarty();
$smarty->template_dir = "../../templates";
$smarty->compile_dir = "../../templates_c";

$smarty->assign('classe',$classe);
$smarty->assign('tableauEleves', $listeElevesClasse);
echo $smarty->fetch('eleve/trombinoscope.tpl');
