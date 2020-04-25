<!DOCTYPE html>
<html lang="fr" dir="ltr">
    <head>
        <meta charset="utf-8">
        <META HTTP-EQUIV="Refresh" CONTENT="10; URL=http://localhost/sio2/peda/test/inc/testIframe.php">
    </head>
    <body>
        <?php
        require_once '../../config.inc.php';

        require_once INSTALL_DIR.'/inc/classes/classApplication.inc.php';
        $Application = new Application();

        // définition de la class USER utilisée en variable de SESSION
        require_once INSTALL_DIR.'/inc/classes/classUser.inc.php';

        session_start();

        if (!(isset($_SESSION[APPLICATION]))) {
            echo "<script type='text/javascript'>document.location.replace('".BASEDIR."');</script>";
            exit;
        }
        echo time();
        Application::afficher($_SESSION);
        ?>
    </body>
</html>
