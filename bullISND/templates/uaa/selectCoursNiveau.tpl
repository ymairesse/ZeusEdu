<div class="form-group">
    
    <select class="form-control" name="listeCours[]" id="listeCours" size="5" multiple>
        {foreach from=$listeCours key=cours item=data}
        <option value="{$cours}">[{$cours}] {$date.statut} {$data.libelle} {$data.nbheures}</option>
        {/foreach}
    </select>
    <div class="help-block">Choisir un ou plusieurs cours (Maj/Ctrl)</div>

</div>
