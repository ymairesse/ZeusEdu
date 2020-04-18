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
require_once INSTALL_DIR.'/inc/classes/classThot.inc.php';
$Thot = new Thot(); 

require_once INSTALL_DIR.'/inc/classes/classEcole.inc.php';
$Ecole = new Ecole();

// récupérer le formulaire
$formulaire = isset($_POST['formulaire']) ? $_POST['formulaire'] : null;
$form = array();
parse_str($formulaire, $form);

$dateDebut = isset($form['dateDebut']) ? $form['dateDebut'] : Null;
$dateFin = isset($form['dateFin']) ? $form['dateFin'] : Null;
$classe = isset($form['classe']) ? $form['classe'] : Null;
$cible = isset($form['cible']) ? $form['cible'] : Null;

require_once INSTALL_DIR.'/smarty/Smarty.class.php';
$smarty = new Smarty();
$smarty->template_dir = INSTALL_DIR.$ds.$module.$ds.'templates';
$smarty->compile_dir = INSTALL_DIR.$ds.$module.$ds.'templates_c';

$listeEleves = $Ecole->listeElevesClasse($classe);

if ($cible == 'parents') {
    $stats = $Thot->getStatsParents($dateDebut, $dateFin, $classe);
    $smarty->assign('stats', $stats);
    $smarty->display('stats/detailsStatsParents.tpl');
    }
    else {
        $stats = $Thot->getStatsEleves($dateDebut, $dateFin, $classe);
        foreach ($stats as $user => $dataStats) {
			$matricule = $dataStats['matricule'];
			$listeEleves[$matricule]['stats'] = $dataStats['nb'];
			} 
		$smarty->assign('listeEleves', $listeEleves);
        $smarty->assign('dateDebut', $dateDebut);
        $smarty->assign('dateFin', $dateFin);
        $smarty->display('stats/detailsStatsEleves.tpl');
    }
