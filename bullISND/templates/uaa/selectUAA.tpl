<form id="formSelectUAA">
    <div class="form-group">
        <select class="form-control" name="listeUAA[]" id="listeUAA" multiple size="20">
            {foreach from=$listeUAA key=idUAA item=libelle}
            <option value="{$idUAA}" {if isset($UAA) && ($idUAA == $UAA)}selected{/if}>{$libelle}</option>
            {/foreach}
        </select>
    </div>
</form>
