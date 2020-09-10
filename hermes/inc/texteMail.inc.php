<?php

require_once '../../config.inc.php';

require_once '../../inc/classes/classApplication.inc.php';
$Application = new Application();

require_once INSTALL_DIR.'/inc/classes/classUser.inc.php';
session_start();

if (!(isset($_SESSION[APPLICATION]))) {
    die("<div class='alert alert-danger'>Votre session a expiré. Veuillez vous reconnecter.</div>");
}

$User = $_SESSION[APPLICATION];
$acronyme = $User->getAcronyme();

$module = $Application->getModule(2);

require_once INSTALL_DIR."/$module/inc/classes/classHermes.inc.php";
$hermes = new hermes();

$id = isset($_POST['id']) ? $_POST['id'] : null;

$recentArchive = $hermes->getMailById($id, $acronyme);

require_once INSTALL_DIR.'/smarty/Smarty.class.php';
$smarty = new Smarty();
$smarty->template_dir = '../templates';
$smarty->compile_dir = '../templates_c';

$smarty->assign('acronyme', $acronyme);
$smarty->assign('recentArchive', $recentArchive);

$smarty->display('../templates/inc/texteMail.tpl');
