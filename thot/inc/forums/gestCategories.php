<?php

require_once 'inc/classes/class.thotForum.php';
$Forum = new ThotForum();

$listeCategories = $Forum->getListeCategories();
$countSubjects = $Forum->countSubjects4categories();
$sujetsAbonnes = $Forum->getSubjects4Abonne($acronyme);
$sujetsAmoi = $Forum->getSubject4proprio($acronyme);


$smarty->assign('listeCategories', $listeCategories);
$smarty->assign('countSubjects', $countSubjects);

$smarty->assign('sujetsAbonnes', $sujetsAbonnes);
$smarty->assign('sujetsAmoi', $sujetsAmoi);

$smarty->assign('corpsPage', 'forums/admin');
