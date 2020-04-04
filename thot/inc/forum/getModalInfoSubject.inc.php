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

// définition de la class Forum
$ds = DIRECTORY_SEPARATOR;
require_once INSTALL_DIR.$ds.$module.$ds.'inc/classes/class.thotForum.php';
$Forum = new ThotForum();

$infoCategorie = $Forum->getInfoCategorie($idCategorie);
$infoSujet = $Forum->getInfoSujet($idCategorie, $idSujet);
$listeAbonnes = $Forum->listeAbonnesSujet($idSujet, $idCategorie);

if (isset($listeAbonnes['prof'])) {
    require_once INSTALL_DIR.'/inc/classes/classEcole.inc.php';
    foreach ($listeAbonnes['prof'] as $acronyme => $wtf) {
        $identite = $User->identiteProf($acronyme);
        $listeAbonnes['prof'][$acronyme] = $Forum->nomProf($identite['sexe'], $identite['prenom'], $identite['nom']);
    }
}

require_once INSTALL_DIR.'/smarty/Smarty.class.php';
$smarty = new Smarty();
$smarty->template_dir = '../../templates';
$smarty->compile_dir = '../../templates_c';

$smarty->assign('infoCategorie', $infoCategorie);
$smarty->assign('infoSujet', $infoSujet);
$smarty->assign('listeAbonnes', $listeAbonnes);

$smarty->display('forum/modal/modalInfoSubject.tpl');
