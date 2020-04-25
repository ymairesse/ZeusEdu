<?php

$onglet = isset($_COOKIE['onglet']) ? $_COOKIE['onglet']: Null;

// lecture de toutes les notifications pour l'utilisateur courant
// ecole => ... niveau => ... classes => ... cours => ... eleves => ...
$listeNotifications = $Thot->listeUserNotification($acronyme);

// liste des pièces jointes liées à ces notifications
$listePJ = $Thot->getPj4Notifs($listeNotifications, $acronyme);
// liste des accusés de lecture demandés par l'utilisateur courant
$listeAccuses = $Thot->getAccuses4user($acronyme, Null);

$smarty->assign('listeAccuses', $listeAccuses);
$smarty->assign('listePJ', $listePJ);

// tous les types de destinataires
$listeTypes = $Thot->getTypes();

$listeNiveaux = Ecole::listeNiveaux();
$smarty->assign('listeNiveaux', $listeNiveaux);

$listeClasses = $Ecole->listeClasses();
$smarty->assign('listeClasses', $listeClasses);

$listeCours = $Ecole->listeCoursProf($acronyme);
$smarty->assign('listeCours', $listeCours);

$listeGroupes = $Thot->getListeGroupes4User($acronyme, array('proprio','admin'));
$smarty->assign('listeGroupes', $listeGroupes);


// ------------------------------------------------------------------------------
// préparation d'une nouvelle notification vierge
$notification = $Thot->newNotification($acronyme);
$smarty->assign('notification', $notification);

// ------------------------------------------------------------------------------

$smarty->assign('INSTALL_DIR', INSTALL_DIR);
$smarty->assign('listeNotifications', $listeNotifications);

$smarty->assign('onglet', $onglet);
$smarty->assign('listeTypes', $listeTypes);

$smarty->assign('corpsPage', 'notification/notif');
