<?php

$type = isset($_POST['type']) ? $_POST['type'] : Null;
$niveau = isset($_POST['niveau']) ? $_POST['niveau'] : Null;
$classe = isset($_POST['classe']) ? $_POST['classe'] : Null;
$matricule = isset($_POST['matricule']) ? $_POST['matricule'] : Null;
$coursGrp = isset($_POST['coursGrp']) ? $_POST['coursGrp'] : Null;


// pour le sélecteur
$smarty->assign('type', $type);
$smarty->assign('listeNiveaux', Ecole::listeNiveaux());
$smarty->assign('niveau', $niveau);
$smarty->assign('classe', $classe);
$smarty->assign('matricule', $matricule);
$smarty->assign('coursGrp', $coursGrp);

$smarty->assign('editable', true);

if ($niveau != '') {
    $listeClasses = $Ecole->listeClassesNiveau($niveau);
    $smarty->assign('listeClasses', $listeClasses);
}

if ($classe != '') {
    $listeEleves = $Ecole->listeEleves($classe,'groupe');
    $smarty->assign('listeEleves', $listeEleves);
}

switch ($type) {
    case 'niveau':
        $lblDestinataire =  $Jdc->getLabel('niveau', $niveau);
        $destinataire = $niveau;
        break;
    case 'classe':
        $lblDestinataire =  $Jdc->getLabel('classe', $classe);
        $destinataire = $classe;
        break;
    case 'eleve':
        $infos = Eleve::staticGetDetailsEleve($matricule);
        $lblDestinataire =  $Jdc->getLabel('eleve', $matricule, $infos);
        $destinataire = $matricule;
        break;
    default:
        $lblDestinataire =  $Jdc->getLabel('ecole','');
        $destinataire = 'ecole';
        break;
    }

$smarty->assign('destinataire', $destinataire);
$smarty->assign('lblDestinataire', $lblDestinataire);

$smarty->assign('selecteur', 'selecteurs/selectAnyDestinataire');

if ($type != '')
    $smarty->assign('corpsPage', 'jdc/jdcAny');
