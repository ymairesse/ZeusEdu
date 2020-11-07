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

$idCategorie = isset($_POST['idCategorie']) ? $_POST['idCategorie'] : Null;
$idSujet = isset($_POST['idSujet']) ? $_POST['idSujet'] : Null;
$sujet = isset($_POST['sujet']) ? $_POST['sujet'] : Null;

$ds = DIRECTORY_SEPARATOR;
require_once INSTALL_DIR.$ds.$module.$ds.'inc/classes/class.thotForum.php';
$Forum = new thotForum();

// liste des catégories sous forme arborescente
$listeCategories = $Forum->getListeCategories();

$categorie = $Forum->getInfoCategorie($idCategorie);
$infoSujet = $Forum->getInfoSujet($idCategorie, $idSujet);


require_once INSTALL_DIR.$ds.'/inc/classes/classEcole.inc.php';
$Ecole = new Ecole();
$listeProfs = $Ecole->listeProfs();
$listeNiveaux = $Ecole->listeNiveaux();
$listeClasses = $Ecole->listeClasses();
$listeCoursGrp = $Ecole->listeCoursProf($acronyme, true);

$listeAbonnes = $Forum->listeAbonnesSujet($idSujet, $idCategorie);

require_once INSTALL_DIR.'/smarty/Smarty.class.php';
$smarty = new Smarty();
$smarty->template_dir = '../../templates';
$smarty->compile_dir = '../../templates_c';

$smarty->assign('listeCategories', $listeCategories);

$smarty->assign('listeProfs', $listeProfs);
$smarty->assign('listeNiveaux', $listeNiveaux);
$smarty->assign('listeClasses', $listeClasses);
$smarty->assign('listeCoursGrp', $listeCoursGrp);

$smarty->assign('listeAbonnes', $listeAbonnes);
// catégorie dans le forum
$smarty->assign('categorie', $categorie);
// le sujet dans sa catégorie
$smarty->assign('infoSujet', $infoSujet);

$smarty->display('forum/modal/modalGestSujets.tpl');
