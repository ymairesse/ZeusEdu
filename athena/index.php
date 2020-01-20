<?php

require_once '../config.inc.php';
include INSTALL_DIR.'/inc/entetes.inc.php';

// ----------------------------------------------------------------------------
//

$smarty->assign('action', $action);
$smarty->assign('mode', $mode);

$acronyme = $user->acronyme();
$smarty->assign('acronyme', $acronyme);

$etape = isset($_POST['etape']) ? $_POST['etape'] : null;

// durée de validité pour les Cookies
$unAn = time() + 365 * 24 * 3600;

$classe = Application::postOrCookie('classe', $unAn);

$smarty->assign('listeClasses', $Ecole->listeGroupes());

$id = isset($_POST['id']) ? $_POST['id'] : null;
$matricule = isset($_POST['matricule']) ? $_POST['matricule'] : null;
$smarty->assign('matricule', $matricule);

$onglet = isset($_POST['onglet']) ? $_POST['onglet'] : 0;
$smarty->assign('onglet', $onglet);

$noBulletin = isset($_POST['noBulletin']) ? $_POST['noBulletin'] : PERIODEENCOURS;

$smarty->assign('BASEDIR', BASEDIR);

require_once INSTALL_DIR."/inc/classes/class.Athena.php";
$Athena = new Athena();
$listeDemandes = $Athena->getDemandesSuivi();
$smarty->assign('listeDemandes', $listeDemandes);

switch ($action) {
    case 'ficheEleve':
        if ($matricule != null) {
            require 'inc/ficheEleve.inc.php';
        }
        break;

    case 'modifier':
           require 'inc/modifier.inc.php';
        break;

    case 'supprimer':
        require 'inc/supprimer.inc.php';
        break;

    case 'enregistrer':
        require 'inc/enregistrer.inc.php';
        break;

    case 'synthese':
        require 'inc/synthese.inc.php';
        break;

    case 'eleves':
        require 'inc/eleves/eleves.inc.php';
        break;

    default:
        require 'inc/coaching.inc.php';
        break;

    }

//
// ----------------------------------------------------------------------------
$smarty->assign('executionTime', round($chrono->stop(), 6));
$smarty->display('index.tpl');
