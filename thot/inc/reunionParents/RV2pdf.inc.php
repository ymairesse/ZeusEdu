<?php

session_start();
require_once("../../../config.inc.php");

// définition de la class Application
require_once (INSTALL_DIR."/inc/classes/classApplication.inc.php");
$Application = new Application();

require_once(INSTALL_DIR."/html2pdf/html2pdf.class.php");

$date = isset($_POST['date'])?$_POST['date']:Null;
$acronyme = isset($_POST['acronyme'])?$_POST['acronyme']:'';
$module = isset($_POST['module'])?$_POST['module']:'';

require_once(INSTALL_DIR.'/inc/classes/classUser.inc.php');
$nomProf = User::identiteProf($acronyme);

require_once(INSTALL_DIR.'/inc/classes/classThot.inc.php');
$thot = new Thot();
$listeRV = $thot->getRVprof($acronyme,$date);

$listeAttente = $thot->getListeAttenteProf($date, $acronyme);

require_once(INSTALL_DIR."/smarty/Smarty.class.php");
$smarty = new Smarty();
$smarty->template_dir = "../templates";
$smarty->compile_dir = "../templates_c";


$smarty->assign('nomProf', sprintf('%s %s', $nomProf['prenom'], $nomProf['nom']));
$smarty->assign('entete', sprintf('%s %s %s',ECOLE, ADRESSE, VILLE));

$smarty->assign('listeRV',$listeRV);
$smarty->assign('listeAttente',$listeAttente);
$smarty->assign('acronyme',$acronyme);
$smarty->assign('nomProf', $nomProf);
$smarty->assign('listePeriodes',$thot->getListePeriodes($date));

$rv4PDF =  $smarty->fetch('../../templates/reunionParents/RV2pdf.tpl');

$html2pdf = new HTML2PDF('P','A4','fr');

$html2pdf->WriteHTML($rv4PDF);
$nomFichier = sprintf('%s.pdf', $acronyme);

// création éventuelle du répertoire au nom de l'utlilisateur
$chemin = INSTALL_DIR."/$module/PDF/$acronyme/";
if (!(file_exists($chemin)))
    mkdir (INSTALL_DIR."/$module/PDF/$acronyme");

$html2pdf->Output($chemin.$nomFichier,'F');
