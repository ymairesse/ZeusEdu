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
$laDate = isset($_POST['laDate']) ? $_POST['laDate'] : Null;

$test = ($laDate != '') ? explode('/', $laDate) : Null;

if ((count($test) == 3) && checkDate($test[1], $test[0], $test[2]))
    $today = trim($laDate);
    else $today = strftime('%d/%m/%Y');

require_once INSTALL_DIR.'/smarty/Smarty.class.php';
$smarty = new Smarty();
$smarty->template_dir = '../../templates';
$smarty->compile_dir = '../../templates_c';

$smarty->assign('today', $today);
$smarty->display('forum/modal/modalDate.tpl');
