<?php

$listeClasses = $Ecole->listeTitulariats($acronyme);
// s'il n'y a qu'un seul titulariat (une seulle classe, le choix est vite fait)
if (count($listeClasses == 1))
    $classe = current($listeClasses);

if (!in_array($classe, $listeClasses))
    $classe = Null;
    else setcookie('classe', $classe, $unAn, '/', null, false, true);

$smarty->assign('classe', $classe);  // pour le sélecteur
$smarty->assign('listeClasses', $listeClasses);

$smarty->assign('editable', true);
$smarty->assign('selecteur', 'selecteurs/selectClassePOST');

if ($classe != Null) {
    $smarty->assign('type', 'classe');
    $smarty->assign('destinataire', $classe);
    $lblDestinataire =  $Jdc->getLabel('classe', $classe);
    $smarty->assign('lblDestinataire', $lblDestinataire);
    $smarty->assign('corpsPage', 'jdc');
    }
