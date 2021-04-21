<div class="panel panel-success">
    <div class="panel-heading">
        Partager
        <div id="ajaxLoader" class="hidden">
            <p>Veuillez patienter</p>
            <img src="../images/ajax-loader.gif" alt="loading" class="center-block">
        </div>
    </div>
    <div class="panel-body">

        <div style="padding: 1em; 0">
            <label class="radio-inline rw" style="padding: 0.2em 0 0.2em"><input type="radio" name="moderw" value="rw" checked>Lecture/Écriture</label>
            <label class="radio-inline r" style="padding: 0.2em 0 0.2em"><input type="radio" name="moderw" value="r">Lecture</label>
            <label class="radio-inline a" style="padding: 0.2em 0 0.2em"><input type="radio" name="moderw" value="release">Arrêt du partage</label>
        </div>

        <div class="form-group">
            <select class="form-control" name="acronyme[]" id="acronyme" size="20" multiple>
                {foreach from=$listeProfs key=acronyme item=dataProf}
                <option value="{$acronyme}">{$dataProf.nom} {$dataProf.prenom}</option>
                {/foreach}
            </select>
        </div>

        <button type="button" class="btn btn-success btn-block" id="btn-shareProf">Partager</button>

    </div>
    <div class="panel-footer">
        Maj ou Ctrl pour sélectionner plusieurs lignes
    </div>

</div>
