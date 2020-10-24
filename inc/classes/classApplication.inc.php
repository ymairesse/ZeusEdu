<?php

require_once INSTALL_DIR.'/phpMailer/class.phpmailer.php';

class Application
{
    public function __construct()
    {
        self::lireConstantes();
        // sorties PHP en français
        setlocale(LC_ALL, 'fr_FR.utf8');
    }

    /**
     * function lireConstantes.
     *
     * @param
     *
     * @return : retourne les constantes globales pour toutes les applis
     */
    public static function lireConstantes()
    {
        // lecture des paramètres généraux dans le fichier .ini, y compris la constante "PFX"
        $constantes = parse_ini_file(INSTALL_DIR.'/config.ini');
        foreach ($constantes as $key => $value) {
            define("$key", $value);
        }

        // lecture dans la table PFX."config" de la BD
        $connexion = self::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT parametre, valeur ';
        $sql .= 'FROM '.PFX.'config ';
        $resultat = $connexion->query($sql);
        if ($resultat) {
            while ($ligne = $resultat->fetch()) {
                $key = $ligne['parametre'];
                $valeur = $ligne['valeur'];
                define("$key", $valeur);
            }
        } else {
            die('config table not present');
        }
        self::DeconnexionPDO($connexion);
    }

    /**
     * suppression de tous les échappements automatiques dans le tableau passé en argument.
     *
     * @param $tableau
     *
     * @return array
     */
    private function Normaliser($tableau)
    {
        foreach ($tableau as $clef => $valeur) {
            if (!is_array($valeur)) {
                $tableau [$clef] = stripslashes($valeur);
            } else {
                // appel récursif
                $tableau [$clef] = self::Normaliser($valeur);
            }
        }

        return $tableau;
    }

    /**
     * passer en revue toutes les variables globales pour normalisation.
     *
     * @param void()
     */
    public function Normalisation()
    {
        // si magic_quotes est "ON",
        if (get_magic_quotes_gpc()) {
            $_POST = self::Normaliser($_POST);    // normaliser les $_POST
            $_GET = self::Normaliser($_GET);        // normaliser les $_GET
            $_REQUEST = self::Normaliser($_REQUEST);    // normaliser les $_REQUEST
            $_COOKIE = self::Normaliser($_COOKIE);    // normaliser les $_COOKIE
        }
    }

    /**
     * afficher proprement le contenu d'une variable précisée
     * le programme est éventuellement interrompu si demandé.
     *
     * @param :    $data n'importe quel tableau ou variable
     * @param bool $die  : si l'on souhaite interrompre le programme avec le dump
     *
     * @return string
     */
    public static function afficher($data, $die = false)
    {
        if (func_num_args() > 0) {
            $data = func_get_args();
        }

        foreach ($data as $wtf => $unData) {
            echo '<pre>';
            var_export($unData);
            echo '</pre>';
        }
        if ($die == true) {
            die();
        }
    }

    public static function afficherSilent($data, $die = false) {
        foreach ($data as $wtf => $unData) {
            echo '<!-- ';
            echo '<pre>';
            var_export($unData);
            echo '</pre>';
            echo ' -->';
        }
        if ($die == true) {
            die();
        }
    }

    /**
     * renvoie le temps écoulé depuis le déclenchement du chrono.
     *
     * @param
     *
     * @return string
     */
    public static function chrono()
    {
        $temps = explode(' ', microtime());

        return $temps[0] + $temps[1];
    }

    /**
     * vider le répertoire "$dir" de tous les fichiers qu'il contient.
     *
     * @param string $dir
     */
    public function vider($dir)
    {
        // liste des fichiers sauf "." et ".."
        $listeFichiers = dirFiles($dir);
        foreach ($listeFichiers as $unFichier) {
            @unlink("$dir/$unFichier");
        }
    }

    /**
     * Connexion à la base de données précisée.
     *
     * @param PARAM_HOST : serveur hôte
     * @param PARAM_BD : nom de la base de données
     * @param PARAM_USER : nom d'utilisateur
     * @param PARAM_PWD : mot de passe
     *
     * @return connexion à la BD
     */
    public static function connectPDO($host, $bd, $user, $mdp)
    {
        try {
            // indiquer que les requêtes sont transmises en UTF8
            // INDISPENSABLE POUR EVITER LES PROBLEMES DE CARACTERES ACCENTUES
            $connexion = new PDO('mysql:host='.$host.';dbname='.$bd, $user, $mdp,
                                array(PDO::MYSQL_ATTR_INIT_COMMAND => 'SET NAMES utf8'));
        } catch (Exception $e) {
            $date = date('d/m/Y H:i:s');
            echo "<style type='text/css'>";
            echo '.erreurBD {width: 500px; margin-left: auto; margin-right: auto; border: 1px solid red; padding: 1em;}';
            echo '.erreurBD .erreur {color: green; font-weight: bold}';
            echo '</style>';

            echo "<div class='erreurBD'>";
            echo '<h3>A&iuml;e, a&iuml;e, a&iuml;e... Caramba...</h3>';
            echo "<p>Une erreur est survenue lors de l'ouverture de la base de donn&eacute;es.<br>";
            echo "Si vous &ecirc;tes l'administrateur et que vous tentez d'installer le logiciel, veuillez v&eacute;rifier le fichier config.inc.php </p>";
            echo "<p>Si le probl&egrave;me se produit durant l'utilisation r&eacute;guli&egrave;re du programme, essayez de rafra&icirc;chir la page (<span style='color: red;'>touche F5</span>)<br>";
            echo "Dans ce cas, <strong>vous n'&ecirc;tes pour rien dans l'apparition du souci</strong>: le serveur de base de donn&eacute;es est sans doute trop sollicit&eacute;...</p>";
            echo "<p>Veuillez rapporter le message d'erreur ci-dessous &agrave; l'administrateur du syst&egrave;me.</p>";
            echo "<p class='erreur'>Le $date, le serveur dit: ".$e->getMessage().'</p>';
            echo '</div>';
            die();
        }

        return $connexion;
    }

    /**
     * Déconnecte la base de données.
     *
     * @param $connexion
     */
    public static function DeconnexionPDO($connexion)
    {
        $connexion = null;
    }

    /**
     * retourne un array contenant une liste des périodes de l'année scolaire.
     *
     * @param $nbBulletins
     * @param $debut : normalement, la première période est 1 mais on a parfois besoin de déclarer une période 0
     *
     * @return array
     */
    public function listePeriodes($nbBulletins, $debut = 1)
    {
        return range($debut, $nbBulletins);
    }

    /**
     * renvoie la liste des applications existantes (et, éventuellement, seulement celles qui sont activées).
     *
     * @param bool $active : rien que les applications actives?
     * @param bool $alpha  : tri alphabétique demandé
     *
     * @return array
     */
    public function listeApplis($actives = true, $alpha = false)
    {
        $connexion = self::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT nom, nomLong, active ';
        $sql .= 'FROM '.PFX.'applications ';
        $sql .= 'WHERE 1 ';
        if ($actives == true) {
            $sql .= 'AND active ';
        }
        if ($alpha == false) {
            $sql .= 'ORDER BY ordre, LOWER(nomLong) ';
        } else {
            $sql .= 'ORDER BY LOWER(nomLong), ordre ';
        }

        $resultat = $connexion->query($sql);
        $liste = array();
        while ($ligne = $resultat->fetch()) {
            $nom = $ligne['nom'];
            $nomLong = $ligne['nomLong'];
            $active = $ligne['active'];
            $liste[$nom] = array('nom' => $nom, 'nomLong' => $nomLong, 'active' => $active);
        }
        self::DeconnexionPDO($connexion);

        return $liste;
    }

    /**
     * liste de tous les droits existants dans la BD pour les différentes applications
     * educ, prof, admin, direction,... et tous les autres statuts éventuels existants
     * ou à venir définis dans les applis.
     *
     * @param
     *
     * @return array
     */
    public function listeDroits()
    {
        $connexion = self::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT userStatus FROM '.PFX.'userStatus ORDER BY ordre';
        $resultat = $connexion->query($sql);
        $liste = array();
        if ($resultat) {
            $resultat->setFetchMode(PDO::FETCH_ASSOC);
            while ($ligne = $resultat->fetch()) {
                array_push($liste, $ligne['userStatus']);
            }
        }
        self::DeconnexionPDO($connexion);

        return $liste;
    }

    /**
     * retourne la liste des statuts disponibles dans l'application
     * semblable à la fonction listeDroits() mais retourne un tableau différent
     * à faire: supprimer listeDroits() et remplace par listeStatuts().
     *
     * @param
     *
     * @return array
     */
    public function listeStatuts()
    {
        $connexion = self::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT userStatus, nomStatut ';
        $sql .= 'FROM '.PFX.'userStatus ORDER BY ordre';
        $resultat = $connexion->query($sql);
        $liste = array();
        if ($resultat) {
            $resultat->setFetchMode(PDO::FETCH_ASSOC);
            while ($ligne = $resultat->fetch()) {
                $status = $ligne['userStatus'];
                $liste[$status] = $ligne['nomStatut'];
            }
        }
        self::DeconnexionPDO($connexion);

        return $liste;
    }

