<?php

$etape = isset($_REQUEST['etape']) ? $_REQUEST['etape'] : null;
$acronyme = isset($_REQUEST['acronyme']) ? $_REQUEST['acronyme'] : null;
$classe = isset($_POST['classe']) ? $_POST['classe'] : null;

$smarty->assign('etape', $etape);
$smarty->assign('acronyme', $acronyme);
$smarty->assign('classe', $classe);

switch ($mode) {
    case 'alias':
        switch ($etape) {
            case 'enregistrer':
                $admin = $user->acronyme();
                if ($acronyme == null) {
                    die('missing user');
                }
                $qui = $Application->changeUserAdmin($acronyme);
                if ($qui == '') {
                    die('unknown user');
                }
                $smarty->assign('message', array(
                    'title' => 'Alias',
                    'texte' => "Vous avez pris l'alias <strong>$qui</strong>",
                    'urgence' => 'success', )
                    );
                $smarty->assign('redirection', '../index.php');
                $smarty->assign('time', 1500);
                $smarty->display('redirect.tpl');
                break;
            default:
                $listeProfs = $Ecole->listeProfs();
                $smarty->assign('listeProfs', $listeProfs);
                $smarty->assign('action', 'autres');
                $smarty->assign('mode', $mode);
                $smarty->assign('etape', 'enregistrer');
                $smarty->assign('selecteur', 'selecteurs/selectNomProf');
                break;
            }
        break;
    case 'switchApplications':
        switch ($etape) {
            case 'enregistrer':
                $enregistrements = $Application->saveApplisStatus($_POST);
                $smarty->assign('message', array(
                            'title' => SAVE,
                            'texte' => "$enregistrements modifications enregistrées.",
                            'urgence' => 'success', )
                            );
                // pas de break, on continue sur la présentation de la grille
            default:
                // activer et désactiver des applications
                $listeApplisActivite = $Application->listeApplis(false, true);
                // logout et admin ne peuvent pas être désactivées
                unset($listeApplisActivite['logout']);
                unset($listeApplisActivite['admin']);
                $smarty->assign('listeApplis', $listeApplisActivite);
                $smarty->assign('action', $action);
                $smarty->assign('mode', $mode);
                $smarty->assign('etape', 'enregistrer');
                $smarty->assign('corpsPage', 'chooseApplisStatus');
                break;
            }
        break;

    case 'config':
        switch ($etape) {
            case 'save':
                $nb = $Application->saveParametres($_POST);
                $smarty->assign('message', array(
                            'title' => SAVE,
                            'texte' => "$nb modification(s) enregistrée(s).",
                            'urgence' => 'success', )
                            );
                // pas de break;
            default:
                $parametres = $Application->lireParametres();
                $smarty->assign('action', $action);
                $smarty->assign('mode', $mode);
                $smarty->assign('parametres', $parametres);
                $smarty->assign('corpsPage', 'paramGeneraux');
            break;
        }
	    break;

    case 'majAcronymes':
        $smarty->assign('corpsPage', 'newAcronymes');
        break;
    }
