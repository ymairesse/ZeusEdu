<div class="container-fluid">

    <div class="row">

        <div class="col-md-3 col-sm-12">

            <div id="ajaxLoader" class="hidden">
                <img src="images/ajax-loader.gif" alt="loading" class="center-block">
            </div>

            <select class="form-control" name="selectCours" id="selectCours">
                <option value="">Sélectionnez un cours</option>
                {foreach from=$listeCours key=ceCoursGrp item=dataCours}
                    <option value="{$ceCoursGrp}" {if $ceCoursGrp==$coursGrp} selected{/if}>
                        {$dataCours.coursGrp} {$dataCours.nomCours|default:$dataCours.libelle} {$dataCours.nbheures}h
                    </option>
                {/foreach}
            </select>

            <button
                type="button"
                class="btn btn-primary btn-block{if !(isset($coursGrp))} hidden{/if}"
                id="newTravail">
                Nouveau travail
            </button>

            <div id="listeTravaux">
                {include file='casier/listeTravaux.tpl'}
            </div>

        </div>

        <div class="col-md-9 col-sm-12">

            <div id="zoneEdition">
                {include file='casier/evalTravaux.tpl'}
            </div>

        </div>

    </div>

</div>

<div id="modal"></div>


{include file="casier/modal/modalDelTravail.tpl"}

{include file="casier/modal/modalDelCompetence.tpl"}

{include file="casier/modal/modalCarnetCotes.tpl"}

{include file="casier/modal/modalConsignes.tpl"}

{include file="casier/modal/modalArchives.tpl"}

