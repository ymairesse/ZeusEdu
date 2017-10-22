<?php

require_once '../../../config.inc.php';

require_once '../../../inc/classes/classApplication.inc.php';
$Application = new Application();

require_once INSTALL_DIR.'/inc/classes/classThot.inc.php';
$thot = new Thot();

require_once INSTALL_DIR.'/inc/classes/classUser.inc.php';
session_start();

$User = $_SESSION[APPLICATION];
$acronyme = $User->getAcronyme();

require_once INSTALL_DIR.'/smarty/Smarty.class.php';
$smarty = new Smarty();
$smarty->template_dir = "../templates";
$smarty->compile_dir = "../templates_c";

$listeRv = $thot->listeChoixRV($acronyme);
$smarty->assign('listeRv',$listeRv);
$smarty->assign('ECOLE',ECOLE);
$smarty->assign('identite', $User->identite());

$rv4PDF =  $smarty->fetch('../../templates/rdv/rv2pdf.tpl');

require_once(INSTALL_DIR."/html2pdf/html2pdf.class.php");
$html2pdf = new HTML2PDF('P','A4','fr');
$html2pdf->WriteHTML($rv4PDF);
$nomFichier = sprintf('rv_%s.pdf', $acronyme);

$module = $Application->getModule(3);

// création éventuelle du répertoire au nom de l'utlilisateur
$chemin = INSTALL_DIR."/$module/PDF/$acronyme/";
if (!(file_exists($chemin)))
    mkdir (INSTALL_DIR."/$module/PDF/$acronyme");

$html2pdf->Output($chemin.$nomFichier,'F');
echo "rv_$nomFichier";
