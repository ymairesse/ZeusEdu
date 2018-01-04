<option value="">Classe</option>
{if isset($listeClasses)}
    {foreach from=$listeClasses item=classe}
        <option value="{$classe}">{$classe}</option>
    {/foreach}
{/if}
