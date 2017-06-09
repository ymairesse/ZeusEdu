<?php

require_once '../../../config.inc.php';

// définition de la class Application
require_once INSTALL_DIR.'/inc/classes/classApplication.inc.php';
$Application = new Application();

$module = $Application->getModule(3);

require_once INSTALL_DIR."/$module/inc/classes/classAdes.inc.php";
$Ades = new Ades();

$type = isset($_POST['type'])?$_POST['type']: null;
$sens = isset($_POST['sens'])?$_POST['sens']: null;

if (isset($type)) {
    $fait = $Ades->getFaitByType($type);
    $ordre = $fait['ordre'];
    if ($sens == 'up') {
        $ordre = $ordre-1;
        $echange = $Ades->getFaitByOrdre($ordre);
    }
    else {
        $ordre = $ordre+1;
        $echange = $Ades->getFaitByOrdre($ordre);
        }
    $Ades->echanger($fait, $echange);
}

require_once INSTALL_DIR."/smarty/Smarty.class.php";
$smarty = new Smarty();
$smarty->template_dir = "../../templates";
$smarty->compile_dir = "../../templates_c";

$listeTypesFaits = $Ades->getListeTypesFaits();
$listeInutiles = $Ades->getTypesFaitsInutilises();

$smarty->assign('listeTypesFaits', $listeTypesFaits);
$smarty->assign('listeInutiles', $listeInutiles);

$smarty->display('faitDisc/tableauFait.tpl');
