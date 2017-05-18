<?php

require_once '../../../config.inc.php';

require_once INSTALL_DIR.'/inc/classes/classApplication.inc.php';
$Application = new Application();

// $module = $Application->getModule(2);

// définition de la class USER utilisée en variable de SESSION
require_once INSTALL_DIR.'/inc/classes/classUser.inc.php';
session_start();
if (!(isset($_SESSION[APPLICATION]))) {
    die("<div class='alert alert-danger'>".RECONNECT.'</div>');
}

$post = isset($_POST['post']) ? $_POST['post'] : null;
// retour du contenu du formulaire qui a été serializé
$form = array();
parse_str($post, $form);

$date = $form['listeDates'];
$listeProfs = $form['listeProfs'];

require_once INSTALL_DIR.'/smarty/Smarty.class.php';
$smarty = new Smarty();
$smarty->template_dir = '../../templates';
$smarty->compile_dir = '../../templates_c';

$module = Application::getModule(3);
$rv4PDF =  $smarty->fetch('reunionParents/RVParents2pdf.tpl');

require_once(INSTALL_DIR."/html2pdf/html2pdf.class.php");
$html2pdf = new HTML2PDF('P','A4','fr');
$html2pdf->WriteHTML($rv4PDF);
$nomFichier = sprintf('%s.pdf', $acronyme);

// création éventuelle du répertoire au nom de l'utlilisateur
$chemin = INSTALL_DIR."/$module/PDF/$acronyme/";
if (!(file_exists($chemin)))
    mkdir (INSTALL_DIR."/$module/PDF/$acronyme");

$html2pdf->Output($chemin.$nomFichier,'F');
