<label for="classe">Classe</label>
<select class="form-control" name="listeClasses" id="listeClasses">
    <option value="">Choisir une classe</option>
    {foreach from=$listeClasses item=classe}
    <option value="{$classe}">{$classe}</option>
    {/foreach}
</select>
