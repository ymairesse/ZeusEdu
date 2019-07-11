<?php

$listeClasses = $user->listeTitulariats();
$smarty->assign('listeClasses', $listeClasses);
$smarty->assign('selecteur', 'selectClasse');
$smarty->assign('classe', $classe);
// la classe actuellement active fait-elle partie des classes dont l'utilisateur est titulaire?
if (in_array($classe, $listeClasses)) {
    // retrouver la liste des élèves de la classe
    $listeEleves = $Ecole->listeEleves($classe, 'groupe');
    $smarty->assign('listeEleves', $listeEleves);

    // établir la liste des décisions éventuelles pour cette liste d'élèves
    // (tous, même ceux pour lesquels aucune décision n'est prise maintenant)
    $listeDecisions = $Bulletin->listeDecisions($listeEleves);

    // ajouter le texte qui figurera dans la BD pour accès par Thot
    $texteNotification = file_get_contents('templates/notification/templateNote.html');
    $texteNotification = str_replace(PHP_EOL, '', $texteNotification);    // suppression des /n
    $listeDecisions = $Bulletin->listeDecisionsAvecTexte($listeDecisions, $listeEleves, $texteNotification);

    // la liste des élèves pour lesquels une notification dans la BD est souhaitée
    $listeDecisionsBD = $Bulletin->listeDecisionsNote($listeDecisions);

    // la liste des élèves pour lesquels une notification par mail est souhaitée
    $listeDecisionsMails = $Bulletin->listeDecisionsMail($listeDecisions);

    // est-ce le moment d'enregistrer ces décisions?
    if ($etape == 'envoyer') {
        $objet = file_get_contents('templates/notification/objetMail.tpl');
        $texte = file_get_contents('templates/notification/texteMail.tpl');
        $signature = file_get_contents('templates/notification/signatureMail.tpl');

        require_once INSTALL_DIR.'/inc/classes/classThot.inc.php';
        $Thot = new thot();

        $texteNotification = file_get_contents('templates/notification/texteNotification.tpl');
        // envoi des notifications dans la BD; la liste des notifications obtenues est celle des matricules
        // des élèves pour lesquels on a enregistré une décision durant la procédure
        $listeNotifications = $Thot->notifier($_POST, $listeDecisionsBD, $listeEleves, $acronyme, $texteNotification);

        // envoi des mails d'avertissement $listeNotifications contient les matricules / $listeDecisions contient
        // la fonction revient avec la liste des élèves auxquels le mail a été envoyé
        $listeMailing = $Thot->mailer($listeDecisionsMails, $objet, $texte, $signature);
        $nbMails = count($listeMailing);
        // avec horodatage pour les élèves de la liste des notifications (dans la BD)
        // la fonction revient avec la liste des élèves auxquels la notification a été envoyée
        $listeNotifs = $Bulletin->daterDecisions($listeNotifications);
        $nbNotifs = count($listeNotifs);

        // recharger la liste des décisions pour l'ensemble de la classe afin de rafraîchir l'affichage
        $listeDecisions = $Bulletin->listeDecisions($listeEleves);
        $smarty->assign('listeDecisions', $listeDecisions);
        // chercher la liste de synthèse des décisions qui viennent d'être actées (et seulement celles-là)
        $listeSynthDecisions = $Bulletin->listeSynthDecisions($listeNotifications);
        $smarty->assign('listeSynthDecisions', $listeSynthDecisions);

        $smarty->assign('message', array(
                'title' => 'Notifications',
                'texte' => sprintf('%d notification(s) et %d Mails mail(s) envoyée(s)',$nbNotifs,$nbMails),
                'urgence' => 'success', )
                );
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
