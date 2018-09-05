<?php

Application::afficher($_POST);

$type = isset($_POST['type']) ? $_POST['type'] : 'eleve';
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

if (isset($niveau)) {
    $listeClasses = $Ecole->listeClassesNiveau($niveau);
    $smarty->assign('listeClasses', $listeClasses);
}

if (isset($classe)) {
    $listeEleves = $Ecole->listeEleves($classe,'groupe');
    $smarty->assign('listeEleves', $listeEleves);
}

$smarty->assign('selecteur', 'selecteurs/selectCoursPOSTetc');



// quels sont les types d'événements à afficher (format JSON)?
// permet de sélectionner les types d'événements à présenter
$typesJDC = isset($_COOKIE['typesJDC']) ? $_COOKIE['typesJDC'] : Null;
$typesJDC = (array) json_decode($typesJDC);
$smarty->assign('typesJDC', $typesJDC);
$listeTypes = $Jdc->getListeTypes();
$smarty->assign('listeTypes', $listeTypes);

switch ($type) {
    case 'niveau':
        $lblDestinataire =  $Jdc->getLabel('niveau', $niveau);
        break;
    case 'classe':
        $lblDestinataire =  $Jdc->getLabel('classe', $classe);
        break;
    case 'eleve':
        $infos = Eleve::staticGetDetailsEleve($matricule);
        $lblDestinataire =  $Jdc->getLabel('eleve', $matricule, $infos);
        break;
    default:
        $lblDestinataire =  $Jdc->getLabel('ecole','');
        break;
}

$smarty->assign('lblDestinataire', $lblDestinataire);
$smarty->assign('jdcInfo', 'Pour voir tous vos événements et pour écrire dans le JDC sélectionné ci-dessus (Tous, niveau, classe, élève)');

$smarty->assign('corpsPage', 'jdc/jdcAny');
