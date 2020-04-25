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

// si c'est une édition, on récupère le nom du groupe
$nomGroupe = isset($_POST['nomGroupe']) ? $_POST['nomGroupe'] : Null;

$ds = DIRECTORY_SEPARATOR;
require_once INSTALL_DIR.$ds.'inc/classes/classThot2.inc.php';
$Thot = new Thot();

// s'il s'agit d'un nouveau groupe
if ($nomGroupe == Null) {
        $dataGroupe = array(
            'nomGroupe' => '',
            'intitule' => '',
            'description' => ''
        );
        $edition = 0;
    }
    else {
        // sinon, on récupère les informations sur le groupe
        $dataGroupe = $Thot->getData4groupe($nomGroupe, $acronyme);
        $edition = 1;
    }

require_once INSTALL_DIR.'/smarty/Smarty.class.php';
$smarty = new Smarty();
$smarty->template_dir = '../../templates';
$smarty->compile_dir = '../../templates_c';

$smarty->assign('dataGroupe', $dataGroupe);
$smarty->assign('edition', $edition);
$smarty->display('gestion/inc/formDescription.tpl');
