<?php

session_start();
require_once('../../../config.inc.php');

$date = isset($_POST['date'])?$_POST['date']:Null;
$mode = isset($_POST['mode'])?$_POST['mode']:Null;
$acronyme = isset($_POST['acronyme'])?$_POST['acronyme']:Null;
$module = isset($_POST['module'])?$_POST['module']:Null;

require_once(INSTALL_DIR.'/inc/classes/classApplication.inc.php');
$Application = new Application();
require_once(INSTALL_DIR."/inc/classes/classThot.inc.php");
$thot = new Thot();
require_once(INSTALL_DIR.'/smarty/Smarty.class.php');
$smarty = new Smarty();

$listeRV = $thot->listeRVParents($date, $mode=='complet');
$listeAttente = $thot->listeAttenteParents($date, $mode=='complet');

// établir une liste complete de tous les élèves qui figurent dans l'une ou dans l'autre liste
$fullListe = array_unique(array_merge(array_keys($listeRV), array_keys($listeAttente)));
$listeEleves = $thot->listeElevesMatricules($fullListe);
$smarty->assign('date', $date);
$smarty->assign('listeRV', $listeRV);
$smarty->assign('listeAttente', $listeAttente);
$smarty->assign('fullListe',$fullListe);
$smarty->assign('listeEleves',$listeEleves);
$smarty->assign('listeProfsEleves',$thot->listeCoursListeEleves($listeEleves));

$smarty->assign('listePeriodes',$thot->getListePeriodes($date));
$smarty->assign('entete', sprintf('%s <br> %s <br> %s <br>',ECOLE, ADRESSE, VILLE));
$rv4PDF =  $smarty->fetch('../../templates/reunionParents/RVParents2pdf.tpl');

require_once(INSTALL_DIR."/html2pdf/html2pdf.class.php");
$html2pdf = new HTML2PDF('P','A4','fr');
$html2pdf->WriteHTML($rv4PDF);
$nomFichier = sprintf('%s.pdf', $acronyme);

// création éventuelle du répertoire au nom de l'utlilisateur
$chemin = INSTALL_DIR."/$module/PDF/$acronyme/";
if (!(file_exists($chemin)))
    mkdir (INSTALL_DIR."/$module/PDF/$acronyme");

$html2pdf->Output($chemin.$nomFichier,'F');
