{* adminProfs.tpl *}
{* ----------------------------------------------------------------------- *}
{* Interface d'administration des réunions de parents                      *}
{* Gestion par prof                                                        *}
{* pour l'administrateur                                                   *}
{* ----------------------------------------------------------------------- *}

<div class="container-fluid">

    <div class="row">

<div class="col-md-2 col-sm-6">

    <div class="panel panel-success">
        <div class="panel-heading">
            Liste des enseignants
        </div>
        <div class="panel-body" style="max-height:40em; overflow:auto">
            <ul class="list-unstyled">
                {foreach from=$listeProfs key=abr item=data}
                <li title="{$data.nom} {$data.prenom}">
                    <button
                        type="button"
                        class="btn btn-sm btn-block btn-prof{if (isset($acronyme)) && ($abr == $data.acronyme)} btn-success{else} btn-default{/if}"
                        data-abreviation="{$data.acronyme}"
                        data-nomprof="{$data.prenom} {$data.nom}"
                        data-statut="{$data.statut}">
                        {$data.nom} {$data.prenom}
                    </button>
                </li>
                {/foreach}
            </ul>
        </div>

    </div>

</div>  <!-- col-md-... -->


        <div class="col-md-7 col-sm-6">

            <!-- liste des RV et liste d'attente -->
            <div id="listeRV" style="max-height:40em; overflow: auto">
                <p class="avertissement">Veuillez sélectionner un professeur dans la colonne de gauche</p>

                {* include file="reunionParents/tableRVAdminDroit.tpl" *}
            </div>

            <div id="listeAttenteProf">
                    {* include file="reunionParents/listeAttenteAdminDroit.tpl" *}
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
                {* include file="reunionParents/listeElevesProf.tpl" *}
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

var titreErreur = "Erreur";

    $(document).ready(function() {

        $('[data-toggle="popover"]').popover();

        $('#printProf').click(function() {
            var idRP = $(this).data('idrp');
            // le prof concerné est celui qui est sélectionné dans la liste des profs
            var acronyme = $('.btn-prof.btn-success').data('abreviation');
            $.post('inc/reunionParents/RV2pdf.inc.php',{
                idRP: idRP,
                acronyme: acronyme
            },
        function(resultat){
            bootbox.alert({
                title: 'Votre document est prêt',
                message: resultat
                });
            })
        })

    $('body').on('click', '#delAllRV', function(){
        var idRP = $('#idRP').val();
        var acronyme = $('.btn-prof.btn-success').data('abreviation');
        $.post('inc/reunionParents/delAllRV.inc.php', {
            idRP: idRP,
            acronyme: acronyme
        }, function(resultat){
            $('#modal').html(resultat);
            $('#modalDelAllRV').modal('show');
        })
    })

    $('#modal').on('click', '#btn-delAllRV', function(){
        var idRP = $('#idRP').val();
        var acronyme = $('.btn-prof.btn-success').data('abreviation');
        if ($('#form-delAllRV').valid()){
            var raison = $('#modal #raisonDel').val();
            $.post('inc/reunionParents/delConfirmDelAllRV.inc.php', {
                idRP: idRP,
                raison: raison,
                acronyme: acronyme
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
                            acronyme: acronyme,
                            droit: true
                        }, function(resultat){
                            $('#listeRV').html(resultat);
                        })
                    }
                })
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
                        var acronyme = $('.btn-prof.btn-success').data('abreviation');
                        // visualisation du changement pour la zone des RV
                        $.post('inc/reunionParents/listeRVprof.inc.php', {
                            idRP: idRP,
                            acronyme: acronyme,
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
        var acronyme = $('.btn-prof.btn-success').data('abreviation');
        $.post('inc/reunionParents/delConfirmRVparent.inc.php', {
            raison: raison,
            idRV: idRV,
            idRP: idRP,
            matricule: matricule
        }, function(resultatJSON){
            var resultat = JSON.parse(resultatJSON);
            if (resultat['nb'] == 1)
                var message = 'Le rendez-vous a été supprimé';
                else var message = 'Problème';
            if (resultat['mailOK'] == true)
                message += '<br> mail envoyé';
                else message += '<br>Le mail de confirmation n\'a pas pu être envoyé';
            $('#modalDelRV').modal('hide');
            $.post('inc/reunionParents/listeRvAdmin.inc.php', {
                idRV: idRV,
                idRP: idRP,
                acronyme: acronyme,
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

        // sélection d'un prof
        $('body').on('click', '.btn-prof', function() {
            var acronyme = $(this).data('abreviation');
            var idRP = $("#idRP").val();
            var nomProf = $(this).data('nomprof');
            var statut = $(this).data('statut');
            $(".btn-prof").removeClass('btn-success');
            $(this).addClass('btn-success');
            // produire la liste des RV pour le prof désigné
            $.post('inc/reunionParents/listeRvAdmin.inc.php', {
                    acronyme: acronyme,
                    idRP: idRP,
                    droit: true
                }, function(resultat) {
                    $("#listeRV").html(resultat);
                    // produire la liste d'attente admin pour ce prof
                    $.post('inc/reunionParents/listeAttenteAdmin.inc.php', {
                                idRP: idRP,
                                acronyme: acronyme,
                                droit: true
                            },
                            function(resultat) {
                                $("#listeAttenteProf").html(resultat);
                                // produire la liste des élèves possibles pour un prof donné
                                $.post('inc/reunionParents/listeEleves.inc.php', {
                                        acronyme: acronyme,
                                        statut: statut,
                                        typeRP: typeRP
                                    },
                                    function(resultat) {
                                        $("#listeEleves").html(resultat);
                                    }
                                )
                            }
                        )
                    }
                )
            })

        // attribution d'un RV à un élève
        $("#listeRV").on('click', '.lien', function() {
            var idRV = $(this).data('idrv');
            var matricule = $('.btn-eleve.btn-success').data('matricule');
            var acronyme = $('.btn-prof.btn-success').data('abreviation');
            var idRP = $("#idRP").val();

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
                                $.post('inc/reunionParents/listeRvAdmin.inc.php', {
                                        acronyme: acronyme,
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

            var title = "Erreur";

            // On envoie l'élève dans la RP $idRP
            if (idRV > 0) {
                // AJOUTER L'ÉLÈVES DANS LA TABLE DÉJÀ INITIALISÉE
                $.post('inc/reunionParents/inscriptionEleve.inc.php', {
                    matricule: matricule,
                    idRP: idRP,
                    idRV: idRV,
                    acronyme: acronyme,
                    periode: periode,
                    userName: userName
                    },
                    function(resultat){
                        switch (resultat) {
                            case '-1':
                                // le nombre max de RV est atteint
                                bootbox.alert({
                                    title: titreErreur,
                                    message: "Cet(te) élève a déjà le nombre maximum de rendez-vous."
                                })
                                break;
                            case '-2':
                                // il y a déjà un RV à cette heure-là
                                bootbox.alert({
                                    title: titreErreur,
                                    message: "Il y a déjà un rendez-vous pour cet-te élève à cette heure-là."
                                })
                                break;
                            default:
                                // si le type de gestion est "eleve", il faut mettre à jour le "badge" et le "popover" des RV de l'élève
                                if (typeGestion == 'eleve') {
                                    // mise à jour du badge -nombre de RV- près du nom de l'élève
                                    var badge = parseInt($("#listeEleves").find('[data-matricule='+matricule+']').closest('li').find('.badge').text());
                                    $("#listeEleves").find('[data-matricule='+matricule+']').closest('li').find('.badge').text(badge+1);

                                    // Mise à jour du popover de la liste de RV
                                    $.post('inc/reunionParents/ulRvEleves.inc.php', {
                                            matricule: matricule,
                                            idRP: idRP
                                        },
                                        function(resultat) {
                                            var btnEleve = $("#listeEleves").find('[data-matricule=' + matricule + ']');
                                            btnEleve.attr('data-content', resultat).attr('data-placement', 'left');
                                            btnEleve.data('bs.popover').setContent();
                                        })
                                    }
                                // reconstruire la liste des RV mise à jour pour le prof désigné
                                $.post('inc/reunionParents/listeRvAdmin.inc.php', {
                                            acronyme: acronyme,
                                            idRP: idRP,
                                            droit: true
                                        },
                                        function(resultat) {
                                            $("#listeRV").html(resultat);
                                            // SUPPRIMER LA LIGNE CORRESPONDANTE du tableau des attentes et qui a été traitée
                                            $('#tbl-attente tr[data-matricule="'+matricule+'"][data-periode="'+periode+'"]').remove();
                                        }
                                    )
                                break;
                            }
                        });
            }
            else bootbox.alert({
                title: title,
                message: "Veuillez choisir une heure de rendez-vous",
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
                periode: periode,
                droit: true
                },
            function (resultat){
                // SUPPRIMER LA LIGNE CORRESPONDANTE qui a été traitée
                $('#tbl-attente tr[data-matricule="'+matricule+'"][data-periode="'+periode+'"]').remove();
            })
        })

    })
</script>
