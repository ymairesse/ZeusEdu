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

$rv4PDF =  $smarty->fetch('reunionParents/RVParents2pdf.tpl');

require_once(INSTALL_DIR."/html2pdf/html2pdf.class.php");
$html2pdf = new HTML2PDF('P','A4','fr');
$html2pdf->WriteHTML($rv4PDF);
$nomFichier = sprintf('%s.pdf', $acronyme);

$ds = DIRECTORY_SEPARATOR;
// création éventuelle du répertoire au nom de l'utlilisateur
$chemin = INSTALL_DIR.$ds.'upload'.$ds.$acronyme.$ds.$module.$ds;

if (!(file_exists($chemin)))
    mkdir($chemin, 0700, true);

$html2pdf->Output($chemin.$nomFichier,'F');

echo sprintf('<p>Vous pouvez récupérer le document au format PDF en cliquant <a target="_blank" id="celien" href="inc/download.php?type=pfN&amp;f=/%s/%s">sur ce lien</a></p>', $module, $nomFichier);
