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

// informations disciplinaires
require_once INSTALL_DIR.'/ades/inc/classes/classEleveAdes.inc.php';
$EleveAdes = new EleveAdes();
$ficheDisciplinaire = $EleveAdes->getListeFaits($matricule);
$listeRetenuesEleve = $EleveAdes->getListeRetenuesEleve($matricule);


require_once INSTALL_DIR.'/smarty/Smarty.class.php';
$smarty = new Smarty();
$smarty->template_dir = '../../templates';
$smarty->compile_dir = '../../templates_c';

$smarty->assign('ANNEESCOLAIRE', ANNEESCOLAIRE);

$smarty->assign('listeTousFaits', $ficheDisciplinaire);
$smarty->assign('listeRetenuesEleve', $listeRetenuesEleve);
$smarty->assign('nbFaits', $EleveAdes->nbFaits($matricule, ANNEESCOLAIRE));

require_once INSTALL_DIR.'/ades/inc/classes/classAdes.inc.php';
$Ades = new Ades();
$smarty->assign('listeTypesFaits', $Ades->listeTypesFaits());
$smarty->assign('descriptionChamps', $Ades->listeChamps());

$smarty->display('detailSuivi/infoDisciplinaires.tpl');
