<?php
if ($matricule != '') {
    $Eleve = new eleve($matricule);
    $detailsEleve = $Eleve->getDetailsEleve();
    $smarty->assign('detailsEleve',$detailsEleve);
    }

switch ($etape) {
    case 'show':
        $id = isset($_POST['id'])?$_POST['id']:Null;
        $notification = $Thot->getNotification($id,$acronyme);
        $smarty->assign('matricule',$matricule);
        $smarty->assign('notification',$notification);
        $smarty->assign('action',$action);
        $smarty->assign('mode',$mode);
        $smarty->assign('edition',true);
        $smarty->assign('corpsPage','formNotification');
        break;
    case 'enregistrer':
        $id = $Thot->enregistrerNotification($_POST);
        if ($id != Null) {
            if ($matricule != '')
                $txt = $detailsEleve['prenom'].' '.$detailsEleve['nom'];
                else if ($classe != '')
                    $txt = "la classe de $classe";
                    else if ($niveau != '')
                        $txt = "l'ensemble du niveau $niveau";
                        else $txt = "tous les élèves";
            $texte = "Notification à $txt enregistrée";
            }
            else $texte = 'Aucun enregistrement effectué';
        $smarty->assign('message', array(
                'title'=>SAVE,
                'texte'=>$texte,
                'urgence'=>SUCCES)
                );
        $smarty->assign('notification',$_POST);
        $smarty->assign('corpsPage','syntheseNotification');
        break;
    default:
        // wtf
        break;
    }

?>
