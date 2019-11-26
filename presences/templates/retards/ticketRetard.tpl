<!DOCTYPE html>
<html lang="fr" dir="ltr">
    <head>
        <meta charset="utf-8">
        <title></title>
    </head>
    <body>
        {foreach from=$form['matricule'] key=n item=unMatricule}
            <h2>Billet de retard</h2>
            <p style="font-size:12pt; font-weight:bold;">{$form['nomEleve'][$n]}</p>
            <p>Le {$form['date'][$n]} à {$form['heure'][$n]}</p>
            <p style='page-break-after: always'>
        {/foreach}
    </body>
</html>