    /**
     * enregistre le statut d'activation / désactivation des applis.
     *
     * @param array $post : array contenant la liste des applis
     *
     * @return int : le nombre de modifications dans la BD
     */
    public function saveApplisStatus($post)
    {
        // chercher la liste des applications disponibles, même inactives
        $listeApplis = self::listeApplis(false);
        // logout et admin ne peuvent jamais être désactivées
        unset($listeApplis['logout']);
        unset($listeApplis['admin']);
        $bilan = array();
        $connexion = self::connectPDO(SERVEUR, BASE, NOM, MDP);
        $nbModifications = 0;
        foreach ($listeApplis as $nom => $details) {
            $status = isset($post[$nom]) ? 1 : 0;
            $sql = 'UPDATE '.PFX.'applications ';
            $sql .= "SET active = '$status' WHERE nom = '$nom'";
            $resultat = $connexion->exec($sql);
            $nbModifications += $resultat;
        }
        self::DeconnexionPDO($connexion);

        return $nbModifications;
    }

    /**
     * modifie le statut de l'utilisateur pour l'application donnée.
     *
     * @param $acronyme
     * @param $application
     * @param $statut
     *
     * @return bool
     */
    public function changeStatut($acronyme, $application, $statut)
    {
        $connexion = self::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'INSERT INTO '.PFX.'profsApplications ';
        $sql .= "SET acronyme='$acronyme', application='$application', userStatus='$statut' ";
        $sql .= "ON DUPLICATE KEY UPDATE userStatus='$statut' ";
        $resultat = $connexion->exec($sql);
        $ok = ($resultat > 0);
        self::DeconnexionPDO($connexion);

        return $ok;
    }

    /**
     * affectation des droits pour les applications aux utilisateurs.
     *
     * @param $usersList : la liste des utilisateurs à affecter
     * @param $applications : la liste des application à affecter
     * @param $droits : les droits à donner à ces utilisateurs sur les applications données
     *
     * @return array
     */
    public function affecteDroitsApplications($usersList, $applications, $droits)
    {
        if ((count($usersList) > 0) && (count($applications) > 0) && (count($droits) > 0)) {
            $connexion = self::connectPDO(SERVEUR, BASE, NOM, MDP);
            $sql = 'INSERT INTO '.PFX.'profsApplications ';
            $sql .= 'SET application = :application, userStatus= :userStatus, acronyme= :acronyme ';
            $sql .= 'ON DUPLICATE KEY UPDATE userStatus= :userStatus ';
            $requete = $connexion->prepare($sql);
            $bilan = array();
            foreach ($usersList as $key => $acronyme) {
                foreach ($applications as $uneAppli) {
                    $data = array(':application' => $uneAppli, ':userStatus' => $droits, ':acronyme' => $acronyme);
                    $resultat = $requete->execute($data);
                    if ($resultat === false) {
                        $bilan[] = array('acronyme' => $acronyme, 'application' => $application, 'droit' => $droits, 'statut' => 'echec');
                    } else {
                        $bilan[] = array('acronyme' => $acronyme, 'application' => $uneAppli, 'droit' => $droits, 'statut' => 'OK');
                    }
                }
            }
            self::DeconnexionPDO($connexion);
        }

        return $bilan;
    }

    /**
     * renvoie la liste des paramètres généraux de l'ensemble de l'application en provenance de la BD.
     *
     * @param
     *
     * @return array $listeParametres
     */
    public function lireParametres()
    {
        $connexion = self::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT ordre, size, label, parametre, valeur, signification ';
        $sql .= 'FROM '.PFX.'config ';
        $sql .= 'ORDER BY ordre, label ';
        $resultat = $connexion->query($sql);
        $listeParametres = array();
        if ($resultat) {
            while ($ligne = $resultat->fetch()) {
                $parametre = $ligne['parametre'];
                $listeParametres[$parametre]['ordre'] = $ligne['ordre'];
                $listeParametres[$parametre]['label'] = $ligne['label'];
                $listeParametres[$parametre]['valeur'] = $ligne['valeur'];
                $listeParametres[$parametre]['signification'] = $ligne['signification'];
                $listeParametres[$parametre]['size'] = $ligne['size'];
            }
        }
        self::DeconnexionPDO($connexion);

        return $listeParametres;
    }

    /**
     * enregistre les paramètres généraux de l'application et renvoie le nombre de paramètres enregistrés.
     *
     * @param post
     *
     * @return $nb : nombre de modificaitons
     */
    public function saveParametres($post)
    {
        $connexion = self::connectPDO(SERVEUR, BASE, NOM, MDP);
        // vérification du nom des paramètres existants dans la BD afin d'éviter
        // d'enregistrer un paramètre qui n'existerait pas
        $sql = 'SELECT parametre FROM '.PFX.'config ';
        $resultat = $connexion->query($sql);
        $listeParametres = array();
        while ($ligne = $resultat->fetch()) {
            $listeParametres[] = $ligne['parametre'];
        }
        $sql = 'INSERT INTO '.PFX.'config ';
        $sql .= 'SET parametre=:parametre, valeur=:valeur ';
        $sql .= 'ON DUPLICATE KEY UPDATE valeur=:valeur ';
        $requete = $connexion->prepare($sql);
        $n = 0;
        foreach ($post as $parametre => $valeur) {
            if (in_array($parametre, $listeParametres)) {
                $data = array(':valeur' => $valeur, ':parametre' => $parametre);
                $resultat = $requete->execute($data);
                if ($resultat > 0) {
                    ++$n;
                }
            }
        }
        self::DeconnexionPDO($connexion);

        return $n;
    }

    /**
     * génération d'un lien pour réinitialiser le mot de passe.
     *
     * @param $acronyme
     * @param $identiteReseau : adresse IP etc...
     *
     * @return bool : le mail a-t-il été envoyé correctement?
     */
    public function renvoiMdp($identite, $identiteReseau)
    {
        $acronyme = $identite['acronyme'];
        $mail = $identite['mail'];
        if ($mail != '') {
            // on peut générer un enregistrement dans la table des lostPasswd
            $token = md5(microtime());

            $connexion = self::connectPDO(SERVEUR, BASE, NOM, MDP);
            $sql = 'INSERT INTO '.PFX.'lostPasswd ';
            $sql .= "SET user='$acronyme', token='$token', date = NOW + INTERVAL 2 DAY ";
            $sql .= "ON DUPLICATE KEY UPDATE token='$token', date = NOW + INTERVAL 2 DAY ";
            $resultat = $connexion->exec($sql);
            self::DeconnexionPDO($connexion);

            $jSemaine = strftime('%A');
            $date = date('d/m/Y');
            $heure = date('H:i');

            require_once '../smarty/Smarty.class.php';
            $smarty = new Smarty();
            $smarty->assign('date', $date);
            $smarty->assign('heure', $heure);
            $smarty->assign('jour', $jSemaine);
            $smarty->assign('TITRECOURT', TITRECOURT);
            $smarty->assign('expediteur', MAILADMIN);
            $smarty->assign('ECOLE', ECOLE);
            $smarty->assign('BASEDIR', BASEDIR);

            $smarty->assign('identiteReseau', $identiteReseau);
            $smarty->assign('identite', $identite);
            $smarty->assign('token', $token);

            $texteFinal = $smarty->fetch('../templates/texteMailmdp.tpl');

            require_once '../phpMailer/class.phpmailer.php';
            $mail = new PHPmailer();
            $mail->IsHTML(true);
            $mail->CharSet = 'UTF-8';
            $mail->From = MAILADMIN;
            $mail->FromName = ADMINNAME;
            $mail->AddAddress($identite['mail']);
            $mail->Subject = NEWPWD;
            $mail->Body = $texteFinal;

            return !$mail->Send();
        }
    }

    /**
     * lire la liste des FlashInfos pour le module donné.
     *
     * @param $module : le module
     *
     * @return array
     */
    public function listeFlashInfos($module)
    {
        $connexion = self::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT * FROM '.PFX.'flashInfos ';
        $sql .= "WHERE application = '$module' ";
        $sql .= 'ORDER BY date DESC ';
        $resultat = $connexion->query($sql);

        $flashInfos = array();
        if ($resultat) {
            $resultat->setFetchMode(PDO::FETCH_ASSOC);
            while ($ligne = $resultat->fetch()) {
                $flashInfos[] = $ligne;
            }
        }
        self::DeconnexionPDO($connexion);

        return $flashInfos;
    }

    /**
     * retourne le répertoire actuel.
     *
     * @param void()
     *
     * @return string
     */
    public static function repertoireActuel()
    {
        $dir = array_reverse(explode('/', getcwd()));

        return $dir[0];
    }

