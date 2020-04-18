<div class="row">

    <div class="col-xs-3">

        <div class="form-group">
            <label for="classe">Classe</label>
            <select class="form-control" name="classe" id="classe" size="6">
                {foreach from=$listeClassesNiveau key=wtf item=classe}
                    <option title="{$classe}" value="{$classe}">{$classe}</option>
                {/foreach}
            </select>
        </div>

    </div>

    <div class="col-xs-9">
        <div class="form-group" id="detailsEleves">
            <select class="form-control" name="listeEleves[]" id="listeEleves">
                <option value="">D'abord choisir une classe</option>
            </select>
            <span class="help-block">Ctrl pour sélection multiple</span>
        </div>
    </div>

</div>
