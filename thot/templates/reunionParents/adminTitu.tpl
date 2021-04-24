{* adminTitu.tpl *}
{* ----------------------------------------------------------------------- *}
{* Interface d'administration des réunions de parents de type "titulaire"  *}
{* pour les titulaires de classe                                           *}
{* ----------------------------------------------------------------------- *}

<div class="container-fluid">

    <div class="row">

        <div class="col-md-9 col-sm-6">

            <!-- liste des RV et liste d'attente -->
            <div id="listeRV" style="max-height:40em; overflow: auto">
                {if isset($listeRV)}
                    {include file="reunionParents/tableRVAdminDroit.tpl"}
                {/if}
            </div>

            <div id="listeAttenteProf">
                {if isset($listeAttente)}
                    {include file="reunionParents/listeAttenteAdminDroit.tpl"}
                {/if}
            </div>

        </div>
        <!-- col-md-... -->


        <div class="col-md-3 col-sm-6">

                <button
                    type="button"
                    id="printProf"
                    title="Imprimer"
                    class="btn btn-primary btn-block"
                    data-idrp="{$idRP}"
                    data-acronyme="{$acronyme}">
                    <i class="fa fa-print fa-2x"></i></button>

            <div id="listeEleves" style="max-height: 40em; overflow:auto;">
                {if isset($listeEleves)} {include file="reunionParents/listeElevesProf.tpl"} {/if}
            </div>

        </div>
        <!-- col-md-... -->

    </div>
    <!-- row -->

</div>
<!-- container -->

<div id="modal"></div>


<script type="text/javascript">

var typeRP="{$typeRP}"
var titreErreur = 'Erreur';

    $(document).ready(function() {

        $('body').on('click', '#delAllRV', function(){
            var idRP = $('#idRP').val();
            $.post('inc/reunionParents/delAllRV.inc.php', {
                idRP: idRP
            }, function(resultat){
                $('#modal').html(resultat);
                $('#modalDelAllRV').modal('show');
            })
        })

        $('#modal').on('click', '#btn-delAllRV', function(){
            var idRP = $('#idRP').val();
            if ($('#form-delAllRV').valid()){
                var raison = $('#modal #raisonDel').val();
                $.post('inc/reunionParents/delConfirmDelAllRV.inc.php', {
                    idRP: idRP,
                    raison: raison
                }, function(resultatJSON){
                    var resultat = JSON.parse(resultatJSON);
                    var nbDel = resultat.nbDel;
                    var nbMails = resultat.nbMails;
                    bootbox.alert({
                        title: "Suppression des rendez-vous",
                        message: nbDel + " rendez-vous annulés, " + nbMails + " mails envoyés",
                        callback: function(){
                            $('#modalDelAllRV').modal('hide');
                            // rétabliisement de la zone des RV
                            $.post('inc/reunionParents/listeRVprof.inc.php', {
                                idRP: idRP,
                                droit: true
                            }, function(resultat){
                                $('#listeRV').html(resultat);
                            })
                        }
                    })
                })
            }
        })

        // attribution d'un RV à un élève
        $("#listeRV").on('click', '.lien', function() {
            var idRV = $(this).data('idrv');
            var matricule = $('.btn-eleve.btn-success').data('matricule');
            // var acronyme = $('.btn-prof.btn-primary').data('abreviation');
            var idRP = $('#idRP').val();

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
                                $.post('inc/reunionParents/listeRvAdmin.inc.php', {
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
                                    title: titreErreur,
                                    message: "L'enregistrement s'est mal passé"
                                });
                                break;
                            case '-1':
                                bootbox.alert({
                                    title: titreErreur,
                                    message: "Le nombre maximum de RV a déjà été atteint"
                                });
                                break;
                            case '-2':
                                bootbox.alert({
                                    title: titreErreur,
                                    message: "Il y a déjà un rendez-vous pour cet-te élève à cette heure-là"
                                });
                                break;
                        }
                    }
                )
            }
        })

        // effacement d'un RV
        $("#listeRV").on('click', '.unlink', function() {
            var idRV = $(this).data('idrv');
            var eleve = $(this).data('eleve');
            var mail = $(this).data('mail');
            var acronyme = $('.btn-prof.btn-success').data('abreviation');
            var idRP = $('#idRP').val();

            // suppression du popover éventuellement resté ouvert
            $(".popover").popover('hide');

            if (mail == '') {
                $.post('inc/reunionParents/delRV.inc.php', {
                        idRV: idRV,
                        idRP: idRP
                    },
                    function(resultat) {
                        switch (resultat) {
                            case '1':
                                // visualisation du changement pour la zone des RV
                                $.post('inc/reunionParents/listeRvAdmin.inc.php', {
                                        acronyme: acronyme,
                                        idRP: idRP,
                                        droit: true
                                    },
                                    function(resultat) {
                                        $("#listeRV").html(resultat);
                                    }
                                );
                                break;
                            case '0':
                                bootbox.alert({
                                    title: titreErreur,
                                    message: "Le RV n'a pas pu être supprimé"
                                })
                                break;
                        }
                    }
                )
            } else {
                $("#modalId").val(id);
                $("#modalNomEleve").html(eleve);
                $("#modalDelRV").modal('show');
            }
        })

        $('body').on('click', '#listeAttente', function() {
            var matricule = $('.btn-eleve.btn-success').data('matricule');
            // var acronyme = $('.btn-prof.btn-primary').data('abreviation');
            if (matricule !== undefined) {
                var idRP = $('#idRP').val();
                $.post('inc/reunionParents/getModalListeAttente.inc.php', {
                    matricule: matricule,
                    idRP: idRP
                }, function(resultat){
                    $('#modal').html(resultat);
                    $('#modalAttente').modal('show');
                    })
            } else bootbox.alert({
                title: titreErreur,
                message: "Veuillez sélectionner un élève dans la colonne de droite"
            })
        })

        // fenêtre popup de choix de la période en liste d'attente
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
                    // retrouver les éléments de la liste d'attente
                    $.post('inc/reunionParents/listeAttenteAdmin.inc.php', {
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

        $('#printProf').click(function() {
            var idRP = $(this).data('idrp');
            // l'acronyme de l'utilisateur courant est connu dans la procédure RV2pdf
            $.post('inc/reunionParents/RV2pdf.inc.php',{
                idRP: idRP,
            },
        function(resultat){
            bootbox.alert({
                title: 'Votre document est prêt',
                message: resultat
                });
            })
        })

        // attribution d'un RV à un élève qui se trouve en liste d'attente
        $('body').on('click','.unlinkAttente', function() {
            var matricule = $(this).data('matricule');
            var periode = $(this).data('periode');
            var idRV = $('.idRV:checked').val();
            var userName = $(this).data('userName');
            var idRP = $('#idRP').val();

            if (idRV > 0) {
                $.post('inc/reunionParents/inscriptionEleve.inc.php', {
                    matricule: matricule,
                    idRP: idRP,
                    periode: periode,
                    userName: userName,
                    idRV: idRV
                    },
                    function(resultat){
                        switch (resultat) {
                            case '-1':
                                bootbox.alert({
                                    title: titreErreur,
                                    message: "Le nombre maximum de RV est atteint"
                                })
                                break;
                            case '-2':
                                bootbox.alert({
                                    title: titreErreur,
                                    message: "Il y a déjà un RV à cette heure-là"
                                })

                                break;
                            default:
                                $.post('inc/reunionParents/delAttente.inc.php', {
                                    matricule: matricule,
                                    idRP: idRP,
                                    periode: periode
                                }, function(resultat){
                                    // SUPPRIMER LA LIGNE CORRESPONDANTE de la table des attentes qui a été traitée
                                    $('#tbl-attente tr[data-matricule="'+matricule+'"][data-periode="'+periode+'"]').remove();
                                    // reconstruire la liste des RV mise à jour pour le prof désigné
                                    $.post('inc/reunionParents/listeRvAdmin.inc.php', {
                                            idRP: idRP,
                                            droit: true
                                            },
                                            function(resultat) {
                                                $("#listeRV").html(resultat);
                                            }
                                        );
                                })
                                break;
                            }
                        });
            }
            else bootbox.alert({
                    title: titreErreur,
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
                matricule: matricule,
                periode: periode
                },
            function (resultat){
                // SUPPRIMER LA LIGNE CORRESPONDANTE qui a été traitée
                $('#tbl-attente tr[data-matricule="'+matricule+'"][data-periode="'+periode+'"]').remove();
            })
        })

    })
</script>
