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
require_once INSTALL_DIR.$ds.$module.$ds.'inc/classes/class.remediation.inc.php';
$Remediation = new Remediation();

$matricule = isset($_POST['matricule']) ? $_POST['matricule'] : Null;

require_once INSTALL_DIR.'/inc/classes/classEleve.inc.php';
$Eleve = new Eleve($matricule);

$eleve = $Eleve->getDetailsEleve();
$classe = $eleve['groupe'];
$niveau = SUBSTR($classe, 0, 1);

$listeCoursGrp = array_keys(current($Remediation->listeCoursGrpActuelsEleve($matricule)));
$listeMatieres = array_keys($Remediation->listeCoursEleves($matricule));

// les remédiations auxquelles l'élève est inscrit
$catalogue = $Remediation->getCatalogue4eleve($niveau, $classe, $listeCoursGrp, $listeMatieres);


require_once INSTALL_DIR.'/smarty/Smarty.class.php';
$smarty = new Smarty();
$smarty->template_dir = INSTALL_DIR.$ds.$module.$ds.'templates';
$smarty->compile_dir = INSTALL_DIR.$ds.$module.$ds.'templates_c';

$smarty->assign('catalogue', $catalogue);

$smarty->display('remediation/catalogue.tpl');