    /**
     * vérifier que l'utilisateur est identifié pour l'application active.
     *
     * @param $nomApplication : nom de l'application à vérifier
     *
     * @return bool : true si accès possible pour l'utilisateur actif
     */
    public function accesApplication($nomApplication)
    {
        return
                isset($_SESSION['identite']['acronyme']) &&
                isset($_SESSION['identite']['mdp']) &&
                $_SESSION['applicationName'] == $nomApplication
                ;
    }
    /**
     * Vérification de l'activation du module pour l'utilisateur actif.
     *
     * @param $BASEDIR : le répertoire de base de l'applicaiton pour forcer un retour
     *
     * @return bool : true si l'utilisateur actif a accès au répertoire actuel
     */
    public function accesModule($BASEDIR)
    {
        $applisAutorisees = array_keys($_SESSION['applications']);
        if (!(in_array(repertoireActuel(), $applisAutorisees))) {
            header('Location: '.$BASEDIR.'index.php');
            exit;
        } else {
            return true;
        }
    }

    /**
     * génération d'un mot de passe d'une longueur donnée et de robustesse donnée.
     *
     * @param $length: longueur souhaitée pour le mot de passe
     * @param $robustesse : robustesse souhaitée
     *
     * @return string
     */
    private function generatePassword($length = 9, $robustesse = 0)
    {
        $voyelles = 'aeuy';
        $consonnes = 'bdghjmnpqrstvz';
        if ($robustesse & 1) {
            $consonnes .= 'BDGHJLMNPQRSTVWXZ';
        }
        if ($robustesse & 2) {
            $voyelles .= 'AEUY';
        }
        if ($robustesse & 4) {
            $consonnes .= '23456789';
        }
        if ($robustesse & 8) {
            $consonnes .= '@#$%';
        }

        $password = '';
        $alt = time() % 2;
        for ($i = 0; $i < $length; ++$i) {
            if ($alt == 1) {
                $password .= $consonnes[(rand() % strlen($consonnes))];
                $alt = 0;
            } else {
                $password .= $voyelles[(rand() % strlen($voyelles))];
                $alt = 1;
            }
        }

        return $password;
    }

    /**
     * convertir les dates au format usuel jj/mm/AAAA en YY-mm-dd pour MySQL.
     *
     * @param string $date date au format usuel
     *
     * @return string date au format MySQL
     */
    public static function dateMysql($date)
    {
        $dateArray = explode('/', $date);
        $sqlArray = array_reverse($dateArray);
        $date = implode('-', $sqlArray);

        return $date;
    }

    /**
     * convertir les date au format MySQL vers le format usuel.
     *
     * @param string $date date au format MySQL
     *
     * @return string date au format usuel français
     */
    public static function datePHP($dateMysql)
    {
        $dateArray = explode('-', $dateMysql);
        $phpArray = array_reverse($dateArray);
        $date = implode('/', $phpArray);

        return $date;
    }

    /**
     * convertir les heures au format MySQL vers le format ordinaire à 24h.
     *
     * @param string $heure l'heure à convertir
     *
     * @return string l'heure au format usuel
     */

    public static function heureMySQL($heure)
    {
        $heureArray = explode(':', $heure);
        $sqlArray = array_reverse($heureArray);
        $heure = implode(':', $sqlArray);

        return $heure;
    }

    /**
     * retournement d'une heure HH:mm en mm:HH (sert à quoi???).
     *
     * @param $heure au format HH:mm
     *
     * @return string
     */
    public static function heurePHP($heure)
    {
        $heureArray = explode(':', $heure);
        $sqlArray = array_reverse($heureArray);
        $heure = implode(':', $sqlArray);

        return $heure;
    }

    /**
     * retourne le jour de la semaine correspondant à une date au format MySQL.
     *
     * @param string $dataMySQL
     *
     * @return string
     */
    public static function jourSemaineMySQL($dateMySQL)
    {
        $timeStamp = strtotime($dateMySQL);

        return strftime('%A', $timeStamp);
    }

    /**
     * Fonction de conversion de date du format français (JJ/MM/AAAA) en Timestamp.
     *
     * @param string $date Date au format français (JJ/MM/AAAA)
     *
     * @return int Timestamp en seconde
     *             http://www.julien-breux.com/2009/02/17/fonction-php-date-francaise-vers-timestamp/
     */
    public static function dateFR2Time($date)
    {
        list($day, $month, $year) = explode('/', $date);
        $timestamp = mktime(0, 0, 0, $month, $day, $year);

        return $timestamp;
    }

    /**
     * convertir un datetime (date et heure) MySQL en date et heure conventionnels en français
     *
     * @param string dateTime : au format YYYY-MM-DD hh:mm
     *
     * @return string : DD-MM-YYYY hh:mm
     */
    public function dateTimeFr($dateTime) {
        if ($dateTime != Null) {
            $dateEnvoi = explode(' ', $dateTime);
            $date = self::datePHP($dateEnvoi[0]);

            return sprintf('%s %s', $date, $dateEnvoi[1]);
        }
        else return Null;
    }

    /**
     * Extrait la liste des fichiers présents dans un répertoire.
     *
     * @param $repertoire
     *
     * @return array un tableau de la liste des fichiers d'un répertoire sauf les fichiers ".", ".." et "index"
     */
    public function listeFichiers($repertoire)
    {
        $liste = scandir($repertoire, 0);
        $exclus = array('.', '..', 'index.php', 'index.html');
        $liste = array_diff(scandir($repertoire, 0), $exclus);

        return $liste;
    }

    /**
     * date d'aujourd'hui au format usuel français.
     *
     * @param void()
     *
     * @return string
     */
    public static function dateNow()
    {
        return date('d/m/Y');
    }

    /**
     * heure à l'instant.
     *
     * @param void()
     *
     * @return string
     */
    public static function timeNow()
    {
        return date('H:i:s');
    }

    /**
     * date dans un an à partir d'aujourd'hui.
     *
     * @param void()
     *
     * @return string
     */
    public static function dateUnAn()
    {
        return date('d/m/Y', strtotime('+365 days'));
    }

    /**
     * date dans un mois à partir d'aujourd'hui.
     *
     * @param void()
     *
     * @return string
     */
    public static function dateUnMois()
    {
        return date('d/m/Y', strtotime('+1 month'));
    }

    /**
     * Recursive function to scan a directory with * scandir() *.
     *
     * @param string $rootDir
     *
     * @return multi dimensional array
     *               http://php.net/manual/en/function.scandir.php
     */
    public function scanDirectories($rootDir)
    {
        // set filenames invisible if you want
        $invisibleFileNames = array('.', '..', 'index.html', 'index.php','.htaccess');
        // run through content of root directory
        $dirContent = scandir($rootDir);
        $allData = array();
        // file counter gets incremented for a better
        $fileCounter = 0;
        foreach ($dirContent as $key => $content) {
            // filter all files not accessible
            $path = $rootDir.'/'.$content;
            if (!in_array($content, $invisibleFileNames)) {
                // if content is file & readable, add to array
                if (is_file($path) && is_readable($path)) {
                    $tmpPathArray = explode('/', $path);
                    // saving filename
                    $allData[$fileCounter]['fileName'] = end($tmpPathArray);
                    // saving while path (for better access)
                    $allData[$fileCounter]['filePath'] = $path;
                    // get file extension
                    $filePartsTmp = explode('.', end($tmpPathArray));
                    $allData[$fileCounter]['fileExt'] = end($filePartsTmp);
                    // get file date
                    $allData[$fileCounter]['fileDate'] = filectime($path);
                    // get filesize in byte
                    $allData[$fileCounter]['fileSize'] = filesize($path);
                    ++$fileCounter;
                // if content is a directory and readable, add path and name
                } elseif (is_dir($path) && is_readable($path)) {
                    $dirNameArray = explode('/', $path);
                    $allData[$path]['dirPath'] = $path;
                    $allData[$path]['dirName'] = end($dirNameArray);
                    // recursive callback to open new directory
                    $allData[$path]['content'] = self::scanDirectories($path);
                }
            }
        }

        return $allData;
    }

    /**
     * retourne une liste des profs ou des membres du personnel.
     *
     * @param $donneCours boolean  si "false", demande la liste de tous les membres du personnel; si "true", demande seulement les enseignants
     *
     * @return array liste de tous les profs de l'école
     */
    public function listeProfs($donneCours = false)
    {
        $connexion = self::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT * FROM '.PFX.'profs ';
        if ($donneCours) {
            $sql .= 'JOIN '.PFX.'profsCours ON ('.PFX.'profsCours.acronyme = '.PFX.'profs.acronyme) ';
            $sql .= "WHERE coursGrp != '' ";
        }
        $sql .= "ORDER BY REPLACE(REPLACE(REPLACE(nom, ' ', ''),'''',''),'-',''), prenom";
        $resultat = $connexion->query($sql);
        $listeProfs = array();
        if ($resultat) {
            $resultat->setFetchMode(PDO::FETCH_ASSOC);
            while ($ligne = $resultat->fetch()) {
                $acronyme = $ligne['acronyme'];
                $listeProfs[$acronyme] = $ligne;
            }
        }
        self::DeconnexionPDO($connexion);

        return $listeProfs;
    }

