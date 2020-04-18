<?php

require_once '../../../config.inc.php';

session_start();

$typeRP = isset($_POST['typeRP']) ? $_POST['typeRP'] : null;
$readonly = isset($_POST['readonly'])?$_POST['readonly']:Null;

require_once INSTALL_DIR.'/inc/classes/classApplication.inc.php';
$Application = new Application();

require_once INSTALL_DIR.'/inc/classes/classEcole.inc.php';
$Ecole = new Ecole();

if ($typeRP == 'profs')
    $listeProfs = $Ecole->listeProfs();
    else {
        $listeProfs = $Ecole->listeProfsTitus(true);
    }

require_once INSTALL_DIR.'/smarty/Smarty.class.php';
$smarty = new Smarty();
$smarty->template_dir = '../../templates';
$smarty->compile_dir = '../../templates_c';

$smarty->assign('listeProfs', $listeProfs);
$smarty->assign('readonly', $readonly);

echo $smarty->fetch('reunionParents/nouveau/listeProfs.tpl');
