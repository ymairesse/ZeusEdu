<?php

$smarty->assign('editable', true);
$smarty->assign('destinataire', $destinataire);
$smarty->assign('type', 'ecole');
$lblDestinataire =  $Jdc->getLblEcole();

$smarty->assign('lblDestinataire', $lblDestinataire);
$smarty->assign('corpsPage', 'jdc');
