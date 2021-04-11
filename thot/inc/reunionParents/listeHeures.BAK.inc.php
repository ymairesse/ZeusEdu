<?php

require_once '../../../config.inc.php';

session_start();

require_once INSTALL_DIR.'/inc/classes/classApplication.inc.php';
$Application = new Application();

$debut = isset($_POST['debut']) ? $_POST['debut']:Null;
$fin = isset($_POST['fin']) ? $_POST['fin']:Null;
$duree = isset($_POST['duree']) ? $_POST['duree']:Null;
$readonly = isset($_POST['readonly']) ? $_POST['readonly']:Null;

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

require_once INSTALL_DIR.'/smarty/Smarty.class.php';
$smarty = new Smarty();
$smarty->template_dir = '../../templates';
$smarty->compile_dir = '../../templates_c';

$smarty->assign('listeHeuresRP', $listeMoments);
$smarty->assign('readonly', $readonly);

echo $smarty->fetch('reunionParents/nouveau/listeHeures.tpl');
