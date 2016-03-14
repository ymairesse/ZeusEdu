<?php

require_once '../config.inc.php';

require_once INSTALL_DIR.'/smarty/Smarty.class.php';
$smarty = new Smarty();
// ----------------------------------------------------------------------------
//

require_once 'inc/fonctions.inc.php';

$connexion = connectPDO(SERVEUR, BASE, NOM, MDP);

$query = file_get_contents('ZeusEdu.sql');
$array = explode(";\n", $query);
$nb = 0;

for ($i = 0; $i < count($array); ++$i) {
    $str = $array[$i];
    if ($str != '') {
        $str .= ';';

        $resultat = $connexion->query($str);
        if ($resultat) {
            ++$nb;
            }
        }
    }

deconnexionPDO($connexion);

$smarty->assign('nb', $nb);
$smarty->assign('SERVEUR', SERVEUR);
$smarty->assign('BASE', BASE);
$smarty->assign('NOM', NOM);
$smarty->assign('MDP', MDP);

//
// ----------------------------------------------------------------------------

$smarty->display('index.tpl');
