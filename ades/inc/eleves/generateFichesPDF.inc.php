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

require_once INSTALL_DIR.'/inc/classes/classEcole.inc.php';
$Ecole = new Ecole();

$module = $Application->getModule(3);
require_once INSTALL_DIR."/$module/inc/classes/classAdes.inc.php";
$Ades = new Ades();

$debut = isset($_POST['debut']) ? $_POST['debut'] : null;
$fin = isset($_POST['fin']) ? $_POST['fin'] : null;
$niveau = isset($_POST['niveau']) ? $_POST['niveau'] : null;
$classe = isset($_POST['classe']) ? $_POST['classe'] : null;
$matricule = isset($_POST['matricule']) ? $_POST['matricule'] : null;

// génération pour un élève isolé, une classe ou le niveau d'étude
if ($matricule == Null) {
    if ($classe == Null) {
        $groupe = sprintf('Niveau %d e', $niveau);
        }
        else {
            $groupe = 'Classe '.$classe;
        }
    }
    else {
        $eleve = Eleve::staticGetDetailsEleve($matricule);
        $groupe = $eleve['nom'].' '.$eleve['prenom'];
    }

// liste de tous les champs existants
$listeChamps = $Ades->lireDescriptionChamps();
// description de chacun des types de faits
$listeTypesFaits = $Ades->listeTypesFaits();
$listeEleves = $Ecole->listeEleves($classe, 'groupe');
$listeFaits = $Ades->fichesDisciplinaires($listeEleves, $debut, $fin);

require_once(INSTALL_DIR."/smarty/Smarty.class.php");
$smarty = new Smarty();
$smarty->template_dir = "../templates";
$smarty->compile_dir = "../templates_c";

$smarty->assign('ECOLE', ECOLE);
$smarty->assign('ADRESSE', ADRESSE);
$smarty->assign('TELEPHONE', TELEPHONE);
$smarty->assign('COMMUNE', COMMUNE);
$smarty->assign('DATE', $Application->dateNow());
$smarty->assign('ANNEESCOLAIRE', ANNEESCOLAIRE);
// pour retrouver la photo de l'élève
$smarty->assign('BASEDIR', BASEDIR);

define('PAGEWIDTH', 600);
$echelles = $Ades->fieldWidth(PAGEWIDTH, $listeTypesFaits, $listeChamps);
$smarty->assign('echelles', $echelles);
$smarty->assign('contexte', 'tableau');
$smarty->assign('listeTypesFaits', $listeTypesFaits);
$smarty->assign('listeChamps', $listeChamps);
$smarty->assign('listeFaits', $listeFaits);

require_once INSTALL_DIR.'/html2pdf/html2pdf.class.php';
$html2pdf = new Html2PDF('P', 'A4', 'fr');
foreach ($listeFaits as $classe => $listeFaitsParEleves) {
    $smarty->assign('listeFaitsParEleves', $listeFaitsParEleves);
    foreach ($listeFaitsParEleves as $matricule => $lesFaits) {
        $smarty->assign('lesFaits', $lesFaits);
        $Eleve = $listeEleves[$matricule];
        $smarty->assign('Eleve', $Eleve);
        $listeRetenues = $Ades->getListeRetenues($matricule);
        $smarty->assign('listeRetenues', $listeRetenues);
        $ficheEleve4PDF = $smarty->fetch('../../templates/eleve/fichesDiscipline4PDF.tpl');
        $html2pdf->WriteHTML($ficheEleve4PDF);
    }
}

$ds = DIRECTORY_SEPARATOR;
$nomFichier = sprintf('discipline_%s.pdf', $groupe);

// création éventuelle du répertoire au nom de l'utlilisateur
$chemin = INSTALL_DIR."/upload/$acronyme/$module/";
if (!(file_exists($chemin))) {
    mkdir(INSTALL_DIR."/upload/$acronyme/$module/", 0700, true);
}

$html2pdf->Output($chemin.$nomFichier, 'F');

$smarty->assign('nomFichier', $module.$ds.$nomFichier);
$link = $smarty->fetch('../../templates/lienDocument.tpl');
echo $link;
