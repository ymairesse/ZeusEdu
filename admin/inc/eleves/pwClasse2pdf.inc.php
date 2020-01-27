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

$classe = isset($_POST['classe']) ? $_POST['classe'] : null;

if ($classe != null) {
    require_once INSTALL_DIR.'/inc/classes/classEleve.inc.php';
    require_once INSTALL_DIR.'/inc/classes/classEcole.inc.php';
    $Ecole = new Ecole();

    require_once INSTALL_DIR.'/smarty/Smarty.class.php';
    $smarty = new Smarty();
    $smarty->template_dir = '../../templates';
    $smarty->compile_dir = '../../templates_c';

    require_once INSTALL_DIR.'/html2pdf/html2pdf.class.php';
    $html2pdf = new HTML2PDF('P', 'A4', 'fr');

    $listeEleves = $Ecole->listeEleves($classe, 'groupe', false);
    $noPage = 1;
    foreach ($listeEleves as $matricule=>$dataEleve) {
        $detailsEleve = Eleve::staticGetDetailsEleve($matricule);
        $dataPwd = Eleve::staticGetDataPwd($matricule);
        $smarty->assign('detailsEleve', $detailsEleve);
        $smarty->assign('dataPwd', $dataPwd);
        $smarty->assign('classe', $detailsEleve['groupe']);
        $smarty->assign('noPage', $noPage);

        $smarty->assign('type', 'classe');

        $pwd4PDF = $smarty->fetch('eleves/pwd2pdf.tpl');

        $html2pdf->WriteHTML($pwd4PDF);
        $noPage++;
        }

    $nomFichier = sprintf('pwd_%s.pdf', $classe);

    $ds = DIRECTORY_SEPARATOR;
    // création éventuelle du répertoire au nom de l'utlilisateur
    $chemin = INSTALL_DIR.$ds."upload".$ds.$acronyme.$ds."pwd";
    if (!(file_exists($chemin))) {
        mkdir(INSTALL_DIR.$ds."upload".$ds.$acronyme.$ds."pwd", 0700, true);
    }

    $html2pdf->Output($chemin.$ds.$nomFichier, 'F');

    $smarty->assign('nomFichier', $nomFichier);
    $smarty->assign('acronyme', $acronyme);
    $smarty->assign('classe', $classe);

    echo $smarty->fetch('eleves/docPwdClasse.tpl');



}
