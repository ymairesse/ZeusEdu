<form class="form-vertical" id="formTravail">

    <div class="row">

        <div class="col-xs-4">
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

        <div class="col-xs-2">
            <div class="form-group" title="Nombre de documents attendus">
                <label for="nbPJ">Nb Docs</label>
                <input type="text" name="nbPJ" id="nbPJ" tabindex="5" value="{$dataTravail.nbPJ|default:'1'}" class="form-control">
            </div>
        </div>

        <div class="col-xs-2">
            <div class="form-group" title="Statut de ce travail">
                <label for="statutForm">Statut</label>
                <select class="form-control" name="statut" id="statut" tabindex="6">
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
                <textarea name="consigne" id="texte" tabindex="2" class="form-control summernote">{$dataTravail.consigne|default:''}</textarea>
                <p class="help-block">Consignes pour ce travail</p>
            </div>
        </div>
    </div>

    <div id="competences" class="row">

        <table class="table table-condensed" id="tableCompetences">
            <thead>
                <tr>
                    <th style="width:5%">&nbsp;</th>
                    <th style="width:45%">Competence</th>
                    <th style="width:40%">Form. / Cert.</th>
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

    function sendFile(file, el) {
    	var form_data = new FormData();
    	form_data.append('file', file);
    	$.ajax({
    		data: form_data,
    		type: "POST",
    		url: 'editor-upload.php',
    		cache: false,
    		contentType: false,
    		processData: false,
    		success: function(url) {
    			$(el).summernote('editor.insertImage', url);
    		}
    	});
    }

    function deleteFile(src) {
    	console.log(src);
    	$.ajax({
    		data: { src : src },
    		type: "POST",
    		url: 'inc/deleteImage.inc.php',
    		cache: false,
    		success: function(resultat) {
    			console.log(resultat);
    			}
    	} );
    }

    $(document).ready(function() {

        $('#texte').summernote({
            lang: 'fr-FR', // default: 'en-US'
            height: null, // set editor height
            minHeight: 150, // set minimum height of editor
            focus: true, // set focus to editable area after initializing summernote
            toolbar: [
              ['style', ['style']],
              ['font', ['bold', 'underline', 'clear']],
              ['font', ['strikethrough', 'superscript', 'subscript']],
              ['color', ['color']],
              ['para', ['ul', 'ol', 'paragraph']],
              ['table', ['table']],
              ['insert', ['link', 'picture', 'video']],
              ['view', ['fullscreen', 'codeview', 'help']],
            ],
            maximumImageFileSize: 2097152,
            dialogsInBody: true,
            callbacks: {
                onImageUpload: function(files, editor, welEditable) {
                    for (var i = files.length - 1; i >= 0; i--) {
                        sendFile(files[i], this);
                    }
                },
                onMediaDelete : function(target) {
                    deleteFile(target[0].src);
                }
            }
        });

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
            rules: {
                coursGrp: 'required',
                titre: 'required',
                texte: {
                    required: true,
                    minlength: 20
                },
                dateDebut: 'required',
                dateFin: 'required',
                nbPJ: 'required'
            }
        })


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
