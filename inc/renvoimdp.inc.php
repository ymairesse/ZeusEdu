<?php
require_once("../config.inc.php");
// définition de la class Application
require_once (INSTALL_DIR."/inc/classes/classApplication.inc.php");
$Application = new Application();

require_once(INSTALL_DIR."/inc/classes/classUser.inc.php");

$acronyme = strtoupper(isset($_POST['acronyme'])?$_POST['acronyme']:Null);

// on tente de créer un utilisateur de ce nom; la création provoque une vérification dans la BD
$User = new user($acronyme);
// si l'utilisateur n'existe pas, l'identité est Null
$identite = $User->identite();

if ($identite != Null) {
    // si on a trouvé une identité, le mail est envoyé
    $identiteReseau = user::identification();
    if ($Application->renvoiMdp($identite,$identiteReseau)) {
        $message(array(
            'title'=>NEWPWD,
            'texte'=>'test',
            'urgence'=>success
        ));
        $smarty->assign('message',$message)
        }
    }
