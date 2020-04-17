<div class="container-fluid">

    <h2>Remédiations</h2>

    <div class="col-md-9 col-sm-12">

        <ul class="nav nav-tabs nav-justified">

            <li><a data-toggle="tab" href="#gestion" id="tabGestion"><i class="fa fa-edit"></i> Gestion</a></li>
            <li class="active"><a data-toggle="tab" href="#calendrier" id="tabCalendrier"><i class="fa fa-calendar"></i> Calendrier</a></li>
            <li><a data-toggle="tab" id="tabPresences" href="#presences"><i class="fa fa-pencil"></i> Présences</a></li>
            <li><a data-toggle="tab" id="tabCatalogue" href="#catalogue"><i class="fa fa-university"></i> Catalogue</a></li>
        </ul>

        <div class="tab-content">
            <div id="gestion" class="tab-pane fade">

                <div class="col-md-4 col-sm-12">

                    <div class="panel panel-default">
                        <div class="panel-heading">
                            <h2>Offres actives</h2>
                            <button type="button" class="btn btn-success btn-sm btn-block" id="btn-newRemediation">Nouvelle offre</button>
                        </div>

                        <div class="panel-body" id="listeRemediations" style="height: 30em; overflow: auto;">
                            {include file="remediation/listeRemediations.tpl"}
                        </div>

                        <div class="panel-footer">
                            {count($offre)} remédiation(s) actives
                        </div>
                    </div>

                </div>

                <div class="col-md-8 col-sm-12" id="detailsOffre">
                    <p class="avertissement">Choisir une remédiation</p>
                </div>
            </div>

            <div id="calendrier" class="tab-pane fade in active">
                <div id="calendar">
                </div>
            </div>

            <div id="presences" class="tab-pane fade">
                {include file="remediation/selecteurs/selectNiveauClasseDates.tpl"}
                <div id="tableauPresences">

                </div>
            </div>

            <div id="catalogue" class="tab-pane fade">
                {include file="remediation/selecteurs/selectNiveauCatalogue.tpl"}
                <div id="catalogueNiveau">

                </div>
            </div>
        </div>
    </div>

    <div class="col-md-3 col-sm-12" id="panelDroit">
        <div id="panelInfo">

        </div>
        <div id="panelEleves">
            {include file="remediation/panelElevesInscrits.tpl"}
        </div>
        <div id="panelGroupes">
            {include file="remediation/panelGroupesCibles.tpl"}
        </div>
    </div>

</div>

{include file="remediation/modal/modalEditRemediation.tpl"}
{include file="remediation/modal/modalEditCible.tpl"}
{include file="remediation/modal/modalAddEleve.tpl"}
{include file="remediation/modal/modalPresences.tpl"}
{include file="remediation/modal/modalContenu.tpl"}

