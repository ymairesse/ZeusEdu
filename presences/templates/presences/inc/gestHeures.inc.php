<?php

switch ($etape) {
  case 'enregistrer':
    $resultats = $Presences->enregistrerHeures($_POST);
    $smarty->assign('message',
                        array(
                            'title' => SAVE,
                            'texte' => sprintf(NBSAVE, $resultats['ok']),
                            'urgence' => 'success',
                            ));
    $smarty->assign('erreurs', $resultats['ko']);

    $listePeriodesCours = $Presences->lirePeriodesCours();
    $smarty->assign('action', 'admin');
    $smarty->assign('mode', 'heures');
    $smarty->assign('etape', 'enregistrer');
    $smarty->assign('listePeriodes', $listePeriodesCours);
    $smarty->assign('corpsPage', 'formHeures');
    break;
  case 'ajouterPeriode':
    $nb = $Presences->ajoutPeriode();
    if ($nb == 0) {
        $smarty->assign('message', array(
          'title' => NOSAVE,
          'texte' => NOHOUR,
          'urgence' => 'warning',
          ));
    }

    // break;   pas de break;
  default:
    $listePeriodesCours = $Presences->lirePeriodesCours();

    $smarty->assign('action', 'admin');
    $smarty->assign('mode', 'heures');
    $smarty->assign('etape', 'enregistrer');
    $smarty->assign('listePeriodes', $listePeriodesCours);
    $smarty->assign('corpsPage', 'formHeures');
    break;
}
