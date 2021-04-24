{* ----------------------------------------------------------------------- *}
{* Interface d'administration des réunions de parents                      *}
{* pour les profs ordinaires                                               *}
{* ----------------------------------------------------------------------- *}

<div class="container-fluid">

    <div class="row">

        <div class="col-md-9 col-sm-12">

            <div id="listeRV">
                {include file="reunionParents/tableRVAdminDroit.tpl"}
            </div>

            <div id="listeAttenteProf">
                {include file="reunionParents/listeAttenteProfDroit.tpl"}
            </div>

        </div>
        <!-- col-md-... -->


        <div class="col-md-3 col-sm-12">
            <button
                type="button"
                id="printProf"
                title="Imprimer"
                class="btn btn-primary btn-block"
                data-idrp="{$idRP}"
                data-acronyme="{$acronyme}">
                <i class="fa fa-print"></i> Impression des RV
            </button>
            <div id="listeEleves" style="max-height: 40em; overflow:auto;">
                {include file="reunionParents/listeElevesProf.tpl"}
            </div>

        </div>

    </div>

</div>

<div id="modal"></div>

<script type="text/javascript">

    var titreErreur = "Erreur";

    $(document).ready(function() {

        $('[data-toggle="popover"]').popover();

        $('body').on('click', ".unlinkAttente", function(){
            var matricule = $(this).data('matricule');
            var idRP = $(this).data('idrp');
            var acronyme = $(this).data('acronyme');
            var periode = $(this).data('periode');
            var idRV = $('.idRV:checked').val();
            var userName = $(this).data('username');

            var titreErreur = "Erreur";

            if (idRV > 0) {
                $.post('inc/reunionParents/inscriptionEleve.inc.php', {
                    matricule: matricule,
                    idRP: idRP,
                    acronyme: acronyme,
                    periode: periode,
                    userName: userName,
                    idRV: idRV
                    },
                    function(resultat){
                        switch (resultat) {
                            case '-1':
                                // le nombre max de RV est atteint
                                bootbox.alert({
                                    title: titreErreur,
                                    message: "Le nombre maximum de RV est atteint pour cet·te élève"
                                })
                                break;
                            case '-2':
                            // il y a déjà un RV à cette heure-là
                                bootbox.alert({
                                    title: titreErreur,
                                    message: "Il y a déjà un RV pour cet·te élève à cette heure-là"
                                })
                            default:
                                // produire la liste des RV mise à jour pour le prof désigné
                                $.post('inc/reunionParents/listeRVprofesseur.inc.php', {
                                            acronyme: acronyme,
                                            idRP: idRP,
                                            droit: true
                                        },
                                        function(resultat) {
                                            $("#listeRV").html(resultat);
                                            // SUPPRIMER LA LIGNE CORRESPONDANTE qui a été traitée
                                            $('#tbl-attente tr[data-matricule="'+matricule+'"][data-periode="'+periode+'"]').remove();
                                        }
                                    )
                            break;
                        }
                    })
                }
                else bootbox.alert({
                    title: titreErreur,
                    message: "Veuillez sélectionner une période de RV"
                })
            })


            $('body').on('click', '#delAllRV', function(){
                var idRP = $('#idRP').val();
                $.post('inc/reunionParents/delAllRVprofesseur.inc.php', {
                    idRP: idRP
                }, function(resultat){
                    $('#modal').html(resultat);
                    $('#modalDelAllRV').modal('show');
                })
            })

            $('#modal').on('click', '#btn-delAllRV', function(){
                var idRP = $('#idRP').val()
                if ($('#form-delAllRV').valid()){
                    var raison = $('#modal #raisonDel').val();
                    $.post('inc/reunionParents/delConfirmDelAllRV.inc.php', {
                        idRP: idRP,
                        raison: raison
                    }, function(resultat){
                        alert(resultat);
                    })
                }
            })


            // suppression d'un RV établi
            $("body").on('click', '.unlink', function() {
                var idRV = $(this).data('idrv');
                var matricule = $(this).data('matricule');
                var idRP = $("#idRP").val();
                var mail = $(this).data('mail');

                // suppression du popover éventuellement resté ouvert
                $(".popover").popover('hide');
                
                if (mail == '') {
                    // il ne s'agit pas d'un RV pris par les parents
                    $.post('inc/reunionParents/delRV.inc.php', {
                            idRV: idRV,
                            idRP: idRP
                        },
                        function(resultat) {
                            if (resultat == 1) {
                                // visualisation du changement pour la zone des RV
                                $.post('inc/reunionParents/listeRVprofesseur.inc.php', {
                                    idRP: idRP,
                                    droit: true
                                }, function(resultat){
                                    $('#listeRV').html(resultat);
                                })
                            }
                        }
                    )
                } else {
                    // il s'agit d'une réservation prise par les parents, il faut réaliser la procédure complète
                    $.post('inc/reunionParents/delRVparent.inc.php', {
                        idRV: idRV,
                        idRP: idRP
                    }, function(resultat){
                        $('#modal').html(resultat);
                        $('#modalDelRV').modal('show');
                    })
                }
            })

        $('#modal').on('click', '#modalConfirmDelRV', function(){
            if ($('#form-confirmDel').valid()){
                var raison = $('#modal #raisonDel').val();
                var idRV = $('#modal #idRV').val();
                var idRP = $('#modal #idRP').val();
                var matricule = $('#modal #matricule').val();
                $.post('inc/reunionParents/delConfirmRVparent.inc.php', {
                    raison: raison,
                    idRV: idRV,
                    idRP: idRP,
                    matricule: matricule
                }, function(resultatJSON){
                    var resultat = JSON.parse(resultatJSON);

                    if (resultat['nb'] == 1)
                        var message = 'Le rendez-vous a été supprimé';
                        else var message = 'Le rendez-vous n\'a pas pu être supprimé';
                    if (resultat['mailOK'] == true)
                        message += '<br> mail envoyé';
                        else message += '<br>Le mail de confirmation n\'a pas pu être envoyé';
                    $('#modalDelRV').modal('hide');
                    $.post('inc/reunionParents/listeRVprofesseur.inc.php', {
                        idRP: idRP,
                        droit: true
                        }, function(resultat){
                            $('#listeRV').html(resultat);
                            bootbox.alert({
                                title: "Suppression d'un RV",
                                message: message
                                })
                            })
                        })
                    }
                })

        // attribution d'un RV à un élève
        $("#listeRV").on('click', '.lien', function() {
            var idRV = $(this).data('idrv');
            var matricule = $('.btn-eleve.btn-success').data('matricule');
            var matricule = $('#listeElevesClasse .btn-success').data('matricule');
            var idRP = $("#idRP").val();
            var acronyme = $(this).data('acronyme');

            var title = 'Erreur';

            if ((idRV > 0) && (matricule > 0)) {
                $.post('inc/reunionParents/inscriptionEleve.inc.php', {
                        matricule: matricule,
                        idRV: idRV,
                        idRP: idRP
                    },
                    function(resultat) {
                        switch (resultat) {
                            case '1':
                                // visualisation du changement pour la zone des RV
                                $.post('inc/reunionParents/listeRVprofesseur.inc.php', {
                                        idRP: idRP,
                                        droit: true
                                    },
                                    function(resultat) {
                                        $("#listeRV").html(resultat);
                                    }
                                )
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
                                    message: "Cet·te élève a déjà le nombre maximum de rendez-vous"
                                })
                                break;
                            case '-2':
                                bootbox.alert({
                                    title: title,
                                    message: "Il y a déjà un rendez-vous pour cet-te élève à cette heure-là"
                                })
                                break;
                        }
                    }
                )
            }
            else bootbox.alert({
                title: title,
                message: 'Veuillez sélectionner un élève dans sa classe'
            })
        })

        $('body').on('click','#listeAttente', function(){
            var matricule = $('.btn-eleve.btn-success').data('matricule');
            var idRP = $(this).data('idrp');
            var acronyme = $('.btn-prof.btn-success').data('abreviation');
            if (matricule != undefined) {
                $.post('inc/reunionParents/getModalListeAttente.inc.php', {
                    matricule: matricule,
                    acronyme: acronyme,
                    idRP: idRP
                }, function(resultat){
                    $('#modal').html(resultat);
                    $('#modalAttente').modal('show');
                    })
                }
                else bootbox.alert({
                    title: titreErreur,
                    message: "Veuillez choisir un élève dans sa classe"
                })
            })

        $('#modal').on('click', '.periode', function(){
            var periode = $(this).data('periode');
            var matricule = $("#attenteMatricule").val();
            var acronyme = $("#listeAttente").data('acronyme');
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
                        title: titreErreur,
                        message: 'L\'enregistrement a échoué: cet·te élève est déjà en liste d\'attente pour la période ' + periode
                        })
                    }
                else {
                    // retrouver les éléments de la liste d'attente
                    $.post('inc/reunionParents/listeAttenteProfesseur.inc.php', {
                        idRP: idRP,
                        acronyme: acronyme,
                        matricule: matricule,
                        periode: periode,
                        droit: true
                    }, function(resultat) {
                        $("#listeAttenteProf").html(resultat);
                        });
                    $("#modalAttente").modal('hide');
                    }
                });
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
                periode: periode,
                droit: true
                },
            function (resultat){
                // SUPPRIMER LA LIGNE CORRESPONDANTE qui a été traitée
                $('#tbl-attente tr[data-matricule="'+matricule+'"][data-periode="'+periode+'"]').remove();
            })
        })

        $('#printProf').click(function() {
            var idRP = $(this).data('idrp');
            // le prof concerné est l'utilisateur actuel, il n'est pas besoin de le préciser
            var acronyme = $(this).data('acronyme');
            $.post('inc/reunionParents/RV2pdf.inc.php',{
                idRP: idRP
            },
        function(resultat){
            bootbox.alert({
                title: 'Votre document est prêt',
                message: resultat
                });
            })
        })

    })
</script>
