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
        $smarty->assign('corpsPage','notification/formNotification');
        break;

    case 'enregistrer':
        $id = $Thot->enregistrerNotification($_POST);
        $notification = $Thot->getNotification($id,$acronyme);
        if ($id != Null) {
            $type = $notification['type'];
            switch ($type) {
                case 'eleves':
                    $txt = $detailsEleve['prenom'].' '.$detailsEleve['nom'];
                    break;
                case 'classes':
                    $txt = sprintf('tous les élèves de la classe de %s',$_POST['destinataire']);
                    break;
                case 'cours':
                    $txt = sprintf('tous les élèves du cours %s',$_POST['destinataire']);
                    break;
                case 'niveau':
                    $txt = sprintf('tous les élèves du niveau %s', $_POST['destinataire']);
                    break;
                case 'ecole':
                    $txt = 'tous les élèves';
                    break;
                default:
                    //wtf
                    break;
                }
            $texte = sprintf('Notification à %s enregistrée',$txt);
            }
            else $texte = 'Aucun enregistrement effectué';

        $smarty->assign('message', array(
                'title'=>SAVE,
                'texte'=>$texte,
                'urgence'=>SUCCES)
                );

        $smarty->assign('notification',$notification);
        $smarty->assign('corpsPage','notification/syntheseNotification');
        break;
    default:
        // wtf
        break;
    }
