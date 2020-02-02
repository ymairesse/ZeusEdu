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

$module = $Application::getmodule(2);

$indice = isset($_POST['indice']) ? $_POST['indice'] : null;
$table = isset($_POST['table']) ? $_POST['table'] : null;

$nbRows = $Application->nbRows4table($table);
$boutons = $Application->listeBoutons($indice, $nbRows);

$ds = DIRECTORY_SEPARATOR;
require_once INSTALL_DIR.$ds.'smarty/Smarty.class.php';
$smarty = new Smarty();
$smarty->template_dir = INSTALL_DIR.$ds.$module.$ds.'templates';
$smarty->compile_dir = INSTALL_DIR.$ds.$module.$ds.'templates_c';

$smarty->assign('indice', $indice);
$smarty->assign('boutons', $boutons);
$smarty->assign('table', $table);
$smarty->display('sql/listeBoutons.inc.tpl');