    /**
     * Établir la liste des utilisateurs (profs) sans cours.
     *
     * @param
     *
     * @return array
     */
    public function listOrphanUsers()
    {
        $connexion = self::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT nom,prenom, acronyme ';
        $sql .= 'FROM '.PFX.'profs WHERE ';
        $sql .= 'acronyme NOT IN (SELECT acronyme FROM '.PFX.'profsCours) ';
        $sql .= "ORDER BY REPLACE(REPLACE (nom,' ',''),'\'','')";
        $resultat = $connexion->query($sql);

        $users = array();
        while ($ligne = $resultat->fetch()) {
            $acronyme = $ligne['acronyme'];
            $users[$acronyme] = array('nom' => $ligne['nom'], 'prenom' => $ligne['prenom']);
        }
        self::DeconnexionPDO($connexion);

        return $users;
    }

     /**
      * liste des utilisateurs avec marque pour ceux qui ont des cours affectés.
      *
      * @param void()
      *
      * @return array : acronyme, nom, prenom, boolCours
      */
     public function listeProfsBoolCours()
     {
         $listeProfs = $this->listeProfs();
         $listeOrphan = $this->listOrphanUsers();
         foreach ($listeProfs as $acronyme => $data) {
             $listeProfs[$acronyme]['boolCours'] = (!(isset($listeOrphan[$acronyme])));
         }

         return $listeProfs;
     }

    /**
     * Suppression de l'utilisateur désigné par son "acronyme".
     *
     * @param string $acronyme
     *
     * @return bool statut d'erreur: OK ou PAS OK
     */
    public function deleteUser($acronyme)
    {
        if ($acronyme == null) {
            die();
        }
        $connexion = self::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'DELETE FROM '.PFX."profs WHERE acronyme='$acronyme' ";
        $resultat = $connexion->exec($sql);
        $erreur1 = ($resultat === false);
        $sql = 'DELETE FROM '.PFX."profsApplications WHERE acronyme='$acronyme' ";
        $resultat = $connexion->exec($sql);
        $erreur2 = ($resultat === false);
        $sql = 'DELETE FROM '.PFX."hermesListes WHERE membre='$acronyme' ";
        $resultat = $connexion->exec($sql);
        $erreur3 = ($resultat === false);

        self::DeconnexionPDO($connexion);

        return !($erreur1 || $erreur2 || $erreur3);
    }

    /**
     * liste des derniers utilisateurs connectés.
     *
     * @param $limite
     *
     * @return array
     */
    public function derniersConnectes($limite)
    {
        $connexion = self::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT distinct user, id,  heure, date, ip, host FROM '.PFX.'logins ';
        $sql .= "ORDER BY id desc limit 0,$limite";
        $resultat = $connexion->query($sql);
        if ($resultat) {
            $resultat->setFetchMode(PDO::FETCH_ASSOC);
            $tableau = $resultat->fetchall();
        } else {
            $tableau = null;
        }
        self::DeconnexionPDO($connexion);

        return $tableau;
    }

    /**
     * vidage de la table dont on fournit le nom.
     *
     * @param string : $table
     *
     * @return bool
     */
    public static function clearTable($table)
    {
        $connexion = self::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'TRUNCATE '.PFX."$table";
        $resultat = $connexion->exec($sql);
        self::DeconnexionPDO($connexion);
        if ($resultat) {
            return true;
        } else {
            return false;
        }
    }

    /**
     * On fournit une liste de tables; la procédure fabrique un fichier .sql permettant la restauration des tables désignées.
     *
     * @param $post : formulaire dans lequel on a coché les noms des tables à sauvegarder
     *
     * @return string : nom du fichier .sql.gz créé
     */
    public function backupTables($post)
    {
        $listeTables = array();
        // seuls les inputs dont le nom commence par "check" sont à considérer
        foreach ($post as $unItem => $value) {
            if (strstr($unItem, 'check')) {
                $data = explode('_', $unItem);
                $listeTables[] = PFX.$data[2];
            }
        }
        $nb = count($listeTables);

        $nbTotal = $this->DBnumTables();
        $listeTables = implode(' ', $listeTables);
        if ($nb < $nbTotal) {
            $fileName = date('Y-m-d:Hms')."_$nb-tables.sql";
        } else {
            $fileName = date('Y-m-d:Hms').'_complet.sql';
        }

        try {
            $output = exec('mysqldump -u '.NOM.' --host='.SERVEUR.' --password='.MDP.' '.BASE." --tables $listeTables > save/$fileName");
        } catch (Exception $e) {
            die($e->getMessage());
        }
        system("gzip save/$fileName");

        return $fileName;
    }

    /**
     * retourne le nombre total de tables de la BD.
     *
     * @param void
     *
     * @return int
     */
    private function DBnumTables()
    {
        $connexion = self::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = "SELECT count(*) as 'Tables', table_schema as 'Database' ";
        $sql .= 'FROM information_schema.TABLES ';
        $sql .= "WHERE table_schema= '".BASE."' ";
        $sql .= 'GROUP BY table_schema ';
        $resultat = $connexion->query($sql);
        $ligne = $resultat->fetch();
        self::DeconnexionPDO($connexion);

        return $ligne['Tables'];
    }

    /**
     * retourne tous les Flash Infos d'un module.
     *
     * @param $module
     *
     * @return array
     */
    public function lireFlashInfos($module)
    {
        $connexion = self::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT * FROM '.PFX.'flashInfos ';
        $sql .= "WHERE application ='$module' ";
        $sql .= 'ORDER BY date DESC, heure DESC ';
        $resultat = $connexion->query($sql);
        $flashInfos = array();
        if ($resultat) {
            $resultat->setFetchMode(PDO::FETCH_ASSOC);
            while ($ligne = $resultat->fetch()) {
                $flashInfos[] = $ligne;
            }
        }
        self::DeconnexionPDO($connexion);

        return $flashInfos;
    }

    /**
     * changement d'utilisateur en gardant les droits admins (Application).
     *
     * @param $acronyme
     *
     * @return string
     */
    public function changeUserAdmin($acronyme)
    {
        // conserver la session de l'admin courant
        $admin = $_SESSION[APPLICATION];

        // prépartion d'un nouvel utilisateur
        $alias = new user($acronyme);
        // mise en mémoire de l'administrateur
        $alias->setAlias($admin);
        $this->alias = $admin;

        $_SESSION[APPLICATION] = $alias;
        $qui = $_SESSION[APPLICATION]->identite();

        return $qui['prenom'].' '.$qui['nom'].': '.$qui['acronyme'];
    }

    /**
     * renvoie la liste des utilisateurs qui disposent du statut global $status dans l'application
     * permet de retrouver tous les "admins", par exemple.
     *
     * @param $status : string
     *
     * @return array
     */
    public function getUserByStatus($status)
    {
        $connexion = self::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT * FROM '.PFX.'profs ';
        $sql .= "WHERE statut = '$status' ";
        $sql .= 'ORDER BY nom, prenom ';
        $resultat = $connexion->query($sql);
        $listeUsers = array();
        if ($resultat) {
            $resultat->setFetchMode(PDO::FETCH_ASSOC);
            $listeUsers = $resultat->fetchAll();
        }
        self::DeconnexionPDO($connexion);

        return $listeUsers;
    }

    /**
     * liste les accès de l'utilisateur indiqué entre deux bornes.
     *
     * @param $user		nom de l'utilisateur concerné
     * @param $nombre  nombre d'accès à traiter
     * @param $from		nombre de lignes à laisser tomber en début
     *
     * @return array : liste des derniers accès à l'application
     */
    public function lastAccess($from, $nombre, $user)
    {
        $connexion = self::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = "SELECT ip,host,date,DATE_FORMAT(heure,'%H:%i') as heure ";
        $sql .= 'FROM '.PFX.'logins ';
        $sql .= "WHERE user='$user' ";
        $sql .= "ORDER BY date DESC,heure DESC limit $from,$nombre ";
        $resultat = $connexion->query($sql);
        $acces = array();
        if ($resultat) {
            $resultat->setFetchMode(PDO::FETCH_ASSOC);
            while ($ligne = $resultat->fetch()) {
                $ligne['date'] = self::datePHP($ligne['date']);
                $acces[] = $ligne;
            }
        }
        self::deconnexionPDO($connexion);

        return $acces;
    }

    /**
     * renvoie la liste de tous les fichiers d'un répertoire.
     *
     * @param $dir : répertoire dont on veut obtenir la liste du contenu
     *
     * @return array
     */
    public function dirFiles($dir)
    {
        $listeFichiers = array();
        if ($handle = @opendir("$dir")) {
            while (false !== ($file = readdir($handle))) {
                if (($file != '.') && ($file != '..')) {
                    $listeFichiers[] = $file;
                }
            }
            closedir($handle);
        }

        return $listeFichiers;
    }

    /**
     * crée un fichier zippé à partir de tous les fichiers qui se trouvent dans le répertoire désigné.
     *
     * @param $dir : répertoire où se trouvent les fichiers à zipper et le fichier à enregistrer
     * @param $filename : nom du fichier à créer
     */
    public function zipFiles($dir, $filename)
    {
        $zip = new ZipArchive();
        if ($zip->open("$dir/$filename", ZIPARCHIVE::CREATE) !== true) {
            exit("Impossible d'ouvrir <$filename>\n");
        }
        $listeFichiers = self::dirFiles($dir);
        foreach ($listeFichiers as $unFichier) {
            $zip->addFile("$dir/$unFichier");
        }
        $zip->close();
    }

