<?php

require_once '../../../config.inc.php';

// définition de la class Application
require_once INSTALL_DIR.'/inc/classes/classApplication.inc.php';
$Application = new Application();

// définition de la class USER utilisée en variable de SESSION
require_once INSTALL_DIR.'/inc/classes/classUser.inc.php';
session_start();
$User = $_SESSION[APPLICATION];

$acronyme = $User->getAcronyme();

$module = $Application->getModule(3);

require_once INSTALL_DIR."/$module/inc/classes/classAdes.inc.php";
$Ades = new Ades();

$idfait = isset($_POST['idfait']) ? $_POST['idfait'] : null;
$infosFait = $Ades->infosFait($idfait);
foreach ($infosFait as $key => $chaine) {
    $infosFait[$key] = html_entity_decode($chaine);
}
$matricule = $infosFait['matricule'];

require_once INSTALL_DIR.'/inc/classes/classEleve.inc.php';
$Eleve = new Eleve($matricule);
$Eleve = $Eleve->getDetailsEleve();

$idretenue = $infosFait['idretenue'];
$infosRetenue = $Ades->infosRetenue($idretenue);

require_once INSTALL_DIR.'/smarty/Smarty.class.php';
$smarty = new Smarty();
$smarty->template_dir = '../../templates';
$smarty->compile_dir = '../../templates_c';

$smarty->assign('ECOLE',ECOLE);
$smarty->assign('ADRESSE',ADRESSE);
$smarty->assign('TELEPHONE',TELEPHONE);
$smarty->assign('COMMUNE',COMMUNE);
$smarty->assign('DATE',$Application->dateNow());

foreach ($infosRetenue as $key => $value) {
    $smarty->assign("$key", $value);
}

foreach ($infosFait as $key => $value) {
    $smarty->assign("$key", $value);
}
// Application::afficher($infosFait,true);
foreach ($Eleve as $key => $value) {
    $smarty->assign("$key", $value);
}

$format = json_decode(file_get_contents('../../templates/retenues/format.json'), true);

require_once(INSTALL_DIR."/html2pdf/html2pdf.class.php");
$orientation = ($format['orientation']=='portrait')?'P':'L';
$page = ($format['page']=='A5')?'A5':'A4';
$html2pdf = new HTML2PDF($orientation,$page,'fr');

$retenue4PDF = $smarty->fetch('../../templates/retenues/retenue.tpl');

$html2pdf->WriteHTML($retenue4PDF);

$dir = "pdf/$acronyme";

$nomFichier = "$dir/retenue_$idfait.pdf";
$html2pdf->Output(INSTALL_DIR."/$module/$nomFichier",'F');
$photo = $Eleve['photo'];
echo sprintf("<a href='%s'><img src='../photos/%s.jpg' alt='%d' style='height:150px'></a>",$nomFichier, $photo, $matricule);
