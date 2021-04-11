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

$formulaire = isset($_POST['formulaire']) ? $_POST['formulaire'] : null;
$form = array();
parse_str($formulaire, $form);

$leType = isset($form['leType']) ? $form['leType'] : null;
$readonly = isset($_form['readonly'])?$_form['readonly']:Null;

require_once INSTALL_DIR.'/inc/classes/classEcole.inc.php';
$Ecole = new Ecole();

switch ($leType) {
    case 'profs':
        $listeProfs = $Ecole->listeProfs();
        break;
    case 'cible':
        $listeProfs = $Ecole->listeProfs();
        break;
    case 'titulaires':
        $listeProfs = $Ecole->listeProfsTitus(true);
        break;
    }

require_once INSTALL_DIR.'/smarty/Smarty.class.php';
$smarty = new Smarty();
$smarty->template_dir = '../../templates';
$smarty->compile_dir = '../../templates_c';

$smarty->assign('listeProfs', $listeProfs);

echo $smarty->fetch('reunionParents/nouveau/listeProfs.tpl');
