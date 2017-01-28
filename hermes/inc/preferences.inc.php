<?php

if ($mode == 'enregistrer') {
    $signature = $_POST['signature'];
    $nb = file_put_contents ('templates/signature.tpl', $signature);
    if ($nb != false) {
        $texte = "$nb octet(s) enregistré(s)";
        $urgence = 'success';
        }
        else {
            $texte = "Échec de l'enregistrement";
            $urgence = 'danger';
            }
    $smarty->assign("message", array(
            'title'=>SAVE,
            'texte'=>$texte,
            'urgence'=>$urgence));
    }
    else $signature = file_get_contents('templates/signature.tpl');
$smarty->assign('action',$action);
$smarty->assign('mode',$mode);
$smarty->assign('signature',$signature);
$smarty->assign('corpsPage','editSignature');
