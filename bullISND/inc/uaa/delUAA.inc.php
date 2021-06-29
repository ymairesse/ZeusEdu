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

$formulaire = isset($_POST['formulaire']) ? $_POST['formulaire'] : null;
$form = array();
parse_str($formulaire, $form);

$ds = DIRECTORY_SEPARATOR;
require_once INSTALL_DIR.$ds.$module.'/inc/classes/classBulletin.inc.php';
$Bulletin = new Bulletin();

$listeUAA = $form['listeUAA'];
$listeRefus = array();
$listeOK = array();

foreach ($listeUAA as $wtf=>$idUAA) {
    $libelle = $Bulletin->getUAAformId($idUAA);;
    $usedUAA = $Bulletin->isUsedUAA($idUAA);
    if ($usedUAA)
        $listeRefus[$idUAA] = $libelle;
        else $listeOK[$idUAA] = $libelle;
    }

$nbDel = $Bulletin->delUAAlist(array_keys($listeOK));

$html = '';
if ($nbDel > 0) {
    $listeUAA = $Bulletin->getListeUAA();

    require_once INSTALL_DIR.'/smarty/Smarty.class.php';
    $smarty = new Smarty();
    $smarty->template_dir = '../../templates';
    $smarty->compile_dir = '../../templates_c';

    $smarty->assign('listeUAA', $listeUAA);
    $html = $smarty->fetch('uaa/selectUAA.tpl');
}

echo json_encode(array('nbDel' => $nbDel, 'nbRefus' => count($listeRefus), 'html' => $html));
