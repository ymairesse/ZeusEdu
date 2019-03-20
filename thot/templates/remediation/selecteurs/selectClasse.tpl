<div class="form-group">
    <label for="classe">Classe</label>
    <select class="form-control" name="classe" id="classeEleve">
        <option value="">Classe</option>
        {foreach from=$listeClasses item=classe}
            <option value="{$classe}">{$classe}</option>
        {/foreach}
    </select>
</div>
