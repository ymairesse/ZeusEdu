<script type="text/javascript" src="../ckeditor/ckeditor.js"></script>

<div class="container">

    <div class="row">

        <div class="col-md-4 col-sm-12">

            <button type="button" class="btn btn-primary btn-block" id="newTravail">Nouveau travail</button>

            <div id="ajaxLoader" class="hidden">
                <img src="images/ajax-loader.gif" alt="loading" class="center-block">
            </div>

            <select class="form-control" name="selectCours" id="selectCours">
                <option value="">Sélectionnez un cours</option>
                {foreach from=$listeCours key=ceCoursGrp item=dataCours}
                <option value="{$ceCoursGrp}" {if $ceCoursGrp==$coursGrp} selected{/if}>{$dataCours.coursGrp} {$dataCours.nomCours|default:$dataCours.libelle} {$dataCours.nbheures}h</option>
                {/foreach}
            </select>

            <div id="listeTravaux">

            </div>

            <div id="detailsTravail">

            </div>

        </div>

        <div class="col-md-8 col-sm-12">


            <div id="editTravail" class="hidden">

                {include file='casier/editTravail.tpl'}

            </div>

            <div id="showTravail" class="hidden">

                {* emplacement pour showTravauxRemis.tpl (généré en Ajax) *}
            </div>

        </div>

    </div>

</div>

<div class="modal fade" id="modalConsignes" tabindex="-1" role="dialog" aria-labelledby="titleModalConsignes" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
        <h4 class="modal-title" id="titleModalConsignes">Rappel des consignes</h4>
      </div>
      <div class="modal-body">

      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-default" data-dismiss="modal">Fermer</button>
      </div>
    </div>
  </div>
</div>

<div class="modal fade" id="modalDelTravail" tabindex="-1" role="dialog" aria-labelledby="titleModalDelTravail" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
        <h4 class="modal-title" id="titleModalDelTravail">Effacement définitif d'un travail</h4>
      </div>
      <div class="modal-body alert alert-danger">
          <p>Veillez confirmer la suppression définitive du travail suivant:</p>
          <h3 id="modalTitreDel"></h3>
          <p>Date de début: <strong id="modalDateDebut"></strong><br>
              Date de fin: <strong id="modalDateFin"></strong>
          </p>
          <p>Nombre de travaux remis par les élèves et qui seront effacés: <strong id="modalNbRemis"></strong></p>

      </div>
      <div class="modal-footer">
          <div class="btn-group pull-right">
              <button type="button" class="btn btn-default" data-dismiss="modal">Annuler</button>
              <button type="button" class="btn btn-danger" id="btnConfirmDelTravail" data-idtravail="">Confirmer</button>
          </div>

      </div>
    </div>
  </div>
</div>

