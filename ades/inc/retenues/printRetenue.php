<?php

require_once '../../../config.inc.php';

// définition de la class Application
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

require_once INSTALL_DIR."/$module/inc/classes/classAdes.inc.php";
$Ades = new Ades();

require_once INSTALL_DIR."/$module/inc/classes/classEleveAdes.inc.php";
$EleveAdes = new EleveAdes();

$idfait = isset($_GET['idfait']) ? $_GET['idfait'] : null;

$infosFait = $EleveAdes->infosFait($idfait);
foreach ($infosFait as $key => $chaine) {
    $infosFait[$key] = html_entity_decode($chaine);
}
$matricule = $infosFait['matricule'];

// retrouver les informations concernant l'élève sanctionné
require_once INSTALL_DIR.'/inc/classes/classEleve.inc.php';
$Eleve = new Eleve($matricule);
$Eleve = $Eleve->getDetailsEleve();

// retrouver l'identifiant de la retenue contenue dans le table $infosFait
$idretenue = $infosFait['idretenue'];
$infosRetenue = $Ades->infosRetenue($idretenue);

// retrouver le nom du prof à l'origine de la retenue
require_once INSTALL_DIR.'/inc/classes/classEcole.inc.php';
$Ecole = new Ecole();
$infosRetenue['nomProf'] = $Ecole->abr2name($infosFait['professeur']);

require_once INSTALL_DIR.'/smarty/Smarty.class.php';
$smarty = new Smarty();
$smarty->template_dir = '../../templates';
$smarty->compile_dir = '../../templates_c';

// Informations générales concernant l'école
$smarty->assign('ECOLE', ECOLE);
$smarty->assign('ADRESSE', ADRESSE);
$smarty->assign('TELEPHONE', TELEPHONE);
$smarty->assign('COMMUNE', COMMUNE);
$smarty->assign('DATE', $Application->dateNow());
$smarty->assign('BASEDIR', BASEDIR);

foreach ($infosFait as $key => $value) {
    $smarty->assign("$key", $value);
}

foreach ($Eleve as $key => $value) {
    $smarty->assign("$key", $value);
}

require INSTALL_DIR.'/vendor/autoload.php';
use Spipu\Html2Pdf\Html2Pdf;

if ($idretenue != 0) {
    foreach ($infosRetenue as $key => $value) {
        $smarty->assign("$key", $value);
    }

    $ds = DIRECTORY_SEPARATOR;
    $formatFile = INSTALL_DIR.$ds.$module.'/templates/retenues/format.json';
    // chargement de la présentation du billet de retenue
    $format = json_decode(file_get_contents($formatFile), true);

    $orientation = ($format['orientation'] == 'portrait') ? 'P' : 'L';
    $page = ($format['page'] == 'A5') ? 'A5' : 'A4';
    $html2pdf = new HTML2PDF($orientation, $page, 'fr');

    $retenue4PDF = $smarty->fetch('retenues/retenue.tpl');

    $html2pdf->WriteHTML($retenue4PDF);
    $html2pdf->Output('retenue_'.$matricule.'.pdf');
}
