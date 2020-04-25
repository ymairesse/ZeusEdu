<?php

$listeNiveaux = $Ecole->listeNiveaux();

$smarty->assign('niveau', $niveau);  // pour le sélecteur
$smarty->assign('listeNiveaux', $listeNiveaux);
$smarty->assign('editable', true);
$smarty->assign('selecteur', 'selecteurs/selectNiveau');

if ($niveau != Null) {
    $lblDestinataire = $Jdc->getLabel('niveau', $niveau);
    $smarty->assign('lblDestinataire', $lblDestinataire);
    $smarty->assign('corpsPage', 'jdc');
    }
