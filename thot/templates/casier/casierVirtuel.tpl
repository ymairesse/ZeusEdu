<script type="text/javascript" src="../ckeditor/ckeditor.js"></script>

<div class="container">

    <div class="row">

        <div class="col-md-4 col-sm-12">

            <button type="button" class="btn btn-primary btn-block hidden" id="newTravail">Nouveau travail</button>

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

            <div id="zoneEdition">

            </div>

        </div>

    </div>

</div>

{include file="casier/modal/modalConsignes.tpl"}

{include file="casier/modal/modalDelTravail.tpl"}

{include file="casier/modal/modalDelCompetence.tpl"}

{include file="casier/modal/modalCarnetCotes.tpl"}

<script type="text/javascript">

    $(document).ready(function() {

        $(document).ajaxStart(function() {
            $('#ajaxLoader').removeClass('hidden');
        }).ajaxComplete(function() {
            $('#ajaxLoader').addClass('hidden');
        });

        $("#zoneEdition").on("click", "#carnetCotes", function(){
            var idTravail = $(this).data('idtravail')
            $.post('inc/casier/modalTransfertCarnet.inc.php', {
                idTravail: idTravail
            },
            function(resultat){
                $("#transfert").html(resultat);
            });
            $("#modalCarnetCotes").modal('show');
        })

        $("#btn-transfert").click(function() {
            var formulaire = $("#formTransfert").serialize();
            $.post('inc/casier/transfertCarnet.inc.php', {
                    formulaire: formulaire
                },
                function(resultat) {
                    $("#modalCarnetCotes").modal('hide');
                    bootbox.alert({
                        message: resultat,
                        backdrop: true
                    });
                })
        })

        $("#selectCours").change(function() {
            var coursGrp = $(this).val();
            $.post('inc/casier/listeTravaux.inc.php', {
                    coursGrp: coursGrp
                },
                function(resultat) {
                    $("#listeTravaux").html(resultat);
                });
            if (coursGrp != '') {
                $("#newTravail, #listeTravaux").removeClass('hidden');
            }
            else {
                $("#newTravail, #listeTravaux").addClass('hidden');
            }
        })

        // création d'un nouveau travail
        $("#newTravail").click(function() {
            var idTravail = null;
            var coursGrp = $("#selectCours").val();
            $.post('inc/casier/getDataTravail.inc.php', {
                    idTravail: idTravail,
                    coursGrp: coursGrp
                },
                function(resultat) {
                    $("#zoneEdition").html(resultat);
                });
        })

        // édition des consignes, etc...
        $("#listeTravaux").on('click', '.btnEdit', function() {
            var idTravail = $(this).closest('div').data('idtravail');
            var coursGrp = $("#selectCours").val();
            $.post('inc/casier/getDataTravail.inc.php', {
                    idTravail: idTravail,
                    coursGrp: coursGrp
                },
                function(resultat) {
                    $("#zoneEdition").html(resultat);
                });

            // Actualiser les détails du travail (dates, etc)
            $.post('inc/casier/detailsTravail.inc.php', {
                    idTravail: idTravail
                },
                function(resultat) {
                    $("#detailsTravail").html(resultat);
                })
        })

        // voir et évaluer les travaux
        $("#listeTravaux").on('click', '.btnShowTravail', function() {
            // désactiver tous les boutons
            $('.btnShowTravail').removeClass('active');
            // activer celui qui vient d'être sélectionné
            $(this).addClass('active');
            var idTravail = $(this).closest('div').data('idtravail');
            // dates du travail, consignes, etc.. au bas de la liste des travaux
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
                    $("#zoneEdition").html(resultat);
                })
        })

        // Enregistrement d'une définition d'un travail ---------------------------
        $("#zoneEdition").on('click', "#btnSubmit", function() {
            if ($("#formTravail").valid()) {
                var formulaire = $("#formTravail").serialize();
                $.post('inc/casier/postTravail.inc.php', {
                        formulaire: formulaire
                    },
                    function(resultat) {
                        // alert(resultat);
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
                                // Confirmation de l'enregistrement avec date et heure
                                bootbox.alert({
                                    message: "travail enregistré le "+date,
                                    backdrop: true
                                });
                            });
                    });
            }
        })

        $("#zoneEdition").on('change', "#selectEleve", function() {
            var matricule = $(this).val();
            if (matricule != '') {
                var idTravail = $(this).find(':selected').data('idtravail');
                var photo = $(this).find(':selected').data('photo');
                // recherche les infos pour le travail "idTravail" de l'élève "matricule"
                $.post('inc/casier/getResultatTravail.inc.php', {
                        idTravail: idTravail,
                        matricule: matricule
                    },
                    function(resultat) {
                        $("#detailsEvaluation").html(resultat);
                    })
            }
            else $("#detailsEvaluation").html();
        })

        $("#zoneEdition").on('click', '.btn-delComp', function(){
            var idCompetence = $(this).data('idcompetence');
            var idTravail = $(this).data('idtravail');
            var bouton = $(this);
            $.post('inc/casier/verifierCompetenceCotee.inc.php', {
                idCompetence: idCompetence,
                idTravail: idTravail
                },
                function(nb){
                    // si la compétence a déjà été évaluée, il faut demander confirmation
                    if (nb > 0) {
                        $("#btn-confirmDel").data('idcompetence', idCompetence);
                        $("#btn-confirmDel").data('idtravail', idTravail);
                        $("#nbEleves").html(nb);
                        $("#modalDelCompetence").modal('show');
                        }
                        else {
                            // sinon, on supprime la compétence de ce travail
                            $.post('inc/casier/delCompetenceTravail.inc.php', {
                                idCompetence: idCompetence,
                                idTravail: idTravail
                            },
                            function(){
                                // on enlève la ligne correspondante dans le tableau des compétences
                                bouton.closest('tr').remove();
                            })
                        }
                }
            )
        })

        $("#btn-confirmDel").click(function(){
            var idCompetence = $(this).data('idcompetence');
            var idTravail = $(this).data('idtravail');
            var bouton = $(".btn-delComp").find("[data-idcompetence='"+idCompetence+"']");
            $.post('inc/casier/delCompetenceTravail.inc.php', {
                idCompetence: idCompetence,
                idTravail: idTravail
            },
            function(){
                // on enlève la ligne correspondante dans le tableau des compétences
                bouton.closest('tr').remove();
            })
        })

        $("#zoneEdition").on('click', "#saveEval", function() {
            var formulaire = $("#evalTravail").serialize();
            // récupérer le contenu actuel du CKEditor
            var evaluation = CKEDITOR.instances.editeurEvaluation.getData();
            $.post('inc/casier/postEvaluation.inc.php', {
                formulaire: formulaire,
                evaluation: evaluation
            }, function(date) {
                bootbox.alert({
                    message: "Évaluation enregistrée le "+date,
                    backdrop: true
                });
            });
            // ajuster la cote obtenue dans le selectEleve (voir "evalTravaux.tpl")
            var matricule = $("#selectEleve option:selected").val();
            $.post('inc/casier/ajusteCote.inc.php', {
                formulaire: formulaire,
                matricule: matricule
            }, function(resultat) {
                $("#selectEleve option:selected").text(resultat);
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
