<?php

require_once '../../config.inc.php';

// définition de la class Application
require_once INSTALL_DIR.'/inc/classes/classApplication.inc.php';
$Application = new Application();


// définition de la class USER utilisée en variable de SESSION
require_once INSTALL_DIR.'/inc/classes/classUser.inc.php';
session_start();

if (!(isset($_SESSION[APPLICATION]))) {
    die("<div class='alert alert-danger'>Votre session a expiré. Veuillez vous reconnecter.</div>");
}
$User = $_SESSION[APPLICATION];

$post['acronyme'] = $User->getAcronyme();
$post['email'] = isset($_POST['email']) ? $_POST['email'] : null;
$post['adresse'] = isset($_POST['adresse']) ? $_POST['adresse'] : null;
$post['codePostal'] = isset($_POST['codePostal']) ? $_POST['codePostal'] : null;
$post['commune'] = isset($_POST['commune']) ? $_POST['commune'] : null;
$post['pays'] = isset($_POST['pays']) ? $_POST['pays'] : null;
$post['titre'] = isset($_POST['titre']) ? $_POST['titre'] : null;
$post['telephone'] = isset($_POST['telephone']) ? $_POST['telephone'] : null;
$post['GSM'] = isset($_POST['GSM']) ? $_POST['GSM'] : null;

$nbModif = $User->modifDataPerso($post);;

require_once INSTALL_DIR.'/smarty/Smarty.class.php';
$smarty = new Smarty();
$smarty->template_dir = '../templates';
$smarty->compile_dir = '../templates_c';

$smarty->assign('identite', $User->identite(true));
echo $smarty->fetch('dataContact.tpl');
