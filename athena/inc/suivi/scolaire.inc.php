<?php

require_once '../../../config.inc.php';

// définition de la class Application
require_once INSTALL_DIR.'/inc/classes/classApplication.inc.php';
$Application = new Application();

// définition de la class USER utilisée en variable de SESSION
require_once INSTALL_DIR.'/inc/classes/classUser.inc.php';

session_start();
if (!(isset($_SESSION[APPLICATION]))) {
    echo "<script type='text/javascript'>document.location.replace('".BASEDIR."');</script>";
    exit;
}

$matricule = isset($_POST['matricule']) ? $_POST['matricule'] : null;
if ($matricule == null) {
    die();
}

require_once INSTALL_DIR.'/smarty/Smarty.class.php';
$smarty = new Smarty();
$smarty->template_dir = '../../templates';
$smarty->compile_dir = '../../templates_c';

$smarty->assign('ANNEEENCOURS', ANNEESCOLAIRE);

require_once INSTALL_DIR.'/bullISND/inc/classes/classBulletin.inc.php';
$Bulletin = new Bulletin();

require_once INSTALL_DIR.'/inc/classes/classEleve.inc.php';
$Eleve = new Eleve($matricule);

$dataEleve = $Eleve->getDetailsEleve();
$smarty->assign('eleve', $dataEleve);

$smarty->assign('ecoles', $Eleve->ecoleOrigine());

if ($Bulletin->listeFullCoursGrpActuel($matricule) != Null) {
    $listeCoursActuelle = $Bulletin->listeFullCoursGrpActuel($matricule)[$matricule];
    $smarty->assign('listeCoursGrp', $listeCoursActuelle);

    $syntheseAnneeEnCours = $Bulletin->syntheseAnneeEnCours($listeCoursActuelle, $matricule);
    $smarty->assign('anneeEnCours', $syntheseAnneeEnCours);
}
else {
    $smarty->assign('listeCoursGrp', Null);
    $smarty->assign('anneeEnCours', Null);
}
$syntheseToutesAnnees = $Bulletin->syntheseToutesAnnees($matricule);
$smarty->assign('syntheseToutesAnnees', $syntheseToutesAnnees);

$smarty->display('detailSuivi/scolaire.tpl');
