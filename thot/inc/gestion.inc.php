<?php

$date = isset($_POST['date']) ? $_POST['date'] : null;
$smarty->assign('date', $date);

$showEdition = false;

switch($mode) {
  case 'bulletin':
    require_once('inc/gestBulletins.inc.php');
    break;

    case 'delNotification':
        $id = isset($_POST['id'])?$_POST['id']:Null;
        // suppression des demandes d'accusé de lecture
        $ok = $Thot->delAccuse($id,$acronyme);
        // suppression des notifications correspondantes
        $nb = $Thot->delNotification($id,$acronyme);
        $smarty->assign('message', array(
                'title'=>DELETE,
                'texte'=>"$nb notification supprimée",
                'urgence'=>SUCCES)
                );
        $showEdition = true;
        break;

    case 'edition':
        $showEdition = true;
        break;

    case 'gestAccuses':
        require_once('inc/gestAccuses.inc.php');
        break;

    case 'delBulk':
        $nb = $Thot->delMultiNotifications($_POST, $acronyme);
        $smarty->assign('message', array(
                'title'=>DELETE,
                'texte'=>"$nb notification supprimée",
                'urgence'=>SUCCES)
                );
        $showEdition = true;
        break;

    case 'reunionParents':
        require_once(INSTALL_DIR.'/inc/classes/classThot.inc.php');
        $thot = new Thot();
        $listeReunions = $thot->listeDatesReunion();
        $smarty->assign('listeDates', $listeReunions);

        if (isset($date)) {
            $smarty->assign('date',$date);
            $listeRV = $thot->getRVprof($acronyme,$date);
            $smarty->assign('listeRV',$listeRV);
            $smarty->assign('corpsPage','reunionParents/gestionRVprof');
        }

        $smarty->assign('selecteur', 'selecteurs/selectDate');
        break;

    case 'parents':
        $titulariats = $user->listeTitulariats("'G','TT','S','C','D'");
        $smarty->assign('listeClasses', implode(',',array_keys($titulariats)));
        $listesParents = $Thot->listeParents($titulariats);
        $smarty->assign('listesParents',$listesParents);
        $smarty->assign('corpsPage','listesParents');
        break;

    default:
        // wtf
        break;
    }

if ($showEdition) {
    // lecture de toutes les notifications en vrac pour l'utilisateur courant
    $listeNotifications = $Thot->listeUserNotification($acronyme);
    $smarty->assign('listeNotifications',$listeNotifications);
    // traitement particuler pour les élèves dont on ne connaît, sinon, que le matricule
    $listeEleves = array();
    $notificationsEleves = isset($listeNotifications['eleves'])?$listeNotifications['eleves']:Null;
    foreach ($notificationsEleves as $id => $item) {
        $matricule = $item['destinataire'];
        $listeEleves[$matricule]=$matricule;
    }
    $smarty->assign('detailsEleves',$Ecole->detailsDeListeEleves($listeEleves));
    $smarty->assign('corpsPage','listeEdition');
    }


?>
