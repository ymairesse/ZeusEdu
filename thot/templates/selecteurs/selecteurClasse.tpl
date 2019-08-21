<div class="form-group">
    <label for="classe">Classe</label>
    <select class="form-control" name="classe" id="classe">
        <option value="">Choisir la classe</option>
        {foreach from=$listeClasses item=classe}
        <option value="{$classe}">{$classe}</option>
        {/foreach}
    </select>
</div>
