{if $listesPerso|count > 0}
    <h4>Listes existantes</h4>
    <table class="table table-condensed" id="tableListes">
        <thead>
        <tr>
            <th>Listes</th>
            <th style="width:4em">Membres</th>
            <th style="width:2em">&nbsp;</th>
        </tr>
        </thead>

        {foreach from=$listesPerso key=unIdListe item=liste}
            <tr data-idliste="{$unIdListe}"{if isset($idListe) && $unIdListe == $idListe} class="selected"{/if}>
                <td class="pop"
                    data-container="body"
                    data-html="true"
                    data-content="{$liste.membres|count|default:0} membres<br>Cliquez pour le détail"
                    data-original-title="{$liste.nomListe}"
                    data-placement="top">
                    {$liste.nomListe}
                </td>
                <td>{$liste.membres|count}</td>
                <td><button type="button" class="btn btn-danger btn-xs btn-delListe"> <i class="fa fa-times"></i> </button></td>
            </tr>
        {/foreach}

    </table>
    {else}
    <p class="avertissement">Veuillez créer une liste</p>
    {/if}
