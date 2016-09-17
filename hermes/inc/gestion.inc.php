<?php

switch ($mode) {
    case 'delete':
        $mailingDel = array();
        $listeDel = array();
        foreach ($_POST as $name=>$value) {
            // membres des listes de mailing à supprimer
            if (substr($name,0,7) == 'mailing') {
                $nom = explode('_',$name);
                $idListe = explode('-',$nom[0]);
                $idListe = $idListe[1];
                $qui = $value;
                $mailingDel[] = array('id'=>$idListe,'acronyme'=>$qui);
                }

            // listes de mailing à supprimer
            if (substr($name,0,5) == 'liste') {
                $idListe = explode('-',$name);
                $idListe = $idListe[1];
                $listeDel[] = $idListe;
                }
            }
        // effacements effectifs des membres des listes et des listes vides
        $nbMailing = $hermes->delMembresListe($mailingDel);
        $nbListes = $hermes->delListes($listeDel, $acronyme);
        $smarty->assign('message',array(
                'title'=>DELETE,
                'texte'=> "$nbMailing destinataire(s) supprimé(s)<br>$nbListes liste(s) vide(s) supprimée(s)<br>Les listes non vides ne sont pas supprimées",
                'urgence'=>'warning'));
        break;
    case 'creationListe':
        $nomListe = isset($_POST['nomListe'])?$_POST['nomListe']:Null;
        $idListe = $hermes->creerGroupe($acronyme,$nomListe);
        $smarty->assign('nomListe',$nomListe);
        $smarty->assign('message', array(
            'title'=>SAVE,
            'texte'=>"La liste $nomListe a été créée",
            'urgence'=>'success'));
        break;
    case 'ajoutMembres':
        $listeMembres = isset($_POST['mails'])?$_POST['mails']:Null;
        $idListe = isset($_POST['idListe'])?$_POST['idListe']:Null;
        if (isset($listeMembres) && isset($idListe)) {
            $nb = $hermes->addMembresListe ($idListe,$listeMembres);
            $smarty->assign("message", array(
                'title'=>SAVE,
                'texte'=>"$nb membres(s) ajouté(s)",
                'urgence'=>'success'));
            }
        break;
    case 'statutListe':
        $nb = $hermes->saveListStatus($_POST, $acronyme);
        $smarty->assign("message", array(
            'title'=>SAVE,
            'texte'=>"$nb modification(s) enregistrée(s)",
            'urgence'=>'success'));
        break;
    case 'abonnement':
        $nb = $hermes->gestAbonnements($_POST, $acronyme);
        $smarty->assign("message", array(
            'title'=>SAVE,
            'texte'=>"$nb abonnement(s) modifié(s)",
            'urgence'=>'success'));
        break;
    default:
        // wtf
        break;
    break;
    }
$listeProfs = $hermes->listeMailingProfs();
$smarty->assign('listeProfs', $listeProfs);

$autresListes = $hermes->listesPerso($acronyme, true);
$listes = array();
foreach ($autresListes as $nomListe=>$laListe)
    $listes[$nomListe] = $laListe;
$listePublie = $hermes->listesDisponibles($acronyme, 'publie');
$listeAbonne = $hermes->listesDisponibles($acronyme, 'abonne');
$abonnesDe = $hermes->abonnesDe($acronyme);
$smarty->assign('listePublie', $listePublie);
$smarty->assign('listeAbonne', $listeAbonne);
$smarty->assign('abonnesDe',$abonnesDe);
$smarty->assign('action',$action);
$smarty->assign('listesPerso',$listes);
$smarty->assign('corpsPage','gestion');
