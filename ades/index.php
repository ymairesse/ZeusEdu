<?php

require_once '../config.inc.php';
include INSTALL_DIR.'/inc/entetes.inc.php';
// ----------------------------------------------------------------------------
//

$smarty->assign('action', $action);
$smarty->assign('mode', $mode);

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

if ($matricule != '') {
    // si un matricule est donné, on aura sans doute besoin des données de l'élève
    require_once INSTALL_DIR."/$module/inc/classes/classEleveAdes.inc.php";
    $eleve = new Eleve($matricule);
    $ficheDisc = new EleveAdes($matricule);
    $titulaires = $eleve->titulaires($matricule);
    $smarty->assign('matricule', $matricule);
    $smarty->assign('eleve', $eleve->getDetailsEleve());

    $classe = $eleve->getDetailsEleve();
    $classe = $classe['groupe'];
    $listeEleves = $Ecole->listeEleves($classe, 'groupe');
    $prevNext = $Ecole->prevNext($matricule, $listeEleves);
    $smarty->assign('prevNext', $prevNext);
    $smarty->assign('ficheDisc', $ficheDisc);
    $smarty->assign('titulaires', $titulaires);
}

switch ($action) {
    case 'admin':
        include 'inc/admin.inc.php';
        break;
    case 'users':
        include 'inc/users.inc.php';
        break;
    case 'synthese':
        include 'inc/synthese.inc.php';
        break;
    case 'retenues':
        include 'inc/retenues.inc.php';
        break;
    case 'print':
        include 'inc/print.inc.php';
        break;
    case 'news':
        if (in_array($userStatus, array('admin', 'educ'))) {
            include 'inc/delEditNews.php';
        }
        break;
    case 'fait':
        include 'inc/fait.inc.php';
        break;
    default:
        include 'inc/eleve.inc.php';
        break;

}

// pour les différents cas où il faut afficher une fiche d'élève, on affiche
if (isset($afficherEleve) && ($afficherEleve == true)) {
    require_once INSTALL_DIR.'/inc/classes/classPad.inc.php';
    $memoEleve = new padEleve($matricule, 'ades');
    $smarty->assign('memoEleve', $memoEleve->getPads());

    if (isset($classe)) {
        $smarty->assign('listeEleves', $Ecole->listeEleves($classe));
        $smarty->assign('classe', $classe);
        $prevNext = $Ecole->prevNext($matricule, $listeEleves);
        $smarty->assign('prevNext', $prevNext);
    }

    $smarty->assign('user', $user);
    $smarty->assign('listeTypesFaits', $Ades->listeTypesFaits());
    $smarty->assign('descriptionChamps', $Ades->listeChamps());
    $smarty->assign('sentByidFait', $Ades->sentByIdFait($matricule));
    $smarty->assign('sentMails', $Ades->sentMails($matricule));
    $smarty->assign('matricule', $matricule);
    $smarty->assign('listeClasses', $Ecole->listeGroupes());
    $listeEleves = $Ecole->listeEleves($classe, 'groupe');
    $smarty->assign('listeEleves', $listeEleves);
    $smarty->assign('selecteur', 'selecteurs/selectClasseEleve');
    $smarty->assign('corpsPage', 'eleve/ficheEleve');
}

//
// ----------------------------------------------------------------------------
$smarty->assign('executionTime', round($chrono->stop(), 6));
$smarty->display('index.tpl');