<script type="text/javascript">
    $(document).ready(function() {

        $(document).ajaxStart(function() {
            $('#ajaxLoader').removeClass('hidden');
        }).ajaxComplete(function() {
            $('#ajaxLoader').addClass('hidden');
        });

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

        $("#selectCours").change(function() {
            $("#editTravail").addClass('hidden');
            $("#showTravail").addClass('hidden');
            var coursGrp = $(this).val();
            $.post('inc/casier/listeTravaux.inc.php', {
                    coursGrp: coursGrp
                },
                function(resultat) {
                    $("#listeTravaux").html(resultat);
                })
        })

        $("#dateDebut").datepicker({
                format: "dd/mm/yyyy",
                clearBtn: true,
                language: "fr",
                calendarWeeks: true,
                autoclose: true,
                todayHighlight: true
            })
            .off('focus')
            .click(function() {
                $(this).datepicker('show');
            });

        $("#dateFin").datepicker({
            format: "dd/mm/yyyy",
            clearBtn: true,
            language: "fr",
            calendarWeeks: true,
            autoclose: true,
            todayHighlight: true
        });

        // création d'un nouveau travail
        $("#newTravail").click(function() {
            $("#showTravail").addClass('hidden');
            // suppression des messages d'erreur de jquery validate
            var idTravail = null;
            var coursGrp = $("#selectCours").val();
            $.post('inc/casier/getDataTravail.inc.php', {
                    idTravail: idTravail,
                    coursGrp: coursGrp
                },
                function(resultat) {
                    var obj = JSON.parse(resultat);
                    $("#coursGrp").val(coursGrp).attr('disabled', false);
                    $("#titre").val(obj.titre);
                    CKEDITOR.instances['consigne'].setData('');
                    $("#dateDebut").val(obj.dateDebut);
                    $("#dateFin").val(obj.dateFin);
                    $("#statutForm").val(obj.statut);
                    $("#idTravail").val('');
                    $("#editTravail").removeClass('hidden');
                });
        })

        // édition des consignes, etc...
        $("#listeTravaux").on('click', '.btnEdit', function() {
            $("#showTravail").addClass('hidden');
            // suppression des messages d'erreur de jquery validate
            $("#editTravail label.error").hide()
            $('.btnShowTravail').removeClass('active');
            $(this).prev().addClass('active');
            var idTravail = $(this).closest('div').data('idtravail');
            var coursGrp = $("#selectCours").val();
            $.post('inc/casier/getDataTravail.inc.php', {
                        idTravail: idTravail,
                        coursGrp: coursGrp
                    },
                    function(resultat) {
                        var obj = JSON.parse(resultat);
                        $("#coursGrp").val(obj.coursGrp).attr('disabled', true);
                        $("#titre").val(obj.titre);
                        CKEDITOR.instances['consigne'].setData(obj.consigne);
                        $("#dateDebut").val(obj.dateDebut);
                        $("#dateFin").val(obj.dateFin);
                        $("#statut").val(obj.statut);
                        $("#idTravail").val(idTravail);
                        $("#editTravail").removeClass('hidden');
                    })
                // Actualiser les détails du travail (dates, etc)
            $.post('inc/casier/detailsTravail.inc.php', {
                    idTravail: idTravail
                },
                function(resultat) {
                    $("#detailsTravail").html(resultat);
                })
            $("#showTravail").addClass('hidden');
        })

        // voir et évaluer les travaux
        $("#listeTravaux").on('click', '.btnShowTravail', function() {
            $("#editTravail").addClass('hidden');
            // désactiver tous les boutons
            $('.btnShowTravail').removeClass('active');
            // activer celui-ci
            $(this).addClass('active');
            var idTravail = $(this).closest('div').data('idtravail');
            // dates du travail, consignes, etc..
            $.post('inc/casier/detailsTravail.inc.php', {
                        idTravail: idTravail
                    },
                    function(resultat) {
                        $("#detailsTravail").html(resultat);
                    })
                // cadre d'évaluation du travail
            $.post('inc/casier/listeTravauxRemis.inc.php', {
                    idTravail: idTravail
                },
                function(resultat) {
                    $("#showTravail").html(resultat).removeClass('hidden');
                })
        })

        // Enregistrement d'une définition d'un travail ---------------------------
        $("#editTravail").on('click', "#btnSubmit", function() {
            if ($("#formTravail").valid()) {
                var coursGrp = $("#coursGrp").val();
                var titre = $("#titre").val();
                var consigne = $("#consigne").val();
                var dateDebut = $("#dateDebut").val();
                var dateFin = $("#dateFin").val();
                var statut = $("#statut").val();
                var idTravail = $("#idTravail").val();
                $.post('inc/casier/postTravail.inc.php', {
                        idTravail: idTravail,
                        coursGrp: coursGrp,
                        titre: titre,
                        consigne: consigne,
                        dateDebut: dateDebut,
                        dateFin: dateFin,
                        statut: statut,
                    },
                    function(resultat) {
                        var obj = JSON.parse(resultat);
                        var coursGrp = obj.coursGrp;
                        var idTravail = obj.idTravail;
                        var date = obj.date;
                        $("#coursGrp").val(coursGrp);
                        $("#selectCours").val(coursGrp);
                        // actualiser la liste des travaux à gauche de l'écran
                        $.post('inc/casier/listeTravaux.inc.php', {
                                coursGrp: coursGrp,
                                idTravail: idTravail
                            },
                            function(resultat) {
                                $("#listeTravaux").html(resultat);
                                $("#selectTravail").val(idTravail);
                                $("li[data-idtravail='" + idTravail + "']").addClass('active');

                            });
                        // Actualiser les détails du travail (dates, etc)
                        $.post('inc/casier/detailsTravail.inc.php', {
                                idTravail: idTravail
                            },
                            function(resultat) {
                                $("#detailsTravail").html(resultat);
                            });
                        // Confirmation de l'enregistrement avec date et heure
                        $.post('inc/casier/alertSave.inc.php',{
                                date: date
                            },
                        function(resultat){
                            $("#editDateHeure").html(resultat);
                        })
                    });

            }
        })

        $("#showTravail").on('change', "#selectEleve", function() {
            var matricule = $(this).val();
            if (matricule != '') {
                var idTravail = $(this).find(':selected').data('idtravail');
                var photo = $(this).find(':selected').data('photo');
                $.post('inc/casier/getResultatTravail.inc.php', {
                        idTravail: idTravail,
                        matricule: matricule
                    },
                    function(resultat) {
                        var obj = JSON.parse(resultat);
                        $("#idTravailEval").val(obj.idTravail);
                        $("#matriculeEval").val(matricule);
                        $("#dateRemise").text(obj.fileInfos.dateRemise);
                        var fileName = obj.fileInfos.fileName;
                        if (fileName != null) {
                            var html = '<a href="inc/download.php?type=pTrEl&amp;idTravail=##idTravail##&amp;matricule=##matricule##">##fileName##</a>'
                            html = html.replace('##matricule##', matricule);
                            html = html.replace('##idTravail##', idTravail);
                            html = html.replace('##fileName##', fileName);
                            $("#fileName").html(html);
                        } else $('#fileName').html('Non remis');

                        $("#fileSize").text(obj.fileInfos.size);
                        $("#remarque").text(obj.remarque);
                        $("#cote").val(obj.cote);
                        $("#max").val(obj.max);
                        CKEDITOR.instances.editeurEvaluation.setData(obj.evaluation);
                        var textePhoto = "<img class='img-responsive' src='../photos/" + photo + ".jpg' alt='" + matricule + "'>";
                        $("#photo").html(textePhoto)
                        $("#detailsEvaluation").removeClass('hidden');
                    })
            }
            else $("#detailsEvaluation").addClass('hidden');

        })

        $("#showTravail").on('click', "#saveEval", function() {
            var idTravail = $("#idTravailEval").val();
            var max = $("#max").val();
            var cote = $("#cote").val();
            var statut = $("#statutEval").is(':checked');
            var evaluation = CKEDITOR.instances.editeurEvaluation.getData();
            var matricule = $("#matriculeEval").val();
            $.post('inc/casier/postEvaluation.inc.php', {
                idTravail: idTravail,
                matricule: matricule,
                max: max,
                cote: cote,
                statut: statut,
                evaluation: evaluation
            }, function(resultat) {
                $("#evalDateHeure").html(resultat);
            })
        })

        $("#detailsTravail").on('click', '#btnVoirConsignes', function(){
            var consigne = $(this).data('consigne');
            $("#modalConsignes .modal-body").html(consigne);
            $("#modalConsignes").modal('show');
        })

        $("#listeTravaux").on('click', '.btnDelete', function(){
            var idTravail = $(this).closest('div').data('idtravail');
            $.post('inc/casier/getConfirmDelTravail.inc.php', {
                idTravail: idTravail
            },
            function(resultat){
                var obj = JSON.parse(resultat);
                var idTravail = obj.idTravail;
                var titre = obj.titre;
                var dateDebut = obj.dateDebut;
                var dateFin = obj.dateFin;
                var nbRemis = obj.nbRemis;
                $("#modalTitreDel").html(titre);
                $("#modalDateDebut").html(dateDebut);
                $("#modalDateFin").html(dateFin);
                $("#modalNbRemis").html(nbRemis);
                $("#modalDelTravail").modal('show');
                $("#btnConfirmDelTravail").data('idtravail', idTravail);
            })
        });

        $("#btnConfirmDelTravail").click(function(){
            var idTravail = $(this).data('idtravail');
            $.post('inc/casier/delTravail.inc.php', {
                idTravail: idTravail
            },
            function(resultat){

            })
            var coursGrp = $("#selectCours :selected").val();
            $.post('inc/casier/listeTravaux.inc.php', {
                    coursGrp: coursGrp
                },
                function(resultat) {
                    $("#listeTravaux").html(resultat);
                    $("#editTravail").addClass('hidden');
                    $("#showTravail").addClass('hidden');
                });
            $("#modalDelTravail").modal('hide');
        })

    })
</script>