    /**
     * compression de tous les fichiers bulletin d'un niveau.
     *
     * @param $dir : répertoire où se trouvent les fichiers
     * @param $bulletin : numéro du bulletin concerné
     * @param $listeClasses : liste des classes à ce niveu d'études
     */
    public function zipFilesNiveau($dir, $bulletin, $listeClasses)
    {
        $niveau = substr($listeClasses[0], 0, 1);
        $zip = new ZipArchive();
        if ($zip->open("$dir/niveau_$niveau-Bulletin_$bulletin.zip", ZIPARCHIVE::CREATE) !== true) {
            exit("Impossible d'ouvrir <niveau_$niveau-Bulletin--_$bulletin.zip>\n");
        }
        $listeFichiers = $this->dirFiles($dir);
        foreach ($listeClasses as $uneClasse) {
            $zip->addFile("$dir/$uneClasse-$bulletin.pdf");
        }
        $zip->close();
    }

     /**
      * renvoie "true" si l'adresse IP est déjà connue dans la table des logins pour cet utilisateur.
      *
      * @param $ip	: adresse IP
      * @param $user	: nom de l'utilisateur
      *
      * @return int
      */
     public function checkIP($ip, $user)
     {
         $connexion = self::connectPDO(SERVEUR, BASE, NOM, MDP);
         $sql = 'SELECT COUNT(*) AS nb ';
         $sql .= 'FROM '.PFX.'logins ';
         $sql .= "WHERE ip='$ip' AND UPPER(user)='$user' ";
        // $sql .= "ORDER BY date DESC, heure DESC ";
        $resultat = $connexion->query($sql);
         $nb = 0;
         if ($resultat) {
             $ligne = $resultat->fetch();
             $nb = $ligne['nb'];
         }
         self::deconnexionPDO($connexion);

         return $nb;
     }

    /**
     * Envoie un mail d'alerte à l'utilisateur et aux admins.
     *
     * @param $acronyme : identifiant de l'utilisateur
     * @param $user	: l'objet "utilisateur"
     * @param $type	: type d'alerte
     * @param $data : données supplémentaires sous forme d'arrey
     *
     * @return bool
     */
    public function mailAlerte($acronyme, $user, $type, $data = null)
    {
        // liste des mails des administrateurs
        $listeMailing = $this->getUserByStatus('admin');
        // userdata
        $identification = $user->identification();
        $ip = $identification['ip'];
        $hostname = $identification['hostname'];
        // $acronyme = $user->getAcronyme();
        $userMail = $user->getMail();

        setlocale(LC_TIME, 'fra_fra');
        $jSemaine = strftime('%A');
        $date = date('d/m/Y');
        $heure = date('H:i');

        switch ($type) {
            case 'mdp':
                $sujet = sprintf(ERREURLOGIN, TITRECOURT);
                $texteAdmin = sprintf(ERREURLOGINADMIN, $acronyme, $data['mdp'], $jSemaine, $date, $heure, $ip, $hostname, $userMail);
                if ($user->userExists($acronyme)) {
                    $texteUser = sprintf(ERREURLOGINUSER, $acronyme, $data['mdp'], $jSemaine, $date, $heure, TITRECOURT, $ip, $hostname);
                }
                break;
            case 'newIP':
                $sujet = sprintf(NOUVELLEIP, TITRECOURT);
                $texteAdmin = sprintf(NOUVELLEIPADMIN, $ip, $hostname, $acronyme, $jSemaine, $date, $heure, $userMail);
                if ($user->userExists($acronyme)) {
                    $texteUser = sprintf(NOUVELLEIPUSER, $ip, $hostname, $jSemaine, $date, $heure, TITRECOURT);
                }
                break;
            default:
                //don't care
                break;
            }
        $mail = new PHPmailer();
        $mail->IsHTML(true);
        $mail->CharSet = 'UTF-8';
        $mail->From = MAILADMIN;
        $mail->FromName = ADMINNAME;
        $envoiMail = true;
        // avertir les administrateurs
        foreach ($listeMailing as $admin) {
            $mail->AddAddress($admin['mail']);
            $mail->Subject = $sujet;
            $mail->Body = $texteAdmin;
        }
        if (!$mail->Send()) {
            $envoiMail = false;
        }

        // prévenir l'utilisateur
            if ($userMail) {
                $mail->ClearAddresses();
                $mail->AddAddress($userMail);
                $mail->Body = $texteUser;
                $mail->Send();
                $envoiMail = false;
            }

        return $envoiMail;
    }

    /**
     * Suppression des anciens élèves dans toutes les tables qui seront indiquées dans $post
     * la liste des élèves provient du fichier CSV uploadé sous forme de $table.
     *
     * @param array $post   : contient la liste des tables sélectionnées qui contiennent un champ "matricule"
     * @param       $table: nom du fichier CSV (transformé en array dans la fonction)
     *
     * @return array : statistiques sur les effacements
     */
    public function suppressionAnciens($post, $tableEleves)
    {
        // former la liste des matricules des élèves
        $tableau = $this->csv2array($tableEleves);
        $listeEleves = $this->tableau2listeEleves($tableau);
        // récupérer les noms des tables sélectionnées depuis les noms des champs dans $post
        $listeTables = array();
        foreach ($post as $unChamp => $wtf) {
            if (substr($unChamp, 0, 6) == 'table#') {
                $uneTable = explode('#', $unChamp);
                $listeTables[] = $uneTable[1];
            }
        }
        // suppressions dans la BD
        $connexion = self::connectPDO(SERVEUR, BASE, NOM, MDP);
        $resultat = 0;
        foreach ($listeTables as $uneTable) {
            foreach ($listeEleves as $matricule) {
                $sql = "DELETE FROM $uneTable WHERE matricule = '$matricule' ";
                // effacement de la photo
                @unlink(INSTALL_DIR."/photos/$matricule.jpg");
                $resultat += $connexion->exec($sql);
            }
        }
        self::DeconnexionPDO($connexion);

        return array(
                    'nbEleves' => count($listeEleves),
                    'nbTables' => count($listeTables),
                    'nbSuppr' => $resultat,
                    );
    }

    /**
     * recherche les éventuels hiatus entre la table importée et la structure de la base de données.
     *
     * @param $entete
     * @param array $champs : liste des champs à trouver
     *
     * @return array: éléments de l'entete du fichier CSV qui ne figurent pas dans la table de la BD et inversement
     */
    public function hiatus($entete, $champs)
    {
        $hiatus1 = array_diff($entete, $champs);
        $hiatus2 = array_diff($champs, $entete);
        $lesProblemes = array();
        if ($hiatus1 || $hiatus2) {
            foreach ($hiatus1 as $unProbleme) {
                $lesProblemes[0][] = $unProbleme;
            }
            foreach ($hiatus2 as $unProbleme) {
                $lesProblemes[1][] = $unProbleme;
            }
        }

        return $lesProblemes;
    }

    /**
     * retourne la liste des champs d'une liste réellement trouvés dans une deuxième liste.
     *
     * @param $champsCherches
     * @param $listeChamps
     *
     * @return array
     */
    public function champsCherches($champsCherches, $listeChamps)
    {
        return array_intersect($champsCherches, $listeChamps);
    }

    /**
     * transforme un fichier .csv uploadé en un array().
     *
     * @param string $fileName : nom du fichier
     *
     * @return $array
     */
    public function csv2array($fileName)
    {
        $handle = fopen("$fileName.csv", 'r');
        $tableau = array();
        while (($data = fgetcsv($handle, 0)) !== false) {
            $tableau[] = $data;
        }
        fclose($handle);

        return $tableau;
    }

    /**
     * liste de toutes les tables qui présentent un champ (typiquement, "matricule")
     * destinée à la suppression des anciens élèves dans toutes les tables de la BD
     * si pas de champ spécifié, retourne toutes les tables.
     *
     * @param string $champ
     *
     * @return array
     */
    public function listeTablesAvecChamp($champ = '')
    {
        $connexion = self::connectPDO(SERVEUR, BASE, NOM, MDP);
        // liste de toutes les tables
        $sql = 'SHOW TABLES FROM '.BASE." LIKE '".PFX."%'";
        $resultat = $connexion->query($sql);
        $listeTables = array();
        if ($resultat) {
            while ($ligne = $resultat->fetch()) {
                $listeTables[] = current($ligne);
            }
        }
        if ($champ != '') {
            $n = 0;
            foreach ($listeTables as $uneTable) {
                $sql = "DESCRIBE $uneTable";
                $resultat = $connexion->query($sql);
                $found = false;
                while (!$found && $ligne = $resultat->fetch()) {
                    $found = ($ligne['Field'] == $champ);
                }
                if (!$found) {
                    unset($listeTables[$n]);
                }
                ++$n;
            }
        }
        self::DeconnexionPDO($connexion);

        return $listeTables;
    }

