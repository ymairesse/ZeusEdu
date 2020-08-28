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
require_once INSTALL_DIR.$ds.$module.$ds."inc/classes/classJdc.inc.php";
$Jdc = new Jdc();

require_once INSTALL_DIR.$ds.'inc/classes/classEcole.inc.php';
$Ecole = new Ecole();

require_once INSTALL_DIR.$ds.'inc/classes/classEleve.inc.php';

$formulaire = isset($_POST['formulaire']) ? $_POST['formulaire'] : Null;
parse_str($formulaire, $form);

require_once INSTALL_DIR.'/smarty/Smarty.class.php';
$smarty = new Smarty();
$smarty->template_dir = INSTALL_DIR.$ds.$module.$ds.'templates';
$smarty->compile_dir = INSTALL_DIR.$ds.$module.$ds.'templates_c';

$smarty->assign('module', $module);

$startDate =  $form['debut'];
$endDate =  $form['fin'];
$matricule = $form['matricule'];
$classe = $form['classe'];
$niveau = $form['niveau'];

$smarty->assign('matricule', $matricule);
$smarty->assign('classe', $classe);
$smarty->assign('niveau', $niveau);

$listeCategories = $form['idCategories'];

$DATE = $Application::dateNow();
$smarty->assign('ECOLE', ECOLE);
$smarty->assign('ADRESSE', ADRESSE);
$smarty->assign('TELEPHONE', TELEPHONE);
$smarty->assign('COMMUNE', COMMUNE);
$smarty->assign('DATE', $DATE);
$smarty->assign('ANNEESCOLAIRE', ANNEESCOLAIRE);
$smarty->assign('dateDebut', $startDate);
$smarty->assign('dateFin', $endDate);

if ($matricule != '') {
    $listeCoursGrp = $Ecole->listeCoursGrpEleve($matricule);
    // relire l'historique pour l'élève et fusionner avec la liste des coursGrp
    $historique = $Jdc->getHistorique($matricule, true);
    foreach ($historique as $coursGrp => $data) {
        $listeCoursGrp[$coursGrp] = $data;
        }
    $jdcDe = sprintf('%s %s %s', $identite['nom'], $identite['prenom'], $identite['classe']);
    $nomFichier = sprintf('JDC %s_%s_%d', $identite['nom'], $identite['prenom'], $identite['matricule']);
    }
    elseif ($classe != '') {
        $listeCoursGrp = $Ecole->listeCoursGrpClasse($classe);
        $jdcDe = sprintf('Classe %s', $classe);
        $nomFichier = sprintf('JDC %s', $classe);
        }
    else {
        $listeCoursGrp = $Ecole->listeCoursGrp($niveau);
        $jdcDe = sprintf('Niveau %de année', $niveau);
        }

$smarty->assign('jdcDe', $jdcDe);

$jdcExtract = $Jdc->jdcFromTo($startDate, $endDate, $listeCoursGrp, $listeCategories, ANNEESCOLAIRE);
$smarty->assign('jdcExtract', $jdcExtract);
$output = $smarty->fetch('jdc/jdcArchiveTxt.tpl');


$chemin = INSTALL_DIR.$ds.'upload'.$ds.$acronyme.$ds.$module.$ds;
// créer le répetoire s'il n'existe pas encore
if (!(file_exists($chemin))) {
    mkdir($chemin, 0700, true);
    }

$nomFichier = $jdcDe.'.html';
file_put_contents ($chemin.$ds.$nomFichier, $output);

$smarty->assign('nomFichier', $nomFichier);

$smarty->display('jdc/inc/trArchive.tpl');
