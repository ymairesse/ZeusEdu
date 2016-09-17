<?php

function executeQueryFile($filesql) {
    $query = file_get_contents($filesql);
    $array = explode(";\n", $query);
    $b = true;
    for ($i=0; $i < count($array) ; $i++) {
        $str = $array[$i];
        if ($str != '') {
             $str .= ';';
             $b &= mysql_query($str);
        }
    }

    return $b;
}

function connectPDO ($host, $bd, $user, $mdp) {
    try {
        // indiquer que les requêtes sont transmises en UTF8
        // INDISPENSABLE POUR EVITER LES PROBLEMES DE CARACTERES ACCENTUES
        $connexion = new PDO('mysql:host='.$host.';dbname='.$bd, $user, $mdp,
                            array(PDO::MYSQL_ATTR_INIT_COMMAND => "SET NAMES utf8"));
        }
    catch(Exception $e)	{
        $date = date("d/m/Y H:i:s");
        echo "<style type='text/css'>";
        echo ".erreurBD {width: 500px; margin-left: auto; margin-right: auto; border: 1px solid red; padding: 1em;}";
        echo ".erreurBD .erreur {color: green; font-weight: bold}";
        echo "</style>";

        echo ("<div class='erreurBD'>");
        echo ("<h3>A&iuml;e, a&iuml;e, a&iuml;e... Caramba...</h3>");
        echo ("<p>Une erreur est survenue lors de l'ouverture de la base de donn&eacute;es.<br>");
        echo ("Si vous &ecirc;tes l'administrateur et que vous tentez d'installer le logiciel, veuillez v&eacute;rifier le fichier config.inc.php </p>");
        echo ("<p>Si le probl&egrave;me se produit durant l'utilisation r&eacute;guli&egrave;re du programme, essayez de rafra&icirc;chir la page (<span style='color: red;'>touche F5</span>)<br>");
        echo ("Dans ce cas, <strong>vous n'&ecirc;tes pour rien dans l'apparition du souci</strong>: le serveur de base de donn&eacute;es est sans doute trop sollicit&eacute;...</p>");
        echo ("<p>Veuillez rapporter le message d'erreur ci-dessous &agrave; l'administrateur du syst&egrave;me.</p>");
        echo ("<p class='erreur'>Le $date, le serveur dit: ".$e->getMessage()."</p>");
        echo ("</div>");
        // print_r(array($host,$bd,$user,$mdp));
        die();
    }
    return $connexion;
}

/***
 * Déconnecte la base de données
 * @param $connexion
 * @return void()
 */
function DeconnexionPDO ($connexion) {
    $connexion = Null;
    }