    /**
     * fournit la liste triée des tables pour l'ensemble des applications commen indiqué dans la table appliTables.
     *
     * @param void()
     *
     * @return array
     */
    public function listeTablesParAppli()
    {
        $connexion = self::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT application, nomTable ';
        $sql .= 'FROM '.PFX.'appliTables ';
        $resultat = $connexion->query($sql);
        $listeTables = array();
        if ($resultat) {
            $resultat->setFetchMode(PDO::FETCH_ASSOC);
            while ($ligne = $resultat->fetch()) {
                $application = $ligne['application'];
                $nomTable = PFX.$ligne['nomTable'];
                $listeTables[$application][] = $nomTable;
            }
        }
        self::DeconnexionPDO($connexion);

        return $listeTables;
    }

    /**
     * fournit la liste *non triée* des tables et des applications liées comme indiqué dans la table appliTables.
     *
     * @param void()
     *
     * @return array
     */
    public function listeTablesEtApplis()
    {
        $connexion = self::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT application, nomTable ';
        $sql .= 'FROM '.PFX.'appliTables ';
        $sql .= 'ORDER BY application ';
        $resultat = $connexion->query($sql);
        $listeTables = array();
        if ($resultat) {
            $resultat->setFetchMode(PDO::FETCH_ASSOC);
            while ($ligne = $resultat->fetch()) {
                $application = $ligne['application'];
                $nomTable = PFX.$ligne['nomTable'];
                $listeTables[$nomTable] = $application;
            }
        }
        self::DeconnexionPDO($connexion);

        return $listeTables;
    }

    /**
     * fournit la liste des associations entre les tables et les applis, y compris la valeur Null pour une table associée à aucune appli
     * (ce qui serait une erreur du programmeur d'une appli)
     * dans ce cas, la $listeTablesEtApplis ne contiendrait pas d'entrée pour une table orpheline.
     *
     * @param array $listeToutesTables
     * @param array $listeTablesEtApplis
     *
     * @return array
     */
    public function listeAssocTablesApplis($listeToutesTables, $listeTablesEtApplis)
    {
        $listeAssoc = array();
        foreach ($listeToutesTables as $nomTable) {
            if (array_key_exists($nomTable, $listeTablesEtApplis)) {
                $listeAssoc[$nomTable] = $listeTablesEtApplis[$nomTable];
            } else {
                $listeAssoc[$nomTable] = null;
            }
        }

        return $listeAssoc;
    }

    /**
     * enregistre les liens entre applications et tables à destination de la table appliTables.
     *
     * @param array $post
     *
     * @return int nb
     */
    public function saveLinkApplisTables($post)
    {
        $connexion = self::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'INSERT INTO '.PFX.'appliTables ';
        $sql .= 'SET nomTable = :nomTable, application= :application ';

        $requete = $connexion->prepare($sql);
        // suppression de la table existante
        $sql = 'TRUNCATE '.PFX.'appliTables ';
        $connexion->exec($sql);
        $nb = 0;
        foreach ($post as $table => $appli) {
            if (substr($table, 0, 6) == 'table_') {
                $table = explode('_', $table);
                $nomTable = $table[2];
                $data = array(':application' => $appli, ':nomTable' => $nomTable);
                $nb += $requete->execute($data);
            }
        }
        self::DeconnexionPDO($connexion);

        return $nb;
    }

    /**
     * fournit la liste des tables pour l'application donnée
     * si pas d'application précisée, donne la liste de toutes les tables
     * cette liste des tables doit, elle-même, figurer dans une table
     * de l'application 'admin'.
     *
     * @param $base
     * @param  $application
     *
     * @return array
     */
    public function listeTables($base, $application = null)
    {
        $connexion = self::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT application, nomTable FROM '.PFX.'appliTables ';
        if ($application) {
            $sql .= "WHERE application = '$application'";
        }
        try {
            $resultat = $connexion->query($sql);
        } catch (PDOException $e) {
            die($e->getMessage());
        }
        $listeTables = array();
        if ($resultat) {
            $resultat->setFetchMode(PDO::FETCH_ASSOC);
            $listeTables = array();
            while ($ligne = $resultat->fetch()) {
                $application = $ligne['application'];
                $listeTables[$application][] = $ligne['nomTable'];
            }
        }
        self::DeconnexionPDO($connexion);

        return $listeTables;
    }

    /**
     * renvoie un tableau indiquant les noms des champs de la table MySQL indiquée.
     *
     * @param $table
     *
     * @return array
     */
    public static function SQLtableFields2array($table)
    {
        $connexion = self::connectPDO(SERVEUR, BASE, NOM, MDP);
       // recherche des noms des champs dans la table visée
       $sql = 'SHOW FULL COLUMNS FROM '.PFX."$table";
        $resultat = $connexion->query($sql);
        $champs = array();
        if ($resultat) {
            $resultat->setFetchMode(PDO::FETCH_ASSOC);
            $champs = $resultat->fetchall();
        }
        self::DeconnexionPDO($connexion);

        return $champs;
    }

    /**
     * Enregistrement d'un fichier CSV dans la table MySQL correspondante
     * Le contenu du fichier CSV a été préalablement vérifié et validé à l'écran.
     *
     * @param $table
     *
     * @return array : 'erreurs'=>nbErreurs, 'ajouts'=>nbAjouts
     */
    public function CSV2MySQL($table)
    {
        $tableauCSV = $this->csv2array($table);
        // isolement de la première ligne du tableau qui contient les noms des champs
        // pour la requête INSERT
        $champsInsert = array_shift($tableauCSV);
        // détermination des clefs primaires de la table
        $primKeys = $this->tablePrimKeys($table);
        // détermination des champs pour la requête UPDATE
        $champsUpdate = array_diff($champsInsert, $primKeys);

        $sql = 'INSERT INTO '.PFX."$table (".implode(',', $champsInsert).') VALUES (';
        $valuesInsert = array();
        foreach ($champsInsert as $unChamp) {
            $valuesInsert[] = ':'.$unChamp;
        }
        $sql .= implode(',', $valuesInsert).') ';
        $valuesUpdate = array();
        foreach ($champsUpdate as $unChamp) {
            $valuesUpdate[] = "$unChamp=:$unChamp";
        }

        // si tous les champs sont des clés primaires, il n'y a pas d'Update possible
        if ($valuesUpdate) {
            $sql .= 'ON DUPLICATE KEY UPDATE '.implode(',', $valuesUpdate);
        }
        $connexion = self::connectPDO(SERVEUR, BASE, NOM, MDP);
        // $connexion->beginTransaction();
        $requete = $connexion->prepare($sql);
        $ajouts = 0;
        $erreurs = 0;
        // combien de champs à insérer?
        $nbChampsInsert = count($champsInsert);

        foreach ($tableauCSV as $uneLigne) {
            $insert = @array_combine($champsInsert, $uneLigne);
            // le compte du nombre de champs est-il bon dans la variable $insert
            if ($nbChampsInsert == count($insert)) {
                //echo $sql;
                //Application::afficher($insert, true);
                $requete->execute($insert);
                ++$ajouts;
            } else {
                ++$erreurs;
            }
        }
        // $connexion->commit();
        self::DeconnexionPDO($connexion);

        return array('erreurs' => $erreurs, 'ajouts' => $ajouts);
    }

    /**
     * supprimer les caractèes accentués d'une chaîne et les remplacer par le caractères non accentué.
     *
     * @param string $string : la chaîne à corriger
     *
     * @return string
     */
    public static function stripAccents($string) {
        $table = array(
        'Š'=>'S', 'š'=>'s', 'Đ'=>'Dj', 'đ'=>'dj', 'Ž'=>'Z', 'ž'=>'z', 'Č'=>'C', 'č'=>'c', 'Ć'=>'C', 'ć'=>'c',
        'À'=>'A', 'Á'=>'A', 'Â'=>'A', 'Ã'=>'A', 'Ä'=>'A', 'Å'=>'A', 'Æ'=>'A', 'Ç'=>'C', 'È'=>'E', 'É'=>'E',
        'Ê'=>'E', 'Ë'=>'E', 'Ì'=>'I', 'Í'=>'I', 'Î'=>'I', 'Ï'=>'I', 'Ñ'=>'N', 'Ò'=>'O', 'Ó'=>'O', 'Ô'=>'O',
        'Õ'=>'O', 'Ö'=>'O', 'Ø'=>'O', 'Ù'=>'U', 'Ú'=>'U', 'Û'=>'U', 'Ü'=>'U', 'Ý'=>'Y', 'Þ'=>'B', 'ß'=>'Ss',
        'à'=>'a', 'á'=>'a', 'â'=>'a', 'ã'=>'a', 'ä'=>'a', 'å'=>'a', 'æ'=>'a', 'ç'=>'c', 'è'=>'e', 'é'=>'e',
        'ê'=>'e', 'ë'=>'e', 'ì'=>'i', 'í'=>'i', 'î'=>'i', 'ï'=>'i', 'ð'=>'o', 'ñ'=>'n', 'ò'=>'o', 'ó'=>'o',
        'ô'=>'o', 'õ'=>'o', 'ö'=>'o', 'ø'=>'o', 'ù'=>'u', 'ú'=>'u', 'û'=>'u', 'ý'=>'y', 'ý'=>'y', 'þ'=>'b',
        'ÿ'=>'y', 'Ŕ'=>'R', 'ŕ'=>'r',
        );
      return strtr($string, $table);
    }

