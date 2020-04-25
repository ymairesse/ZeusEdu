<?php

session_start();
require_once("../../config.inc.php");

// définition de la class Application
require_once (INSTALL_DIR."/inc/classes/classApplication.inc.php");
$Application = new Application();

// définition de la class Bulletin
require_once (INSTALL_DIR."/bullISND/inc/classes/classBulletin.inc.php");
$Bulletin = new Bulletin();

$matricule = isset($_POST['matricule'])?$_POST['matricule']:Null;
$noBulletin = isset($_POST['noBulletin'])?$_POST['noBulletin']:Null;
$anneeEtude = isset($_POST['anneeEtude'])?$_POST['anneeEtude']:Null;

$listeCoursGrp = $Bulletin->listeCoursGrpEleves($matricule, $noBulletin);

if ($listeCoursGrp) {
    $listeCoursGrp = $listeCoursGrp[$matricule];
    $listeProfsCoursGrp = $Bulletin->listeProfsListeCoursGrp($listeCoursGrp);
    $listeSituations = $Bulletin->listeSituationsCours($matricule, array_keys($listeCoursGrp), null, true);
    $sitPrecedentes = $Bulletin->situationsPrecedentes($listeSituations, $noBulletin);
    $sitActuelles = $Bulletin->situationsPeriode($listeSituations, $noBulletin);
    $listeCompetences = $Bulletin->listeCompetencesListeCoursGrp($listeCoursGrp);
    $listeCotes = $Bulletin->listeCotes($matricule, $listeCoursGrp, $listeCompetences, $noBulletin);

    $ponderations = $Bulletin->getPonderations($listeCoursGrp, $noBulletin);
    $cotesPonderees = $Bulletin->listeGlobalPeriodePondere($listeCotes, $ponderations, $noBulletin);

    $tableauAttitudes = $Bulletin->tableauxAttitudes($matricule, $noBulletin);

    $commentairesCotes = $Bulletin->listeCommentairesTousCours($matricule, $noBulletin);
    $mentions = $Bulletin->listeMentions($matricule, $noBulletin);

    $commentairesEducs = $Bulletin->listeCommentairesEduc($matricule, $noBulletin);
    $commentairesEducs = isset($commentairesEducs[$matricule][$noBulletin]) ? $commentairesEducs[$matricule][$noBulletin] : Null;

    $remarqueTitulaire = $Bulletin->remarqueTitu($matricule, $noBulletin);
    if ($remarqueTitulaire != null) {
        $remarqueTitulaire = $remarqueTitulaire[$matricule][$noBulletin];
    } else {
        $remarqueTitulaire = '';
    }
    $tableauAttitudes = $Bulletin->tableauxAttitudes($matricule, $noBulletin);
    $noticeDirection = $Bulletin->noteDirection($anneeEtude, $noBulletin);

    require_once(INSTALL_DIR."/smarty/Smarty.class.php");
    $smarty = new Smarty();
    $smarty->template_dir = "../templates";
    $smarty->compile_dir = "../templates_c";

    $smarty->assign('noBulletin', $noBulletin);
    $smarty->assign('matricule',$matricule);
    $smarty->assign('listeCoursGrp', $listeCoursGrp);
    $smarty->assign('listeProfsCoursGrp', $listeProfsCoursGrp);
    $smarty->assign('sitPrecedentes', $sitPrecedentes);
    $smarty->assign('sitActuelles', $sitActuelles);
    $smarty->assign('listeCotes', $listeCotes);
    $smarty->assign('listeCompetences', $listeCompetences);

    $smarty->assign('cotesPonderees', $cotesPonderees);
    $smarty->assign('commentaires', $commentairesCotes);
    $smarty->assign('attitudes', $tableauAttitudes);
    $smarty->assign('commentairesEducs', $commentairesEducs);
    $smarty->assign('remTitu', $remarqueTitulaire);
    $smarty->assign('mention', $mentions);
    $smarty->assign('noticeDirection', $noticeDirection);
    $smarty->display('detailSuivi/bulletin.tpl');
}
