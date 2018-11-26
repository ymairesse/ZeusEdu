<?php

$listeNiveaux = Ecole::listeNiveaux();
$listeCours = $user->getListeCours($acronyme);
$listeTypes = $Jdc->getListeTypes();

$smarty->assign('editable', true);
$smarty->assign('type', 'ecole');
$smarty->assign('listeNiveaux', $listeNiveaux);
$smarty->assign('listeTypes', $listeTypes);

// quels sont les types d'événements à afficher (format JSON)?
$typesJDC = isset($_COOKIE['typesJDC']) ? $_COOKIE['typesJDC'] : Null;
$typesJDC = (array) json_decode($typesJDC);

$lblDestinataire =  $Jdc->getLabel('ecole','');
$smarty->assign('lblDestinataire', $lblDestinataire);
$smarty->assign('jdcInfo', 'Pour voir tous vos événements et pour écrire dans le JDC sélectionné ci-dessus (Tous, niveau, classe, élève)');
$smarty->assign('typesJDC', $typesJDC);

$smarty->assign('corpsPage', 'jdc/jdcAny');
