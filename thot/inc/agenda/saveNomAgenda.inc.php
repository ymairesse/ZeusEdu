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

$nomAgenda = isset($_POST['nomAgenda']) ? $_POST['nomAgenda'] : Null;
$idAgenda =  isset($_POST['idAgenda']) ? $_POST['idAgenda'] : Null;

if ($nomAgenda != Null){
    $ds = DIRECTORY_SEPARATOR;
    require_once INSTALL_DIR.$ds.$module.$ds."inc/classes/class.Agenda.php";
    $Agenda = new Agenda();

    if ($idAgenda == Null) {
        $idAgenda = $Agenda->createAgenda4user($acronyme, $nomAgenda);
    }
    else {
        $verifIdAgenda = $Agenda->verifIdAgendaProprio($idAgenda, $acronyme);
        if ($Agenda->verifIdAgendaProprio($idAgenda, $acronyme) > 0)
            $Agenda->saveNewName($idAgenda, $nomAgenda, $acronyme);
            else die('Cet agenda ne vous appartient pas');
    }

}

echo $idAgenda;
