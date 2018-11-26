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

require_once INSTALL_DIR."/$module/inc/classes/classJdc.inc.php";
$Jdc = new Jdc();

$listePeriodes = $Jdc->lirePeriodesCours();
$categories = $Jdc->categoriesTravaux();

$id = isset($_POST['id']) ? $_POST['id'] : Null;

if ($id != Null) {
    if ($id != $Jdc->verifIdProprio($id, $acronyme))
        die('Cette note au JDC ne vous appartient pas');

    $travail = $Jdc->getTravail($id);
    $travail['listePJ'] = $Jdc->getPJ($id);

    $destinataire = $travail['destinataire'];
    $type = $travail['type'];
    if ($type == 'coursGrp')
        $infos = $User->listeCoursProf();
        else $infos = Null;
    $lblDestinataire = $Jdc->getLabel($type, $destinataire, $infos);

    // établir la liste des fichiers PJ sélectionnés
    $selectedFiles = array();
    foreach ($travail['listePJ'] AS $shareId => $data){
        if ($data['path'] == '/')
            $selectedFiles[] = $data['path'].$data['fileName'];
            else $selectedFiles[] = $data['path'].'/'.$data['fileName'];
    }

    $ds = DIRECTORY_SEPARATOR;
    require_once INSTALL_DIR.$ds.'widgets/fileTree/inc/classes/class.Treeview.php';

    $Tree = new Treeview(INSTALL_DIR.$ds.'upload'.$ds.$acronyme, $selectedFiles);
    $baobab = $Tree->getTree();

    require_once(INSTALL_DIR."/smarty/Smarty.class.php");
    $smarty = new Smarty();
    $smarty->template_dir = INSTALL_DIR.$ds.$module.$ds."templates";
    $smarty->compile_dir = "../../templates_c";

    $smarty->assign('INSTALL_DIR', INSTALL_DIR);

    $smarty->assign('categories', $categories);
    $smarty->assign('listePeriodes', $listePeriodes);

    $smarty->assign('tree', $baobab);

    $smarty->assign('lblDestinataire', $lblDestinataire);
    $smarty->assign('selectedFiles', $travail['listePJ']);

    $smarty->assign('travail',$travail);
    $smarty->display('jdc/modal/modalEdit.tpl');
    }
