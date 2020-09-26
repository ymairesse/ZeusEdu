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

$idCarnet = isset($_POST['idCarnet'])?$_POST['idCarnet']:Null;
$coursGrp = isset($_POST['coursGrp'])?$_POST['coursGrp']:Null;
$bulletin = isset($_POST['bulletin'])?$_POST['bulletin']:Null;

$ds = DIRECTORY_SEPARATOR;
require_once INSTALL_DIR.$ds.$module.$ds."inc/classes/classBulletin.inc.php";
$Bulletin = new Bulletin();

// soit on fait un nouvel entête pour une nouvelle cote
if ($idCarnet == Null) {
    $entete = $Bulletin->getNewEnteteCote($coursGrp, $bulletin);
    }
    else {
        // soit on arrive avec un $idCarnet (c'est une édition d'une cote existante)
        $entete = $Bulletin->getEnteteCote($idCarnet);
        $coursGrp = $entete['coursGrp'];
        $bulletin = $entete['bulletin'];
    }

$listeCoursGrp = $User->listeCoursProf();
$listeCompetences = current($Bulletin->listeCompetences($coursGrp));

if (!(in_array($coursGrp, array_keys($listeCoursGrp))))
    die();

$ds = DIRECTORY_SEPARATOR;
require_once INSTALL_DIR.'/smarty/Smarty.class.php';
$smarty = new Smarty;
$smarty->template_dir = INSTALL_DIR.$ds.$module.$ds.'templates';
$smarty->compile_dir = INSTALL_DIR.$ds.$module.$ds.'templates_c';

$smarty->assign('nbBulletins', NBPERIODES);
$smarty->assign('entete',$entete);
$smarty->assign('listeCours', $listeCoursGrp);
$smarty->assign('listeCompetences', $listeCompetences);
$smarty->display('carnet/modal/modalEditCote.tpl');
