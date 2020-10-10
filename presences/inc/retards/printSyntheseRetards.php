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

$debut = Application::dateMySql($_POST['debut']);
$fin = Application::dateMySql($_POST['fin']);
$niveau = isset($_POST['niveau']) ? $_POST['niveau'] : Null;
$classe = isset($_POST['classe']) ? $_POST['classe'] : Null;
$matricule = isset($_POST['matricule']) ? $_POST['matricule'] : Null;

require_once INSTALL_DIR.'/inc/classes/classEcole.inc.php';
$Ecole = new Ecole();

$ds = DIRECTORY_SEPARATOR;
require_once INSTALL_DIR.$ds.$module.$ds.'inc/classes/classPresences.inc.php';
$Presences = new Presences();

require_once INSTALL_DIR."/smarty/Smarty.class.php";
$smarty = new Smarty();
$smarty->template_dir = INSTALL_DIR.$ds.$module.$ds.'templates';
$smarty->compile_dir = INSTALL_DIR.$ds.$module.$ds.'templates_c';

// renvoie la liste des retards durant une période pour un niveau d'étude, une classe ou un élève
$listeRetards = $Presences->getListeSyntheseRetards($debut, $fin, $niveau, $classe, $matricule);

if ($matricule != Null) {
    $listeEleves = array($matricule);
    $groupe = "Un élève";
    }
    else if ($classe != Null) {
            $listeEleves = array_keys($Ecole->listeElevesClasse($classe));
            $groupe = sprintf("Classe %s",$classe);
            }
            else if ($niveau != Null){
                    $listeEleves = array_keys($Ecole->listeElevesNiveaux($niveau));
                    $groupe = sprintf("Niveau %ue année", $niveau);
                    }
                    else {
                        $listeEleves = array_keys($Ecole->listeElevesEcole());
                        $groupe = "Tous les élèves";
                    }

$allRetards = $Presences->getAllRetards($listeEleves);

$smarty->assign('debut', Application::datePHP($debut));
$smarty->assign('fin', Application::datePHP($fin));


$smarty->assign('listeRetards', $listeRetards);
$smarty->assign('allRetards', $allRetards);
$smarty->assign('groupe', $groupe);
$smarty->assign('acronyme', $acronyme);

$html = $smarty->fetch('retards/syntheseRetards4PDF.tpl');

$ds = DIRECTORY_SEPARATOR;

require INSTALL_DIR.'/vendor/autoload.php';
use Spipu\Html2Pdf\Html2Pdf;

$html2pdf = new Html2Pdf('P', 'A4', 'fr');

$html2pdf->writeHTML($html);

$date = date("d-m-Y H i");

$html2pdf->Output('syntheseRetards_'.$date.'.pdf');
