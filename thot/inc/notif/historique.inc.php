<?php

$onglet = isset($_COOKIE['onglet']) ? $_COOKIE['onglet']: Null;

// lecture de toutes les notifications pour l'utilisateur courant
// ecole => ... niveau => ... classes => ... cours => ... eleves => ...
$listeNotifications = $Thot->listeUserNotification($acronyme);

// liste des pièces jointes liées à ces notifications
$listePJ = $Thot->getPj4Notifs($listeNotifications, $acronyme);
// liste des accusés de lecture demandés par l'utilisateur courant
$listeAccuses = $Thot->getAccuses4user($acronyme, Null);

$annoncesPerimees = $Thot->getAnnoncesPerimees($acronyme);

$smarty->assign('listeAccuses', $listeAccuses);
$smarty->assign('listePJ', $listePJ);

// tous les types de destinataires
$listeTypes = $Thot->getTypes();
// tous les types de destinataires sauf les élèves isolés
$selectTypes = $Thot->getTypes(true);

// pour chaque notification, déterminer le nombre d'accusés attendus
// cette liste sera construite plus loin
$listeAttendus = array_keys($listeTypes);

$listeNiveaux = $Ecole->listeNiveaux();
$listeClasses = $Ecole->listeClasses();
$listeCours = $user->getListeCours();
$listeProfs = $Ecole->listeProfs(true);
// $listeGroupes = $Thot->getListeGroupes($acronyme);

// valeur à déterminer ensuite
$destinataire = Null;

// ------------------------------------------------------------------------------
// la liste de toutes les notifications est ventilée par groupe destinataire
foreach ($listeNotifications as $type => $lesNotifications) {
    foreach ($lesNotifications as $notifId => $uneNotification) {
        if ($uneNotification['accuse'] == 1) {
            $destinataire = $uneNotification['destinataire'];
            switch ($type) {
                case 'ecole':
                    // wtf : il n'y a pas d'accusé de lecture possible pour toute l'école
                    $listeAttendus[$type][$notifId] = Null;
                    break;
                case 'niveau':
                    $listeAttendus[$type][$notifId] = $Ecole->nbEleves($destinataire);
                    break;
                case 'cours':
                    $nb = count($Ecole->listeElevesMatiere($destinataire));
                    $listeAttendus[$type][$notifId] = $nb;
                    break;
                case 'coursGrp':
                    $nb = count($Ecole->listeElevesCours($destinataire));
                    $listeAttendus[$type][$notifId] = $nb;
                    break;
                case 'classes':
                    $nb = count($Ecole->listeElevesClasse($destinataire));
                    $listeAttendus[$type][$notifId] = $nb;
                    break;
                case 'groupe':
                    // À prévoir...
                    // $listeAttentdus[$type][$notifId] = ...;
                    break;
                case 'eleves':
                    $nb = 1;
                    $listeAttendus[$type][$notifId] = $nb;
                    break;
                case 'profsCours':

                    break;
                }
            }
        if (isset($uneNotification['matricule']))
            $listeNotifications[$type][$notifId]['destinataire'] = Eleve::staticGetDetailsEleve($uneNotification['matricule']);
        }
    }

// ------------------------------------------------------------------------------
// préparation d'une nouvelle notification vierge
$notification = $Thot->newNotification($acronyme);
$smarty->assign('notification', $notification);

// ------------------------------------------------------------------------------

$smarty->assign('INSTALL_DIR', INSTALL_DIR);
$smarty->assign('listeNotifications', $listeNotifications);
$smarty->assign('annoncesPerimees', $annoncesPerimees);
$smarty->assign('listeAttendus', $listeAttendus);
$smarty->assign('onglet', $onglet);
$smarty->assign('listeTypes', $listeTypes);
$smarty->assign('selectTypes', $selectTypes);
$smarty->assign('listeNiveaux', $listeNiveaux);
$smarty->assign('listeClasses', $listeClasses);
$smarty->assign('listeProfs', $listeProfs);
$smarty->assign('listeCours', $listeCours);

$smarty->clearAllCache();

$smarty->assign('corpsPage', 'notification/historique');
