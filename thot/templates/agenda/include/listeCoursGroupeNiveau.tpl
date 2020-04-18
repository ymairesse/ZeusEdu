<div class="row">

    <div class="col-xs-6">
        <div class="form-group">
            <select class="form-control" name="coursGrp" id="coursGrp" size="6">
                {foreach from=$listeCoursGrpNiveau key=coursGrp item=data}
                    {assign var=listeProfs value=$listeProfsCoursGrp.$coursGrp|implode:'/'}
                    <option title="{$listeProfs}" value="{$coursGrp}">[{$coursGrp}] {$data.statut} {$data.libelle} {$data.nbheures}h [{$listeProfs}]</option>
                {/foreach}
            </select>
        </div>
    </div>

    <div class="col-xs-6">

        <div class="form-group" id="detailsEleves">
            <select class="form-control" name="listeEleves[]" id="listeEleves">
                <option value="">D'abord choisir un cours</option>
            </select>
            <span class="help-block">Ctrl pour sélection multiple</span>
        </div>
    </div>

</div>
