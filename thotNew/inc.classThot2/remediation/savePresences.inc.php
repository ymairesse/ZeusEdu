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
require_once INSTALL_DIR.$ds.$module.$ds.'inc/classes/class.remediation.inc.php';
$remediation = new Remediation();

$formulaire = isset($_POST['formulaire']) ? $_POST['formulaire'] : Null;

$form = array();
parse_str($formulaire, $form);

$idOffre = $form['idOffre'];

$listePresences = array();
foreach ($form as $field => $value) {
    $champ = explode('_', $field);
    if ($champ[0] == 'presence') {
        $matricule = $champ[1];
        $listePresences[$matricule] = $value;
    }
}

$remediation->savePresences($idOffre, $listePresences);

$listeInscrits = $remediation->getEleves($idOffre, $acronyme);

require_once INSTALL_DIR.'/smarty/Smarty.class.php';
$smarty = new Smarty();
$smarty->template_dir = INSTALL_DIR.$ds.$module.$ds.'templates';
$smarty->compile_dir = INSTALL_DIR.$ds.$module.$ds.'templates_c';

$smarty->assign('listeEleves', $listeInscrits);
$smarty->assign('idOffre', $idOffre);

$smarty->display('remediation/panelElevesInscrits.tpl');