<script type="text/javascript">

    $(document).ready(function() {

        $(document).ajaxStart(function() {
            $('#ajaxLoader').removeClass('hidden');
        }).ajaxComplete(function() {
            $('#ajaxLoader').addClass('hidden');
        });

        $('#listeTravaux').on('click', '#btn-archive', function(){
            var coursGrp = $("#selectCours").val();
            $.post('inc/casier/travauxArchives.inc.php', {
                coursGrp: coursGrp
            },
            function(resultat){
                $('#modalArchives .modal-body').html(resultat);
                $('#modalArchives').modal('show');
            })
        })

        $('#btn-submitArchive').click(function(){
            var formulaire = $('#formArchives').serialize();
            $.post('inc/casier/saveStatutFromArchive.inc.php', {
                formulaire: formulaire
                },
                function(resultat){
                    $('#modalArchives').modal('hide');
                    var coursGrp = $('#selectCours').val();
                    $.post('inc/casier/listeTravaux.inc.php', {
                            coursGrp: coursGrp,
                            idTravail: undefined,
                            matricule: undefined
                        },
                        function(resultat) {
                            $("#listeTravaux").html(resultat);
                        });
                    bootbox.alert(resultat + 'statut(s) mis à jour');
                })
        })

        $("#zoneEdition").on('click', '#carnetCotes', function(){
            var idTravail = $(this).data('idtravail')
            $.post('inc/casier/modalTransfertCarnet.inc.php', {
                idTravail: idTravail
            },
            function(resultat){
                $("#transfert").html(resultat);
            });
            $("#modalCarnetCotes").modal('show');
        })

        $('#btn-transfert').click(function() {
            var formulaire = $('#formTransfert').serialize();
            $.post('inc/casier/transfertCarnet.inc.php', {
                    formulaire: formulaire
                },
                function(resultat) {
                    $('#modalCarnetCotes').modal('hide');
                    bootbox.alert({
                        message: resultat,
                        backdrop: true
                    });
                })
        })

        $("#zoneEdition").on('click', '#consignes', function(){
            var idTravail = $('.btnShowTravail.active').data('idtravail');
            var coursGrp = $("#selectCours").val();
            $.post('inc/casier/getConsignes.inc.php', {
                    idTravail: idTravail,
                    coursGrp: coursGrp
                },
                function(resultat) {
                    $("#modalConsignes .modal-body").html(resultat);
                    $("#modalConsignes").modal('show');
                });
        })

        $("#selectCours").change(function() {
            var coursGrp = $(this).val();
            $.post('inc/casier/listeTravaux.inc.php', {
                    coursGrp: coursGrp,
                    idTravail: undefined,
                    matricule: undefined
                },
                function(resultat) {
                    $("#listeTravaux").html(resultat);
                    $("#zoneEdition").html("<p class='avertissement'>Veuillez sélectionner un travail dans la colonne de gauche</p>");
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
            $.post('inc/casier/getConsignesTravail.inc.php', {
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
            $('#listeTravaux button').removeClass('active');
            $(this).prev('button').addClass('active');
            $.post('inc/casier/getConsignesTravail.inc.php', {
                    idTravail: idTravail,
                    coursGrp: coursGrp,
                    showArchive: 'hide'
                },
                function(resultat) {
                    $("#zoneEdition").html(resultat);
                });
            })

        // voir et évaluer les travaux
        $("#listeTravaux").on('click', '.btnShowTravail', function() {
            // désactiver tous les boutons
            $('.btnShowTravail').removeClass('active');
            // activer celui qui vient d'être sélectionné
            $(this).addClass('active');
            var idTravail = $(this).data('idtravail');
            var coursGrp = $("#selectCours :selected").val();

            // cadre d'évaluation du travail
            $.post('inc/casier/listeElevesEvalues.inc.php', {
                    idTravail: idTravail,
                    coursGrp: coursGrp
                },
                function(resultat) {
                    $("#zoneEdition").html(resultat);
                    // chercher les informations éventuelles sur le travail de l'élève actif
                    if ($("#selectEleve").val() != '') {
                        var matricule = $("#selectEleve :selected").val();
                        $.post('inc/casier/getResultatTravail.inc.php', {
                            idTravail: idTravail,
                            matricule: matricule
                            },
                            function(resultat){
                                $("#detailsEvaluation").html(resultat);
                            })
                    }
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
                        // Actualiser les détails du travail (consignes, dates, etc)
                        $.post('inc/casier/getConsignesTravail.inc.php', {
                                idTravail: idTravail,
                                coursGrp: coursGrp,
                                showArchive: 'hide'
                            },
                            function(resultat) {
                                $("#zoneEdition").html(resultat);
                                bootbox.alert({
                                    message: "Travail enregistré le "+date
                                });
                            });
                    });
            }
        })

        $("#zoneEdition").on('change', '#selectEleve', function() {
            var matricule = $(this).val();
            if (matricule != '') {
                var idTravail = $(this).find(':selected').data('idtravail');
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
                $('#tableCompetences tr[data-idcompetence="'+ idCompetence +'"]').remove();
                $("#modalDelCompetence").modal('hide');
            })
        })

        $("#zoneEdition").on('click', "#saveEval", function() {
            var formulaire = $("#evalTravail").serialize();
            $.post('inc/casier/postEvaluation.inc.php', {
                formulaire: formulaire
            }, function(date) {
                bootbox.alert({
                    message: "Évaluation enregistrée le "+date
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

        $("#listeTravaux").on('click', '.btnDelete', function(){
            var idTravail = $(this).closest('div').data('idtravail');
            $('#listeTravaux button').removeClass('active');
            $(this).next('button').addClass('active');
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
                var coursGrp = $("#selectCours :selected").val();
                $.post('inc/casier/listeTravaux.inc.php', {
                        coursGrp: coursGrp
                    },
                    function(resultat) {
                        $("#listeTravaux").html(resultat);
                        $("#editTravail").addClass('hidden');
                        $("#showTravail").addClass('hidden');
                    });
                $("#zoneEdition").html("<p class='avertissement'>Veuillez sélectionner un travail dans la colonne de gauche</p>");
            })
            $("#modalDelTravail").modal('hide');
        })

        $('#zoneEdition').on('click', '#btn-showRemis', function(){
            var idTravail = $(this).data('idtravail');
            if (idTravail != '') {
                var coursGrp = $("#selectCours :selected").val();
                $.post('inc/casier/getReceptionTravail.inc.php', {
                    idTravail: idTravail,
                    coursGrp: coursGrp
                }, function(resultat){
                    $('#modal').html(resultat);
                    $('#modalTravauxRemis').modal('show');
                })
            }
            else {
                bootbox.alert({
                    title: 'Avertissement',
                    message: 'Sélectionnez d\'abord un travail'
                })
            }

        })

    })

</script>
