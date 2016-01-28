<?php

switch ($etape) {
    case 'show':
        $id = isset($_POST['id'])?$_POST['id']:Null;
        // liste des accusés de lecture pour cet id
        $listeAccuses = $Thot->getAccuses($id,$acronyme);
        $smarty->assign('listeAccuses',$listeAccuses);
        // la notificaiton, pour mémoire
        $notification = $Thot->getNotification($id,$acronyme);
        $smarty->assign('notification',$notification);
        $smarty->assign('corpsPage','verifAccuses');
        break;

    default:
        $smarty->assign('listeAccuses',$Thot->listeAccuses($acronyme));
        $smarty->assign('corpsPage','listeAccuses');
        break;
}

 ?>
