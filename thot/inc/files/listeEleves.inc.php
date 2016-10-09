<?php

require_once '../../../config.inc.php';

require_once INSTALL_DIR.'/inc/classes/classApplication.inc.php';
$Application = new Application();

require_once INSTALL_DIR.'/inc/classes/classEcole.inc.php';
$Ecole = new Ecole();

$classe = isset($_POST['classe']) ? $_POST['classe'] : null;
$coursGrp = isset($_POST['coursGrp']) ? $_POST['coursGrp'] : null;

if ($classe != null) {
    $listeEleves = $Ecole->listeElevesClasse($classe);
} elseif ($coursGrp != null) {
        $listeEleves = $Ecole->listeElevesCours($coursGrp);
    } else {
            $listeEleves = null;
        }

require_once INSTALL_DIR.'/smarty/Smarty.class.php';
$smarty = new Smarty();
$smarty->template_dir = '../../templates';
$smarty->compile_dir = '../../templates_c';

$smarty->assign('listeEleves', $listeEleves);

echo $smarty->fetch('files/listeEleves.tpl');
