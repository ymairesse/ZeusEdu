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

require_once INSTALL_DIR.'/inc/classes/classEleve.inc.php';
$Eleve = new Eleve($matricule);

// adresses mail provenant de la fiche de l'élève (importation de ProEco)
$details = $Eleve->getDetailsEleve();

$responsable = array('titre'=> 'Responsable', 'nom' => $details['nomResp'], 'mail' => trim($details['courriel']));
$pere = array('titre'=>'Père', 'nom' => $details['nomPere'], 'mail' => trim($details['mailPere']));
$mere = array('titre'=> 'Mère', 'nom' => $details['nomMere'], 'mail' => trim($details['mailMere']));

// adresses mail des parents provenant de Thot
require_once INSTALL_DIR.'/inc/classes/classThot.inc.php';
$Thot = new Thot();
$infoParentsThot = $Thot->getInfoParents($matricule);

require_once INSTALL_DIR.'/smarty/Smarty.class.php';
$smarty = new Smarty();
$smarty->template_dir = '../../templates';
$smarty->compile_dir = '../../templates_c';

$smarty->assign('listeParents', array($responsable, $pere, $mere));
$smarty->assign('infoParentsThot', $infoParentsThot);

$smarty->display('eleve/choixSendParents.tpl');
