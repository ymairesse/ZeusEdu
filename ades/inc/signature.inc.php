<?php

if ($etape == 'enregistrer') {
    $signature = $_POST['signature'];
    $nb = file_put_contents('templates/signature.tpl', $signature);
    if ($nb != false) {
        $title = SAVE;
        $texte = sprintf('%d octet(s) enregistré(s)', $nb);
        $urgence = SUCCES;
    } else {
        $title = NOSAVE;
        $texte = "Échec de l'enregistrement";
        $urgence = 'danger';
    }
    $smarty->assign('message', array(
            'title' => $title,
            'texte' => $texte,
            'urgence' => $urgence, ));
} else {
    $signature = file_get_contents('templates/signature.tpl');
}
$smarty->assign('action', $action);
$smarty->assign('mode', 'editSignature');
$smarty->assign('etape', 'enregistrer');
$smarty->assign('signature', $signature);
$smarty->assign('corpsPage', 'editSignature');