    /**
     * simplification des noms (suppression des accents et autres caractères indésirables)
     *
     * @param string $nomPrenom
     *
     * @return string
     */
     public static function simplifieNom($nomPrenom) {
         $np = strtolower(self::stripAccents($nomPrenom));
         $np = str_replace(' ', '_', $np);
         $np = str_replace('-', '', $np);
         $np = str_replace('\'', '', $np);

         return $np;
     }

    /**
     * suppression de quelques caractères ennuyeux (espace, tiret, apostrohpe): utile pour créer des noms d'utilisateurs.
     *
     * @param $string : la chaîne à nettoyerListes
     *
     * @return string
     */
    private function stripIndesirables($string)
    {
        $indesirables = array(' ', '-', "'");
        $string = str_replace($indesirables, '', $string);

        return $string;
    }

    /**
     * attribue un nom d'utilisateur à un élèves première lettre du prénom, 7 lettres du nom + matricule.
     *
     * @param $matricule
     * @param $nom
     * @param $prenom
     *
     * @return string
     */
    public function userName($matricule, $nom, $prenom)
    {
        $nom = strtolower(self::stripIndesirables(self::stripAccents($nom)));
        $prenom = strtolower(self::stripIndesirables(self::stripAccents($prenom)));
        $username = substr($prenom, 0, 1).substr($nom, 0, 7).$matricule;

        return $username;
    }

    /**
     * retourne le nom des différents champs d'une table provenant de la BD.
     *
     * @param $table
     *
     * @return array
     */
    public function nomsChampsBD($champs)
    {
        $nomChamps = array();
        foreach ($champs as $unChamp) {
            $nomChamps[] = $unChamp['Field'];
        }

        return $nomChamps;
    }

    /**
     * retourne les noms des champs d'une $table MySQL qui sont Primary keys.
     *
     * @param $table
     *
     * @return array
     */
    public function tablePrimKeys($table)
    {
        $connexion = self::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SHOW KEYS FROM '.PFX."$table WHERE Key_name = 'PRIMARY' ";
        $resultat = $connexion->query($sql);
        $resultat->setFetchMode(PDO::FETCH_ASSOC);
        if ($resultat) {
            // la colonne 4 contient les noms des champs "PRIMARY"
            $keys = $resultat->fetchall(PDO::FETCH_COLUMN, 4);
        }
        self::DeconnexionPDO($connexion);

        return $keys;
    }

    /**
     * retourn le type MIME du fichier dont on fournit le nom.
     *
     * @param $file
     *
     * @return string
     */
    public function checkFileType($fileName)
    {
        $finfo = finfo_open(FILEINFO_MIME);

        return finfo_file($finfo, $fileName);
    }

    /**
     * renvoie le résultat de la requête SQL sous forme d'array.
     *
     * @param string $table : nom de la table à convertir en array
     * @param int $from : début de recherche dans la table
     * @param int $nb : nombre d'éléments à chercher
     *
     * @return $tableau : array
     */
    public function SQLtable2array($table, $from, $nb)
    {
        $connexion = self::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT * FROM '.PFX."$table ";
        $sql .= 'limit :from, :nb ';
        $requete = $connexion->prepare($sql);

        $requete->bindParam(':from', $from, PDO::PARAM_INT);
        $requete->bindParam(':nb', $nb, PDO::PARAM_INT);

        $resultat = $requete->execute();
        $tableau = array();
        if ($resultat) {
            $requete->setFetchMode(PDO::FETCH_ASSOC);
            $tableau = $requete->fetchall();
        }
        self::DeconnexionPDO($connexion);

        return $tableau;
    }

    /**
     * produit un tableau de la liste des élèves provenant d'un fichier CSV transformé en array.
     *
     * @param array $tableau
     *
     * @return $array : liste des matricules des élèves
     */
    public function tableau2listeEleves($tableau)
    {
        $entete = array_shift($tableau);
        if ($entete[0] != 'matricule') {
            die('matricule attendu en premi&egrave;re colonne');
        }
        $listeMatricules = array();
        foreach ($tableau as $uneLigne) {
            $listeMatricules[] = $uneLigne[0];
        }

        return $listeMatricules;
    }

    /**
     * vider un répertoire complet et l'effacer
     * http://php.net/manual/fr/function.rmdir.php.
     *
     * @param $dir
     */
    public function rrmdir($dir)
    {
        if (is_dir($dir)) {
            $objects = scandir($dir);
            foreach ($objects as $object) {
                if ($object != '.' && $object != '..') {
                    if (filetype($dir.'/'.$object) == 'dir') {
                        rrmdir($dir.'/'.$object);
                    } else {
                        unlink($dir.'/'.$object);
                    }
                }
            }
            reset($objects);
            rmdir($dir);
        }
    }

    /**
     * retourne la liste des $nbJours dates ouvrables suivantes d'une date donnée.
     *
     * @param string $date
     * @param $nbJours : nombre de jours souhaités
     * @param $debutInclus: faut-il tenir compte du jour actuel?
     *
     * @return array
     */
    public function datesSuivantes($date, $nbJours = '1', $debutInclus = true)
    {
        $fetes = array('25/12/2014', '01/01/2015');
        $listeDates = array();
        $dateLendemain = $date;
        if ($debutInclus) {
            $listeDates = array($date);
        } else {
            $listeDates = array();
        }
        while ($nbJours >= 1) {
            $timeStamp = strtotime(str_replace('/', '-', $dateLendemain).'1 weekday');
            $dateLendemain = date('d/m/Y', $timeStamp);
            if (!(in_array($dateLendemain, $fetes))) {
                $listeDates[] = $dateLendemain;
                --$nbJours;
            }
        }

        return $listeDates;
    }

    /**
     * Création d'un lien enregistré dans la base de données pour la récupération du mdp.
     *
     * @param void()
     *
     * @return string
     */
    public function createPasswdLink($userName)
    {
        $link = md5(microtime());
        $connexion = self::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'INSERT INTO '.PFX.'lostPasswd ';
        $sql .= "SET user='$userName', token='$link', date=NOW() + INTERVAL 2 DAY ";
        $sql .= "ON DUPLICATE KEY UPDATE token='$link', date=NOW() + INTERVAL 2 DAY ";
        $resultat = $connexion->exec($sql);
        self::DeconnexionPDO($connexion);

        return $link;
    }

    /**
     * Envoie un mail de rappel de mot de passe à l'utlisateur dont on a l'adresse.
     *
     * @param $link : le lien de l'adresse où changer le mdp
     * @param $identite	: toutes les informations d'identité de l'utilisateur
     * @param $identiteReseau : informations relatives à la connexion (IP,...)
     *
     * @return bool
     */
    public function mailPasswd($link, $identite, $identiteReseau)
    {
        $jSemaine = strftime('%A');
        $date = date('d/m/Y');
        $heure = date('H:i');

        $smarty = new Smarty();
        $smarty->template_dir = '../templates';
        $smarty->compile_dir = '../templates_c';
        $smarty->assign('date', $date);
        $smarty->assign('heure', $heure);
        $smarty->assign('jour', $jSemaine);
        $smarty->assign('expediteur', MAILADMIN);
        $smarty->assign('identiteReseau', $identiteReseau);
        $smarty->assign('identite', $identite);
        $smarty->assign('ECOLE', ECOLE);
        $smarty->assign('BASEDIR', BASEDIR);
        $smarty->assign('TITRECOURT', TITRECOURT);
        $smarty->assign('token', $link);
        $texteFinal = $smarty->fetch('texteMailmdp.tpl');

        require_once '../phpMailer/class.phpmailer.php';
        $mail = new PHPmailer();
        $mail->IsHTML(true);
        $mail->CharSet = 'UTF-8';
        $mail->From = MAILADMIN;
        $mail->FromName = ADMINNAME;
        $mail->AddAddress($identite['mail']);
        $mail->AddBCC(MAILADMIN);
        $mail->Subject = NEWPWD;
        $mail->Body = $texteFinal;

        return !$mail->Send();
    }

    /**
     * recherche la présence d'un token donné dans la BD pour un utilisateur donné.
     *
     * @param $token : le token cherché
     * @param $user : le nom d'utilisateur correspondant au token
     *
     * @return string : l'utilisateur recherché s'il est dans la table
     */
    public function chercheToken($token, $user)
    {
        $connexion = self::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT user, token, date ';
        $sql .= 'FROM '.PFX.'lostPasswd ';
        $sql .= "WHERE token='$token' AND user='$user' AND date >= NOW() ";
        $sql .= 'LIMIT 1 ';

        $resultat = $connexion->query($sql);
        $userName = '';
        if ($resultat) {
            $resultat->setFetchMode(PDO::FETCH_ASSOC);
            $ligne = $resultat->fetch();
            $userName = $ligne['user'];
        }
        self::DeconnexionPDO($connexion);

        return $userName;
    }

