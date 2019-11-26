<?php

require_once '../../config.inc.php';

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

$module = $Application->getModule(2);

$formulaire = isset($_POST['formulaire']) ? $_POST['formulaire'] : null;
$form = array();
parse_str($formulaire, $form);

$date = isset($form['date']) ? $form['date'] : Null;
$statuts = isset($form['statut']) ? $form['statut'] : Null;

$ds = DIRECTORY_SEPARATOR;
require_once INSTALL_DIR.$ds.$module.$ds.'inc/classes/classPresences.inc.php';
$Presences = new Presences();

$listePeriodes = $Presences->lirePeriodesCours();
$listeJustifications = $Presences->listeJustificationsAbsences();
$listeParDate = $Presences->listePresencesDate($date, $statuts);

require_once INSTALL_DIR.'/smarty/Smarty.class.php';
$smarty = new Smarty();
$smarty->template_dir = INSTALL_DIR.$ds.$module.$ds.'templates';
$smarty->compile_dir = INSTALL_DIR.$ds.$module.$ds.'templates_c';

require_once INSTALL_DIR.$ds.'html2PDF/vendor/autoload.php';

use Spipu\Html2Pdf\Html2Pdf;
use Spipu\Html2Pdf\Exception\Html2PdfException;
use Spipu\Html2Pdf\Exception\ExceptionFormatter;

$html2pdf = new \Spipu\Html2Pdf\Html2Pdf('P', 'A4', 'fr');

$smarty->assign('listePeriodes', $listePeriodes);
$smarty->assign('listeJustifications', $listeJustifications);
$smarty->assign('date', $date);
$smarty->assign('statuts', $Presences->getDetailsStatuts($statuts));
$smarty->assign('listeParDate', $listeParDate);

$liste4PDF = $smarty->fetch('listes/listeParDate.tpl');
$html2PDF->writeHTML($liste4PDF);

$html2pdf->output('Absences_'.$date);
