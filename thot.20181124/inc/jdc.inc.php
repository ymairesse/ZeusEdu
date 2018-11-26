<?php

// informations provenant du sélecteur
// type de JDC: défini dans le sélecteur classe, élève,...
$type = isset($_POST['type']) ? $_POST['type'] : null;
$smarty->assign('type', $type);

$matricule = isset($_POST['matricule']) ? $_POST['matricule'] : null;
$classe = isset($_POST['classe']) ? $_POST['classe'] : null;
$coursGrp = isset($_POST['coursGrp']) ? $_POST['coursGrp'] : null;
$niveau = isset($_POST['niveau']) ? $_POST['niveau'] : null;

// le sélecteur éventuel revient avec un $type qui va permettre de définir un "destinataire"
switch ($type) {
    case 'eleve':
        $destinataire = $matricule;
        break;
    case 'classe':
        $destinataire = $classe;
        break;
    case 'niveau':
        $destinataire = $niveau;
        break;
    case 'coursGrp':
        $destinataire = $coursGrp;
        break;
    case 'ecole':
        $destinataire = 'all';
        break;
    default:
        $destinataire = Null;
        break;
}
$smarty->assign('destinataire', $destinataire);

$categories = $Jdc->categoriesTravaux();
$smarty->assign('categories', $categories);

switch ($mode) {
    case 'coursGrp':
        require_once 'inc/jdc/jdcCours.inc.php';
        break;

    case 'jdcAny':
        require_once 'inc/jdc/jdcAny.inc.php';
        break;

    case 'approbations':
        require_once 'inc/jdc/pageApprobationsJdc.inc.php';
        break;

    case 'subjectif':
        $smarty->assign('type', 'subjectif');
        require_once 'inc/jdc/subjectifEleve.inc.php';
        break;

    default:
        // wtf
        break;
    }
