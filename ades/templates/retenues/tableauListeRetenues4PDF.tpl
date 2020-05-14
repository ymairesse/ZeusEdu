<style type="text/css">

    table.retenues {
        border: solid 1px #777;
        border-collapse: collapse;
        width: 100%
    }
    table.retenues td, th {
        border: solid 1px #777;
        text-align: center;
        height: 20px;
    }
    table.retenues td.retenuesNom {
        text-align: left;
    }

</style>

<page backtop="10mm" backbottom="25mm" backleft="7mm" backright="10mm" footer="date">

    <img src="{$BASEDIR}/images/logoEcole.png" style="float:right">

<h4>{$infosRetenue.titrefait}: le {$infosRetenue.dateRetenue} à {$infosRetenue.heure} Local {$infosRetenue.local}  Durée: {$infosRetenue.duree}h</h4>

<p>Nombre d'élèves {$infosRetenue.occupation} inscrits / {$infosRetenue.places} places</p>

<table class="retenues" style="width:100%">
    <thead>
        <tr>
            <th style="width:20px">&nbsp;</th>
            <th>Nom de l'élève</th>
            <th style="width:40px">Classe</th>
            <th>Travail à effectuer</th>
            <th style="width:80px">Professeur</th>
            <th style="width:50px">Présent</th>
            <th style="width:50px">Signé</th>
        </tr>
    </thead>
    {assign var=n value=1}
    {foreach from=$listeEleves key=matricule item=unEleve}
    <tr>
        <td>{$n}</td>
        <td style="width:150px;" class="retenuesNom">
            {$unEleve.nomPrenom}
        </td>
        <td>{$unEleve.groupe|default:'&nbsp;'}</td>
        <td style="width:230px;">{$unEleve.travail|default:'&nbsp;'}</td>
        <td>{$unEleve.professeur|default:'&nbsp;'}</td>
        <td>{if $unEleve.present}X{/if}</td>
        <td>{if $unEleve.signe}X{/if}</td>
        {assign var=n value=$n+1}
    </tr>
    {/foreach}

</table>

</page>
