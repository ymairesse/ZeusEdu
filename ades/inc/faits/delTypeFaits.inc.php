<?php

session_start();

require_once '../../../config.inc.php';
// définition de la class Application
require_once INSTALL_DIR.'/inc/classes/classApplication.inc.php';
$Application = new Application();

$module = $Application->getModule(3);

require_once INSTALL_DIR."/$module/inc/classes/classAdes.inc.php";
$Ades = new Ades();

$type = isset($_POST['type']) ? $_POST['type'] : null;

if ($type != null) {
    // suppression effective du fait de ce type
    $Ades->delTypeFaits($type);
    // réindexation des ordres par pas de 1 (pour éviter les trous)
    $Ades->reIndexTypesFAits();

    require_once INSTALL_DIR."/smarty/Smarty.class.php";
    $smarty = new Smarty();
    $smarty->template_dir = "../../templates";
    $smarty->compile_dir = "../../templates_c";

    // liste des types de faits existants
    $listeTypesFaits = $Ades->getListeTypesFaits();
    $smarty->assign('listeTypesFaits', $listeTypesFaits);

    // liste des faits inutilisés et qui peuvent donc être effacés.
    $listeInutiles = $Ades->getTypesFaitsInutilises();
    $smarty->assign('listeInutiles', $listeInutiles);

    echo $smarty->fetch('faitDisc/tableauFait.tpl');
}
