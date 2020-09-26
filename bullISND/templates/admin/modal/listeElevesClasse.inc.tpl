<form id="formEleves">

    <label for="eleves">Élèves</label>
    <select class="form-control" name="listeEleves[]" id="listeEleves" size="10" multiple style="max-height:15em; overflow: auto;">
        {foreach from=$listeEleves key=matricule item=data}
        <option value="{$matricule}">{$data.groupe} {$data.nom} {$data.prenom}</option>
        {/foreach}
    </select>
    <div class="help-block">Ctrl / Maj pour sélection multiple</div>

</form>
