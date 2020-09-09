<?php

require_once INSTALL_DIR.'/inc/classes/classUser.inc.php';

$listeProfs = $hermes->listeMailingProfs();

$smarty->assign('listeProfs', $listeProfs);

$listesParId = $hermes->listesPerso($acronyme, true);
$listesParNom = array();
foreach ($listesParId as $nomListe => $laListe)
    $listesParNom[$nomListe] = $laListe;


$listePublie = $hermes->listesDisponibles($acronyme, 'publie');
foreach($listePublie as $idListe => $data) {
    $prof = User::identiteProf($data['proprio']);
    $listePublie[$idListe]['nomProf'] = sprintf('%s %s', $prof['nom'], $prof['prenom']);
}

$listeAbonne = $hermes->listesDisponibles($acronyme, 'abonne');
foreach($listeAbonne as $idListe => $data) {
    $prof = User::identiteProf($data['proprio']);
    $listeAbonne[$idListe]['nomProf'] = sprintf('%s %s', $prof['nom'], $prof['prenom']);
}

$abonnesDe = $hermes->abonnesDe($acronyme);

$smarty->assign('listePublie', $listePublie);
$smarty->assign('listeAbonne', $listeAbonne);
$smarty->assign('abonnesDe', $abonnesDe);
$smarty->assign('listesPerso', $listesParNom);

$smarty->assign('corpsPage', 'gestion');
