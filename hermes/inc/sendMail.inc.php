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

$module = Application::getModule(2);

$formulaire = isset($_POST['formulaire']) ? $_POST['formulaire'] : null;
$form = array();
parse_str($formulaire, $form);

$ds = DIRECTORY_SEPARATOR;
require_once INSTALL_DIR.$ds.$module.$ds.'inc/classes/classHermes.inc.php';
$Hermes = new Hermes();

$nbEnvois = $Hermes->sendMail($acronyme, $form);
$texte = sprintf('<strong>%d mails</strong> envoyés<br>', $nbEnvois);

$id = $Hermes->archiveMail($acronyme, $form);

if (isset($form['files'])) {
    $nbPJ = $Hermes->archivePJ($acronyme, $id, $form['files']);
    $texte .= sprintf('<strong>%d fichier(s)</strong> joint(s)<br>', $nbPJ);
}

if (isset($form['publier'])) {
    $nbNotifs = $Hermes->archiveDestinataires($id, $form['mails']);
    $texte .= sprintf('<strong>%d notifications</strong> envoyées', $nbNotifs);
}

echo $texte;
