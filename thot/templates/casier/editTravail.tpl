<form class="form-vertical" id="formTravail" name="formTravail" action="index.php" method="POST">

    <div class="row">

        <div class="col-xs-5">
            <label for="titre">Titre du travail</label>
            <input type="text" name="titre" maxlength="40" tabindex="1" value="{$dataTravail.titre|default:''}" id="titre" class="form-control" placeholder="Titre du travail">
        </div>

        <div class="col-xs-2">
            <div class="form-group">
                <label for="dateDebut">Date début</label>
                <input type="text" name="dateDebut" id="dateDebut" tabindex="3" placeholder="Date de début" class="datepicker form-control" value="{$dataTravail.dateDebut|default:''}">
            </div>
        </div>

        <div class="col-xs-2">
            <div class="form-group">
                <label for="dateFin">Date de fin</label>
                <input type="text" name="dateFin" id="dateFin" tabindex="4" placeholder="Date de fin" class="datepicker form-control" value="{$dataTravail.dateFin|default:''}">
            </div>
        </div>

        <div class="col-xs-3">
            <div class="form-group">
                <label for="statutForm">Statut</label>
                <select class="form-control" name="statut" id="statut" tabindex="5">
                    {foreach from=$listeStatuts key=unStatut item=libelle}
                    <option value="{$unStatut}" {if $dataTravail.statut == $unStatut} selected{/if}>{$libelle}</option>
                    {/foreach}
                </select>
            </div>
        </div>

    </div> <!-- row -->

    <div class="row">
        <div class="col-xs-12">
            <div class="form-group">
                <label for="modalConsigne"></label>
                <textarea name="consigne" id="consigne" tabindex="2" class="form-control ckeditor">{$dataTravail.consigne|default:''}</textarea>
                <p class="help-block">Consignes pour ce travail</p>
            </div>
        </div>
    </div>

    <div id="competences" class="row">

        <table class="table table-condensed" id="tableCompetences">
            <thead>
                <tr>
                    <th style="width:5%">&nbsp;</th>
                    <th style="width:60%">Competence</th>
                    <th style="width:20%">Form. / Cert.</th>
                    <th style="width:10%">Max</th>
                </tr>
            </thead>
            <tbody>

                {include file="casier/tableauCompetences.tpl"}

            </tbody>

        </table>

        <div class="clearfix"></div>
        <div class="col-xs-6">
            <button type="button" class="btn btn-info btn-block{if $dataTravail.idTravail == ''} hidden{/if}" id="btn-addCompetence" data-idtravail="{$dataTravail.idTravail|default:''}" data-coursgrp="{$dataTravail.coursGrp}">Ajouter une compétence</button>
        </div>

        <div class="col-xs-4 col-xs-offset-2">
            <button type="button" class="btn btn-primary btn-block pull-right" id="btnSubmit">Enregistrer</button>
        </div>

    </div>

    <input type="hidden" name="idTravail" id="idTravail" value="{$dataTravail.idTravail|default:''}">
    <input type="hidden" name="coursGrp" value="{$dataTravail.coursGrp}">

    </div>

</form>

{include file="casier/modal/modalListeCompetences.tpl"}


<script type="text/javascript">

    $(document).ready(function() {

        $('#titre').focus();

        $("#btn-addCompetence").click(function() {
            var idTravail = $(this).data('idtravail');
            var coursGrp = $(this).data('coursgrp');
            $.post('inc/casier/listeCompetencesLibres.inc.php', {
                    idTravail: idTravail,
                    coursGrp: coursGrp
                },
                function(resultat) {
                    $("#modalListeCompetences .modal-body").html(resultat);
                    $("#modalListeCompetences").modal('show');
                }
            );
        })

        // confirmation dans la boîte modale
        $('#btn-confAddCompetence').click(function() {
            // liste des compétences cochées et activées
            var competences = $(".idCompetence:checked").map(function() {
                return ($(this).val());
            }).get();

            var idTravail = $(this).data('idtravail');
            var coursGrp = $(this).data('coursgrp');
            $.post('inc/casier/addCompetence.inc.php', {
                    idTravail: idTravail,
                    coursGrp: coursGrp,
                    competences: competences
                },
                function(resultat) {
                    $("#tableCompetences tbody").html(resultat);
                    $("#modalListeCompetences").modal('hide');
                })
        })

        $("#formTravail").validate({
            // pour ne pas ignorer le textarea caché par CKEDITOR
            ignore: "input:hidden:not(input:hidden.required)",
            rules: {
                coursGrp: 'required',
                titre: 'required',
                consigne: {
                    required: function() {
                        // mise à jour du textarea depuis le CKEDITOR
                        CKEDITOR.instances.consigne.updateElement();
                    }
                },
                dateDebut: 'required',
                dateFin: 'required'
            },
            errorPlacement: function(error, element) {
                if ($(element).attr('id') == 'consigne') {
                    $('#cke_consigne').after(error);
                } else {
                    element.after(error);
                }
            }
        })

        CKEDITOR.replace('consigne');

        $("input").tabEnter();

        $("#dateDebut").datepicker({
            format: "dd/mm/yyyy",
            clearBtn: true,
            language: "fr",
            calendarWeeks: true,
            autoclose: true,
            todayHighlight: true
        });

        $("#dateFin").datepicker({
            format: "dd/mm/yyyy",
            clearBtn: true,
            language: "fr",
            calendarWeeks: true,
            autoclose: true,
            todayHighlight: true
        });

    })
</script>
