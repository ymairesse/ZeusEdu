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

require_once INSTALL_DIR.$ds.$module.$ds."inc/classes/classBulletin.inc.php";
$Bulletin = new Bulletin();

require_once INSTALL_DIR.$ds.'inc/classes/classEcole.inc.php';
$Ecole = new Ecole();

// durée de validité pour les Cookies
$unAn = time() + 365 * 24 * 3600;
$tri = $Application->postOrCookie('tri', $unAn);

$formulaire = isset($_POST['formulaire']) ? $_POST['formulaire'] : null;
$form = array();
parse_str($formulaire, $form);

$coursGrp = $form['coursGrp'];
$bulletin = $form['bulletin'];

// sécurité
$listeCoursGrp = $User->listeCoursProf();
if (!(in_array($coursGrp, array_keys($listeCoursGrp))))
    die('Ce cours ne vous appartient pas.');

$nb = $Bulletin->recordCotes($form);

$listeEleves = $Ecole->listeElevesCours($coursGrp, $tri);

$listeTravaux = $Bulletin->listeTravaux($coursGrp, $bulletin);
$listeCotes = ($listeTravaux != null) ? $Bulletin->listeCotesCarnet($listeTravaux) : null;

$listeErreursEncodage = $Bulletin->listeErreursCarnet($listeCotes);

$listeMoyennes = $Bulletin->listeMoyennesCarnet($listeCotes);
$listeCompetences = current($Bulletin->listeCompetences($coursGrp));

require_once INSTALL_DIR.'/smarty/Smarty.class.php';
$smarty = new Smarty;
$smarty->template_dir = INSTALL_DIR.$ds.$module.$ds.'templates';
$smarty->compile_dir = INSTALL_DIR.$ds.$module.$ds.'templates_c';

$smarty->assign('COTEABS', COTEABS);
$smarty->assign('COTENULLE', COTENULLE);
$smarty->assign('MENTIONSTEXTE', MENTIONSTEXTE);

$smarty->assign('coursGrp', $coursGrp);
$smarty->assign('bulletin', $bulletin);
$smarty->assign('listeEleves', $listeEleves);
$smarty->assign('listeTravaux', $listeTravaux);
$smarty->assign('listeCotes', $listeCotes);
$smarty->assign('listeErreursEncodage', $listeErreursEncodage);
$smarty->assign('listeMoyennes', $listeMoyennes);
$smarty->assign('listeCompetences', $listeCompetences);

$smarty->display('carnet/tableauCotes.tpl');