    /**
     * Effacement des tokens plus anciens que deux jours à partir de maintenant
     *
     * @param int $nbJours : nombre de jours depuis la demande de renouvellement du mdp
     *
     * @return void
     */
    public function delOldTokens($nbJours){
        $connexion = self::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'DELETE FROM '.PFX.'lostPasswd ';
        $sql .= 'WHERE date < NOW() - INTERVAL :nbJours DAY ';
        $requete = $connexion->prepare($sql);

        $requete->bindParam(':nbJours', $nbJours, PDO::PARAM_INT);

        $resultat = $requete->execute();

        self::DeconnexionPDO($connexion);

        return;
    }

     /**
      * Enregistre le mot de passe provenant du formulaire et correspondant à l'utilisateur indiqué.
      *
      * @param array $post : contenu du formulaire
      *
      * @return nombre d'enregistrements réussis (normalement 1)
      */
     public function savePasswd($post)
     {
         $passwd = isset($post['passwd']) ? $post['passwd'] : null;
         $passwd2 = isset($post['passwd2']) ? $post['passwd2'] : null;
         $token = $post['token'];
         // confirmation du userName dans la BD (sécurité)
         $userName = strtoupper($this->chercheToken($post['token'], $post['userName']));
         $nb = 0;
         if (($passwd == $passwd2) && ($userName != '') && (strlen($passwd) >= 8)) {
             $passwd = md5($passwd);
             $connexion = self::connectPDO(SERVEUR, BASE, NOM, MDP);
             $sql = 'UPDATE '.PFX.'profs ';
             $sql .= 'SET mdp =:passwd ';
             $sql .= 'WHERE UPPER(acronyme) = :userName ';
             $requete = $connexion->prepare($sql);
             $data = array(':passwd' => $passwd, ':userName' => $userName);
             $resultat = $requete->execute($data);
             if ($resultat) {
                 $nb = 1;
             }
         // suppression de tous les tokens de cet utilisateur dans la table des mots de passe à récupérer
         $sql = 'DELETE FROM '.PFX.'lostPasswd ';
             $sql .= 'WHERE UPPER(user) = :userName ';
             $data = array(':userName' => $userName);
             $requete = $connexion->prepare($sql);
             $resultat = $requete->execute($data);

             self::DeconnexionPDO($connexion);
         }

         return $nb;
     }

    /**
     *  renvoie le nom du module courant.
     *
     * @param $level : le niveau de sous-repertoire à explorer
     *
     * @return string
     */
    public function getModule($level)
    {
        $dir = explode('/', getcwd());

        return $dir[count($dir) - $level];
    }

    /**
     * renvoie la valeur numérique d'une variable, y compris avec des nombres à virgules ou contenant des espaces.
     *
     * @param $chaine
     *
     * @return float
     */
    public static function floatVal($nombre)
    {
        $nombre = str_replace(',', '.', $nombre);
        $nombre = str_replace(' ', '', $nombre);

        return floatval($nombre);
    }

    /**
     * Suppression de la virgule et remplacement par un point dans les nombres + suppression des espaces.
     *
     * @param $nombre string
     *
     * @return string
     */
    public static function sansVirg($nombre)
    {
        $nombre = str_replace(',', '.', $nombre);
        $nombre = str_replace(' ', '', $nombre);

        return $nombre;
    }

    /**
     * recherche les messages en attente de lecture pour chaque appli disponible
     *
     * @param string $acronyme : l'utilisateur concerné
     *
     * @return array
     */
    public function listeMessages($user) {
        // liste des messages par application
        $listeApplis = array_keys($this->listeApplis());

        $notifications = Null;
        foreach ($listeApplis as $uneAppli) {
            // recherche des applications pour lesquelles un fichier "funcNotifs.inc.php" a été créé
            // on y trouve une fonction de comptage des notifications en attente
            if (file_exists($uneAppli.'/inc/funcMessages.inc.php')) {
                require_once $uneAppli.'/inc/funcMessages.inc.php';
                // définition et appel de la fonction de comptage des notifications spécifique au module
                $function = $uneAppli."_messages";
                $notifications[$uneAppli] = $function($user);
            }
        }

        return $notifications;
    }


    /**
     * renvoie la liste des heures de cours données dans l'école.
     *
     * @param void
     *
     * @return array
     */
    public function lirePeriodesCours()
    {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT debut, fin ';
        $sql = "SELECT DATE_FORMAT(debut,'%H:%i') as debut, DATE_FORMAT(fin,'%H:%i') as fin ";
        $sql .= 'FROM '.PFX.'presencesHeures ';
        $sql .= 'ORDER BY debut, fin';

        $resultat = $connexion->query($sql);
        $listePeriodes = array();
        $periode = 1;
        if ($resultat) {
            while ($ligne = $resultat->fetch()) {
                $debut = $ligne['debut'];
                $fin = $ligne['fin'];
                $listePeriodes[$periode++] = array('debut' => $debut, 'fin' => $fin);
            }
        }
        Application::deconnexionPDO($connexion);

        return $listePeriodes;
    }

    /**
     * renvoie l'heure de la période de cours la plus proche de l'heure passée en argument
     *
     * @param string $heure
     *
     * @return string
     */
    public function heureLaPlusProche($heure){
        $listePeriodes = $this->lirePeriodesCours();
        $time = explode(':', $heure);
        $time = mktime($heure[0], $heure[1]);

        $n = 1;
        while (($listePeriodes[$n]['fin'] < $heure) && ($n < count($listePeriodes))) {
            $n++;
        }
        $timeDebut = explode(':', $listePeriodes[$n]['debut']);
        $timeFin = explode(':', $listePeriodes[$n]['fin']);

        if (((float) $time - (float) $timeDebut) > ((float) $timeFin - (float) $time))
            return $listePeriodes[$n]['debut'];
            else return $listePeriodes[$n]['fin'];
    }


    /**
    * mode debug de php
    *
    */
    public static function debug() {
        ini_set('display_errors', 1);
        ini_set('display_startup_errors', 1);
        error_reporting(E_ALL);
    }

    /**
     * retourne la valeur "POSTEE" ou, si pas de POST, la valeur du COOKIE
     * fixe la valeur du COOKIE à la valeur "POSTEE"
     *
     * @param  string $name  $_POST[$name]
     * @param  int $duree: durée de validité du cookie
     *
     * @return string
     */
    public static function postOrCookie ($name, $duree = Null) {
        if ($duree == Null)
            $duree = time() + 365 * 24 * 3600;
        if (isset($_POST[$name])) {
            $value = $_POST[$name];
            setcookie($name, $value, $duree, '/', null, false, true);
        } else {
                $value = (isset($_COOKIE[$name])) ? $_COOKIE[$name] : null;
            }
        return $value;
    }

     /**
       * modifie la valeur de 'acronyme' en changeant "$ancien" par "$nouveau" dans la table indiquée
       *
       * @param string $ancien : ancien acronyme
       * @param string $nouveau: nouvelle version
       * @param string $table : nom de la table
       * @param string $field : nom du champ à modifier (généralement 'acronyme')
       *
       * @return int : nombre de modifications
       */
      public function changeAcronyme4table($ancien, $nouveau, $table, $field){
          $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
          $sql = 'UPDATE '.PFX.$table.' SET '.$field.' = :nouveau ';
          $sql .= 'WHERE '.$field.' = :ancien ';
          $requete = $connexion->prepare($sql);

          $nb = 0;
          $requete->bindParam(':ancien', $ancien, PDO::PARAM_STR, 7);
          $requete->bindParam(':nouveau', $nouveau, PDO::PARAM_STR, 7);

          $resultat = $requete->execute();
          if ($resultat)
  			$nb = $requete->rowCount();

          Application::deconnexionPDO($connexion);

  		return $nb;
      }

    /**
     * renvoie le nombre total de lignes d'une table dans la BD
     *
     * @param string $table
     *
     * @retnur array
     */
    public function nbRows4table ($table){
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT COUNT(*) AS nb FROM '.PFX.$table;
        $requete = $connexion->prepare($sql);

        $resultat = $requete->execute();
        $ligne = $requete->fetch();
        $nb = $ligne['nb'];

        Application::deconnexionPDO($connexion);

        return $nb;
    }

    /**
    * renvoie une série de nombres entre 0 et $nbBlocs autour de $actuel
    *
    * @param int $actuel
    * @param int $nbElemnts
    *
    * @return array
    */
    public function listeBoutons($actuel, $nbElements) {
        $nbBoutons = intdiv($nbElements, 20);
        $reste = $nbElements % 20;
        $nbBoutons += ($reste == 0) ? 0 : 1;
        $liste = array();

        $liste[$actuel] = $actuel;

        if ($actuel >= 2)
            $liste[$actuel-1] = $actuel-1;
        if ($actuel >= 3)
            $liste[$actuel-2] = $actuel-2;

        if ($actuel < $nbBoutons)
            $liste[$actuel+1] = $actuel+1;
        if ($actuel < $nbBoutons-1)
            $liste[$actuel+2] = $actuel+2;

        $liste[1] = 1;
        $liste[$nbBoutons] = $nbBoutons;

        if ($actuel-3 > 0)
            $liste[$actuel-3] = '...';
        if ($actuel+3 < $nbBoutons)
            $liste[$actuel+3] = '...';
        ksort($liste);

        return $liste;
        }

}
