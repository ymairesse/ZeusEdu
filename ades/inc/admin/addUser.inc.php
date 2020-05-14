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

// l'identifiant de l'utilisateur à modifier
$utilisateur = isset($_POST['utilisateur']) ? $_POST['utilisateur'] : null;
$statut = isset($_POST['statut']) ? $_POST['statut'] : null;

$ds = DIRECTORY_SEPARATOR;
require_once INSTALL_DIR.$ds.$module.$ds.'inc/classes/classAdes.inc.php';
$Ades = new Ades();

// ne pas modifier l'utilisateur actif
if (($utilisateur != $acronyme) && ($statut != '')) {
    $nb = $Application->changeStatut($utilisateur, $module, $statut);

    if ($nb > 0) {
        require_once(INSTALL_DIR."/smarty/Smarty.class.php");
        $smarty = new Smarty();
        $smarty->template_dir = INSTALL_DIR.$ds.$module.$ds."templates";
        $smarty->compile_dir = INSTALL_DIR.$ds.$module.$ds."templates_c";

        $adesUsersList = $Ades->adesUsersList($module);
        $listeStatuts = $Application->listeStatuts();
        $smarty->assign('listeStatuts', $listeStatuts);
        $smarty->assign('usersList', $adesUsersList);
        $smarty->assign('acronyme', $acronyme);

        $smarty->display('admin/tableUsersList.tpl');
    }
}
