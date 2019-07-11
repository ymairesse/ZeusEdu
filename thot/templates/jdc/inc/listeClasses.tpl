<select class="form-control" name="classe" id="selectClasse">
    <option value="">Limiter à une classe (optionnel)</option>
    {foreach from=$listeClasses key=wtf item=classe}
    <option value="{$classe}">{$classe}</option>
    {/foreach}
</select>
