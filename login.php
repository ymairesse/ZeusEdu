<?php

session_start();
require_once 'config.inc.php';

// définition de la class APPLICATION
require_once INSTALL_DIR.'/inc/classes/classApplication.inc.php';
$Application = new Application();
$Application->Normalisation();

// définition de la class USER
require_once INSTALL_DIR.'/inc/classes/classUser.inc.php';

// extraire l'identifiant et le mot de passe
// l'identifiant est passé en majuscules => casse sans importance
$acronyme = isset($_POST['acronyme']) ? strtoupper($_POST['acronyme']) : null;
$mdp = isset($_POST['mdp']) ? $_POST['mdp'] : null;
$memory = isset($_POST['memory']) ? $_POST['memory'] : Null;

// Les données acronyme et mdp ont été postées dans le formulaire de la page accueil.php
if (!empty($acronyme) && !empty($mdp)) {
    // recherche de toutes les informations sur l'utilisateur et les applications activées
    $user = new user($acronyme);

    // noter le passage de l'utilisateur dans les logs
    $user->logger($acronyme);
    $identification = $user->identification();

    // vérification du mot de passe
    if ($user->getPasswd() == md5($mdp)) {
        // mettre à jour la session avec les infos de l'utilisateur
        $_SESSION[APPLICATION] = $user;
        if ($memory != Null) {
            setcookie('acronyme', $acronyme, time() + 3600 * 12);
            setcookie('mdp', $mdp, time() + 3600 * 12);
            setcookie('memory', $memory, time() + 3600 * 12);
        }
        else {
            setcookie('acronyme', Null, time()-1);
            setcookie('mdp', Null, time()-1);
            setcookie('memory',Null, time()-1);
        }

        header('Location: index.php');
        exit;
    } else {
        $data['mdp'] = $mdp;
        if ($Application->mailAlerte($acronyme, $user, 'mdp', $data)) {
            header('Location: accueil.php?message=erreurMDP');
            exit;
        } else {
            header('Location: accueil.php?message=erreurMDP');
            exit;
        }
    }
} else {
        // le nom d'utilisateur ou le mot de passe n'ont pas été donnés
    header('Location: accueil.php?erreur=manque');
    exit;
    }
