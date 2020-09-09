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

$module = $Application->getModule(2);

$ds = DIRECTORY_SEPARATOR;
require_once INSTALL_DIR.$ds.$module.$ds.'inc/classes/classHermes.inc.php';
$Hermes = new hermes();

$id = isset($_POST['id']) ? $_POST['id'] : Null;

$listeProfs = $Hermes->listeMailingProfs();
$listeMembres = array_keys($Hermes->membresListe($id));

foreach ($listeProfs['membres'] AS $acronyme => $data) {
    if (in_array($acronyme, $listeMembres)){
        $listeProfs['membres'][$acronyme]['selected'] = true;
    }
}

require_once INSTALL_DIR.'/smarty/Smarty.class.php';
$smarty = new Smarty();
$smarty->template_dir = '../templates';
$smarty->compile_dir = '../templates_c';

$smarty->assign('listeProfs', $listeProfs);

$smarty->display('inc/listeProfs.tpl');
