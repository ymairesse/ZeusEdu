<page backtop="10mm" backbottom="10mm" backleft="10mm" backright="15mm">

    <img src="../../../images/logoEcole.png" style="float:right; width:150px;">
    <h1>{$secretariat.nom} {$secretariat.prenom} [{$secretariat.groupe}] </h1>

    <h2>Informations administratives</h2>
    <h3>Personne responsable</h3>
    <p>Nom: <strong>{$secretariat.nomResp}</strong> Adresse mail: <strong>{$secretariat.mailResp|default:"--"}</strong></p>

    <h3>Parents</h3>
    <h4>Père</h4>
    <p>Nom: <strong>{$secretariat.nomPere}</strong> Adresse mail: <strong>{$secretariat.mailPere|default:"--"}</strong></p>

    <h4>Mère</h4>
    <p>Nom: <strong>{$secretariat.nomMere}</strong> Adresse mail: <strong>{$secretariat.mailMere|default:"-"}</strong></p>

    <h2>Inscriptions sur la plate-forme Thot</h2>

    {if ($thot[0].userName == '')}
        <h3>Aucune inscription</h3>
        <p><strong>Attention! Vous n'avez pas d'accès aux informations importantes de l'ISND</strong></p>
        {else}
        {foreach from=$thot item=unParent}
            <p><strong>{$unParent.formule} {$unParent.nom} {$unParent.prenom}</strong></p>
            <p>Nom d'utilisateur: <strong>{$unParent.userName}</strong> Adresse mail: <strong>{$unParent.mail}</strong></p>
            <p>Adresse mail {if $unParent.confirme == 0}<strong>NON</strong>{/if} confirmée</p>
        {/foreach}
    {/if}

    <p style="margin-left: 500px; margin-top:50px;">Signature</p>

</page>
