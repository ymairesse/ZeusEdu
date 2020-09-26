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

$ds = DIRECTORY_SEPARATOR;
require_once INSTALL_DIR.$ds.$module.$ds.'inc/classes/classBulletin.inc.php';
$Bulletin = new Bulletin();

$formulaire = isset($_POST['formulaire']) ? $_POST['formulaire'] : null;
$form = array();
parse_str($formulaire, $form);

$matricule = isset($form['matricule']) ? $form['matricule'] : Null;
$commentaire = isset($form['commentaire']) ? $form['commentaire'] : Null;
$bulletin = isset($form['bulletin']) ? $form['bulletin'] : Null;

$annee = isset($form['annee']) ? $form['annee'] : Null;
$parcours = isset($form['parcours']) ? $form['parcours'] : Null;

$nb = $Bulletin->enregistrerRemarque($commentaire, $matricule, $bulletin);
$nb += $Bulletin->setNoticesParcours($matricule, $annee, $parcours);

echo $nb;
