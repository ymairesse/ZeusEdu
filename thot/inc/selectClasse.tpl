<label for="classe" class="sr-only">Classe</label>
<select class="form-control" name="classe" id="classe" required>
    <option value="">Choisir la classe</option>
    {foreach from=$listeClasses key=wtf item=classe}
    <option value="{$classe}">{$classe}</option>
    {/foreach}
</select>
