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

$matricule = isset($_POST['matricule']) ? $_POST['matricule'] : null;
$formulaire = isset($_POST['formulaire']) ? $_POST['formulaire'] : null;
$form = array();
parse_str($formulaire, $form);

require_once INSTALL_DIR.'/inc/classes/classEleve.inc.php';
$elv = Eleve::staticGetDetailsEleve($matricule);

$coteAbs = explode(',', COTEABS);
$coteNulle = explode(',', COTENULLE);

// création d'un tableau de la liste des cotes pour le travail
$listeCotes = array();
foreach ($form as $field => $value) {
    $champ = explode('_',$field);
    if ($champ[0] == 'cote') {
        $id = $champ[1];
        $listeCotes[$id]['cote'] = Application::sansVirg($value);
    }
    if ($champ[0] == 'max') {
        $id = $champ[1];
        $listeCotes[$id]['max'] = Application::sansVirg($value);
    }
}

// totalisation des cotes par compétence pour le travail
$total = array('cote'=> Null, 'max' => Null);
foreach ($listeCotes as $id => $evaluation) {
    if (is_numeric($evaluation['max'])) {
        if (is_numeric($evaluation['cote'])) {
            $total['cote'] += (float) $evaluation['cote'];
            $total['max'] += (float) $evaluation['max'];
        }
        else if (in_array($evaluation['cote'], $coteNulle)){
            // juste pour ne plus avoir Null dans $total['cote']
            $total['cote'] += 0;
            $total['max'] += (float) $evaluation['max'];
        }
    }
}

if ($total['max'] != '')
    echo sprintf("%s - %s %s [%s / %s]", $elv['classe'], $elv['nom'], $elv['prenom'], $total['cote'], $total['max']);
    else echo sprintf("%s - %s %s", $elv['classe'], $elv['nom'], $elv['prenom']);
