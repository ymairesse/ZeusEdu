{foreach from=$listesPerso key=idListe item=liste}
    <tr data-idliste="{$idListe}">
        <td data-container="body"
            title="{$liste.membres|count|default:0} membres|{foreach from=$liste.membres key=acronyme item=wtf}{$acronyme} {/foreach}">
            <input type="text" name="nomListe_{$idListe}" maxlength="32" value="{$liste.nomListe}" class="form-control nomListe">
        </td>
        <td style="text-align:center">
            <input type="radio" name="statut_{$idListe}" {if $liste.statut == 'prive'}checked="checked"{/if} value="prive">
        </td>
        <td style="text-align:center">
            <input type="radio" name="statut_{$idListe}" {if $liste.statut == 'publie'}checked="checked"{/if} value="publie">
        </td>
        <td>
            <button type="button" class="btn btn-success btn-xs btn-editListe"><i class="fa fa-save"></i></button>
        </td>
    </tr>
{/foreach}
