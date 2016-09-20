<?php

require_once '../../../config.inc.php';

require_once '../../../inc/classes/classApplication.inc.php';
$Application = new Application();

require_once INSTALL_DIR.'/inc/classes/classUser.inc.php';
session_start();

// définition de la class USER utilisée en variable de SESSION
// require_once INSTALL_DIR.'/inc/classes/classUser.inc.php';
// session_start();
if (!(isset($_SESSION[APPLICATION]))) {
    die("<div class='alert alert-danger'>".RECONNECT.'</div>');
}

$User = $_SESSION[APPLICATION];
$acronyme = $User->getAcronyme();

$matricule = isset($_POST['matricule']) ? $_POST['matricule'] : null;

if ($matricule != null) {
    require_once INSTALL_DIR.'/inc/classes/classEleve.inc.php';
    $Eleve = new Eleve($matricule);
    $detailsEleve = $Eleve->getDetailsEleve();
    $dataPwd = $Eleve->getDataPwd();

    require_once INSTALL_DIR.'/smarty/Smarty.class.php';
    $smarty = new Smarty();
    $smarty->template_dir = '../../templates';
    $smarty->compile_dir = '../../templates_c';
    $smarty->assign('detailsEleve', $detailsEleve);
    $smarty->assign('dataPwd', $dataPwd);
    $smarty->assign('type', 'eleve');
    $smarty->assign('noPage', 0);

    $pwd4PDF = $smarty->fetch('eleves/pwd2pdf.tpl');
    require_once INSTALL_DIR.'/html2pdf/html2pdf.class.php';
    $html2pdf = new HTML2PDF('P', 'A4', 'fr');
    $html2pdf->WriteHTML($pwd4PDF);
    $nomFichier = sprintf('pwd_%s.pdf', $matricule);


    $ds = DIRECTORY_SEPARATOR;
    // création éventuelle du répertoire au nom de l'utlilisateur
    $chemin = INSTALL_DIR.$ds."upload".$ds.$acronyme.$ds."pwd";
    if (!(file_exists($chemin))) {
        mkdir(INSTALL_DIR.$ds."upload".$ds.$acronyme.$ds."pwd", 0700, true);
    }

    $html2pdf->Output($chemin.$ds.$nomFichier, 'F');

    $smarty->assign('nomFichier', $nomFichier);
    $smarty->assign('acronyme', $acronyme);
    $smarty->assign('photo', $detailsEleve['photo']);
    echo $smarty->fetch('eleves/docPwd.tpl');

}
