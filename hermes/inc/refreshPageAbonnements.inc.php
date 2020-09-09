<?php

require_once '../../config.inc.php';

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

$module = $Application->getModule(2);

// définition de la class Hermes
$ds = DIRECTORY_SEPARATOR;
require_once INSTALL_DIR.$ds.$module.$ds.'inc/classes/classHermes.inc.php';
$Hermes = new hermes();

$listesParId = $Hermes->listesPerso($acronyme, true);
$listesParNom = array();
foreach ($listesParId as $nomListe => $laListe)
    $listesParNom[$nomListe] = $laListe;


$listePublie = $Hermes->listesDisponibles($acronyme, 'publie');
foreach($listePublie as $idListe => $data) {
    $prof = User::identiteProf($data['proprio']);
    $listePublie[$idListe]['nomProf'] = sprintf('%s %s', $prof['nom'], $prof['prenom']);
}

$listeAbonne = $Hermes->listesDisponibles($acronyme, 'abonne');
foreach($listeAbonne as $idListe => $data) {
    $prof = User::identiteProf($data['proprio']);
    $listeAbonne[$idListe]['nomProf'] = sprintf('%s %s', $prof['nom'], $prof['prenom']);
}

$abonnesDe = $Hermes->abonnesDe($acronyme);

require_once INSTALL_DIR.'/smarty/Smarty.class.php';
$smarty = new Smarty();
$smarty->template_dir = '../templates';
$smarty->compile_dir = '../templates_c';

$smarty->assign('listePublie', $listePublie);
$smarty->assign('listeAbonne', $listeAbonne);
$smarty->assign('abonnesDe', $abonnesDe);
$smarty->assign('listesPerso', $listesParNom);

$smarty->display('inc/abonnements.inc.tpl');
