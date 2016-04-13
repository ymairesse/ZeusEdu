<?php

require_once '../../../config.inc.php';

require_once '../../../inc/classes/classApplication.inc.php';
$Application = new Application();

require_once INSTALL_DIR.'/inc/classes/classUser.inc.php';
session_start();

if (!(isset($_SESSION[APPLICATION]))) {
    die("<div class='alert alert-danger'>Votre session a expiré. Veuillez vous reconnecter.</div>");
}

$User = $_SESSION[APPLICATION];
$acronyme = $User->getAcronyme();

$id = isset($_POST['id'])?$_POST['id']:Null;

require_once (INSTALL_DIR."/inc/classes/classThot.inc.php");
$thot = new Thot();

$listeAccuses = $thot->getAccuses($id, $acronyme);

require_once(INSTALL_DIR."/smarty/Smarty.class.php");
$smarty = new Smarty();
$smarty->template_dir = "../templates";
$smarty->compile_dir = "../templates_c";

$smarty->assign('listeAccuses', $listeAccuses);
$accuses = $smarty->fetch('../../templates/notification/modalAccuses.tpl');
echo $accuses;
