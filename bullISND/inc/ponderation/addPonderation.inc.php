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

$matricule = isset($_POST['matricule'])?$_POST['matricule']:Null;
$coursGrp = isset($_POST['coursGrp'])?$_POST['coursGrp']:Null;
$bulletin = isset($_POST['bulletin'])?$_POST['bulletin']:Null;

$ds = DIRECTORY_SEPARATOR;
require_once INSTALL_DIR.$ds.$module.'/inc/classes/classBulletin.inc.php';
$Bulletin = new Bulletin();

$listePonderations = $Bulletin->getPonderations($coursGrp)[$coursGrp];
$listePonderations = (isset($listePonderations[$matricule])) ? $listePonderations[$matricule] : $listePonderations['all'];

$intituleCours = $Bulletin->intituleCours($coursGrp);

require_once INSTALL_DIR.'/inc/classes/classEcole.inc.php';
$Ecole = new Ecole();

if ($matricule != 'all') {
    $nomEleve = $Ecole->nomPrenomClasse($matricule);
    $nomEleve = sprintf('%s %s %s', $nomEleve['prenom'], $nomEleve['nom'], $nomEleve['classe']);
} else {
        $nomEleve = 'Tous les élèves';
    }

$classesDansCours = (isset($coursGrp)) ? implode(', ', $Bulletin->classesDansCours($coursGrp)) : Null;

require_once(INSTALL_DIR."/smarty/Smarty.class.php");
$smarty = new Smarty();
$smarty->template_dir = INSTALL_DIR.$ds.$module.$ds."templates";
$smarty->compile_dir = INSTALL_DIR.$ds.$module.$ds."templates_c";

$smarty->assign('listePonderations', $listePonderations);
$smarty->assign('listeClasses', $classesDansCours);
$smarty->assign('NOMSPERIODES', explode(',', NOMSPERIODES));
$smarty->assign('listePeriodes', range(1, NBPERIODES));
$smarty->assign('intituleCours', $intituleCours);
$smarty->assign('matricule', $matricule);
$smarty->assign('coursGrp', $coursGrp);
$smarty->assign('bulletin', $bulletin);
$smarty->assign('nomEleve', $nomEleve);

$smarty->display('ponderation/modal/modalPonderation.tpl');
