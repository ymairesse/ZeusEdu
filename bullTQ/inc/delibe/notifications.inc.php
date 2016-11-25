<?php

$listeClasses = $user->listeTitulariats();
$smarty->assign('listeClasses', $listeClasses);
$smarty->assign('selecteur', 'selecteurs/selectClasse');
$smarty->assign('classe', $classe);
// la classe actuellement active fait-elle partie des classes dont l'utilisateur est titulaire?
if (in_array($classe, $listeClasses)) {
    // retrouver la liste des élèves de la classe
    $listeEleves = $Ecole->listeEleves($classe, 'groupe');
    $smarty->assign('listeEleves', $listeEleves);
    // recherche la liste des décisions éventuelles pour cette liste d'élèves
    // (tous, même ceux pour lesquels aucune décision n'est prise maintenant)
    $listeDecisions = $BullTQ->listeDecisions($listeEleves);

    // est-ce le moment d'enregistrer ces décisions?
    if ($etape == 'envoyer') {
        $objet = file_get_contents('templates/notification/objetMail.tpl');
        $texte = file_get_contents('templates/notification/texteMail.tpl');
        $signature = file_get_contents('templates/notification/signatureMail.tpl');

        require_once INSTALL_DIR.'/inc/classes/classThot.inc.php';
        $Thot = new thot();

        $texteNotification = file_get_contents('templates/notification/texteNotification.tpl');

        // envoi des notifications dans la BD; la liste des notifications obtenues est celle des matricules
        // des élèves pour lesquels on a enregistré une décision
        $listeNotifications = $Thot->notifier($_POST, $listeDecisions, $listeEleves, $acronyme, $texteNotification);
        $listeEnvoi = array_intersect_key($listeDecisions, $listeNotifications);

        // envoi des mails d'avertissement $listeNotifications contient les matricules / $listeDecisions contient
        $listeMailing = $Thot->mailer($listeEnvoi, $objet, $texte, $signature);
        // avec horodatage pour les élèves de cette liste
        $nbNotifs = $BullTQ->daterDecisions($listeNotifications);
        $nbMails = count($listeMailing);

        // recharger la liste des décisions pour l'ensemble de la classe
        $listeDecisions = $BullTQ->listeDecisions($listeEleves);

        // chercher la liste de synthèse des décisions qui viennent d'être actées (et seulement celles-là)
        $listeSynthDecisions = $BullTQ->listeSynthDecisions($listeNotifications);
        $smarty->assign('listeSynthDecisions', $listeSynthDecisions);
        $smarty->assign('message', array(
                'title' => 'Notifications',
                'texte' => sprintf('%d notification(s) et %d mail(s) envoyée(s)', $nbNotifs, $nbMails),
                'urgence' => 'success', )
                );
        $smarty->assign('listeDecisions', $listeDecisions);
        $smarty->assign('corpsPage', 'synthNotifications');
    }
        // sinon, on affiche le statut de chaque élève du point de vue des décisions du C.Cl.
        else {
            $estTitulaire = in_array($classe, $user->listeTitulariats());
            $smarty->assign('estTitulaire', $estTitulaire);
            $smarty->assign('listeDecisions', $listeDecisions);
            $smarty->assign('corpsPage', 'notifications');
        }
}
    // on ne sait pas encore quelle classe traiter et seul le selecteur est présenté
    else {
        $smarty->assign('corpsPage', null);
    }
