<?php

require_once '../../../config.inc.php';

require_once INSTALL_DIR.'/inc/classes/classApplication.inc.php';
$Application = new Application();

$module = $Application->getModule(3);

$ds = DIRECTORY_SEPARATOR;
require_once INSTALL_DIR.'/inc/classes/classEcole.inc.php';
$Ecole = new Ecole();

require_once INSTALL_DIR.$ds.$module.$ds.'inc/classes/classPresences.inc.php';
$Presences = new Presences();

require_once(INSTALL_DIR."/smarty/Smarty.class.php");
$smarty = new Smarty();
$smarty->template_dir = INSTALL_DIR.$ds.$module.$ds."templates";
$smarty->compile_dir = INSTALL_DIR.$ds.$module.$ds."templates_c";

$smarty->assign('ECOLE', ECOLE);
$smarty->assign('ADRESSE', ADRESSE);
$smarty->assign('TELEPHONE', TELEPHONE);
$smarty->assign('COMMUNE', COMMUNE);
$smarty->assign('DATE', $Application->dateNow());
$smarty->assign('BASEDIR', BASEDIR);

define('PAGEWIDTH', 600);

require_once INSTALL_DIR.$ds.'html2PDF/vendor/autoload.php';

use Spipu\Html2Pdf\Html2Pdf;
use Spipu\Html2Pdf\Exception\Html2PdfException;
use Spipu\Html2Pdf\Exception\ExceptionFormatter;

$html2pdf = new \Spipu\Html2Pdf\Html2Pdf('L', 'A5', 'fr');

foreach ($_POST['toPrint'] as $data) {

    if ($data != '') {
        $item = explode('_', $data);
        $matricule = $item[0];
        $idTraitement = $item[1];

        $dataEleve = $Ecole->nomPrenomClasse($matricule);

        $datesSanction = $Presences->getDatesSanction4idTraitement($idTraitement);
        $datesRetards = $Presences->getDatesRetards4idTraitement($idTraitement);
        $dataTraitement = $Presences->getDataTraitement($idTraitement);

        $smarty->assign('dataEleve', $dataEleve);
        $smarty->assign('datesRetards', $datesRetards);
        $smarty->assign('datesSanction', $datesSanction);
        $smarty->assign('idTraitement', sprintf('%08d',$idTraitement));
        $smarty->assign('dataTraitement', $dataTraitement);

        $billet4PDF = $smarty->fetch('retards/billetRetard4PDF.tpl');
        $html2pdf->writeHTML($billet4PDF);

        $nb = $Presences->incrementPrint($idTraitement);
    }
}

$html2pdf->output('FicheRetard.pdf','D');
