<label for="coursGrp" class="sr-only">Cours</label>

<select class="form-control" name="coursGrpProf" id="coursGrpProf" required>
    <option value="">Choisir le cours</option>
    {foreach from=$listeCoursProf key=coursGrp item=data}
    <option value="{$coursGrp}">
        [{$coursGrp}] {$data.statut} {$data.libelle} {$data.nbheures}h {$data.classes}{if $data.virtuel == 1} *{/if}
    </option>
    {/foreach}
</select>

* = cours virtuel
