<div class="form-group">
    <label for="eleves">Élèves</label>
    <select class="form-control" name="matricules[]" id="matricules" size="15" multiple>

        {foreach from=$listeEleves  key=matricule item=dataEleve}
            <option value="{$matricule}">{$dataEleve.groupe} {$dataEleve.nom} {$dataEleve.prenom}</option>
        {/foreach}

    </select>

    <div class="help-block">
        Sélectionnez un ou plusieurs élèves (Maj / Ctrl)
    </div>
</div>
