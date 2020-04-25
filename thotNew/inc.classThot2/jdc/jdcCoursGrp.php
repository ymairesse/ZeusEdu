<?php

// informations provenant du sélecteur
// type de JDC: défini dans le sélecteur classe, élève,...
$type = isset($_POST['type']) ? $_POST['type'] : null;
$smarty->assign('type', $type);

$matricule = isset($_POST['matricule']) ? $_POST['matricule'] : null;
$classe = isset($_POST['classe']) ? $_POST['classe'] : null;
$coursGrp = isset($_POST['coursGrp']) ? $_POST['coursGrp'] : null;
$niveau = isset($_POST['niveau']) ? $_POST['niveau'] : null;

$destinataire = $coursGrp;
$smarty->assign('destinataire', $destinataire);

$categories = $Jdc->categoriesTravaux();
$smarty->assign('categories', $categories);

$listeCoursGrp = $Ecole->listeCoursProf($acronyme, true);
$smarty->assign('listeCoursGrp', $listeCoursGrp);
$smarty->assign('corpsPage', 'jdc/choixCours');
