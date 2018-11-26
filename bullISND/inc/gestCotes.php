<?php

$unAn = time() + 365 * 24 * 3600;
$etape = isset($_REQUEST['etape']) ? $_REQUEST['etape'] : null;
$bulletin = isset($_REQUEST['bulletin']) ? $_REQUEST['bulletin'] : PERIODEENCOURS;

$coursGrp = Application::postOrCookie('coursGrp', $unAn);
$smarty->assign('coursGrp', $coursGrp);

if (isset($_POST['tri'])) {
    $tri = $_POST['tri'];
    setcookie('tri', $tri, $unAn, null, null, false, true);
} else {
        $tri = isset($_COOKIE['tri']) ? $_COOKIE['tri'] : null;
    }
$smarty->assign('tri', $tri);

$sections = "'G', 'GT', 'TT'";

$listeCoursProf = $user->listeCoursProf(Null, true);

$smarty->assign('listeCours', $listeCoursProf);

switch ($mode) {
    case 'voir':
        $smarty->assign('selecteur', 'selecteurs/selectBulletinCours');
        $smarty->assign('nbBulletins', NBPERIODES);
        $smarty->assign('bulletin', $bulletin);
        $smarty->assign('action', $action);
        $smarty->assign('mode', $mode);
        if ($etape == 'showCotes' && in_array($coursGrp, array_keys($listeCoursProf))) {
            $listeEleves = $Ecole->listeElevesCours($coursGrp, $tri);
            $ponderations = $Bulletin->getPonderations($coursGrp, $bulletin);
            $listeCompetences = $Bulletin->listeCompetences($coursGrp);
            $listeCotes = $Bulletin->listeCotes($listeEleves, $coursGrp, $listeCompetences, $bulletin);
            $smarty->assign('listeCompetences', $listeCompetences);
            $smarty->assign('cours', $Bulletin->intituleCours($coursGrp));
            $smarty->assign('cotesCours', $Bulletin->recapCotesCours($listeEleves, $listeCompetences, $coursGrp, $bulletin));
            $smarty->assign('ponderations', $ponderations);
            $smarty->assign('listeGlobalPeriodePondere', $Bulletin->listeGlobalPeriodePondere($listeCotes, $ponderations, $bulletin));
            $smarty->assign('corpsPage', 'showCotesCours');
        }
        break;
    default: die('missing mode');
    }
