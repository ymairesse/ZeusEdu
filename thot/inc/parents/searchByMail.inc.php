<?php

$mail = isset($_POST['mail']) ? trim($_POST['mail']) : Null;

if ($mail != Null) {
    $listeParents = $Thot->getParentsByMail($mail);
}
else $listeParents = Null;

$smarty->assign('listeParents', $listeParents);
$smarty->assign('mail', $mail);

$listeClasses = $Ecole->listeGroupes();
$smarty->assign('listeClasses', $listeClasses);

$smarty->assign('selecteur', 'selecteurs/selectClasseMailPOST');
$smarty->assign('corpsPage', 'parents/parentsByMail');
