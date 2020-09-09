{$idListe}
<h3>Création d'une liste</h3>

<form role="form" name="creation" id="creation" method="POST" action="index.php" class="form-vertical" role="form">

    <input type="text" placeholder="Nom de la liste à créer" maxlenght="32" id="nomListe" name="nomListe" class="form-control">
    <div class="btn-group pull-right">
        <button type="reset" class="btn btn-default">Annuler</button>
        <button type="button" class="btn btn-primary" id="btn-createList">Créer la liste</button>
    </div>

    {if $listesPerso|count > 0}
        <h4>Listes existantes</h4>
        <table class="table table-condensed table-striped">
        <tr>
            <thead>
            <th>Listes</th>
            <th>Membres</th>
            </thead>
        </tr>
        {foreach from=$listesPerso key=unIdListe item=liste}
        <tr{if $unIdListe == $idListe} class="selected"{/if}>
            <td class="pop"
                data-container="body"
                data-original-title="{$liste.nomListe}: {$liste.membres|count|default:0} membres"
                data-content="{foreach from=$liste.membres key=acronyme item=wtf}{$acronyme} {/foreach}"
                data-placement="top">
                {$liste.nomListe}
            </td>
            <td>{$liste.membres|count}</td>
        </tr>
        {/foreach}
        </table>
    {/if}

</form>
