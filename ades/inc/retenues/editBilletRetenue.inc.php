<?php

if ($etape == 'enregistrer') {
    $retenue = $_POST['retenue'];
    $page = $_POST['page'];  // A4 ou A5
    $orientation = $_POST['orientation']; // portrait ou paysage

    // mise en forme Json
    $format = array('page' => $page, 'orientation' => $orientation);
    // récupération des dictionnaires pour la compilation
    $dicoZeus = json_decode(file_get_contents('templates/retenues/dicoZeus.json'), true);
    $dicoAdes = json_decode(file_get_contents('templates/retenues/dicoAdes.json'), true);
    $nb = 0;
    // enregistrement du modèle au format Hashtag
    $nb += file_put_contents('templates/retenues/retenueModele.tpl', $retenue);
    // compilation des notations Hashtag vers Smarty
    $nb += file_put_contents('templates/retenues/retenue.tpl', $Ades->compileTemplate($retenue,$dicoZeus, $dicoAdes));
    $nb += file_put_contents('templates/retenues/format.json', json_encode($format));
    if ($nb != false) {
        $texte = sprintf('%d octet(s) enregistré(s)', $nb);
        $urgence = 'success';
    } else {
        $texte = "Échec de l'enregistrement";
        $urgence = 'danger';
    }
    $smarty->assign('message', array(
            'title' => SAVE,
            'texte' => $texte,
            'urgence' => $urgence, ));
} else {
    $retenue = file_get_contents('templates/retenues/retenueModele.tpl');
    // relire les formats enregistrés
    $format = json_decode(file_get_contents('templates/retenues/format.json'), true);
}

$smarty->assign('retenue', $retenue);
$smarty->assign('format', $format);
$smarty->assign('corpsPage', 'templates/retenues/editeurTexte');
