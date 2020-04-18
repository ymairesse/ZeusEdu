<?php

require_once INSTALL_DIR.'/inc/classes/classThot.inc.php';
$thot = new Thot();

$listeCollections = $thot->listeCollections($acronyme);
$smarty->assign('listeCollections', $listeCollections);

$listeQuestionsParCollection = $thot->listeQuestionsParCollection ($listeCollections);
$smarty->assign('listeQuestionsCollection',$listeQuestionsParCollection);

$smarty->assign('corpsPage', 'exercices/exercicesMain');
