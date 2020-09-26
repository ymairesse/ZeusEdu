<form id="listeProfCours">
    <div class="form-group">
        <label for="listeProfsCoursGrp">Titulaire(s) du cours</label>
        <select class="form-control" name="listeProfsCoursGrp[]" id="listeProfsCoursGrp" size="{$listeProfsCoursGrp|@count}" multiple>
            {foreach from=$listeProfsCoursGrp key=acronyme item=dataProf}
            <option value="{$acronyme}">{$dataProf.formule} {$dataProf.prenom} {$dataProf.nom}</option>
            {/foreach}
        </select>
        <div class="help-block">Ctrl / Maj pour sélection multiple</div>
    </div>
</form>
