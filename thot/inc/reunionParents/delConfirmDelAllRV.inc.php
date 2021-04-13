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

$idRP = isset($_POST['idRP']) ? $_POST['idRP'] : Null;
$raison = isset($_POST['raison']) ? $_POST['raison'] : Null;

require_once(INSTALL_DIR.'/inc/classes/classThot.inc.php');
$Thot = new Thot();

$prof = User::identiteProf($acronyme);

$formule = ($prof['sexe'] == 'M') ? 'Monsieur' : 'Madame';
$initiale = mb_substr($prof['prenom'], 0, 1);
$nomProf = sprintf('%s %s. %s', $formule, $initiale, $prof['nom']);
$mailExpediteur = $prof['mail'];

$liste = $Thot->getRVprof($acronyme, $idRP);
$listeRV = array();
foreach ($liste as $idRV => $data) {
    if ($data['dispo'] == 0)
        $listeRV[$idRV] = $data;
    }

$texte = file_get_contents("../../templates/reunionParents/mail/texteAnnulation.tpl");
// remplacement du textarea par la mention de la $raison de la suppression du RV
$texte = preg_replace('#<textarea[^>]*>.*?</textarea>#si', '{$raison}', $texte);
// ajout du disclaimer
$disclaimer = "<div style='font-size:small'><a href='".DISCLAIMER."'>Clause de non responsabilité</a></div>";
$texte .= "<hr> $disclaimer";

$objet = 'Annulation de rendez-vous '.ECOLE;

$mail = new PHPmailer();
$mail->IsHTML(true);
$mail->CharSet = 'UTF-8';
$mail->From = $mailExpediteur;
$mail->FromName = $nomProf;

$nbMails = 0; $nbDel = 0;
foreach ($listeRV as $idRV => $infoRV) {
    $formule = $infoRV['formule'];
    $nomParent = $infoRV['nomParent'];
    $prenomParent = $infoRV['prenomParent'];
    $nomParent = sprintf('%s %s %s', $formule, $prenomParent, $nomParent);
    $mailParent = $infoRV['mail'];

    $info = $Thot->getInfoRV($idRV, $idRP);

    $texteMail = str_replace('{$nomParent}', $nomParent, $texte);
    $texteMail = str_replace('{$nomProf}', $nomProf, $texteMail);
    $texteMail = str_replace('{$infoRV.date}', $info['date'], $texteMail);
    $texteMail = str_replace('{$infoRV.heure}', $info['heure'], $texteMail);
    $texteMail = str_replace('{$raison}', $raison, $texteMail);
    $texteMail = str_replace('{$signature}', $nomProf, $texteMail);

    $mail->AddAddress($mailParent, $nomParent);

    $mail->Subject = $objet;
    $mail->Body = $texteMail;

    if ($mail->Send())
        $nbMails++;

    $nbDel = $Thot->delRV($idRP, $idRV);

    $mail->ClearAllRecipients();
}

echo json_encode(array('nbDel' => $nbDel, 'nbMails' => $nbMails));
