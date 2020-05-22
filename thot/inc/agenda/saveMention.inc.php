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
require_once INSTALL_DIR.$ds.$module.$ds."inc/classes/class.Agenda.php";
$Agenda = new Agenda();

$mention = isset($_POST['mention']) ? $_POST['mention'] : null;
$idCategorie = isset($_POST['idCategorie']) ? $_POST['idCategorie'] : null;
$ordre = isset($_POST['ordre']) ? $_POST['ordre'] : null;

$idCategorie = $Agenda->saveMention($mention, $idCategorie);

if ($ordre == Null){
    // mettre au dernier rang avec un ordre > plus grand
    $ordre = $Agenda->putOrdre4Categorie($idCategorie);
    }

echo $nb;
