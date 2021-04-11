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

// INFORMATIONS NÉCESSAIRES POUR LA CRÉATION DU CANEVAS DE LA RP
$debut = isset($form['debut']) ? $form['debut']:Null;
$fin = isset($form['fin']) ? $form['fin']:Null;
$duree = isset($form['duree']) ? $form['duree']:Null;


$listeMoments = array();

if ($duree > 0) {
    // passer au format 00:00
    $debut = date('H:i', strtotime($debut));
    $fin = date('H:i', strtotime($fin));
    $plusTard = $debut;
    while ($plusTard <= $fin) {
        $listeMoments[] = $plusTard;
        $plusTard = date('H:i',strtotime($duree." minutes", strtotime($plusTard)));
    }
}

// Application::afficher($listeMoments, true);

require_once INSTALL_DIR.'/smarty/Smarty.class.php';
$smarty = new Smarty();
$smarty->template_dir = '../../templates';
$smarty->compile_dir = '../../templates_c';

$smarty->assign('listeHeuresRP', $listeMoments);

echo $smarty->fetch('reunionParents/nouveau/listeHeures.tpl');
