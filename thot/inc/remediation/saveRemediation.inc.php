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

$idOffre = $remediation->saveRemediation($form, $acronyme);

if ($form['idClone'] != '') {
    $remediation->cloneGroupesRemediation($idOffre, $form['idClone'], $acronyme);
    $remediation->cloneElevesRemediation($idOffre, $form['idClone'], $acronyme);
    }

echo json_encode(array(
        'idOffre' => $idOffre,
        'message' => sprintf("L'offre de remédiation <strong>%s</strong> a été enregistrée", $form['title']))
    );
