<?php
require_once("../config.inc.php");
include (INSTALL_DIR."/inc/entetesMin.inc.php");
// ----------------------------------------------------------------------------
//

$smarty->assign('action',$action);
$smarty->assign('mode',$mode);

switch ($action) {
    case 'createLink':
        // on a un nom d'utilisateur; il reste à vérifier son existence dans la BD
        $userName = isset($_POST['userName'])?$_POST['userName']:Null;
        if ($userName != '')
            $identite = user::identiteProf($userName);
        // quand il est vérifié (et qu'il existe), on crée le token dans la table lostPasswd et on envoie le mail contenant le lien
        if ($identite != Null) {
            $link = $Application->createPasswdLink($userName);
            $identiteReseau = user::identification();
            $Application->mailPasswd($link, $identite, $identiteReseau);
            $smarty->assign('identite',$identite);
            $smarty->assign('corpsPage','waitMail');
            }
        break;
    case 'changePasswd':
        // on vérifie que le token reçu en GET existe et qu'il n'est pas périmé
        $acronyme = isset($_GET['acronyme'])?$_GET['acronyme']:Null;
        $token = isset($_GET['token'])?$_GET['token']:Null;
        // on revient avec le userName si le token est correct et associé à l'acronyme
        $userName = $Application->chercheToken($token,$acronyme);
        if ($userName != '') {
            $identite = user::identiteProf($userName);
            $identiteReseau = user::identification();

            $smarty->assign('userName',$userName);
            $smarty->assign('TITRECOURT',TITRECOURT);
            $smarty->assign('ECOLE',ECOLE);
            $smarty->assign('token',$token);
            $smarty->assign('identite',$identite);
            $smarty->assign('identiteReseau',$identiteReseau);
            $smarty->assign('action','savePasswd');
            $smarty->assign('corpsPage','formulairePasswd');
            }
            else {
                $smarty->assign('corpsPage','tokenPerime');
            }

        break;

    case 'savePasswd':
        // enregistrement du nouveau mot de passe dans la BD
        $nb = $Application->savePasswd($_POST);
        $smarty->assign('corpsPage','confirmationPwd');
        break;

    default:
        // pas d'action indiquée ou paramètres non conformes
        $smarty->assign('action','createLink');
        $smarty->assign('corpsPage','formulaireUserName');

        break;
    }


//
// ----------------------------------------------------------------------------
$smarty->assign('executionTime', round($chrono->stop(),6));
$smarty->display ('index.tpl');
