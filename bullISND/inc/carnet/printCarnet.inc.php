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

$identite = $User->identite();
$civ = ($identite['sexe'] == 'F') ? 'Mme ' : 'M. ';
$nomProf = sprintf('%s %s %s', $civ, $identite['prenom'], $identite['nom']);

$coursGrp = isset($_POST['coursGrp']) ? $_POST['coursGrp'] : Null;
$tri = isset($_POST['tri']) ? $_POST['tri'] : 'alpha';

$formulaire = isset($_POST['formulaire']) ? $_POST['formulaire'] : Null;
$form = array();
parse_str($formulaire, $form);

$periodes = $form['periodes'];

require_once INSTALL_DIR."/inc/classes/classEcole.inc.php";
$Ecole = new Ecole();

require_once INSTALL_DIR."/bullISND/inc/classes/classBulletin.inc.php";
$Bulletin = new Bulletin();

$listeEleves = $Ecole->listeElevesCours($coursGrp, $tri);


$ds = DIRECTORY_SEPARATOR;
require_once INSTALL_DIR.'/smarty/Smarty.class.php';
$smarty = new Smarty;
$smarty->template_dir = INSTALL_DIR.$ds.$module.$ds.'templates';
$smarty->compile_dir = INSTALL_DIR.$ds.$module.$ds.'templates_c';

$smarty->assign('coursGrp',$coursGrp);
$smarty->assign('listeEleves',$listeEleves);
$smarty->assign('nomProf',$nomProf);
$smarty->assign('date', Application::dateNow());
$smarty->assign('ANNEESCOLAIRE', ANNEESCOLAIRE);

require INSTALL_DIR.'/vendor/autoload.php';
use Spipu\Html2Pdf\Html2Pdf;

$html2pdf = new HTML2PDF('L','A4','fr');

foreach ($periodes as $unePeriode) {
    $listeTravaux = $Bulletin->listeTravaux($coursGrp, $unePeriode);
    $listeCotes = ($listeTravaux != Null) ? $Bulletin->listeCotesCarnet($listeTravaux) : Null;
    $listeMoyennes = $Bulletin->listeMoyennesCarnet($listeCotes);
    $listeCompetences = current($Bulletin->listeCompetences($coursGrp));

    $smarty->assign('listeTravaux',$listeTravaux);
    $smarty->assign('listeCotes', $listeCotes);
    $smarty->assign('listeMoyennes', $listeMoyennes);
    $smarty->assign('listeCompetences', $listeCompetences);

    $smarty->assign('bulletin', $unePeriode);

    $carnet4PDF =  $smarty->fetch('simpleShowCarnet.tpl');
    $html2pdf->WriteHTML($carnet4PDF);
    }

$listeBulletins = implode('', $periodes);
$nomFichier = $coursGrp.'_'.$listeBulletins.'.pdf';
$chemin = INSTALL_DIR.$ds.'upload'.$ds.$acronyme.$ds.$module.$ds;
// créer le répetoire s'il n'existe pas encore
if (!(file_exists($chemin))) {
    mkdir($chemin, 0700, true);
    }

$html2pdf->Output($chemin.$nomFichier, 'F');

$smarty->assign('nomFichier', $nomFichier);
$smarty->assign('module', $module);
$smarty->display('carnet/download.tpl');
