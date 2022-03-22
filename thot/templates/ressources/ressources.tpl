<div class="container-fluid">

    <div class="row">

        <div class="col-xs-12">

            <h2>Réservation des ressources</h2>

                    <div class="col-xs-12 col-md-4">
                        <h3>Types de ressources</h3>

                        <div class="form-group" id="typeRessources">

                            {include file="ressources/selectTypeRessource.tpl"}

                        </div>
                        <div id="ajaxLoader" class="hidden">
                            <img src="images/ajax-loader.gif" alt="loading" class="center-block">
                        </div>

                        {if $userStatus == 'admin'}
                        <div class="btn-group btn-group-justified">
                            <a type="button"
                                class="btn btn-success"
                                id="btn-addRessourceType"
                                href="javascript:void(0)"
                                data-container="body"
                                title="Ajouter un type de ressource">
                                Ajouter un type de ressource
                            </a>
                            <a type="button"
                                class="btn btn-danger"
                                id="btn-delRessourceType"
                                data-container="body"
                                href="javascript:void(0)"
                                title="Supprimer ce type de ressource"
                                disabled>
                                Supprimer ce type de ressource
                            </a>
                        </div>
                        {/if}

                        <h3>Ressources de ce type disponibles</h3>
                        {if $userStatus == 'admin'}
                        <div class="btn-group btn-group-justified">
                            <a type="button" class="btn btn-xs btn-success" id="btn-addRessources" href="javascript:void(0)" title="Ajouter une ressource" data-container="body"><i class="fa fa-plus"></i> </a>
                            <a type="button" class="btn btn-xs btn-info btn-res" id="btn-cloneRessources" href="javascript:void(0)" title="Cloner cette ressource" data-container="body"><i class="fa fa-clone"></i> </a>
                            <a type="button" class="btn btn-xs btn-warning btn-res" id="btn-editRessources" href="javascript:void(0)" title="Modifier cette ressource" data-container="body"><i class="fa fa-edit"></i> </a>
                            <a type="button" class="btn btn-xs btn-danger btn-res" id="btn-delRessources" data-idType="" href="javascript:void(0)" title="Supprimer cette ressource" data-container="body"><i class="fa fa-times"></i></a>
                        </div>
                        {/if}

                        <form id="formSelectRessources">

                            <div class="panel panel-default" id="panelDispo">
                                <div class="panel-body" style="height: auto;">
                                    <div id="resDispo">

                                    {include file="ressources/selectRessource.tpl"}

                                    </div>
                                </div>
                                <div class="panel-footer">
                                    <p><span class="pull-right micro" id="nbRes"><span>0</span> Sélectionné(s)</span></p>
                                </div>
                            </div>

                            <div class="input-group input-daterange form-control">
                                <table class="table table-condensed">
                                    <tr>
                                        <td>
                                            <div class="input-group">
                                                <label for="dateStart">Début</label>
                                                <input type="text" class="form-control datepicker" id="dateStart" name="dateStart" value="" style="width:100%">
                                            </div>
                                        </td>

                                        <td>
                                            <div class="input-group">
                                                <label for="dateEnd">Fin</label>
                                                <input type="text" class="form-control datepicker" id="dateEnd" name="dateEnd" value="" style="width:100%">
                                            </div>
                                        </td>

                                    </tr>
                                </table>

                            </div>

                        </form>

                        <button type="button" class="btn btn-primary btn-block" id="btn-selectRessources">Sélectionner >>>></button>

                    </div>


                    <div class="col-xs-12 col-md-8" id="detailsRessources">

                        {include file="ressources/detailsRessources.html"}

                    </div>

            </div>

        </div>

    </div>

</div>

<div id="modal"></div>

