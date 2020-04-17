<?php

require_once '../../../config.inc.php';

require_once INSTALL_DIR.'/inc/classes/classApplication.inc.php';
$Application = new Application();

// définition de la class USER utilisée en variable de SESSION
require_once INSTALL_DIR.'/inc/classes/classUser.inc.php';
session_start();

if (!(isset($_SESSION[APPLICATION]))) {
    die("<div class='alert alert-danger'>".RECONNECT.'</div>');
}

$User = $_SESSION[APPLICATION];
$acronyme = $User->getAcronyme();

$id = isset($_POST['id']) ? $_POST['id'] : null;
$raison = isset($_POST['raison']) ? $_POST['raison'] : null;

require_once INSTALL_DIR.'/inc/classes/classThot.inc.php';
$thot = new Thot();

// suppression effective du RV
$nb = $thot->delRV($id);

if ($nb != 0) {
    // avertir les parents de la suppression du RV
    $infoRV = $thot->getInfoRV($id);

    $date = $infoRV['date'];
    $heure = $infoRV['heure'];
    $mailParent = $infoRV['mail'];
    $abreviation = $infoRV['acronyme'];

    $nomParent = sprintf('%s %s %s', $infoRV['formule'], $infoRV['prenom'], $infoRV['nom']);
    $prof = User::identiteProf($abreviation);
    $nomProf = sprintf('%s %s', $prof['prenom'], $prof['nom']);

    // texte du mail d'annulation
    $texte = file_get_contents('../../templates/reunionParents/mail/texteAnnulation.tpl');
    $texte = str_replace('##nomparent##', $nomParent, $texte);
    $texte = str_replace('##date##', $date, $texte);
    $texte = str_replace('##heure##', $heure, $texte);
    $texte = str_replace('##raison##', $raison, $texte);
    $texte = str_replace('##nomprof##', $nomProf, $texte);

    $identiteProf = User::identiteProf($acronyme);
    $mailExpediteur = $identiteProf['mail'];
    $nomExpediteur = sprintf('%s. %s', substr($identiteProf['prenom'], 0, 1), $identiteProf['nom']);

    $objet = 'Annulation de rendez-vous '.ECOLE;

    // ajout de la signature
    $signature = file_get_contents('../../templates/reunionParents/mail/signature.tpl');
    $signature = str_replace('##expediteur##', $nomExpediteur, $signature);
    $signature = str_replace('##mailExpediteur##', $mailExpediteur, $signature);
    $texte .= $signature;

    // ajout du disclaimer
    $disclaimer = "<div style='font-size:small'><a href='".DISCLAIMER."'>Clause de non responsabilité</a></div>";
    $texte .= "<hr> $disclaimer";

    $mail = new PHPmailer();
    $mail->IsHTML(true);
    $mail->CharSet = 'UTF-8';
    $mail->From = $mailExpediteur;
    $mail->FromName = $nomExpediteur;

    // envoi du mail au parent
    $mail->AddAddress($mailParent, $nomParent);

    // envoyer le mail à l'expéditeur aussi
    $mail->AddBCC($mailExpediteur, $nomExpediteur);

    $mail->Subject = $objet;
    $mail->Body = $texte;

    $envoiMail = ($mail->Send());

    if ($envoiMail == false) {
        $resultat = array(
            'message' => 'Envoi de mail en échec',
            'reussite' => true,
            'mail' => false,
        );
    } else {
        $resultat = array(
            'message' => sprintf('Mail envoyé à %s', $mailParent),
            'reussite' => true,
            'mail' => true,
        );
    }
} else {
    $resultat = array(
            'message' => 'Le RV n\'a pas été supprimé',
            'reussite' => false,
            'mail' => false,
        );
}
echo json_encode($resultat);
