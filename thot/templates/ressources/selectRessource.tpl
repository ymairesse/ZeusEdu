<div class="form-group">
    <label for="selRessource"></label>

    <select class="form-control" name="selectRessource[]" id="selectRessource" multiple size="15">
    {if !(isset($listeRessources))}
        <option value="">Sélectionner d'abord un type</option>
        {else}

        {foreach from=$listeRessources key=idRes item=data }
        <option value="{$idRes}"{if (isset($idRessource)) && ($idRes == $idRessource)} selected{/if}>{$data.description}</option>
        {/foreach}
    {/if}
    </select>
</div>
