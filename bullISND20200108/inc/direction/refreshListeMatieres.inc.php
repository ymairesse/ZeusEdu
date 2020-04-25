<?php

require_once '../../../config.inc.php';

require_once INSTALL_DIR.'/inc/classes/classApplication.inc.php';
$Application = new Application();

require_once INSTALL_DIR.'/inc/classes/classUser.inc.php';
session_start();

if (!(isset($_SESSION[APPLICATION]))) {
    echo "<script type='text/javascript'>document.location.replace('".BASEDIR."');</script>";
    exit;
}

$User = $_SESSION[APPLICATION];
$acronyme = $User->getAcronyme();

// retrouver le nom du module actif
$module = $Application->getModule(3);

$matricule = isset($_POST['matricule']) ? $_POST['matricule'] : Null;
$anScol = isset($_POST['anScol']) ? $_POST['anScol'] : Null;
$periode = isset($_POST['periode']) ? $_POST['periode'] : Null;

require_once INSTALL_DIR.'/inc/classes/classPad.inc.php';
$padEleve = New padEleve($matricule, $acronyme);

// liste simple des coursGrp pour cette année scolaire et cette périodes
$listeCours = $padEleve->getCours4pad($matricule, $anScol, $periode);
sort($listeCours);
require_once INSTALL_DIR.'/inc/classes/classEcole.inc.php';
$Ecole = new Ecole();
$listeCoursGrp = $Ecole->detailsListeCoursGrp(array_flip($listeCours));

// détail des informations sur les matières à problème pour l'élève $matricule
$listeMatieres = $padEleve->getMatieres4pad($matricule, $anScol, $periode);

require_once INSTALL_DIR.'/smarty/Smarty.class.php';
$smarty = new Smarty();
$smarty->template_dir = '../../templates';
$smarty->compile_dir = '../../templates_c';

$smarty->assign('ANNEESCOLAIRE', ANNEESCOLAIRE);
$smarty->assign('listeMatieres', $listeMatieres);
$smarty->assign('listeCoursGrp', $listeCoursGrp);
$smarty->assign('matricule', $matricule);
$smarty->assign('anScol', $anScol);
$smarty->assign('periode', $periode);

$smarty->display('direction/listeMatieres.tpl');
