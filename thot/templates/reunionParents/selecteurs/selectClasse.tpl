<div class="form-group">
    <select class="form-control" name="classe" id="classe">
        <option value="">Classe</option>
        {foreach from=$listeClasses item=uneClasse}
            <option value="{$uneClasse}"{if isset($classe) && ($uneClasse == $classe)} selected{/if}>{$uneClasse}</option>
        {/foreach}
    </select>

</div>
