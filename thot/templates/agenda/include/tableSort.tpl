<table class="table table-condensed" id="tableCategories">
    <tr>
        <th>&nbsp;</th>
        <th>Libellé</th>
        <th colspan="2">Ordre</th>
        <th>&nbsp;</th>
    </tr>
    {foreach from=$listeCategories key=idCategorie item=mention name=boucle}
    <tr data-idcategorie="{$mention.idCategorie}" data-ordre="{$smarty.foreach.boucle.index}">
        <td>
            <button type="button" class="btn btn-danger btn-xs btn-delCategorie" data-idcategorie="{$mention.idCategorie}" class="btn-delCategorie" {if in_array($mention.idCategorie, $usedCategories)} disabled{/if}>
            <i class="fa fa-times"></i>
            </button>
        </td>
        <td>
            <div class="input-group">
                <input type="text" class="form-control uneCategorie" name="mention[]" maxlength="30" value="{$mention.categorie}" data-idcategorie={$mention.idCategorie}
                {if in_array($mention.idCategorie, $usedCategories)} readonly title="Cette mention ne peut être modifiée"{/if}>
               <div class="input-group-btn">
                 <button class="btn btn-default btn-saveMention" type="button"{if in_array($mention.idCategorie, $usedCategories)} disabled{/if}>
                   <i class="fa fa-save"></i>
                 </button>
               </div>
            </div>

        </td>
        <td>
            {if $smarty.foreach.boucle.last}
            &nbsp;
            {else}
            <button type="button" class="btn btn-warning btn-down btn-xs" data-id="{$mention.idCategorie}"><i class="fa fa-arrow-down"></i></button>
            {/if}
        </td>
        <td>
            {if $smarty.foreach.boucle.first}
            &nbsp;
            {else}
            <button type="button" class="btn btn-warning btn-up btn-xs" data-id="{$mention.idCategorie}"><i class="fa fa-arrow-up"></i></button>
            {/if}
        </td>
        <td>
            &nbsp;
        </td>
    </tr>

    {/foreach}

    <tr>
        <td>&nbsp;</td>
        <td>
            <div class="input-group">
                <input type="text"
                    class="form-control"
                    name="newMention"
                    id="newMention"
                    maxlength="30"
                    style="background: #afa"
                    value="" placeholder="Nouvelle mention à ajouter">
               <div class="input-group-btn">
                 <button class="btn btn-success btn-saveNewMention" type="button">
                   <i class="fa fa-save"></i>
                 </button>
               </div>
            </div>
        </td>
        <td colspan="3">&nbsp;</td>
    </tr>

</table>
