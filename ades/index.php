<?php

require_once '../config.inc.php';
include INSTALL_DIR.'/inc/entetes.inc.php';
// ----------------------------------------------------------------------------
//

$smarty->assign('action', $action);
$smarty->assign('mode', $mode);

$refreshOn = isset($_COOKIE['refreshOn']) ? $_COOKIE['refreshOn'] : 0;

$classe = Application::postOrCookie('classe', $unAn);

$matricule = isset($_GET['matricule']) ? $_GET['matricule'] : Null;
if ($matricule == Null)
    $matricule = Application::postOrCookie('matricule', $unAn);

$etape = isset($_POST['etape']) ? $_POST['etape'] : null;

$acronyme = $user->getAcronyme();
$smarty->assign('acronyme', $acronyme);
$identite = $user->identite();
$smarty->assign('identite', $identite);

require_once INSTALL_DIR."/$module/inc/classes/classAdes.inc.php";
$Ades = new Ades();

require_once INSTALL_DIR."/$module/inc/classes/classEleveAdes.inc.php";
$EleveAdes = new EleveAdes();

switch ($action) {
    case 'admin':
        // toutes les fonctions d'administration de l'application
        include 'inc/admin.inc.php';
        break;
    case 'synthese':
        // fiches de comportement et statistiques
        include 'inc/synthese.inc.php';
        break;
    case 'retenues':
        // gestion des heures et locaux de retenues
        include 'inc/retenues.inc.php';
        break;

    case 'news':
        if (in_array($userStatus, array('admin', 'educ'))) {
            include 'inc/delEditNews.php';
        }
        break;
    case 'fait':
        // enregistrement d'un fait disciplinaire pour un élève donné
        include 'inc/fait.inc.php';
        break;
    default:
        // accès à la fiche de comportement d'un élève
        include 'inc/eleve.inc.php';
        break;
}

//
// ----------------------------------------------------------------------------

$smarty->assign('INSTALL_DIR', INSTALL_DIR);
$smarty->assign('executionTime', round($chrono->stop(), 6));
$smarty->assign('refreshOn', $refreshOn);

$smarty->display('index.tpl');
