<option value="">Classe</option>
{if isset($listeClasses)}
    {foreach from=$listeClasses item=uneClasse}
        <option value="{$uneClasse}"{if isset($classe) && ($uneClasse == $classe)} selected{/if}>
            {$uneClasse}
        </option>
    {/foreach}
{/if}
