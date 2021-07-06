<select class="form-control" name="typeRessource" id="typeRessource">
    <option value="">Sélectionner</option>
    {foreach from=$typeRessources key=unId item=ressource}
        <option value="{$unId}" {if isset($idType) && ($idType === $unId)}selected{/if}>{$ressource}</option>
    {/foreach}
</select>
