<div class="row">

    <div class="col-xs-6">

        <div class="form-group">
            <select class="form-control" name="cours" id="cours" size="6">
                {foreach from=$listeCoursNiveau key=cours item=data}
                    <option value="{$cours}">[{$cours}] {$data.statut} {$data.libelle} {$data.nbHeures}h</option>
                {/foreach}
            </select>
        </div>

    </div>

    <div class="col-xs-6">

        <div class="form-group" id="detailsEleves">
            <select class="form-control" name="listeEleves[]" id="listeEleves">
                <option value="">D'abord choisir une matière</option>
            </select>
            <span class="help-block">Ctrl pour sélection multiple</span>
        </div>

    </div>

</div>
