<form id="formElevesCours">
    <div class="form-group">
        <label for="listeElevesCoursGrp">Élèves qui suivent le cours <span class="badge badge-primary">{$listeElevesCoursGrp|@count|default:0}</span></label>
        <select class="form-control" name="listeElevesCoursGrp[]" id="listeElevesCoursGrp" size="{$listeElevesCoursGrp|@count}" multiple style="max-height:25em; overflow:auto">
            {foreach from=$listeElevesCoursGrp key=matricule item=dataEleve}
            <option value="{$matricule}">{$dataEleve.groupe} {$dataEleve.nom} {$dataEleve.prenom}</option>
            {/foreach}
        </select>
        <div class="help-block">Ctrl / Maj pour sélection multiple</div>
    </div>
</form>
