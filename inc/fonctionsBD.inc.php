<?php
/* ---------------------------------------
/* D E P R E C A T E D 
/* ---------------------------------------
/*
 * function connectPDO
 * @param PARAM_HOST, PARAM_BD, PARAM_USER, PARAM_PWD
 */
/* function connectPDO ($PARAM_HOST, $PARAM_BD, $PARAM_USER, $PARAM_PWD) {
	try {
		// indiquer que les requêtes sont transmises en UTF8
		// INDISPENSABLE POUR EVITER LES PROBLEMES DE CARACTERES ACCENTUES
        $connexion = new PDO('mysql:host='.$PARAM_HOST.';dbname='.$PARAM_BD, $PARAM_USER, $PARAM_PWD,
							array(PDO::MYSQL_ATTR_INIT_COMMAND => "SET NAMES utf8"));
		}
	catch(Exception $e)	{
        die ("Une erreur est survenue lors de l'ouverture de la base de données");
	}
    return $connexion;
}
*/
/*
 * function deconnexionPDO
 * @param $connexion
 */
 /*
function deconnexionPDO ($connexion) {
    $connexion = Null;
    }
*/



?>
