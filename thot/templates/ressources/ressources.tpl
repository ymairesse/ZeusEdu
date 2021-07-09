<div class="container-fluid">

    <div class="row">

        <div class="col-xs-12">

            <h2>Réservation des ressources</h2>

                    <div class="col-xs-12 col-md-4">
                        <h3>Types de ressources</h3>

                        <div class="form-group" id="typeRessources">

                            {include file="ressources/selectTypeRessource.tpl"}

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
                            <a type="button" class="btn btn-xs btn-success" id="btn-addRessource" href="javascript:void(0)" disabled title="Ajouter une ressource" data-container="body"><i class="fa fa-plus"></i> </a>
                            <a type="button" class="btn btn-xs btn-info afterDel" id="btn-cloneRessource" href="javascript:void(0)" disabled title="Cloner cette ressource" data-container="body"><i class="fa fa-clone"></i> </a>
                            <a type="button" class="btn btn-xs btn-warning afterDel" id="btn-editRessource" href="javascript:void(0)" disabled title="Modifier cette ressource" data-container="body"><i class="fa fa-edit"></i> </a>
                            <a type="button" class="btn btn-xs btn-danger afterDel" id="btn-delRessource" data-idType="" href="javascript:void(0)" disabled title="Supprimer cette ressource" data-container="body"><i class="fa fa-times"></i></a>
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
                                    <p><span class="pull-right micro" id="nbRes">0 Sélectionné(s)</span></p>
                                </div>
                            </div>

                            <div class="input-group input-daterange form-control">
                                <table class="table table-condensed">
                                    <tr>
                                        <td>
                                            <input type="text" class="form-control datepicker" id="dateStart" name="dateStart" value="" style="width:100%">
                                        </td>
                                        <td>depuis</td>
                                        <td>
                                            <select class="form-control" name="startTime" id="startTime">
                                                {foreach from=$listeHeuresCours key=wtf item=data}
                                                    <option value="{$data.debut}">[ {$data.debut}</option>
                                                {/foreach}
                                            </select>
                                        </td>

                                    </tr>
                                    <tr>
                                        <td><input type="text" class="form-control datepicker" id="dateEnd" name="dateEnd" value="" style="width:100%"></td>
                                        <td>jusqu'à</td>
                                        <td>
                                            <select class="form-control" name="endTime" id="endTime">
                                                {foreach from=$listeHeuresCours key=wtf item=data}
                                                    <option value="{$data.debut}" {if $wtf == 1}disabled{/if}>{$data.debut} ]</option>
                                                {/foreach}
                                            </select>
                                        </td>

                                    </tr>
                                </table>

                            </div>

                        </form>

                        <button type="button" class="btn btn-primary btn-block" id="btn-selectRessources" disabled>Sélectionner >>>></button>

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
    </ul>
</div>

