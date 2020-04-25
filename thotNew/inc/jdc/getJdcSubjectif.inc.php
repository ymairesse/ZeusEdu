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

$id = isset($_POST['id']) ? $_POST['id'] : Null;
$editable = isset($_POST['editable']) ? $_POST['editable'] : Null;
$locked = isset($_POST['locked']) ? $_POST['locked'] : Null;
$subjectif = isset($_POST['subjectif']) ? $_POST['subjectif'] : Null;

$ds = DIRECTORY_SEPARATOR;
require_once INSTALL_DIR.$ds.$module.$ds."inc/classes/classJdc.inc.php";
$Jdc = new Jdc();

if ($id != Null) {
    $arrayId = explode('_', $id);
    // si c'est un id commençant par 'Rem_' ou 'Coach_', on prend le vrai $id
    // dans $arrayId[1], sinon, dans $arrayId[0]
    $id = (isset($arrayId[1])) ? $arrayId[1] : $arrayId[0];
    $type = (isset($arrayId[1])) ? $arrayId[0] : Null;

    switch ($type) {
        case 'Rem':
            $travail = $Jdc->getRemediation($id);
            $lblDestinataire = Null;
            $travail['type'] = $type;
            $listePJ = Null;
            break;
        case 'Coach':
            $travail = $Jdc->getCoaching($id);
            $lblDestinataire = Null;
            $travail['type'] = $type;
            $listePJ = Null;
            break;
        default:
            $travail = $Jdc->getTravail($id);
            $coursGrp = $travail['destinataire'];
            $lblDestinataire = $Jdc->getRealDestinataire(Null, $acronyme, 'coursGrp', $coursGrp);
            $listePJ = $Jdc->getPj($id);
            break;
    }

    require_once INSTALL_DIR.'/smarty/Smarty.class.php';
    $smarty = new Smarty();
    $smarty->template_dir = INSTALL_DIR.$ds.$module.$ds.'templates';
    $smarty->compile_dir = INSTALL_DIR.$ds.$module.$ds.'templates_c';

    $smarty->assign('lblDestinataire', $lblDestinataire);

    $smarty->assign('id', $id);
    $smarty->assign('travail', $travail);
    $smarty->assign('listePJ', $listePJ);

    $categories = $Jdc->categoriesTravaux();
    $smarty->assign('categories', $categories);

    $smarty->assign('editable', $editable);
    $smarty->assign('subjectif', $subjectif);
    $smarty->assign('acronyme', $acronyme);

    $smarty->display('jdc/unTravail.tpl');
}
