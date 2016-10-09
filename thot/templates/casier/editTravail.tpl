<form class="form-vertical" id="formTravail" name="formTravail" action="index.php" method="POST">

    <div class="row">

        <div class="col-sm-12">
            <div id="editDateHeure">

            </div>

            <select class="form-control" name="coursGrp" id="coursGrp">
                <option value="">Sélectionnez un cours</option>
                {foreach from=$listeCours key=coursGrp item=dataCours}
                <option value="{$coursGrp}" {if isset($data.coursGrp) && ($data.coursGrp==$coursGrp)} selected{/if}>
                    {$dataCours.coursGrp} {$dataCours.nomCours|default:$dataCours.libelle} {$dataCours.nbheures}h
                </option>
                {/foreach}
            </select>

        </div>


        <div class="col-sm-12">
            <label for="titre" class="sr-only">Titre du travail</label>
            <input type="text" name="titre" maxlength="40" value="{$data.titre|default:''}" id="titre" class="form-control" placeholder="Titre du travail">

            <div class="form-group">
                <label for="modalConsigne"></label>
                <textarea name="consigne" id="consigne" class="form-control ckeditor">{$data.consigne|default:''}</textarea>
                <p class="help-block">Consignes pour ce travail</p>
            </div>
        </div>

        <div class="col-xs-4">
            <div class="form-group">
                <label for="dateDebut" class="sr-only">Date de début</label>
                <input type="text" name="dateDebut" id="dateDebut" placeholder="Date de début" class="datepicker form-control" value="{$data.dateDebut|default:''}">
            </div>
        </div>

        <div class="col-xs-4">
            <div class="form-group">
                <label for="dateFin" class="sr-only">Date de fin</label>
                <input type="text" name="dateFin" id="dateFin" placeholder="Date de fin" class="datepicker form-control" value="{$data.dateFin|default:''}">
            </div>
        </div>

        <div class="col-xs-4">
            <div class="form-group">
                <label for="statutForm" class="sr-only">Statut</label>
                <select class="form-control" name="statut" id="statut">
                    <option value="readwrite" {if !(isset($data.status)) || $data.status=='readwrite' } selected{/if}>Travail en cours</option>
                    <option value="hidden" {if isset($data.status) && $data.status=='hidden' } selected{/if}>Caché aux élèves</option>
                    <option value="readonly" {if isset($data.status) && $data.status=='readonly' } selected{/if}>Lecture seule</option>
                    <option value="termine" {if isset($data.status) && $data.status=='termine' } selected{/if}>Travail terminé</option>
                </select>
            </div>
        </div>

        <input type="hidden" name="idTravail" id="idTravail" value="">

        <button type="button" class="btn btn-primary pull-right" id="btnSubmit">Enregistrer</button>

    </div>

</form>
