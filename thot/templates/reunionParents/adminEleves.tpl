{* ----------------------------------------------------------------------- *}
{* Interface d'administration des réunions de parents                      *}
{* Gestion par élève                                                        *}
{* pour l'administrateur                                                   *}
{* ----------------------------------------------------------------------- *}


<div class="container-fluid">

    <div class="row">

        <div class="col-md-3 col-sm-4">

            <div class="panel panel-success">
                <div class="panel-heading">
                    Sélection de la classe
                </div>
                <div class="panel-body">
                    <div class="form-group">
                        <select class="form-control" name="niveau" id="niveau">
                            <option value="">Niveau d'étude</option>
                            {foreach from=$listeNiveaux item=leNiveau}
                                <option value="{$leNiveau}" {if isset($niveau) && ($leNiveau == $niveau)}selected{/if}>{$leNiveau}e année</option>
                            {/foreach}
                        </select>
                    </div>

                    <div class="form-group" id="lesClasses">
                        {* liste des classes *}
                    </div>
                </div>

            </div>



        </div>
        <!-- col-md-... -->

        <div class="col-md-3 col-sm-8">

            <div class="panel panel-success">
                <div class="panel-heading">
                    Sélection de l'élève <button class="btn btn-success btn-sm pull-right"
                        style="margin: -10px"
                        type="button"
                        id="cleaner"
                        title="Nettoyer les infobulles">
                        <i class="fa fa-trash"></i>
                    </button>
                </div>

                <div id="listeEleves" style="height:30em; overflow:auto">

                        <p class="avertissement">Sélectionnez une classe dans la colonne de gauche</p>

                </div>

            </div>

        </div>
        <!-- col-md-... -->

        <div class="col-md-6 col-sm-12">

            <div class="panel panel-warning">

                <div class="panel-heading">
                    Sélection du professeur
                </div>
                <div class="panel-body" style="font-size:8pt">
                    <div id="listeProfs">
                        <!-- selectProfsCible.tpl -->
                    </div>

                    <div id="listeRV" style="max-height:25em; overflow: auto">
                        <!-- tableRVAdmin.tpl -->
                    </div>

                    <div id="listeAttenteProf">
                        <!-- listeAttenteAdmin.tpl -->
                    </div>

                </div>

            </div>

        </div>
        <!-- col-md-... -->

    </div>
    <!-- row -->

</div>
<!-- container -->

<div id="modal"></div>

<script type="text/javascript">

    $(document).ready(function() {

        $('[data-toggle="popover"]').popover();

        $('#niveau').change(function(){
            var niveau = $(this).val();
            $.post('inc/reunionParents/selectClasses4niveau.inc.php', {
                niveau: niveau
            }, function(resultat){
                $('#lesClasses').html(resultat);
            })
        })

        $('#lesClasses').on('change', '#classe', function(){
            var classe = $(this).val();
            $(".popover").popover('hide');
            var idRP = $("#idRP").val();
            $.post('inc/reunionParents/listeElevesDeployee.inc.php', {
                    classe: classe,
                    idRP: idRP
                },
                function(resultat) {
                    $('#listeEleves').html(resultat);
                    $.post('inc/reunionParents/listeProfsClasse.inc.php', {
                        classe: classe
                    }, function(resultat){
                        $('#listeProfs').html(resultat);
                        // en attente de la sélection du prof
                        $("#listeRV").html('');
                        $("#listeAttenteProf").html('');
                    })
                })
        })

        // sélection d'un élève
        $(document).on('click', '.btn-eleve', function() {
            var matricule = $(this).data('matricule');
            var idRP = $('#idRP').val();
            $(".btn-eleve").removeClass('btn-success');
            $(this).addClass('btn-success');
            if ($('#selectProf').length == 0) {
                $.post('inc/reunionParents/listeProfsRPcible.inc.php', {
                        idRP: idRP
                    },
                    function(resultat) {
                        $("#listeProfs").html(resultat);
                        $("#listeRV").html('');
                        $("#listeAttenteProf").html('');
                    }
                )
            }
        })

        // sélection d'un prof
        $("#listeProfs").on('change', '#selectProf', function() {
            var acronyme = $(this).val();
            var idRP = $("#idRP").val();
            var nomProf = $(this).find(':selected').data('nomprof');
            $("#attenteAcronyme").val(acronyme);
            $("#selectProf").attr('size', 1);
            $.post('inc/reunionParents/listeRvAdmin.inc.php', {
                    userStatus: 'admin',
                    acronyme: acronyme,
                    idRP: idRP,
                    nomProf: nomProf
                },
                function(resultat) {
                    // tableRVAdmin.tpl
                    $("#listeRV").html(resultat);
                });
            $.post('inc/reunionParents/listeAttenteAdmin.inc.php', {
                    idRP: idRP,
                    acronyme: acronyme
                },
                function(resultat) {
                    // listeAttenteAdmin.tpl
                    $("#listeAttenteProf").html(resultat);
                })
        })

        // attribution d'un RV à un élève
        $("#listeRV").on('click', '.lien', function() {
            var idRV = $(this).data('idrv');
            var matricule = $('.btn-eleve.btn-success').data('matricule');
            var acronyme = $('#selectProf').val();
            var idRP = $("#idRP").val();

            if ((idRV > 0) && (matricule > 0)) {
                $.post('inc/reunionParents/inscriptionEleve.inc.php', {
                        matricule: matricule,
                        idRV: idRV,
                        idRP: idRP,
                        acronyme: acronyme
                    },
                    function(resultat) {
                        switch (resultat) {
                            case '1':
                                // visualisation du changement pour la zone des RV
                                $("#selectProf").trigger('change');

                                // Mise à jour du popover
                                $.post('inc/reunionParents/ulRvEleves.inc.php', {
                                        matricule: matricule,
                                        idRP: idRP
                                    },
                                    function(resultat) {
                                        var btnEleve = $('#listeEleves').find('[data-matricule=' + matricule + ']');
                                        btnEleve.attr('data-content', resultat).attr('data-placement', 'left');
                                        btnEleve.data('bs.popover').setContent();
                                    })

                                // Mise à jour du badge du nombre de RV de l'élève
                                var nb = parseInt($('#listeEleves').find('[data-matricule=' + matricule + ']').find('.badge').text());
                                $('#listeEleves').find('[data-matricule=' + matricule + ']').find('.badge').text(nb + 1);

                                break;
                            case '0':
                                bootbox.alert({
                                    title: title,
                                    message: "L'enregistrement s'est mal passé..."
                                })
                                break;
                            case '-1':
                                bootbox.alert({
                                    title: title,
                                    message: "Le nombre maximal de RV pour cet élève a été atteint"
                                })
                                break;
                            case '-2':
                                bootbox.alert({
                                    title: title,
                                    message: "Il y a déjà un rendez-vous pour cet·te élève à cette heure-là"
                                })
                                break;
                        }
                    }
                )
            }
        })

        // suppression d'un RV établi
        $("#listeRV").on('click', '.unlink', function() {
            var idRV = $(this).data('idrv');
            var matricule = $(this).data('matricule');
            var idRP = $("#idRP").val();
            var mail = $(this).data('mail');
            if (mail == '') {
                // il ne s'agit pas d'un RV pris par les parents
                $.post('inc/reunionParents/delRV.inc.php', {
                        idRV: idRV,
                        idRP: idRP
                    },
                    function(resultat) {
                        if (resultat == 1) {
                            // visualisation du changement pour la zone des RV
                            $("#selectProf").trigger('change');
                            // Mise à jour du popover
                            $.post('inc/reunionParents/ulRvEleves.inc.php', {
                                    matricule: matricule,
                                    idRP: idRP
                                },
                                function(resultat) {
                                    var btnEleve = $('#listeEleves').find('[data-matricule=' + matricule + ']');
                                    btnEleve.attr('data-content', resultat).attr('data-placement', 'left');
                                    btnEleve.data('bs.popover').setContent();
                                })

                            // Mise à jour du badge du nombre de RV de l'élève
                            var nb = parseInt($('#listeEleves').find('[data-matricule=' + matricule + ']').find('.badge').text());
                            $('#listeEleves').find('[data-matricule=' + matricule + ']').find('.badge').text(nb - 1);
                        }
                    }
                )
            } else {
                // il s'agit d'une réservation prise par les parents, il faut réaliser la procédure complète
                var nomEleve = $(this).data('nomEleve');
                $("#modalId").val(idRV);
                $("#modalNomEleve").html(nomEleve);
                $("#modalDelRV").modal('show');
            }
        })

        // attribution d'un RV à un élève qui se trouve en liste d'attente
        $('body').on('click','.unlinkAttente', function() {
            var matricule = $(this).data('matricule');
            var acronyme = $(this).data('acronyme');
            var periode = $(this).data('periode');
            var idRP = $('#idRP').val();
            // quelle est l'heure de RV cochée?
            var idRV = $('.idRV:checked').val();
            var userName = $(this).data('userName');
            var typeGestion = $("#typeGestion").val();

            if (idRV > 0) {
                var title = 'Attribution d\'un RV';

                $.post('inc/reunionParents/inscriptionEleve.inc.php', {
                    matricule: matricule,
                    idRP: idRP,
                    idRV: idRV,
                    acronyme: acronyme,
                    periode: periode,
                    userName: userName,
                    },
                    function(resultat){
                        switch (resultat) {
                            case '-1':
                                // le nombre max de RV est atteint
                                bootbox.alert({
                                    title: title,
                                    message: "Cet(te) élève a déjà le nombre maximum de rendez-vous"
                                })
                                break;
                            case '-2':
                                // il y a déjà un RV à cette heure-là
                                bootbox.alert({
                                    title: title,
                                    message: "Il y a déjà un rendez-vous pour cet-te élève à cette heure-là."
                                })
                                break;
                            default:
                                // si le mode est "adminEleves", il faut mettre à jour le "badge" et le "popover" des RV de l'élève
                                if (typeGestion == 'eleve') {
                                    // mise à jour du badge -nombre de RV- près du nom de l'élève
                                    var badge = parseInt($('#listeEleves').find('[data-matricule='+matricule+']').closest('li').find('.badge').text());
                                    $('#listeEleves').find('[data-matricule='+matricule+']').closest('li').find('.badge').text(badge+1);

                                    // Mise à jour du popover de la liste de RV
                                    $.post('inc/reunionParents/ulRvEleves.inc.php', {
                                            matricule: matricule,
                                            idRP: idRP
                                        },
                                        function(resultat) {
                                            var btnEleve = $('#listeEleves').find('[data-matricule=' + matricule + ']');
                                            btnEleve.attr('data-content', resultat).attr('data-placement', 'left');
                                            btnEleve.data('bs.popover').setContent();
                                        })
                                    }
                                // reconstruire la liste des RV mise à jour pour le prof désigné
                                $.post('inc/reunionParents/listeRvAdmin.inc.php', {
                                            acronyme: acronyme,
                                            idRP: idRP
                                        },
                                        function(resultat) {
                                            $('#listeRV').html(resultat);
                                            // SUPPRIMER LA LIGNE CORRESPONDANTE qui a été traitée
                                            $('#tbl-attente tr[data-matricule="'+matricule+'"][data-periode="'+periode+'"]').remove();
                                        }
                                    )
                                break;
                            }
                        });
            }
            else bootbox.alert({
                    title: title,
                    message: 'Veuillez choisir une heure de rendez-vous dans la liste des disponibilités'
                })

        })

    // effacement de la liste d'attente
    $('body').on('click','.delAttente', function() {
        var matricule = $(this).data('matricule');
        var idRP = $('#idRP').val();
        var acronyme = $(this).data('acronyme');
        var periode = $(this).data('periode');

        $.post('inc/reunionParents/delAttente.inc.php', {
            idRP: idRP,
            acronyme: acronyme,
            matricule: matricule,
            periode: periode
            },
        function (resultat){
            // SUPPRIMER LA LIGNE CORRESPONDANTE qui a été traitée
            $('#tbl-attente tr[data-matricule="'+matricule+'"][data-periode="'+periode+'"]').remove();
            //$("#listeAttenteProf").html(resultat);
        })
    })

    $('body').on('click', '.popover .close', function() {
        $(this).closest('.popover').popover('hide');
    });

    $('body').on('click','#listeAttente', function(){
        var matricule = $('.btn-eleve.btn-success').data('matricule');
        var idRP = $(this).data('idrp');
        var acronyme = $('#selectProf').val();
        $.post('inc/reunionParents/getModalListeAttente.inc.php', {
            matricule: matricule,
            acronyme: acronyme,
            idRP: idRP
        }, function(resultat){
            $('#modal').html(resultat);
            $('#modalAttente').modal('show');
            })
        })

    $('#modal').on('click', '.periode', function(){
        var periode = $(this).data('periode');
        var matricule = $("#attenteMatricule").val();
        var acronyme = $("#attenteAcronyme").val();
        var idRP = $("#idRP").val();

        // introduire en liste d'attente
        $.post('inc/reunionParents/setListeAttente.inc.php', {
            idRP: idRP,
            acronyme: acronyme,
            matricule: matricule,
            periode: periode
        }, function(nbSave) {
            if (nbSave == 0) {
                bootbox.alert({
                    title: 'Problème',
                    message: 'L\'enregistrement a échoué: cet·te élève est déjà en liste d\'attente pour la période ' + periode
                    })
                }
            else {
                // recomposer la liste des RV du prof "acronyme"
                $.post('inc/reunionParents/listeRvAdmin.inc.php', {
                    acronyme: acronyme,
                    idRP: idRP
                    },
                    function(resultat){
                        $("#listeRV").html(resultat);
                        // retrouver les éléments de la liste d'attente
                        $.post('inc/reunionParents/listeAttenteAdmin.inc.php', {
                            idRP: idRP,
                            acronyme: acronyme,
                            matricule: matricule,
                            periode: periode
                        }, function(resultat) {
                            $("#listeAttenteProf").html(resultat);
                        });
                        $("#modalAttente").modal('hide');
                    })
                }
            });

        })

    })
</script>
