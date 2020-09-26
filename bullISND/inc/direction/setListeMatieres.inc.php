<?php

require_once '../../../config.inc.php';

require_once INSTALL_DIR.'/inc/classes/classApplication.inc.php';
$Application = new Application();

require_once INSTALL_DIR.'/inc/classes/classUser.inc.php';
session_start();

if (!(isset($_SESSION[APPLICATION]))) {
    echo "<script type='text/javascript'>document.location.replace('".BASEDIR."');</script>";
    exit;
}

$User = $_SESSION[APPLICATION];
$acronyme = $User->getAcronyme();

// retrouver le nom du module actif
$module = $Application->getModule(3);

// récupérer le formulaire d'encodage des cours
$formulaire = isset($_POST['formulaire']) ? $_POST['formulaire'] : null;
$form = array();
parse_str($formulaire, $form);

$matricule = isset($_POST['matricule']) ? $_POST['matricule'] : Null;
$anScol = isset($_POST['anScol']) ? $_POST['anScol'] : Null;
$periode = isset($_POST['periode']) ? $_POST['periode'] : Null;

// liste des nouveaux cours à intégrer à la fiche

$newListe = isset($form['coursGrp']) ? $form['coursGrp'] : Null;;

if ($newListe != Null) {

    require_once INSTALL_DIR.'/inc/classes/classPad.inc.php';
    $padEleve = New padEleve($matricule, $acronyme);
    // liste des matières déjà présentes pour cette année scolaire et cette périodes
    $oldListe = $padEleve->getCours4pad($matricule, $anScol, $periode);
    // fusion des deux listes et tri
    $listeCours = array_merge($newListe, $oldListe);
    sort($listeCours);

    require_once INSTALL_DIR.'/inc/classes/classEcole.inc.php';
    $Ecole = new Ecole();
    $listeCoursGrp = $Ecole->detailsListeCoursGrp(array_flip($listeCours));

    $nb = $padEleve->createNewMatieres4pad($matricule, $anScol, $periode, $listeCoursGrp);

    $listeMatieres = $padEleve->getMatieres4pad($matricule, $anScol, $periode);

    require_once INSTALL_DIR.'/smarty/Smarty.class.php';
    $smarty = new Smarty();
    $smarty->template_dir = '../../templates';
    $smarty->compile_dir = '../../templates_c';

    $smarty->assign('ANNEESCOLAIRE', ANNEESCOLAIRE);
    $smarty->assign('listeMatieres', $listeMatieres);
    $smarty->assign('listeCoursGrp', $listeCoursGrp);
    $smarty->assign('anScol', $anScol);
    $smarty->assign('periode', $periode);

    $smarty->display('direction/listeMatieres.tpl');
}
