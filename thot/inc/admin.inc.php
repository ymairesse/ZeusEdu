<?php

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

    default:
        // wtf
        break;
    }

if ($showEdition) {
    $listeNotifications = $Thot->listeUserNotification($acronyme);
    $smarty->assign('listeNotifications',$listeNotifications);
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
