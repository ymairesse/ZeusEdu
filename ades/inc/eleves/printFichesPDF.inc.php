<?php

require_once(INSTALL_DIR."/smarty/Smarty.class.php");
$smarty = new Smarty();
$smarty->template_dir = "../templates";
$smarty->compile_dir = "../templates_c";

$listeChamps = $Ades->lireDescriptionChamps();

// description de chacun des types de faits
$listeTypesFaits = $Ades->listeTypesFaits();
$listeFaits = $Ades->fichesDisciplinaires($listeEleves, $debut, $fin);

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
        $ficheEleve4PDF = $smarty->fetch('templates/eleve/fichesDiscipline4PDF.tpl');
        $html2pdf->WriteHTML($ficheEleve4PDF);

    }
}

$html2pdf->Output($groupe.'.pdf');
