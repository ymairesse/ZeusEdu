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

$path = isset($_POST['path']) ? $_POST['path'] : null;
$fileName = isset($_POST['fileName']) ? $_POST['fileName'] : null;
$dirOrFile = isset($_POST['dirOrFile']) ? $_POST['dirOrFile'] : null;

require_once INSTALL_DIR.'/smarty/Smarty.class.php';
$smarty = new Smarty();
$smarty->template_dir = '../../templates';
$smarty->compile_dir = '../../templates_c';

$smarty->assign('path', $path);
$smarty->assign('fileName', $fileName);
$smarty->assign('dirOrFile', $dirOrFile);

$smarty->display('files/modal/modalShare.tpl');
