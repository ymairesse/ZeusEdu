<?php

// on revérifie l'identité de l'utilisateur, ses cours et sa liste de titulariats
// déjà déterminés dans index.php
$User = $_SESSION[APPLICATION];
$acronyme = $User->getAcronyme();

$listeCours = $User->listeCoursProf();
$titulaire = $User->listeTitulariats();

// liste des approbations en attente pour l'utilisateur courant,
// pour ses cours ou en tant que titulaire
$approbations = $Jdc->getApprobations($listeCours, $titulaire);
// appréciations des élèves sur les notes au JDC
$appreciations = $Jdc->listeAppreciations(array_keys($approbations));

$smarty->assign('approbations', $approbations);
$smarty->assign('appreciations', $appreciations);
$smarty->assign('corpsPage', 'jdc/listeApprobations');