<script type="text/javascript">
    function dateMysql(dateFr) {
        var date = dateFr.split('/');
        return date[2] + '-' + date[1] + '-' + date[0];
    }

    jQuery.validator.addMethod(
        "dateFr",
        function(value, element) {
            return value.match(/^\d\d?\/\d\d?\/\d\d\d\d$/);
        },
        "Date au format jj/mm/AAAA svp"
    );

    // -------------------------------------------------------------------------------------
    // pour des raisons de compatibilité avec Google Chrome et autres navigateurs à base
    // de webkit, il ne faut pas utiliser la règle "date" du validateur jquery.validate.js
    // Elle sera remplacée par la règle "uneDate" dont le fonctionnement n'est pas basé sur
    // le présupposé que le contenu du champ est une date. Google Chrome et Webkit traitent
    // exclusivement les dates au format américain mm-dd-yyyy
    // sans cette nouvelle règle, les dates du type 15-09-2012 sont refusées sous Webkit
    // https://github.com/jzaefferer/jquery-validation/issues/20
    // -------------------------------------------------------------------------------------
    jQuery.validator.addMethod(
        "uneDate",
        function(value, element) {
            var reg = new RegExp("/", "g");
            var tableau = value.split(reg);
            // ne pas oublier le paramètre de "base" dans la syntaxe de parseInt
            // au risque que les numéros des jours et des mois commençant par "0" soient
            // considérés comme de l'octal
            // https://developer.mozilla.org/en-US/docs/JavaScript/Reference/Global_Objects/parseInt
            jour = parseInt(tableau[0], 10);
            mois = parseInt(tableau[1], 10);
            annee = parseInt(tableau[2], 10);
            nbJoursFev = new Date(annee, 1, 1).getMonth() == new Date(annee, 1, 29).getMonth() ? 29 : 28;
            var lgMois = new Array(31, nbJoursFev, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31);
            condMois = ((mois >= 1) && (mois <= 12));
            if (!(condMois)) return false;
            condJour = ((jour >= 1) && (jour <= lgMois[mois - 1]));
            condAnnee = ((annee > 1900) && (annee < 2100));
            var testDateOK = (condMois && condJour && condAnnee);
            return this.optional(element) || testDateOK;
        },
        "Date incorrecte"
    );

    jQuery.validator.addMethod(
        "time",
        function(value, element) {
            return this.optional(element) || (/^(([0-1]?[0-9])|([2][0-3])):([0-5]?[0-9])(:([0-5]?[0-9]))?$/i.test(value));
        },
        "Heure invalide"
    );


    $(document).ready(function() {

        $('#tabGestion').trigger('click');

        $(document).ajaxStart(function() {
            $('body').addClass('wait');
        }).ajaxComplete(function() {
            $('body').removeClass('wait');
        });

        $("#nom").typeahead({
             minLength: 2,
            afterSelect: function(item){
                $.ajax({
                    url: 'inc/searchMatricule.php',
                    type: 'POST',
                    data: 'query=' + item,
                    dataType: 'text',
                    async: true,
                    success: function(matricule){
                        if (matricule != '') {
                            // générer la vue des remédiations possibles pour l'élève
                            $.post('inc/remediation/getRemediationsEleve.inc.php', {
                                matricule: matricule
                            }, function(resultat){
                                $('#catalogueNiveau').html(resultat);
                            })
                            }
                        }
                    })
                },
            source: function(query, process){
                 $.ajax({
                    url: 'inc/searchNom.php',
                    type: 'POST',
                    data: 'query=' + query,
                    dataType: 'JSON',
                    async: true,
                    success: function (data) {
                        process(data);
                        $('#niveauCatalogue').val('');
                        }
                })
            }
        })

        $('#catalogue').on('click', '#btn-selectMatricule', function(){
            var nom = $('#nom').val();
            $.post('inc/remediation/returnMatricule4nom.inc.php', {
                nom: nom
            }, function(matricule){
                if (matricule != '') {
                    // générer la vue des remédiations possibles pour l'élève
                    $.post('inc/remediation/getRemediationsEleve.inc.php', {
                        matricule: matricule
                    }, function(resultat){
                        $('#catalogueNiveau').html(resultat);
                    })
                    }
                    else {
                        $('#catalogueNiveau').html('');
                    }
            })
        })

        $('#catalogue').on('click', '.btnShow', function(){
            var title = $(this).data('title');
            var prof = $(this).data('prof');
            var content = $(this).data('content');
            $('#modalContenuLabel').text(title + ' -> ' + prof);
            $('#modalContenu .modal-body').html(content);
            $('#modalContenu').modal('show');
        })

        $('#presences').on('click', '#btn-listePresences', function(){
            if ($('#formListePresences').valid()) {
                var classe = $('#classePresences').val();
                var debut = $('#debutPresences').val();
                var fin = $('#finPresences').val();
                $.post('inc/remediation/listePresences.inc.php', {
                    classe: classe,
                    debut: debut,
                    fin: fin
                }, function(resultat){
                    $('#tableauPresences').html(resultat);
                })
            }
        })

        $('#presences').on('change', '#niveauPresences', function(){
            var niveau = $(this).val();
            $.post('inc/remediation/selectClasse.inc.php', {
                niveau: niveau
            }, function(resultat){
                $('#nom').val('');
                $('#classePresences').html(resultat);
            })
        })

        $('#catalogue').on('change', '#niveauCatalogue', function(){
            var niveau = $(this).val();
            if (niveau != '') {
                $.post('inc/remediation/getCatalogue.inc.php', {
                    niveau: niveau
                }, function(resultat){
                    $('#catalogueNiveau').html(resultat);
                })
            }
        })

        $('#catalogue').on('click', '#btn-selectNiveau', function(){
            var niveau = $('#niveauCatalogue').val();
            if (niveau != '') {
                $.post('inc/remediation/getCatalogue.inc.php', {
                    niveau: niveau
                }, function(resultat){
                    $('#catalogueNiveau').html(resultat);
                })
            }
        })

        $('#calendar').fullCalendar({
            weekends: false,
            defaultView: 'month',
            weekends: false,
            eventLimit: 3,
            height: 600,
            timeFormat: 'HH:mm',
            header: {
                left: 'prev, today, next',
                center: 'title',
                right: 'month,agendaWeek,agendaDay,listMonth,listWeek'
            },
            buttonText: {
                listMonth: 'Liste Mois',
                listWeek: 'Liste Semaine'
            },
            businessHours: {
                start: '08:15',
                end: '19:00',
                dow: [1, 2, 3, 4, 5]
            },
            minTime: "08:00:00",
            maxTime: "18:00:00",
            eventSources: [{
                url: 'inc/remediation/events.json.php',
                type: 'POST',
                data: {},
                error: function() {
                    alert('Attention, vous semblez avoir perdu la connexion à l\'Internet.');
                }
            }],
            eventRender: function(event, element, view) {
                // popover
                if (view.name == 'month') {
                  element.popover({
                    title: event.acronyme,
                    content: event.contenu,
                    trigger: 'hover',
                    placement: "top",
                    container: "#calendar"
                  });
              }
              // événements passés
              var listeClasses = event.className;
              if (listeClasses.indexOf('past-event') > 0) {
                    element.children().addClass("past-event");
                }
            },
            eventClick: function(calEvent, jsEvent, view) {
                var listeClasses = calEvent.className;
                var idOffre = calEvent.id; // l'id de l'événement
                {* accès uniquement au propriétaire *}
                if (listeClasses.indexOf("proprio") > 0) {
                    $('#panelDroit button').prop('disabled', false);
                    var laClasse= calEvent.className;
                    $('.fc-event').removeClass('btn-green');
                    $('.fc-event.'+laClasse[0]).addClass('btn-green');

                    // reconstituer le panneau des élèves pour cet événement
                    $.post('inc/remediation/panelEleves.inc.php', {
                        idOffre: idOffre
                    }, function(resultat){
                        $('#panelEleves').html(resultat);
                        // reconstituer le panneau des groupes pour cet événement
                        $.post('inc/remediation/panelGroupes.inc.php', {
                            idOffre: idOffre
                        }, function(resultat){
                            $('#panelGroupes').html(resultat);
                            $.post('inc/remediation/panelInfo.inc.php', {
                                idOffre: idOffre
                            }, function(resultat){
                                $('#panelInfo').html(resultat);
                            })
                        })
                    })

                    $('.popover.in').removeClass('in');
                    $('.btn-showOffre').removeClass('btn-green').addClass('btn-primary');
                    $('.btn-showOffre[data-idoffre="' + idOffre+ '"]').addClass('btn-green');

                }
                else {
                    $.post('inc/remediation/panelInfo.inc.php', {
                        idOffre: idOffre
                    }, function(resultat){
                        $('#panelInfo').html(resultat);
                        $('#panelEleves').html('');
                        $('#panelGroupes').html('');
                    })
                    $('#panelDroit button').prop('disabled', true);
                }
            },
            dayClick: function(calEvent, jsEvent, view) {
                var debut = moment(calEvent);
                var today = moment().format('YYYY-MM-DD');
                if (debut.isBefore(today)) {
                    bootbox.alert({
                        title: 'Erreur',
                        message: 'Vous ne pouvez pas fixer une remédiation dans le passé'
                        })
                }
                else {
                    var heure = moment(calEvent).format('HH:mm');
                    var date = moment(calEvent).format('DD/MM/YYYY');
                    $.post('inc/remediation/editRemediation.inc.php', {
                        date: date,
                        heure: heure
                    }, function(resultat) {
                        $('#formEditRemediation').html(resultat);
                        $('#modalEditRemediation').modal('show');
                    })
                }
            },
            eventDrop: function(calEvent, jsEvent, view) {
                var newStartDate = moment(calEvent.start).format('YYYY-MM-DD HH:mm');
                var newEndDate = moment(calEvent.end).format('YYYY-MM-DD HH:mm');
                var idOffre = calEvent.id;
                var debut = moment(calEvent.start);
                var today = moment().format('YYYY-MM-DD');

                if (debut.isBefore(today)) {
                    bootbox.alert({
                        title: 'Erreur',
                        message: 'Attention!! Vous ne pouvez pas déplacer un événement vers le passé'
                        });
                    $('#calendar').fullCalendar('refetchEvents');
                }
                else {
                    $.post('inc/remediation/changeEventTime.inc.php', {
                        idOffre: idOffre,
                        startDate: newStartDate,
                        endDate: newEndDate
                    }, function(resultat){
                        $('#listeRemediations').html(resultat);
                        $.post('inc/remediation/detailsOffre.inc.php', {
                            idOffre: idOffre
                        }, function(resultatHTML) {
                            $('#detailsOffre').html(resultatHTML);
                            $.post('inc/remediation/panelInfo.inc.php', {
                                idOffre: idOffre
                            }, function(resultat){
                                $('#panelInfo').html(resultat);
                            })
                        })
                    })
                }
            },
            eventResize: function(calEvent, delta, revertFunc) {
                newStartDate = moment(calEvent.start).format('YYYY-MM-DD HH:mm');
                newEndDate = moment(calEvent.end).format('YYYY-MM-DD HH:mm');
                idOffre = calEvent.id;
                $.post('inc/remediation/changeEventTime.inc.php', {
                    idOffre: idOffre,
                    startDate: newStartDate,
                    endDate: newEndDate
                }, function(){
                    $.post('inc/remediation/detailsOffre.inc.php', {
                        idOffre: idOffre
                    }, function(resultatHTML) {
                        $('#detailsOffre').html(resultatHTML);
                    })
                })
            },
        })



        $('#panelEleves').on('click', '#btn-presences', function() {
            var idOffre = $(this).data('idoffre');
            $.post('inc/remediation/getListePresences.inc.php', {
                idOffre: idOffre
            }, function(resultat) {
                $('#modalPresences .modal-body').html(resultat);
                $('#modalPresences').modal('show');
            })
        })

        $('#modalPresences').on('click', '#savePresences', function() {
            var formulaire = $('#formPresences').serialize();
            $.post('inc/remediation/savePresences.inc.php', {
                formulaire: formulaire
            }, function(resultat) {
                $('#panelEleves').html(resultat);
                $('#modalPresences').modal('hide');
            })
        })

        $('#detailsOffre').on('click', '#btn-edit', function() {
            var idOffre = $(this).data('idoffre');
            $.post('inc/remediation/editRemediation.inc.php', {
                idOffre: idOffre
            }, function(resultat) {
                $('#formEditRemediation').html(resultat);
                $('#modalEditRemediation').modal('show');
            })
        })

        $('#detailsOffre').on('click', '#btn-clone', function() {
            var idOffre = $(this).data('idoffre');
            $.post('inc/remediation/editRemediation.inc.php', {
                idOffre: idOffre,
                clone: true
            }, function(resultat) {
                $('#formEditRemediation').html(resultat);
                $('#modalEditRemediation').modal('show');
            })
        })

        $('#panelGroupes').on('click', '.btn-delCible', function() {
            var ligne = $(this).closest('li');
            var idOffre = $(this).closest('li').data('idoffre');
            var type = $(this).closest('li').data('type');
            var cible = $(this).closest('li').data('cible');
            bootbox.confirm({
                message: "Veuillez confirmer la suppression du groupe <strong>" + cible + "</strong>",
                buttons: {
                    confirm: {
                        label: 'Supprimer',
                        className: 'btn-danger'
                    },
                    cancel: {
                        label: 'Annuler',
                        className: 'btn-default'
                    }
                },
                callback: function(result) {
                    if (result == true) {
                        $.post('inc/remediation/delGroupeCible.inc.php', {
                                idOffre: idOffre,
                                type: type,
                                cible: cible
                            },
                            function() {
                                ligne.remove();
                            })
                    }
                }
            })
        })

        $('#detailsOffre').on('click', '#btn-delOffre', function() {
            var idOffre = $(this).data('idoffre');
            bootbox.confirm({
                message: "Veuillez confirmer la suppression du cette remédiation",
                buttons: {
                    confirm: {
                        label: 'Supprimer',
                        className: 'btn-danger'
                    },
                    cancel: {
                        label: 'Annuler',
                        className: 'btn-default'
                    }
                },
                callback: function(result) {
                    if (result == true) {
                        $.post('inc/remediation/delRemediation.inc.php', {
                                idOffre: idOffre
                            },
                            function(resultat) {
                                var resultat = JSON.parse(resultat);
                                if (resultat.erreur == false) {
                                    $.post('inc/remediation/listeRemediations.inc.php', {
                                            idOffre: idOffre
                                        },
                                        function(resultat) {
                                            $('#listeRemediations').html(resultat);
                                            $('#listeRemediations .btn').first().trigger('click');
                                        });
                                    }
                            });
                        $('#calendar').fullCalendar('removeEvents', idOffre);
                    }
                }
            })
        })

        $('#panelEleves').on('click', '#btn-addEleve', function() {
            var idOffre = $(this).data('idoffre');
            $('#modalIdOffre').val(idOffre);
            $('#modalInvitationEleve').modal('show');
        })

        $('#panelEleves').on('click', '.btn-delEleve', function(e) {
            var ligne = $(this).closest('li');
            var idOffre = $(this).data('idoffre');
            var matricule = $(this).data('matricule');

            if (e.ctrlKey) {
                $.post('inc/remediation/delEleve.inc.php', {
                    idOffre: idOffre,
                    matricule: matricule
                }, function(resultat) {
                    if (resultat == 1)
                        ligne.remove();
                })
            } else {
                bootbox.confirm({
                    message: "Veuillez confirmer la désincription de l'élève",
                    buttons: {
                        confirm: {
                            label: 'Supprimer',
                            className: 'btn-danger'
                        },
                        cancel: {
                            label: 'Annuler',
                            className: 'btn-default'
                        }
                    },
                    callback: function(result) {
                        if (result == true) {
                            $.post('inc/remediation/delEleve.inc.php', {
                                idOffre: idOffre,
                                matricule: matricule
                            }, function(resultat) {
                                if (resultat == 1)
                                    ligne.remove();
                            })
                        }
                    }
                })
            }
        })

        $('#panelGroupes').on('click', '#btn-addCible', function() {
            var idOffre = $(this).data('idoffre');
            $.post('inc/remediation/editCible.inc.php', {
                idOffre: idOffre
            }, function(resultat) {
                $('#modalEditCible #detailsCible').html(resultat);
                $('#modalEditCible').modal('show');
            })
        })

        <!-- // Montrer les détails de l'offre de remédiation cliquée dans la partie gauche de l'écran -->
        $('#listeRemediations').on('click', '.btn-showOffre', function() {
            var idOffre = $(this).data('idoffre');
            var laClasse = 'class_' + idOffre;
            $('.fc-event').removeClass('btn-green');
            $('.fc-event.'+laClasse).addClass('btn-green');
            $('.btn-showOffre').removeClass('btn-green').addClass('btn-primary');
            $(this).removeClass('btn-primary').addClass('btn-green');
            $.post('inc/remediation/detailsOffre.inc.php', {
                idOffre: idOffre
            }, function(restultat) {
                $('#detailsOffre').html(restultat);
            });
            $.post('inc/remediation/panelEleves.inc.php', {
                idOffre: idOffre
            }, function (resultat){
                $('#panelEleves').html(resultat);
                $.post('inc/remediation/panelGroupes.inc.php', {
                    idOffre: idOffre
                }, function(resultat){
                    $('#panelGroupes').html(resultat);
                    $.post('inc/remediation/panelInfo.inc.php', {
                        idOffre: idOffre
                    }, function(resultat){
                        $('#panelInfo').html(resultat);
                    })
                })
            })
        })

        $('#btn-newRemediation').click(function() {
            $.post('inc/remediation/editRemediation.inc.php', {}, function(resultat) {
                $('#formEditRemediation').html(resultat);
                $('#modalEditRemediation').modal('show');
            })
        })

        $('#btn-saveRemediation').click(function() {
            if ($('#formEditRemediation').valid()) {
                var formulaire = $('#formEditRemediation').serialize();
                $.post('inc/remediation/saveRemediation.inc.php', {
                    formulaire: formulaire
                }, function(resultat) {
                    var resultat = JSON.parse(resultat);
                    var message = resultat.message;
                    var idOffre = resultat.idOffre;
                    bootbox.alert(message);
                    $('#modalEditRemediation').modal('hide');
                    // reconstruction de la liste des offres
                    $.post('inc/remediation/listeRemediations.inc.php', {
                            idOffre: idOffre
                        },
                        function(resultat) {
                            $('#listeRemediations').html(resultat);
                            // mise à jour de la liste des inscriptions
                            $.post('inc/remediation/listeElevesInscrits.inc.php', {
                                idOffre: idOffre
                            }, function(resultat){
                                $('#panelEleves').html(resultat);
                            })
                        });
                    // mise à jour du panneau central et du calendrier
                    $.post('inc/remediation/detailsOffre.inc.php', {
                        idOffre: idOffre
                    }, function(resultatHTML) {
                        $('#detailsOffre').html(resultatHTML);
                        $('#calendar').fullCalendar('refetchEvents');
                    })
                })
            }
        })

        $('#formEditRemediation').validate({
            rules: {
                title: {
                    required: true
                },
                contenu: {
                    required: true
                },
                date: {
                    required: true,
                    uneDate: true
                },
                heure: {
                    required: true,
                    time: true
                },
                local: {
                    required: true
                },
                duree: {
                    required: true,
                },
                places: {
                    required: true,
                    number: true
                }
            }
        })

    })
</script>
