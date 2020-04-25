<?php

require_once '../../../config.inc.php';

require_once INSTALL_DIR.'/inc/classes/classApplication.inc.php';
$Application = new Application();

// définition de la class User pour récupérer le nom d'utilisateur depuis la session
require_once INSTALL_DIR.'/inc/classes/classUser.inc.php';
session_start();

if (!(isset($_SESSION[APPLICATION]))) {
    echo "<script type='text/javascript'>document.location.replace('".BASEDIR."');</script>";
    exit;
}

// retrouver le nom du module actif
$module = $Application->getModule(3);
$ds = DIRECTORY_SEPARATOR;
require_once INSTALL_DIR.$ds.$module.$ds.'inc/classes/classBulletin.inc.php';
$Bulletin = new Bulletin();

$User = $_SESSION[APPLICATION];
$acronyme = $User->getAcronyme();

// définition de la class Ecole
require_once INSTALL_DIR.'/inc/classes/classEcole.inc.php';
$Ecole = new Ecole();

$matricule = isset($_POST['matricule']) ? $_POST['matricule'] : Null;
$anScol = isset($_POST['anScol']) ? $_POST['anScol'] : Null;
$periode = isset($_POST['periode']) ? $_POST['periode'] : Null;

// liste des cours suivis par l'élève durant cette année scolaire
$listeCours = $Ecole->listeCoursListeEleves($matricule)[$matricule];

require_once INSTALL_DIR.'/inc/classes/classPad.inc.php';
$Pad = new padEleve($matricule, $acronyme);

// liste des matières qui figurent déjà dan sla liste des problèmes de l'élève
$listeMatieres = $Pad->getMatieres4pad($matricule, $anScol, $periode);
$listeMatieres = isset($listeMatieres[$anScol][$periode]) ? $listeMatieres[$anScol][$periode] : Null;
$listeMatieres = ($listeMatieres != Null) ? array_keys($listeMatieres) : array();

require_once INSTALL_DIR.'/smarty/Smarty.class.php';
$smarty = new Smarty();
$smarty->template_dir = '../../templates';
$smarty->compile_dir = '../../templates_c';

$smarty->assign('matricule', $matricule);
$smarty->assign('anScol', $anScol);
$smarty->assign('periode', $periode);
$smarty->assign('listeCours', $listeCours);
$smarty->assign('listeMatieres', $listeMatieres);
$smarty->display('direction/listeCBmatieres.tpl');
