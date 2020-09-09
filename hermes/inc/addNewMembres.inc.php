<?php

require_once '../../config.inc.php';

require_once '../../inc/classes/classApplication.inc.php';
$Application = new Application();

require_once INSTALL_DIR.'/inc/classes/classUser.inc.php';
session_start();

if (!(isset($_SESSION[APPLICATION]))) {
    die("<div class='alert alert-danger'>Votre session a expiré. Veuillez vous reconnecter.</div>");
}

$module = $Application->getModule(2);

$ds = DIRECTORY_SEPARATOR;
require_once INSTALL_DIR.$ds.$module.$ds."inc/classes/classHermes.inc.php";
$Hermes = new hermes();

$User = $_SESSION[APPLICATION];
$acronyme = $User->getAcronyme();

$idListe = isset($_POST['idListe']) ? $_POST['idListe'] : Null;

$formulaire = isset($_POST['formulaire']) ? $_POST['formulaire'] : Null;
$form = array();
parse_str($formulaire, $form);

$listeAcronymes = $form['mails'];

$nb = $Hermes->addMembresListe($idListe, $listeAcronymes);

echo $nb;
