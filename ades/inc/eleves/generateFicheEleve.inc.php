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

$User = $_SESSION[APPLICATION];
$acronyme = $User->getAcronyme();

// durée de validité pour les Cookies
$unAn = time() + 365 * 24 * 3600;
$matricule = Application::postOrCookie('matricule', $unAn);
$classe =  Application::postOrCookie('classe', $unAn);

$module = $Application->getModule(3);
require_once INSTALL_DIR."/$module/inc/classes/classEleveAdes.inc.php";
$EleveAdes = new EleveAdes();

require_once INSTALL_DIR.'/inc/classes/classEleve.inc.php';

require_once INSTALL_DIR."/$module/inc/classes/classAdes.inc.php";
$Ades = new Ades();

require_once INSTALL_DIR.'/inc/classes/classPad.inc.php';
$memoEleve = new padEleve($matricule, 'ades');

$eleve = Eleve::staticGetDetailsEleve($matricule);
$titulaires = Eleve::staticGetTitulaires($classe);

require_once INSTALL_DIR."/smarty/Smarty.class.php";
$smarty = new Smarty();
$smarty->template_dir = "../../templates";
$smarty->compile_dir = "../../templates_c";

$userStatus = $User->userStatus($module);
$smarty->assign('userStatus', $userStatus);

$identite = $User->identite();
$smarty->assign('identite', $identite);

$smarty->assign('eleve', $eleve);
$smarty->assign('titulaires', $titulaires);
$smarty->assign('listeTypesFaits', $Ades->listeTypesFaits());
$smarty->assign('descriptionChamps', $Ades->listeChamps());

$smarty->assign('memoEleve', $memoEleve->getPads());

$ficheDisciplinaire = $EleveAdes->getListeFaits($matricule);
$listeRetenuesEleve = $EleveAdes->getListeRetenuesEleve($matricule);

$smarty->assign('listeTousFaits', $ficheDisciplinaire);
$smarty->assign('listeRetenuesEleve', $listeRetenuesEleve);

echo $smarty->fetch('eleve/ficheEleve.tpl');
