<?php

if ($etape == 'enregistrer') {
    $mailRetenue = $_POST['mailRetenue'];
    $nb = file_put_contents('templates/retenues/texteRetenue.html', $mailRetenue);
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
    $mailRetenue = file_get_contents('templates/retenues/texteRetenue.html');
}
$smarty->assign('action', $action);
$smarty->assign('mode', 'editMailRetenue');
$smarty->assign('etape', 'enregistrer');
$smarty->assign('signature', $mailRetenue);
$smarty->assign('corpsPage', 'retenues/editMailRetenue');
