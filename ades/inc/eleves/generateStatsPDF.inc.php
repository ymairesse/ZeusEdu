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

require_once INSTALL_DIR.'/inc/classes/classEleve.inc.php';

$module = $Application->getModule(3);
require_once INSTALL_DIR."/$module/inc/classes/classAdes.inc.php";
$Ades = new Ades();

$formulaire = isset($_POST['formulaire']) ? $_POST['formulaire'] : null;
$form = array();
parse_str($formulaire, $form);

$debut = $form['debut'];
$fin = $form['fin'];
$matricule = isset($form['matricule']) ? $form['matricule'] : null;
$niveau = isset($form['niveau']) ? $form['niveau'] : null;
$classe = isset($form['classe']) ? $form['classe'] : null;

// détermination des types de faits à imprimer
$aImprimer = array();
foreach ($form AS $field => $value) {
    if (substr($field, 0, 4) == 'type') {
        $typeFait = explode('_', $field);
        $aImprimer[$typeFait[1]] = 1;
    }
}

// génération pour un élève isolé, une classe ou le niveau d'étude
if ($matricule == Null) {
    if ($classe == Null) {
        $listeEleves = $listeEleves = $Ecole->listeElevesNiveaux($niveau);
        $groupe = sprintf('Niveau %d e', $niveau);
        }
        else {
            $listeEleves = $Ecole->listeEleves($classe, 'groupe');
            $groupe = 'Classe '.$classe;
        }
    }
    else {
        $eleve = Eleve::staticGetDetailsEleve($matricule);
        $listeEleves = array($matricule => $eleve);
        $groupe = $eleve['nom'].' '.$eleve['prenom'];
    }

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

define('PAGEWIDTH', 600);

$statistiques = $Ades->statistiques($listeEleves, $debut, $fin, $aImprimer);

$ds = DIRECTORY_SEPARATOR;
require INSTALL_DIR.'/vendor/autoload.php';
use Spipu\Html2Pdf\Html2Pdf;

$html2pdf = new Html2Pdf('P', 'A4', 'fr');

$smarty->assign('debut', $debut);
$smarty->assign('fin', $fin);
$smarty->assign('groupe', $groupe);
$smarty->assign('statistiques', $statistiques);

$ficheStats4PDF = $smarty->fetch('../../templates/eleve/statistiques4PDF.tpl');
$html2pdf->WriteHTML($ficheStats4PDF);

$nomFichier = sprintf('stats_%s.pdf', $groupe);

// création éventuelle du répertoire au nom de l'utlilisateur
$chemin = INSTALL_DIR."/upload/$acronyme/$module/";
if (!(file_exists($chemin))) {
    mkdir(INSTALL_DIR."/upload/$acronyme/$module/", 0700, true);
}

$html2pdf->Output($chemin.$nomFichier, 'F');

$smarty->assign('nomFichier', $module.$ds.$nomFichier);
$link = $smarty->fetch('../../templates/lienDocument.tpl');
echo $link;
