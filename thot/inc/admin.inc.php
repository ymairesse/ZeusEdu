<?php

$date = isset($_POST['date']) ? $_POST['date'] : null;
$smarty->assign('date', $date);


require_once INSTALL_DIR.'/inc/classes/classThot.inc.php';
$thot = new Thot();

switch ($mode) {
    case 'reunionParents':
        if ($etape == 'enregistrer') {
            $canevas = $thot->getCanevas($_POST);
            $attribProfs = $thot->getAttribProfs($_POST);
            $nb = $thot->saveCanevasProfs($date, $canevas, $attribProfs);
            $message = array(
                'title' => SAVE,
                'texte' => sprintf('%d modification(s) enregistrée(s)', $nb),
                'urgence' => 'warning',
                );
            $smarty->assign('message', $message);
        }
        if ($etape == 'delete') {
            if (isset($date)) {
                $nb = $thot->deleteRP($date);
                $message = array(
                    'title' => DELETE,
                    'texte' => sprintf('%d suppressions(s) enregistrée(s)', $nb),
                    'urgence' => 'warning',
                    );
                $smarty->assign('message', $message);
            }
            $date = null;  // cette date n'existe plus
        }

        $listeReunions = $thot->listeDatesReunion();
        $smarty->assign('listeDates', $listeReunions);
        $listeProfs = $Ecole->listeProfs(true);
        $smarty->assign('listeProfs',$listeProfs);

        $smarty->assign('corpsPage', 'reunionParents/prepaRP');
        $smarty->assign('selecteur', 'selecteurs/selectDate');
        break;
    default:
        // wtf
        break;
}
