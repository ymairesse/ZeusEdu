<?php

require_once '../config.inc.php';
require_once INSTALL_DIR.'/inc/entetesMin.inc.php';
// ----------------------------------------------------------------------------
//
$smarty->assign('action', $action);
$smarty->assign('mode', $mode);

switch ($action) {
    case 'etape2':
        // on a un nom d'utilisateur; il reste à vérifier son existence dans la BD
        $userName = isset($_POST['userName']) ? $_POST['userName'] : null;
        if ($userName != '') {
            $identite = user::identiteProf($userName);
        } else {
                $identite = null;
            }

        $smarty->assign('etape', 2);
        // quand il est vérifié (et qu'il existe), on crée le token dans la table lostPasswd et on envoie le mail contenant le lien
        if ($identite != null) {
            $link = $Application->createPasswdLink($userName);
            $identiteReseau = user::identification();
            $Application->mailPasswd($link, $identite, $identiteReseau);
            $smarty->assign('identite', $identite);
            // prochaine étape à prévoir
            $smarty->assign('action', 'etape3');
            $smarty->assign('sousDoc', 'waitMail');
            $smarty->assign('corpsPage', 'steps');
        } else {
                $smarty->assign('IMPOSSIBLE', IMPOSSIBLE);
                $smarty->assign('MAILADMIN', MAILADMIN);
                $smarty->assign('acronyme', $userName);
                $smarty->assign('sousDoc', 'userUnknown');
                $smarty->assign('corpsPage', 'steps');
            }
        break;
        
    case 'etape3':
        // effacement des tokens périmés (plus de deux jours)
        $Application->delOldTokens(2);
        // on vérifie que le token reçu en GET existe
        $acronyme = isset($_GET['acronyme']) ? $_GET['acronyme'] : null;
        $token = isset($_GET['token']) ? $_GET['token'] : null;
        // on revient avec le userName si le token est correct et associé à l'acronyme
        $userName = $Application->chercheToken($token, $acronyme);
        if ($userName != '') {
            $identite = user::identiteProf($userName);
            $identiteReseau = user::identification();

            $smarty->assign('userName', $userName);
            $smarty->assign('TITRECOURT', TITRECOURT);
            $smarty->assign('ECOLE', ECOLE);
            $smarty->assign('token', $token);
            $smarty->assign('identite', $identite);
            $smarty->assign('identiteReseau', $identiteReseau);
            // prochaine étape à prévoir
            $smarty->assign('action', 'etape4');
            $smarty->assign('etape', 3);
            $smarty->assign('sousDoc', 'formulairePasswd');
            $smarty->assign('corpsPage', 'steps');
        } else {
                $smarty->assign('sousDoc', 'tokenPerime');
                $smarty->assign('corpsPage', 'steps');
            }

        break;

    case 'etape4':
        // enregistrement du nouveau mot de passe dans la BD
        $nb = $Application->savePasswd($_POST);
        $smarty->assign('etape', 4);
        $smarty->assign('sousDoc', 'confirmationPwd');
        $smarty->assign('corpsPage', 'steps');
        break;

    default:
        // pas d'action indiquée ou paramètres non conformes
        // prochaine étape à prévoir
        $smarty->assign('action', 'etape2');
        $smarty->assign('etape', 1);
        $smarty->assign('sousDoc', 'formulaireUserName');
        $smarty->assign('corpsPage', 'steps');
        break;
    }

//
// ----------------------------------------------------------------------------
$smarty->assign('executionTime', round($chrono->stop(), 6));
$smarty->display('index.tpl');
