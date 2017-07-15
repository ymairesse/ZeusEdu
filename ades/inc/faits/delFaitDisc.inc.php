<?php

require_once '../../../config.inc.php';

// définition de la class Application
require_once INSTALL_DIR.'/inc/classes/classApplication.inc.php';
$Application = new Application();

// répertoire du module actuel
$module = $Application->getModule(3);

// durée de validité pour les Cookies
$unAn = time() + 365 * 24 * 3600;

// définition de la class USER utilisée en variable de SESSION
require_once INSTALL_DIR.'/inc/classes/classUser.inc.php';

session_start();
if (!(isset($_SESSION[APPLICATION]))) {
    echo "<script type='text/javascript'>document.location.replace('".BASEDIR."');</script>";
    exit;
}

$idfait = isset($_POST['idfait']) ? $_POST['idfait'] : null;

require_once INSTALL_DIR."/$module/inc/classes/classAdes.inc.php";
$Ades = new Ades();

require_once INSTALL_DIR."/$module/inc/classes/classEleveAdes.inc.php";
$EleveAdes = new EleveAdes();

require_once INSTALL_DIR."/smarty/Smarty.class.php";
$smarty = new Smarty();
$smarty->template_dir = "../../templates";
$smarty->compile_dir = "../../templates_c";

$fait = $EleveAdes->lireUnFait($idfait);
$smarty->assign('fait', $fait);

$matricule = $fait['matricule'];

require_once INSTALL_DIR.'/inc/classes/classEleve.inc.php';
$Eleve = Eleve::staticGetDetailsEleve($matricule);
$smarty->assign('Eleve',$Eleve);


$type = $fait['type'];
// il faut connaître les caractéristiques de ce type de fait (couleurs,...)
$prototype = $Ades->prototypeFait($type);
$smarty->assign('prototype', $prototype);

$smarty->display('faitDisc/delFaitDisciplinaire.tpl');