<div id="contextMenu" class="dropdown clearfix" data-date="" data-heure="" data-acronyme="" data-idressource="">
    <ul class="dropdown-menu"
        role="menu"
        style="display:block; position:static; margin-bottom:5px;">
        <li>
            <a tabindex="-1" href="javascript:void(0)" id="reserverPeriode"><i class="fa fa-user"></i> Réserver pour la période</a>
        </li>
        <li>
            <a tabindex="-1" href="javascript:void(0)" id="supprimerPeriode"><i class="fa fa-times"></i> Supprimer la réservation</a>
        </li>
        <li>
            <a tabindex="-1" href="javascript:void(0)" id="attribuerRessource"<i class="fa fa-hand-pointer-o"> Attribution/remise</i></a>
        </li>
        <li>
            <a tabindex="-1" href="javascript:void(0)" id="attribuerRessourcePeriode"<i class="fa fa-hand-grab-o"> Attribution/remise <span id="ctHeure">heure</span></i></a>
        </li>
    </ul>
</div>




<script type="text/javascript">

    function refreshListeRessources(idType){
        $.post('inc/ressources/getRessourceByType.inc.php', {
            idType: idType
        }, function(resultat){
            $('#resDispo').html(resultat);
        })
    }

    $(document).ready(function(){

        // restauration du nombre de ressources sélectionnées
        var idRessources = Cookies.get('idRessources');
        if (idRessources != undefined) {
            var nbCheckedRessources = $.parseJSON(Cookies.get('idRessources')).length;
            $('#nbRes span').html(nbCheckedRessources);
        }


        var idType = Cookies.get('idType');
        if (idType != undefined) {
            $('#typeRessource').val(idType);
            $('#btn-delRessourceType').attr('disabled', false);
            refreshListeRessources(idType);
            // les cases à cocher des ressources sont rétablies dans le sélecteur "selectRessource.tpl"
            }
            else {
                $('#btn-delRessourceType').attr('disabled', true);
            }

        $(document).ajaxStart(function() {
            $('#ajaxLoader').removeClass('hidden');
        }).ajaxComplete(function() {
            $('#ajaxLoader').addClass('hidden');
        });

        // rafraîchissement des boutons d'action sur les ressources (edit, clone, del)
        var idRessources = Cookies.get('idRessources');
        if (idRessources != undefined) {
            idRessources = $.parseJSON(idRessources);
            if (idRessources.length == 1) {
                var idRessource = idRessources[0];
                $('#btn-cloneRessources').attr('disabled', false).data('idressource', idRessource);
                $('#btn-editRessources').attr('disabled', false).data('idressource', idRessource);
                $('#btn-delRessources').attr('disabled', false).data('idressource', idRessource);
                }
                else {
                    $('#btn-cloneRessources').attr('disabled', true).data('idressource', '');
                    $('#btn-editRessources').attr('disabled', true).data('idressource', '');
                    $('#btn-delRessources').attr('disabled', true).data('idressource', '');
                }
        }


        // changement du type des ressources souhaitées
        $('body').on('change', '#typeRessource', function(){
            var idType = $(this).val();
            Cookies.set('idType', idType);
            // rafraîchir la liste des ressources disponibles pour ce type
            refreshListeRessources(idType);
            if (idType != '') {
                $('#btn-delRessourceType').attr('disabled', false);
                }
                else {
                    $('#btn-delRessourceType').attr('disabled', true);
                }
        })

        // sélection case à cocher des ressources
        $('body').on('change', '.ressource', function(){
            // enregistrement des choix de ressources dans le Cookie
            var idRessources = []
            $('.ressource:checked').each(function() {
                idRessources.push(this.attributes.value.value);
            });
            Cookies.set('idRessources', JSON.stringify(idRessources));

            var nb = $('.ressource:checked').length;
            $('#nbRes').text(nb + ' sélectionné(s)');

            $('#btn-selectRessources').attr('disabled', (nb == 0));
            if (nb == 1){
                var idRessource = $('.ressource:checked').val();
                $('#btn-cloneRessources').attr('disabled', false).data('idressource', idRessource);
                $('#btn-editRessources').attr('disabled', false).data('idressource', idRessource);
                $('#btn-delRessources').attr('disabled', false).data('idressource', idRessource);
                }
                else {
                    $('#btn-cloneRessources').attr('disabled', true).data('idressource', '');
                    $('#btn-editRessources').attr('disabled', true).data('idressource', '');
                    $('#btn-delRessources').attr('disabled', true).data('idressource', '');
                }
        })

        $('body').on('click', '.btn-infoRessource', function(){
            var idRessource = $(this).data('idressource');
            $.post('inc/ressources/modalViewCalendar.inc.php', {
                idRessource: idRessource
            }, function(resultat){
                $('#modal').html(resultat);
                $('#modalViewCalendar').data('idRessource', idRessource);
                $('#modalViewCalendar').modal('show');
            })
        })

        $('#supprimerPeriode').click(function(){
            var idRessource = $(this).closest('div').data('idressource');
            var date = $(this).closest('div').data('date');
            var heure = $(this).closest('div').data('heure');
            var acronyme = $(this).closest('div').data('acronyme');
            var td = $('button[data-date="'+date+'"][data-heure="'+heure+'"][data-idressource="'+idRessource+'"]').closest('td');
            $.post('inc/ressources/unReserveAdmin.inc.php', {
                abreviation: acronyme,
                idRessource: idRessource,
                date: date,
                heure: heure
            }, function(resultat){
                td.html(resultat);
            })
        })

        $('body').on('click', '.btn-allPeriode', function(){
            var heure = $(this).data('heure');
            var formulaire = $('#formSelectRessources').serialize();
            $.post('inc/ressources/reserveAllPeriode.inc.php', {
                heure: heure,
                formulaire: formulaire
            }, function(resultat){
                $('#btn-selectRessources').trigger('click');
            })
        })

        $('body').on('click', '.btn-allDate', function(){
            var date = $(this).data('date');
            var idRessource = $(this).data('idressource');
            $.post('inc/ressources/reserveAll4date.inc.php', {
                idRessource: idRessource,
                date: date
            }, function(resultat){
                $('#btn-selectRessources').trigger('click');
            })
        })

        // action sur le bouton si la ressource est déjà réservée par l'utilisateur
        $('body').on('click', '.btn-reserved', function(){
            var idRessource = $(this).closest('tr').data('idressource');
            var date = $(this).closest('tr').data('date');
            var heure = $(this).data('heure');
            var abreviation = $(this).data('acronyme');
            var td = $(this).closest('td');
            $.post('inc/ressources/unReserveRessource.inc.php', {
                idRessource: idRessource,
                date: date,
                heure: heure,
                abreviation: abreviation
            }, function(resultat){
                if (resultat != '')
                    td.html(resultat);
            })
        })

        // réservation de la ressource
        $('body').on('click', '.btn-reservation', function(){
            var acronyme = $(this).data('acronyme');
            var idRessource = $(this).closest('tr').data('idressource');
            var date = $(this).closest('tr').data('date');
            var heure = $(this).data('heure');
            var td = $(this).closest('td');
            $.post('inc/ressources/reserveRessource.inc.php', {
                idRessource: idRessource,
                date: date,
                heure: heure
            }, function(resultat){
                td.html(resultat);
            })
        })

        $('#btn-cloneRessources').click(function(){
            var idRessource = $(this).data('idressource');
            $.post('inc/ressources/cloneRessource.inc.php', {
                idRessource: idRessource,
                addEditClone: 'clone'
            }, function(resultat){
                $('#modal').html(resultat);
                $('#modalEditRessource').modal('show');
            })
        })

        $('#btn-editRessources').click(function(){
            var idRessource = $(this).data('idressource');
            $.post('inc/ressources/editRessource.inc.php', {
                idRessource: idRessource,
                addEditClone: 'edit'
            }, function(resultat){
                $('#modal').html(resultat);
                $('#modalEditRessource').modal('show');
            })
        })

        $('#btn-delRessources').click(function(){
            var idRessource = $(this).data('idressource');
            $.post('inc/ressources/reservations4ressource.inc.php', {
                idRessource: idRessource
            }, function(resultat){
                $('#modal').html(resultat);
                $('#modalConfirmDelRes').modal('show');
            })
        })
        $('#modal').on('click', '#btn-modalDelRessource', function(){
            var idRessource = $(this).data('idressource');
            $.post('inc/ressources/modalDelRessource.inc.php', {
                idRessource: idRessource
            }, function(resultat){
                var resultJSON = JSON.parse(resultat);
                var nbRessources = resultJSON.nbRessources;
                var nbReservations = resultJSON.nbReservations;
                // liste des ressources de ce type mise à jour
                $('#resDispo').html(resultJSON.html);
                // mise à jour des boutons d'édition des ressources
                $('.btn-res').data('idressource', '').attr('disabled', true);
                $('#modalConfirmDelRes').modal('hide');
                $("#detailsRessources").load('templates/ressources/detailsRessources.html');
                bootbox.alert({
                    title: "Suppression d'une ressource",
                    message: nbRessources + " ressource supprimée <br>"+ nbReservations +" effacée(s)"
                })
            })
        })

        $('#btn-selectRessources').click(function(){
            var dateStart = $('#dateStart').val().split('/');
            var dateDebut = new Date(dateStart[2], dateStart[1]-1, dateStart[0]);

            var dateEnd = $('#dateEnd').val().split('/');
            var dateFin = new Date(dateEnd[2], dateEnd[1]-1, dateEnd[0]);

            var n = $('.ressource:checked').length;
            if ((dateDebut <= dateFin) && n > 0) {
                var formulaire = $('#formSelectRessources').serialize();
                $.post('inc/ressources/getWantedRessources.inc.php', {
                        formulaire: formulaire
                    }, function(resultat){
                        $('#detailsRessources').html(resultat)
                    })
                }
                else bootbox.alert({
                    title: 'Erreur',
                    message: 'Veuillez sélectionner au moins un item'
                })
        })

        $('#dateStart').on('change', function (e) {
            var d = $('#dateStart').datepicker('getDate');
            var n = new Date(d.getFullYear(), d.getMonth(), d.getDate());

            $('#dateEnd').datepicker('setStartDate', n).datepicker('setDate', n);
        });

        var d = new Date();
        var today = new Date().toLocaleDateString();
        $('.datepicker').val(today);

        $('#dateStart, #dateEnd').datepicker({
            startDate: today,
            format: 'dd/mm/yyyy',
            clearBtn: true,
            language: 'fr',
            calendarWeeks: true,
            autoclose: true,
            todayHighlight: true,
            daysOfWeekDisabled: [0,6],
        })

        $('#modal').on('click', '#hasCaution', function(){
            if ($(this).is(':checked'))
                $('#caution').attr('disabled', false);
                else $('#caution').attr('disabled', true);
        })

        $('#modal').on('click', '#btn-reset', function(){
            $('#formAddRessource').trigger('reset');
        })

        $('#btn-addRessources').click(function(){
            var idType = $('#typeRessource').val();
            $.post('inc/ressources/editRessource.inc.php', {
                idType: idType,
                addEditClone: 'add'
            }, function(resultat){
                $('#modal').html(resultat);
                $('#modalEditRessource').modal('show');
                $('.btn-res').attr('enabled', true);
            })
        })

        $('#modal').on('click', '#btn-save', function(){
            if ($('#formEditRessource').valid()){
                var reference = $('#reference').val();
                var description = $('#description').val();
                var texteType = $('#typeRessource :selected').text();
                var formulaire = $('#formEditRessource').serialize();

                $.post('inc/ressources/saveRessource.inc.php', {
                    formulaire: formulaire
                }, function(resultat){
                    var resultJSON = JSON.parse(resultat);
                    var idRessource = resultJSON.idRessource;
                    // idRessource revient avec Null si la référence existe déjà
                    if (idRessource != null) {
                        var addEditClone = resultJSON.addEditClone;
                        if (addEditClone == 'edit')
                            bootbox.alert({
                                title: 'Modification de la ressource',
                                message: 'La ressource <strong>' + description + '</strong> a été modifiée'
                            })
                            else bootbox.alert({
                                    title: 'Nouvelle ressource',
                                    message: 'La ressource <strong>' + description + '</strong> a été ajoutée'
                                })
                        // liste des ressources de ce type mise à jour
                        $('#resDispo').html(resultJSON.html);
                        $('#btn-delRessource').attr('disabled', false);
                        $('#modalEditRessource').modal('hide');
                        // mise à jour des boutons d'édition des ressources
                        $('.btn-res').data('idressource', idRessource);
                        $("#detailsRessources").load('templates/ressources/detailsRessources.html');
                    }
                    else bootbox.alert({
                        title: 'Problème',
                        message: 'Une ressource avec la référence <strong>' + reference + '</strong> pour le type <strong> ' + texteType + ' </strong>existe déjà.'
                        })
                });
            }
        })

        $('#btn-delRessourceType').click(function(){
            var idType = $('#typeRessource').val();
            var texte = $('#typeRessource :selected').text();
            var title = 'Suppression d\'un type de ressource';
            $.post('inc/ressources/delTypeRessource.inc.php', {
                idType: idType
            }, function(resultat){
                if (resultat != '') {
                    $('#typeRessources').html(resultat);
                    // recharger la liste des types de ressources
                    $.post('inc/ressources/getRessourceByType.inc.php', {
                        idType: 0
                    }, function(resultat){
                        $('#resDispo').html(resultat);
                        $('#btn-delRessourceType').attr('disabled', true);
                        bootbox.alert({
                            title: 'Le titre',
                            message: 'Le type de ressource <strong> ' + texte + '</strong> a été supprimé'
                            });
                    })
                }
                else bootbox.alert({
                    title: title,
                    message: 'Ce type contient des ressources et ne peut être supprimé'
                    })
            })
        })

        $('#btn-addRessourceType').click(function(){
            bootbox.prompt({
                title: 'Dénomination de ce nouveau type',
                callback: function(result){
                    if (result != '') {
                        $.post('inc/ressources/addTypeRessource.inc.php', {
                            type: result
                        }, function(resultat){
                            $('#typeRessource').html(resultat);
                            $.post('inc/ressources/getRessourceByType.inc.php', {
                                idType: 0
                            }, function(resultat){
                                $('#resDispo').html(resultat);
                                $('#btn-delRessourceType').attr('disabled', false);
                            })
                        })
                    }
                }
            })
        })

        $('body').on('click', '#selAllRessources', function(){
            var isChecked = !$(this).closest('table').find('.ressource').first().is(':checked');
            $('.ressource').prop('checked', isChecked);
        })


        {if ($userStatus == 'admin')}
            // userStatus == admin
            $('#reserverPeriode').click(function(){
                var idRessource = $(this).closest('div').data('idressource');
                var date = $(this).closest('div').data('date');
                var heure = $(this).closest('div').data('heure');
                var td = $('button[data-date="'+date+'"][data-heure="'+heure+'"][data-idressource="'+idRessource+'"]').closest('td');
                $.post('inc/ressources/reserveRessource.inc.php', {
                    idRessource: idRessource,
                    date: date,
                    heure: heure
                }, function(resultat){
                    td.html(resultat);
                })
            })

            $('#attribuerRessource').click(function(){
                var idRessource = $(this).closest('div').data('idressource');
                var date = $(this).closest('div').data('date');
                var heure = $(this).closest('div').data('heure');
                var abreviation = $(this).closest('div').data('acronyme');
                var td = $('button[data-date="'+date+'"][data-heure="'+heure+'"][data-idressource="'+idRessource+'"]').closest('td');
                $.post('inc/ressources/attribuerRessource.inc.php', {
                    idRessource: idRessource,
                    date: date,
                    heure: heure,
                    abreviation: abreviation
                }, function(resultat){
                    td.html(resultat);
                })
            })

            $('#attribuerRessourcePeriode').click(function(){
                var date = $(this).closest('div').data('date');
                var heure = $(this).closest('div').data('heure');
                var abreviation = $(this).closest('div').data('acronyme');

                var listeBoutons = $('button[data-heure="' + heure +'"][data-acronyme="' + abreviation + '"]');
                $(listeBoutons).each(function() {
                    var idRessource = $(this).data('idressource');
                    var date = $(this).data('date');
                    var td = $('button[data-date="'+date+'"][data-heure="'+heure+'"][data-idressource="'+idRessource+'"]').closest('td');
                    $.post('inc/ressources/attribuerRessource.inc.php', {
                        idRessource: idRessource,
                        date: date,
                        heure: heure,
                        abreviation: abreviation
                    }, function(resultat){
                        td.html(resultat);
                    })
                });
            })


            $('body').on('contextmenu', '#detailsRessources .btn', function(event){
                $('#contextMenu').data('date', $(this).data('date'));
                var heure = $(this).data('heure');
                $('#contextMenu').data('heure', heure);
                $('#contextMenu').data('idressource', $(this).data('idressource'));
                var acronyme = $(this).data('acronyme');
                $('#contextMenu').data('acronyme', acronyme);
                $('span#ctHeure').text(heure);
                if ($(this).hasClass('btn-reserved')) {
                        $('#reserverPeriode').attr('disabled', true);
                        $('#supprimerPeriode').attr('disabled', false);
                        $('#attribuerRessource').attr('disabled', false);
                    }
                    else if ($(this).hasClass('btn-reservation')) {
                        $('#reserverPeriode').attr('disabled', false);
                        $('#supprimerPeriode').attr('disabled', true);
                        $('#attribuerRessource').attr('disabled', true);
                    }
                    else if ($(this).hasClass('btn-attribue')) {
                        $('#reserverPeriode').attr('disabled', true);
                        $('#supprimerPeriode').attr('disabled', true);
                        $('#attribuerRessource').attr('disabled', false);
                    }
                    else {
                        $('#reserverPeriode').attr('disabled', false);
                        $('#supprimerPeriode').attr('disabled', true);
                    }
                $('#contextMenu').css({
                  display: "block",
                  left: event.pageX-50,
                  top: event.pageY
              });
            return false;
            })

            $('html').click(function() {
                $('#contextMenu').hide();
            });

            $('body').on('click', '#btn-longTerme', function(){
                var idRessource = $(this).data('idressource');
                var idType = $(this).data('idtype');
                $.post('inc/ressources/getModalLongTerme.inc.php', {
                    idRessource: idRessource,
                    idType: idType
                }, function(resultat){
                    $('#modal').html(resultat);
                    $('#modalLongTerme').modal('show');
                })
            })
            $('#modal').on('click', '#saveModalLongTerme', function(){
                var formulaire = $('#formLongTerme').serialize();
                var description = $('#description').val();
                var idType = $('#idType').val();
                var idRessource = $('#idRessource').val();
                $.post('inc/ressources/saveModalLongTerme.inc.php', {
                    formulaire: formulaire
                }, function(resultat){
                    bootbox.alert({
                        title: 'Emprunt à long terme',
                        message: 'Réservation de "' + description + '" enregistrée',
                        callback: function(){
                            $('#modalLongTerme').modal('hide');
                            // rafraîchir la liste des ressources disponibles pour ce type
                            refreshListeRessources(idType);
                        }
                    })
                })
            })
        // userStatus == admin
        {/if}

    })

</script>
