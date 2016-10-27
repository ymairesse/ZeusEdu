<script type="text/javascript" src="../ckeditor/ckeditor.js"></script>

<div class="box">

    <div id="evalDateHeure">

    </div>

    <select class="form-control" id="selectEleve">
        <option value="">Sélectionnez un élève</option>
        {foreach from=$listeTravaux key=matricule item=dataTravail}
        <option class="{if $dataTravail.remis == 1}remis{else}nonRemis{/if}" value="{$matricule}" data-photo="{$dataTravail.photo}" data-idtravail="{$dataTravail.idTravail}">
            {$dataTravail.groupe} - {$dataTravail.nom} {$dataTravail.prenom}
            {if $dataTravail.cote != ''} [ {$dataTravail.cote}/{$dataTravail.max} ] {/if}
        </option>
        {/foreach}

    </select>

    <div id="detailsEvaluation" class="hidden">

        <h4 id="nomEleve"></h4>

        <p>
            <strong id="fileName" class="nomFichier"></strong>
             -> <strong id="fileSize"></strong>
             Remis le: <strong id="dateRemise"></strong>
         </p>

        <form class="form-vertical" id="evalTravail">
            <div class="row">

                <div class="col-sm-10">
                    <fieldset class="info">
                        <legend>Remarque de l'élève</legend>
                        <p class="form-control-static" id="remarque"></p>
                    </fieldset>

                    <div class="row">

                            <div class="col-xs-3">
                                <div class="form-group">
                                    <label for="cote">Cote</label>
                                    <input type="text" class="form-control" name="cote" value="" id="cote">
                                </div>

                            </div>

                            <div class="col-xs-3">
                                <div class="form-group">
                                    <label for="max">Max</label>
                                    <input type="text" class="form-control" name="max" value="" id="max">
                                </div>
                            </div>

                            <div class="col-xs-3">
                                {* <div class="form-group">
                                    <label for="statut">Fermé</label>
                                    <input type="checkbox" class="form-control" name="statut" id="statutEval" value="1">
                                    <p class="help-block">Fermé=non attendu</p>
                                </div> *}
                                &nbsp;
                            </div>

                    </div>
                </div>

                <div class="col-sm-2">
                    <button type="button" class="btn btn-primary btn-block" id="saveEval">Enregistrer</button>
                    <div id="photo"> </div>
                </div>

            </div>

            <div class="form-group">
                <label for="evaluation">Commentaire</label>
                <textarea name="evaluation" class="form-control" id="editeurEvaluation"></textarea>
            </div>

            <input type="hidden" name="idTravail" id="idTravailEval" value="">
            <input type="hidden" name="matricule" id="matriculeEval" value="">

        </form>

    </div>

</div>

<script type="text/javascript">
    $(document).ready(function() {

        CKEDITOR.replace('editeurEvaluation');

        $("#hideShowConsignes").click(function() {
            $("#consignes").toggle('slow');
        })

        $("#cote, #max").blur(function(e) {
            laCote = $(this).val().replace(',', '.');
            $(this).val(laCote);
        })

    })
</script>
