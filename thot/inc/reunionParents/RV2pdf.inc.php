<?php

require_once '../../../config.inc.php';

require_once INSTALL_DIR.'/inc/classes/classApplication.inc.php';
$Application = new Application();

// définition de la class USER utilisée en variable de SESSION
require_once INSTALL_DIR.'/inc/classes/classUser.inc.php';
session_start();

if (!(isset($_SESSION[APPLICATION]))) {
    echo "<script type='text/javascript'>document.location.replace('".BASEDIR."');</script>";
    exit;
}

$User = $_SESSION[APPLICATION];
$acronyme = $User->getAcronyme();

$module = $Application->getModule(3);

require_once(INSTALL_DIR."/html2pdf/html2pdf.class.php");

$idRP = isset($_POST['idRP'])?$_POST['idRP']:Null;
$acronyme = isset($_POST['acronyme'])?$_POST['acronyme']:'';


$nomProf = User::identiteProf($acronyme);

require_once(INSTALL_DIR.'/inc/classes/classThot.inc.php');
$thot = new Thot();
$listeRV = $thot->getRVprof($acronyme,$idRP);

$listeAttente = $thot->getListeAttenteProf($idRP, $acronyme);

$ds = DIRECTORY_SEPARATOR;
require_once(INSTALL_DIR."/smarty/Smarty.class.php");
$smarty = new Smarty();
$smarty->template_dir = INSTALL_DIR.$ds.$module.$ds."templates";
$smarty->compile_dir = INSTALL_DIR.$ds.$module.$ds."templates_c";


$smarty->assign('nomProf', sprintf('%s %s', $nomProf['prenom'], $nomProf['nom']));
$smarty->assign('entete', sprintf('%s %s %s',ECOLE, ADRESSE, VILLE));

$smarty->assign('listeRV',$listeRV);
$smarty->assign('listeAttente',$listeAttente);
$smarty->assign('acronyme',$acronyme);
$smarty->assign('nomProf', $nomProf);
$smarty->assign('listePeriodes',$thot->getListePeriodes($idRP));

$rv4PDF =  $smarty->fetch('../../templates/reunionParents/RV2pdf.tpl');

require INSTALL_DIR.'/vendor/autoload.php';
use Spipu\Html2Pdf\Html2Pdf;

$html2pdf = new Html2Pdf('P', 'A4', 'fr');

$html2pdf->WriteHTML($rv4PDF);

// création éventuelle du répertoire au nom de l'utlilisateur
$chemin = INSTALL_DIR.$ds.'upload'.$ds.$acronyme.$ds.$module.$ds;
if (!(file_exists($chemin)))
    mkdir ($chemin, 0700, true);

$html2pdf->Output($chemin.$nomFichier, 'F');

echo sprintf('<p>Vous pouvez récupérer le document au format PDF en cliquant <a target="_blank" id="celien" href="inc/download.php?type=pfN&amp;f=/%s/%s">sur ce lien</a></p>', $module, $nomFichier);
