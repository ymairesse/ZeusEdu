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

// récupérer le formulaire d'encodage du JDC
$formulaire = isset($_POST['formulaire']) ? $_POST['formulaire'] : Null;
$form = array();
parse_str($formulaire, $form);

$idFait = isset($form['idFait']) ? $form['idFait'] : Null;

$ds = DIRECTORY_SEPARATOR;
require_once INSTALL_DIR.$ds.$module.$ds."inc/classes/classEleveAdes.inc.php";
$EleveAdes = new EleveAdes();

require_once INSTALL_DIR.$ds.$module.$ds.'inc/classes/classAdes.inc.php';
$Ades = new Ades();


$infosFait = $EleveAdes->infosFait($idFait);
foreach ($infosFait as $key => $chaine) {
    $infosFait[$key] = html_entity_decode($chaine);
}
$matricule = $infosFait['matricule'];

require_once INSTALL_DIR.'/inc/classes/classEleve.inc.php';
$Eleve = new Eleve($matricule);
$Eleve = $Eleve->getDetailsEleve();

$idretenue = $infosFait['idretenue'];
$infosRetenue = $Ades->infosRetenue($idretenue);

$date = str_replace('-','',Application::dateMysql($infosRetenue['dateRetenue']));
$heure = str_replace(':','', $infosRetenue['heure']);
$user = $Eleve['user'];
$fileName= $user.'_'.$date.'_'.$heure.'.pdf';

require_once INSTALL_DIR.'/smarty/Smarty.class.php';
$smarty = new Smarty();
$smarty->template_dir = '../../templates';
$smarty->compile_dir = '../../templates_c';

$smarty->assign('ECOLE', ECOLE);
$smarty->assign('ADRESSE', ADRESSE);
$smarty->assign('TELEPHONE', TELEPHONE);
$smarty->assign('COMMUNE', COMMUNE);
$smarty->assign('DATE', $Application->dateNow());
$smarty->assign('BASEDIR', BASEDIR);

foreach ($infosRetenue as $key => $value) {
    $smarty->assign("$key", $value);
}
foreach ($infosFait as $key => $value) {
    $smarty->assign("$key", $value);
}
foreach ($Eleve as $key => $value) {
    $smarty->assign("$key", $value);
}

// création éventuelle du répertoire au nom de l'utlilisateur
$chemin = INSTALL_DIR.$ds.'upload'.$ds.$acronyme.$ds.$module;
if (!(file_exists($chemin)))
    mkdir ($chemin, 0700, true);

// chargement de la présentation du billet de retenue
$format = json_decode(file_get_contents('../../templates/retenues/format.json'), true);

require INSTALL_DIR.'/vendor/autoload.php';
use Spipu\Html2Pdf\Html2Pdf;

$orientation = ($format['orientation'] == 'portrait') ? 'P' : 'L';
$page = ($format['page'] == 'A5') ? 'A5' : 'A4';
$html2pdf = new HTML2PDF($orientation, $page, 'fr');

$retenue4PDF = $smarty->fetch('retenues/retenue.tpl');

$html2pdf->WriteHTML($retenue4PDF);
// le document est enregistré prêt à être envoyé
$html2pdf->Output($chemin.$ds.$fileName,'F');

echo $fileName;
