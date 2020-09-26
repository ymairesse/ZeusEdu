{if isset($listeClasses)}
    {foreach from=$listeClasses item=uneClasse}
        <option value="{$uneClasse}"{if isset($classe) && ($classe == $uneClasse)} selected{/if}>{$uneClasse}</option>
    {/foreach}
{/if}
