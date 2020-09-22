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

$ds = DIRECTORY_SEPARATOR;
require_once INSTALL_DIR.$ds.$module.$ds.'inc/classes/classJdc.inc.php';
$Jdc = new Jdc();

$id = isset($_POST['id']) ? $_POST['id'] : Null;
$editable = isset($_POST['editable']) ? $_POST['editable'] : Null;
$locked = isset($_POST['locked']) ? $_POST['locked'] : Null;
$subjectif = isset($_POST['subjectif']) ? $_POST['subjectif'] : Null;

if ($id != null) {

    require_once INSTALL_DIR.'/smarty/Smarty.class.php';
    $smarty = new Smarty();
    $smarty->template_dir = INSTALL_DIR.$ds.$module.$ds.'templates';
    $smarty->compile_dir = INSTALL_DIR.$ds.$module.$ds.'templates_c';

    $travail = $Jdc->getTravail($id);
    $smarty->assign('travail', $travail);

    $type = $travail['type'];
    $smarty->assign('type', $type);
    $destinataire = $travail['destinataire'];

    $categories = $Jdc->categoriesTravaux();
    $smarty->assign('categories', $categories);

    $lblDestinataire = $Jdc->getRealDestinataire(Null, $acronyme, $type, $destinataire);

    $smarty->assign('lblDestinataire', $lblDestinataire);

    $pj = $Jdc->getPj($id);
    $smarty->assign('id', $id);
    $smarty->assign('lblDestinataire', $lblDestinataire);

    $smarty->assign('editable', $editable);
    $smarty->assign('subjectif', $subjectif);
    $smarty->assign('locked', $locked);
    $smarty->assign('acronyme', $acronyme);

    $listePJ = $Jdc->getPJ($id);
    $smarty->assign('listePJ', $listePJ);

    $smarty->display('jdc/unTravail.tpl');
}
