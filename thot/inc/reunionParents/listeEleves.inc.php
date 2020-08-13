<?php

require_once '../../../config.inc.php';

require_once INSTALL_DIR.'/inc/classes/classApplication.inc.php';
$Application = new Application();

session_start();
if (!(isset($_SESSION[APPLICATION]))) {
    die("<div class='alert alert-danger'>".RECONNECT.'</div>');
}

$acronyme = isset($_POST['acronyme']) ? $_POST['acronyme'] : null;
$statut = isset($_POST['statut']) ? $_POST['statut'] : null;
$typeRP = isset($_POST['typeRP']) ? $_POST['typeRP'] : null;

require_once INSTALL_DIR.'/inc/classes/classEcole.inc.php';
$Ecole = new Ecole();

require_once INSTALL_DIR.'/inc/classes/classThot.inc.php';
$thot = new Thot();

switch ($typeRP) {
    case 'profs':
        $listeEleves = $thot->getElevesDeProf($acronyme, $statut);
        break;
    case 'titus':
        $listeTitulariats = $Ecole->listeTitulariats($acronyme);
        $listeEleves = $Ecole->listeElevesMultiClasses($listeTitulariats);
        break;
    case 'cible':
        $listeClasses = array_flip($Ecole->listeClasses());
        $listeEleves = $Ecole->listeElevesMultiClasses($listeClasses);
        break;
}

require_once INSTALL_DIR.'/smarty/Smarty.class.php';
$smarty = new Smarty();
$smarty->template_dir = '../../templates';
$smarty->compile_dir = '../../templates_c';

$smarty->assign('listeEleves', $listeEleves);
$smarty->display('reunionParents/listeElevesProf.tpl');
