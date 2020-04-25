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

require_once INSTALL_DIR.'/inc/classes/classThot.inc.php';
$Thot = new Thot();

$userName = isset($_POST['userName']) ? $_POST['userName'] : null;

$identite = $Thot->verifUser($userName,'userName');

require_once(INSTALL_DIR.'/smarty/Smarty.class.php');
$smarty = new Smarty();
$smarty->template_dir = '../../templates';
$smarty->compile_dir = '../../templates_c';

$smarty->assign('identite', $identite);
$smarty->assign('MAILADMIN', MAILADMIN);
$smarty->assign('ADMINNAME', ADMINTHOT);

$smarty->assign('identite', $identite);
$smarty->assign('ECOLE', ECOLE);
$smarty->assign('identite', $identite);

$token = substr($identite['md5pwd'], 0, 20);
$link = ADRESSETHOT.'/confirm/index.php?token='.$token.'&amp;mail='.$identite['mail'].'&amp;userName='.$identite['userName'];
$smarty->assign('link', $link);

$texteMail = $smarty->fetch('parents/texteConfirmation.tpl');

echo $texteMail;