<script type="text/javascript">

    function refreshListeRessources(idType, idRessource){
        $.post('inc/ressources/getRessourceByType.inc.php', {
            idType: idType,
            idRessource: idRessource
        }, function(resultat){
            $('#resDispo').html(resultat);
            $('#btn-delRessource').attr('disabled', true);
            $('#btn-cloneRessource').attr('disabled', true);
            $('#btn-editRessource').attr('disabled', true);
            $('#btn-selectRessources').attr('disabled', true);
            if (idRessource != undefined)
                $('.afterDel').attr('disabled', false);
        })
    }

    $(document).ready(function(){

        {if ($userStatus == 'admin')}

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

            $('body').on('contextmenu', '#detailsRessources .btn-hire', function(event){
                $('#contextMenu').data('date', $(this).data('date'));
                $('#contextMenu').data('heure', $(this).data('heure'));

                $('#contextMenu').data('idressource', $(this).data('idressource'));
                var acronyme = $(this).data('acronyme');
                $('#contextMenu').data('acronyme', acronyme);
                if (acronyme != undefined) {
                    $('#reserverPeriode').addClass('hidden');
                    $('#supprimerPeriode').removeClass('hidden');
                    }
                    else {
                        $('#reserverPeriode').removeClass('hidden');
                        $('#supprimerPeriode').addClass('hidden');
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
                        message: 'Réservation de "'+description+'" enregistrée',
                        callback: function(){
                            $('#modalLongTerme').modal('hide');
                            // rafraîchir la liste des ressources disponibles pour ce type
                            refreshListeRessources(idType, idRessource);
                        }
                    })
                })
            })

        {/if}

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

        $('#btn-cloneRessource').click(function(){
            var idRessource = $(this).data('idressource');
            $.post('inc/ressources/cloneRessource.inc.php', {
                idRessource: idRessource,
                addEditClone: 'clone'
            }, function(resultat){
                $('#modal').html(resultat);
                $('#modalEditRessource').modal('show');
            })
        })

        $('#btn-editRessource').click(function(){
            var idRessource = $(this).data('idressource');
            $.post('inc/ressources/editRessource.inc.php', {
                idRessource: idRessource,
                addEditClone: 'edit'
            }, function(resultat){
                $('#modal').html(resultat);
                $('#modalEditRessource').modal('show');
            })
        })

        $('#btn-delRessource').click(function(){
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
                $('.afterDel').data('idressource', '').attr('disabled', true);
                $('#modalConfirmDelRes').modal('hide');
                $("#detailsRessources").load('templates/ressources/detailsRessources.html');
                bootbox.alert({
                    title: "Suppression d'une ressource",
                    message: nbRessources + " ressource supprimée <br>"+ nbReservations +" effacée(s)"
                })
            })
        })


        // sélection case à cocher des ressources
        $('body').on('change', '.ressource', function(){
            var nb = $('.ressource:checked').length;
            $('#nbRes').text(nb + " sélectionné(s)");
            $('#btn-selectRessources').attr('disabled', (nb == 0));
            if (nb == 1){
                var idRessource = $('.ressource:checked').val();
                $('#btn-cloneRessource').attr('disabled', false).data('idressource', idRessource);
                $('#btn-editRessource').attr('disabled', false).data('idressource', idRessource);;
                $('#btn-delRessource').attr('disabled', false).data('idressource', idRessource);;
                }
                else {
                    $('#btn-cloneRessource').attr('disabled', true).data('idressource', '');
                    $('#btn-editRessource').attr('disabled', true).data('idressource', '');
                    $('#btn-delRessource').attr('disabled', true).data('idressource', '');
                }
        })

        $('#btn-selectRessources').click(function(){
            var dateStart = $('#dateStart').val();
            startTime = $('#startTime').val();
            dateStart = dateStart.split('/').reverse().join('-') + 'T' + startTime
            var dateDebut = new Date(dateStart);

            var dateEnd = $('#dateEnd').val();
            startTime = $('#endTime').val();
            dateEnd = dateEnd.split('/').reverse().join('-') + 'T' + startTime
            var dateFin = new Date(dateEnd);

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
                    message: 'Veuillez sélectionner au moins un item et une période de plus de 50 minutes d\'emprunt'
                })
        })

        $('#dateStart').on("change", function (e) {
            var d = $("#dateStart").datepicker('getDate');
             var n = new Date(d.getFullYear(), d.getMonth(), d.getDate());
            $("#dateEnd").datepicker('setStartDate', n).datepicker('setDate', n);
            if ($('#dateEnd').val() != $('#dateStart').val()) {
                $('#endTime option').attr('disabled', false);
                }
                else {
                    var n = 0;
                    while ($('#startTime option').eq(n).val() <= $('#startTime option:selected').val()){
                        $('#endTime option').eq(n).attr('disabled', true);
                        n++;
                    }
                }
        });

        $('#dateEnd').on('change', function(e){
            if ($('#dateEnd').val() != $('#dateStart').val()) {
                $('#endTime option').attr('disabled', false);
                }
                else {
                    var n = 0;
                    var heure;
                    while ($('#startTime option').eq(n).val() <= $('#startTime option:selected').val()){
                        heure = $('#endTime option').eq(n).val();
                        n++;
                    }
                    $('#endTime :not(:disabled)').first().prop('selected', true);
                }
        })

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

        $('#startTime').change(function(){
            var heure = $('#startTime :selected').next().val();
            $('#endTime').val(heure);
            if ($('#dateStart').val() == $('#dateEnd').val()){
                heure = $('#startTime option').first().val();
                $('#endTime option').attr('disabled', false);
                var n = 0;
                while ($('#startTime option').eq(n).val() < $('#startTime option:selected').val()){
                    $('#endTime option').eq(n).attr('disabled', true);
                    n++;
                }
            }
        })

        $('body').on('change', '#typeRessource', function(){
            var idType = $(this).val();
            // rafraîchir la liste des ressources disponibles pour ce type
            refreshListeRessources(idType);
        })

        $('#modal').on('click', '#hasCaution', function(){
            if ($(this).is(':checked'))
                $('#caution').attr('disabled', false);
                else $('#caution').attr('disabled', true);
        })

        $('#modal').on('click', '#btn-reset', function(){
            $('#formAddRessource').trigger('reset');
        })

        $('#btn-addRessource').click(function(){
            var idType = $('#typeRessource').val();
            $.post('inc/ressources/editRessource.inc.php', {
                idType: idType,
                addEditClone: 'add'
            }, function(resultat){
                $('#modal').html(resultat);
                $('#modalEditRessource').modal('show');
                $('.afterDel').attr('enabled', true);
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
                        $('.afterDel').data('idressource', idRessource);
                        $("#detailsRessources").load('templates/ressources/detailsRessources.html');
                    }
                    else bootbox.alert({
                        title: 'Problème',
                        message: 'Une ressource avec la référence <strong>' + reference + '</strong> pour le type <strong> ' + texteType + ' </strong>existe déjà.'
                        })
                });
            }
        })

        $('body').on('change', '#typeRessource', function(){
            var type = $(this).val();
            $("#detailsRessources").load('templates/ressources/detailsRessources.html');
            if (type != '') {
                $('#btn-delRessourceType').attr('disabled', false);
                $('#btn-addRessource').attr('disabled', false)
                }
                else {
                    $('#btn-delRessourceType').attr('disabled', true);
                    $('#btn-addRessource').attr('disabled', true)
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

        $('body').on('change', '#selectRessource', function(){
            var idRessource = $(this).val();
            $('#panelDispo .panel-footer span').text(idRessource.length + ' Sél.')
            $('#btn-selectRessources').attr('disabled', false);
            if (idRessource.length == 1){
                $('#btn-delRessource').attr('disabled', false);
                $('#btn-cloneRessource').attr('disabled', false);
                $('#btn-editRessource').attr('disabled', false);
                }
                else {
                     $('#btn-delRessource').attr('disabled', true);
                     $('#btn-cloneRessource').attr('disabled', true);
                     $('#btn-editRessource').attr('disabled', true);
                }
        })

    })

</script>
