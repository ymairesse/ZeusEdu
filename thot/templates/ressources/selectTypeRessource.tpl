<select class="form-control" name="typeRessource" id="typeRessource">
    <option value="">Sélectionner</option>
    {foreach from=$typeRessources key=id item=ressource}
        <option value="{$id}" {if isset($idType) && ($idType == $id)}selected{/if}>{$ressource}</option>
    {/foreach}
</select>
