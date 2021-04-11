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

$raison = isset($_POST['raison']) ? $_POST['raison'] : Null;

$idRV = isset($_POST['idRV']) ? $_POST['idRV'] : Null;
$idRP = isset($_POST['idRP']) ? $_POST['idRP'] : Null;
$matricule = isset($_POST['matricule']) ? $_POST['matricule'] : Null;

require_once INSTALL_DIR.'/inc/classes/classThot.inc.php';
$Thot = new Thot();

$infoRV = $Thot->getInfoRV($idRV, $idRP);

$nb = $Thot->delRV($idRP, $idRV);

$mailOK = false;
if ($nb == 1) {
    $nomParent = sprintf('%s %s %s', $infoRV['formule'], $infoRV['prenomParent'], $infoRV['nomParent']);
    $mailParent = $infoRV['mail'];

    $prof = User::identiteProf($acronyme);
    $nomProf = sprintf('%s %s', $prof['prenom'], $prof['nom']);

    $texte = file_get_contents("../../templates/reunionParents/mail/texteAnnulation.tpl");

    // remplacement du textarea par la mention de la $raison de la suppression du RV
    $texte = preg_replace('#<textarea[^>]*>.*?</textarea>#si', '{$raison}', $texte);

    $texte = str_replace('{$nomParent}', $nomParent, $texte);
    $texte = str_replace('{$nomProf}', $nomProf, $texte);
    $texte = str_replace('{$infoRV.date}', $infoRV['date'], $texte);
    $texte = str_replace('{$infoRV.heure}', $infoRV['heure'], $texte);

    $mailExpediteur = $prof['mail'];

    $objet = 'Annulation de rendez-vous '.ECOLE;

    // ajout du disclaimer
    $disclaimer = "<div style='font-size:small'><a href='".DISCLAIMER."'>Clause de non responsabilité</a></div>";
    $texte .= "<hr> $disclaimer";

    require_once INSTALL_DIR.'/smarty/Smarty.class.php';
    $smarty = new Smarty();
    $smarty->template_dir = '../../templates';
    $smarty->compile_dir = '../../templates_c';

    $smarty->assign('nomParent', $nomParent);
    $smarty->assign('nomProf', $nomProf);
    $smarty->assign('infoRV', $infoRV);
    $smarty->assign('raison', $raison);

    $mail = new PHPmailer();
    $mail->IsHTML(true);
    $mail->CharSet = 'UTF-8';
    $mail->From = $mailExpediteur;
    $mail->FromName = $nomProf;

    // envoi du mail au parent
    $mail->AddAddress($mailParent, $nomParent);

    // envoyer le mail à l'expéditeur aussi
    $mail->AddBCC($mailExpediteur, $nomProf);

    $mail->Subject = $objet;
    $mail->Body = $texte;

    // true si le mail est parti
    $mailOK = $mail->Send();
    }

echo json_encode(array('nb' => $nb, 'mailOK' => $mailOK));
