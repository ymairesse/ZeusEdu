<?php

require_once 'inc/classes/class.thotForum.php';
$Forum = new ThotForum();

$listeCategories = $Forum->getListeCategories();
$smarty->assign('listeCategories', $listeCategories);

$sujetsAbonnes = $Forum->getSubjects4Abonne($acronyme);
$smarty->assign('sujetsAbonnes', $sujetsAbonnes);

$sujetsAmoi = $Forum->getSubject4proprio($acronyme);
$smarty->assign('sujetsAmoi', $sujetsAmoi);

$smarty->assign('corpsPage', 'forum/index');
