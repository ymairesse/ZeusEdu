<!DOCTYPE html>
<html>
    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        {include file='../../javascript.js'}
        {include file='../../styles.sty'}
        <title>Installation</title>
    </head>
    <body>
        <div class="container">
        <h1>Initialisation de la base de données</h1>
        <h2>Les paramètres suivants ont été utilisés</h3>
        <ul>
            <li>Nom du serveur: <strong>{$SERVEUR}</strong></li>
            <li>Base de données: <strong>{$BASE}</strong></li>
            <li>Nom d'utlisateur: <strong>{$NOM}</strong></li>
            <li>Mot de passe: <strong>{$MDP}</strong></li>
        </ul>
        <p>Ces informations figurent dans le fichier <strong>config.inc.php</strong></p>

        <h2>Résultat</h3>
        <p>Nombre d'opérations réalisées: {$nb}</p>
        <p>Veuillez maintenant</p>
        <ul>
            <li>vérifier que la base de données a été correctement initialisée </li>
            <li style="color: red">effacer le répertoire <strong>install</strong></li>
        </ul>
        <p>Si tout s'est bien passé, vous pouvez démarrer l'<a href="../index.php">application Zeus/Edu</a> dès maintenant.</p>
    </div>
    </body>
</html>
