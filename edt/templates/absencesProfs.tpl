<div class="container-fluid">

    <div class="row">

        <div class="col-xs-12">

            <ul class="nav nav-tabs">
                <li class="active"><a data-toggle="tab" href="#absences">Gestion des absences</a></li>
                <li><a data-toggle="tab" href="#tabEDT">Sélection du professeur</a></li>
            </ul>

            <div class="tab-content">

                <div id="tabEDT" class="tab-pane fade">
                    <div class="col-xs-12 col-md-3">
                        <div class="form-group">
                            <label for="listeProfs">Sélection</label>
                            <select class="form-control" name="listeProfs" id="listeProfs" size="25">
                                <option value="">Sélection du prof</option>
                                {foreach from=$listeProfs key=unAcronyme item=data}
                                <option value="{$unAcronyme}">{$data.nom} {$data.prenom}</option>
                                {/foreach}
                            </select>

                        </div>
                        <button type="button" class="btn btn-primary btn-block" id="btn-selectProf" name="button">Ann. Modifications</button>

                    </div>
                    <div class="col-md-9 col-xs-12">
                        <button type="button" class="btn btn-danger btn-block" id="btn-selectDates" disabled><i class="fa fa-calendar-plus-o "></i> Sélection <strong id="nomProf"></strong> >>>>>></button>

                        <div id="calendrier">
                            {if isset($acronyme)}
                            <div id="EDTcalendar"
                                data-editable="{$editable|default:'false'}"
                                data-acronyme="{$acronyme|default:''}"
                                data-viewstate="agendaWeek">
                            </div>
                            {else}
                            <p class="avertissement">
                                Veuillez choisir un enseignant dans la zone de gauche
                            </p>
                            {/if}
                        </div>

                    </div>
                </div>

                <div id="absences" class="tab-pane fade in active">

                    {include file="selecteurs/choixJour.tpl"}

                    <div id="gestionAbs">
                        {include file="ABScalendar.tpl"}
                    </div>

                </div>

            </div>

        </div>

    </div>

    <table>
        <tr>
            <td class="repris" style="width:15em">Repris</td>
            <td class="licencie" style="width:15em">Licencié</td>
            <td class="travaux" style="width:15em">Travaux</td>
            <td class="educ" style="width:15em">Educateur</td>
            <td class="autre" style="width:15em">Autre</td>
        </tr>
    </table>
</div>



<div id="modal"></div>

<div id="contextMenu" class="dropdown clearfix" data-date="" data-heure="" data-starttime="" data-acronyme="">
    <ul class="dropdown-menu"
        role="menu"
        style="display:block; position:static; margin-bottom:5px;">
        <li>
            <a tabindex="-1" href="javascript:void(0)" id="copierPeriode"><i class="fa fa-files-o"></i> Copier la période</a>
        </li>
        <li>
            <a tabindex="-1" href="javascript:void(0)" id="collerPeriode"><i class="fa fa-clipboard"></i> Coller la période</a>
        </li>
    </ul>
</div>


<script type="text/javascript">

    function dateFr2En(laDate){
        var date = laDate.split('/');
        var dateEn = date[2] + '-' + date[1] + '-' + date[0]
        return dateEn;
    }

    function refresh(laDate){
        $.post('inc/getAbsences4date.inc.php', {
            laDate: laDate
        }, function(resultat){
            $('#gestionAbs').html(resultat);
        })
    }

    // ******************************************************* drag and drop
    var acronyme;
    var origine;

    // source =================================================================
    function start(event) {
        origine = event.currentTarget;
        event.currentTarget.closest('td').classList.add('enroute');
        var target = event.originalEvent.target;

        acronyme = target.getAttribute('data-acronyme');
        var heure = target.getAttribute('data-heure');
        var date = target.getAttribute('data-date');
        var html = target.closest('td').innerHTML;

        // empaqueter dans un array "attribut"
        attribut = [];
        attribut.push(heure); attribut.push(date); attribut.push(html);
        // convertir en chaîne JSON
        var source = JSON.stringify(attribut);
        event.originalEvent.dataTransfer.effectAllowed = 'copy';
        event.originalEvent.dataTransfer.setData('text/plain', source);
    }
    function end(event) {
        event.currentTarget.closest('td').classList.remove('enroute');
    }

    // destinatation ==========================================================
    function entree(event){
        var cible = event.originalEvent.target;
        try {
            var abreviation = cible.closest("tr").getAttribute('data-acronyme');
            if ((abreviation == acronyme) && cible.classList.contains('drop')) {
                    cible.classList.add('dropMe');
                }
            }
            catch(e) { }
        event.preventDefault();
        }

    function sortie(event){
        if (event.originalEvent.target.classList != undefined)
            event.originalEvent.target.classList.remove('dropMe');
    }

    function depot(event) {
        event.preventDefault();
        var target = event.originalEvent.target;
        var abreviation = target.closest('tr').getAttribute('data-acronyme');
        // nous sommes bien sur la ligne du prof "acronyme"
        if (abreviation == acronyme){
            // la cellule du tableau est bien de la class "drop"
            if (event.originalEvent.target.classList.contains('drop')) {
                // les informations transférées dans le dnd
                var transfert = event.originalEvent.dataTransfer.getData('text/plain');
                transfert = JSON.parse(transfert);

                // target.setAttribute('data-heure', transfert[0]);
                // target.setAttribute('data-date', transfert[1]);
                // récupérer le contenu HTML de l'origine
                target.innerHTML += transfert[2];

                var heureOrigine = origine.getAttribute('data-heure');
                var nouvelleHeure = target.getAttribute('data-heure');

                // on ne recopiera pas plus loin
                $('[data-acronyme="' + abreviation + '"][data-heure="' + heureOrigine + '"]').attr('draggable',false);

                target.classList.remove('drop');
                target.classList.add('dropped');
                // variable globale "origine"
                origine.removeAttribute('draggable');

                origine.closest('td').classList.add('wasDragged');
                $('#btn-saveMove').attr('disabled', false).removeClass('btn-primary').addClass('btn-danger');
                }
            target.classList.remove('dropMe');
            }
        }

    // *************************************************** drag and drop

    $(document).ready(function() {

        sessionStorage.clear();

        $('body').on('click', '#btn-chargeEduc', function(){
            var date = $('#choixDate').val();
            $.post('inc/choixEducateurs.inc.php', {
                date: date
            }, function(resultat){
                $('#modal').html(resultat);
                $('#modalSelectEduc').modal('show');
            })
        })
        $('#modal').on('click', '#btn-saveEducs', function(){
            var formulaire = $('#formEduc').serialize();
            $.post('inc/saveEducs.inc.php', {
                formulaire: formulaire
            }, function(nbSave){
                var date = $('#choixDate').val();
                $.post('inc/getAbsences4date.inc.php', {
                    date: date
                }, function(resultat){
                    $('#gestionAbs').html(resultat);
                    $('#modalSelectEduc').modal('hide');
                    bootbox.alert({
                        title: 'Enregistrement',
                        message: "<strong>" + nbSave + "</strong> information(s) enregistrée(s)"
                    })
                })
            })
        })

        $('body').on('click', '.btn-educ', function(){
            var laPeriode = $(this).data('periode');
            var date = $('#choixDate').val();
            $.post('inc/choixEducateurs.inc.php', {
                date: date,
                laPeriode: laPeriode
            }, function(resultat){
                $('#modal').html(resultat);
                $('#modalSelectEduc').modal('show');
                $('input.educs').eq(3).focus();
            })
        })

        $('body').on('click', '.btn-viewProf', function(){
            var acronyme = $(this).closest('th').data('acronyme');
            $.post('inc/modalViewProf.inc.php', {
                acronyme: acronyme
            }, function(resultat){
                $('#modal').html(resultat);
                $('#modalViewProf').data('acronyme', acronyme);
                $('#modalViewProf').modal('show');
            })
        })



        $(document).ajaxStart(function() {
            $('#ajaxLoader').removeClass('hidden');
        }).ajaxComplete(function() {
            $('#ajaxLoader').addClass('hidden');
        });

        $('#copierPeriode').click(function(event){
            // recopie effective des données préalablement préservées dans le sessionStorage
            sessionStorage.setItem('startTime', sessionStorage.getItem('preCopyStartTime'));
            sessionStorage.setItem('date', sessionStorage.getItem('preCopyDate'));
            sessionStorage.setItem('heure', sessionStorage.getItem('preCopyHeure'));
            sessionStorage.setItem('acronyme', sessionStorage.getItem('preCopyAcronyme'));
        })
        $('#collerPeriode').click(function(){
            var startTime = sessionStorage.getItem('startTime');
            var title = "Je suis vraiment désolé";
            if (startTime != null) {
                var date = sessionStorage.getItem('date');
                var heure = sessionStorage.getItem('heure');
                var acronyme = sessionStorage.getItem('acronyme');
                // on avait noté la date et l'heure dans la position du clic droit "preCopy"
                var newStartTime = sessionStorage.getItem('preCopyStartTime');
                var newDate = sessionStorage.getItem('preCopyDate');
                var newHeure = sessionStorage.getItem('preCopyHeure');
                var newAcronyme = sessionStorage.getItem('preCopyAcronyme');
                $.post('inc/pastePeriode.inc.php', {
                    acronyme: acronyme,
                    date: date,
                    heure: heure,
                    startTime: startTime,
                    newDate: newDate,
                    newHeure: newHeure,
                    newAcronyme: newAcronyme
                }, function(resultat){
                    var laDate = $('#choixDate').val();
                    refresh(laDate);
                    if (resultat < 0)
                        bootbox.alert({
                            title: title,
                            message: "<i class='fa fa-warning fa-2x'></i> Vous ne pouvez copier/coller que pour le même professeur (<strong>" + acronyme + "</strong>) <br>et le même jour (le <strong>" + date + "</strong>)"
                        });
                })
            }
            else bootbox.alert({
                title: title,
                message: "Oups... Vous n'avez encore rien copié"
            })
        })
        $('body').on('contextmenu', '.table-absences td', function(event){
            var td = event.originalEvent.originalTarget.closest('td');
            var startTime = td.getAttribute('data-starttime');
            var acronyme = td.getAttribute('data-acronyme');
            var heure = td.getAttribute('data-heure');
            var date = td.getAttribute('data-date');
            // si la période est encore vide
            if (startTime == null){
                // préparation du futur "coller" éventuel
                $('#copierPeriode').addClass('hidden');
                $('#collerPeriode').removeClass('hidden');
                }
                else {
                    // préparation d'un futur "copier" éventuel
                    $('#copierPeriode').removeClass('hidden');
                    $('#collerPeriode').addClass('hidden');
                    }
            sessionStorage.setItem('preCopyStartTime', startTime);
            sessionStorage.setItem('preCopyAcronyme', acronyme);
            sessionStorage.setItem('preCopyDate', date);
            sessionStorage.setItem('preCopyHeure', heure);
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



        // traitement des infos complémentaires et des retards pour l'entête de la feuille d'absences
        $('body').on('click', '.td-edit li', function(){
            var id = $(this).data('id');
            var date = $('#choixDate').val();
            var type = $(this).closest('td').data('type');
            if (type == 'info') {
                $.post('inc/editDelInfo.inc.php', {
                    id: id,
                    type: type,
                    date: date
                }, function(resultat){
                    $('#modal').html(resultat);
                    $('#modalEditDelRetard').modal('show');
                })
            }
            else {
                $.post('inc/editDelRetard.inc.php', {
                    id: id,
                    type: type,
                    date: date
                }, function(resultat){
                    $('#modal').html(resultat);
                    $('#modalEditDelRetard').modal('show');
                })
            }
        })

        $('body').on('click', '#btn-addInfo', function(){
            var date = $('#choixDate').val();
            var type = $(this).data('type');
            $.post('inc/editDelRetard.inc.php', {
                id: null,
                type: type,
                date: date,
            }, function(resultat){
                $('#modal').html(resultat);
                $('#modalEditDelRetard').modal('show');
            })
        })
        $('#modal').on('click', '#btn-modalSaveInfo', function(){
            var formulaire = $('#modalEdit').serialize();
            $.post('inc/modalSaveInfo.inc.php', {
                formulaire: formulaire
            }, function(resultat){
                $('#listeInfos').html(resultat);
                $('#modalEditDelInfo').modal('hide');
            })
        })
        // suppression de l'info ou du retard
        $('#modal').on('click', '#btn-modalDelInfo', function(){
            var formulaire = $('#modalEdit').serialize();
            $.post('inc/modalDelInfo.inc.php', {
                formulaire: formulaire
            }, function(resultat){
                $('#listeInfos').html(resultat);
                // quelle que soit la boîte modale présente, la fermer
                $('#modal .modal').modal('hide');

            })
        })
        // traitement des retards
        $('body').on('click', '#btn-addRetard', function(){
            var date = $('#choixDate').val();
            var type = $(this).data('type');
            $.post('inc/editDelRetard.inc.php', {
                id: null,
                type: type,
                date: date,
            }, function(resultat){
                $('#modal').html(resultat);
                $('#modalEditDelRetard').modal('show');
            })
        })
        $('#modal').on('click', '#btn-modalSaveRetard', function(){
            var formulaire = $('#modalEdit').serialize();
            $.post('inc/modalSaveInfo.inc.php', {
                formulaire: formulaire
            }, function(resultat){
                $('#listeInfos').html(resultat);
                $('#modalEditDelRetard').modal('hide');
            })
        })


        $('#modal').on('keyup', '#acronyme', function(){
            var abreviation = $(this).val().toUpperCase();
            if (abreviation != '' && ($('#modalListeProfs option[value="'+abreviation+'"]').length == 1))
                $('#modalListeProfs option[value="' + abreviation + '"]').prop('selected', true);
                else $('#modalListeProfs').val('');
        })
        $('#modal').on('blur', '#acronyme', function(){
            var abreviation = $(this).val().toUpperCase();
            if (abreviation != '') {
                var exists = 0 != $('#modalListeProfs option[value=' + abreviation + ']').length;
                if (!exists)
                    $('#modalListeProfs option[value=""]').prop('selected', true);
                }
        })
        $('#modal').on('change', '#modalListeProfs', function(){
            var abreviation = $(this).val();
            $('#acronyme').val(abreviation);
        })

// ********************************

        $('#modal').on('keyup', '.educs', function(){
            var abreviation = $(this).val().toUpperCase();
            var periode = $(this).data('periode');
            if (abreviation != '')
                $.post('inc/searchProf.inc.php', {
                    abreviation: abreviation
                }, function(resultat){
                    $('.nomProf[data-periode="' + periode +'"]').text(resultat);
                })
        })
        $('#modal').on('blur', '.educs', function(){
            var abreviation = $(this).val();
            var periode = $(this).data('periode');
            $.post('inc/getAcronyme.inc.php', {
                abreviation: abreviation
            }, function(resultat){
                $('.educs[data-periode="' + periode + '"]').val(resultat);
            })
        })


// ********************************

        $('#modal').on('change', '#listeProfs', function(){
            var abreviation = $(this).val();
            $('#acronyme').val(abreviation);
        })

        $('#modal').on('click', '#btn-saveStatut', function(){
            var formulaire = $('#formStatut').serialize();
            $.post('inc/saveStatutAbs.inc.php', {
                formulaire: formulaire
            }, function(resultat){
                var resultatJS = JSON.parse(resultat);
                $('#modalChangeStatut').modal('hide');
                var laDate = $('#choixDate').val();
                $.post('inc/getAbsences4date.inc.php', {
                    laDate: laDate
                }, function(resultat){
                    $('#gestionAbs').html(resultat);
                    bootbox.alert({
                        title: 'Enregistrement',
                        message: resultatJS.data + ' information(s) et ' + resultatJS.statuts + ' statut(s) enregistré(s)',
                    })
                })
            })
        })

        $('body').on('dragover', '.drop', function(event){
            event.preventDefault();
            return false;
        })

        $('body').on('dragenter', '.drop', entree);
        $('body').on('dragleave', '.drop', sortie);
        $('body').on('drop', '.drop', depot);

        $('body').on('dragstart', '.draggable', start);
        $('body').on('dragend', '.draggable', end);


        $('body').on('click', '.table-absences .btn-edit', function(){
            var td = $(this).closest('td');
            var acronyme = td.data('acronyme');
            var date = td.data('date');
            var heure = td.data('heure');
            var startTime = td.data('starttime');
            $.post('inc/changeStatutAbs.inc.php', {
                acronyme: acronyme,
                date: date,
                heure: heure,
                startTime: startTime
            }, function(resultat){
                $('#modal').html(resultat);
                $('#modalChangeStatut').modal('show');
            })
        })

        $('body').on('click', '#btn-saveMove', function(){
            var nMove = 0;
            // liste des heures originales déplacées
            var listeOld = []
            $('.wasDragged .draggable').each(function(){
                var heure = $(this).data('heure');
                var acronyme = $(this).data('acronyme');
                var date = $(this).data('date');
                var startTime = $(this).data('starttime');
                listeOld.push([date, heure, acronyme, startTime]);
            });
            listeOld = JSON.stringify(listeOld);

            var listeNew = [];
            $('.dropped .draggable').each(function(){
                var heure = $(this).closest('td').data('heure');
                var date = $(this).data('date');
                var acronyme = $(this).data('acronyme');
                var startTime = $(this).data('starttime');
                listeNew.push([date, heure, acronyme, startTime]);
            });
            listeNew = JSON.stringify(listeNew);

            // enregistrer les nouvelles heures de cours déplacées
            $.post('inc/saveHeuresDeplacees.inc.php', {
                listeOld: listeOld,
                listeNew: listeNew
            }, function(resultat){
                bootbox.alert({
                    title: 'Déplacements',
                    message: resultat + ' mouvement(s) de cours enregistré(s)'
                });
                var laDate = $('#choixDate').val();
                refresh(laDate);
                })
            });

        $('body').on('click', '#btn-resetMove', function(){
            bootbox.confirm({
                title: 'Annulation',
                message: 'Veuillez confirmer l\'annulation des déplacements',
                callback: function(){
                    var laDate = $('#choixDate').val();
                    refresh(laDate);
                }
            })
        })


        $('body').on('mouseover', 'td li', function(){
            var ceci = $(this);
            ceci.addClass('actif');
        })
        $('body').on('mouseout', 'td li', function(){
            var ceci = $(this);
            ceci.removeClass('actif');
        })

        $('#listeInfos').on('mouseover', 'td li', function(){
            $(this).find('a.badge').removeClass('opacity0').addClass('opacity100');
        })
        $('#listeInfos').on('mouseout', 'td li', function(){
            $(this).find('a.badge').removeClass('opacity100').addClass('opacity0');
        })


        $('body').on('click', '#btn-printPDF', function(){
            var date = $('#choixDate').val();
            $.post('inc/printPDF.inc.php', {
                date: date
            }, function(resultat){
                bootbox.alert({
                    title: 'Gestion des absences',
                    message: 'Vous pouvez maintenant <a href="' + resultat + '"> télécharger le document <i class="fa fa-file-pdf-o fa-2x"></i></a>'
                });
            })
        })


        // $('body').on('click', function (e) {
		//     $('[data-toggle="popover"]').each(function () {
		//         if (!$(this).is(e.target) && $(this).has(e.target).length === 0 && $('.popover').has(e.target).length === 0) {
		//             $(this).popover('hide');
		//         }
	    // 	});
		// });

        $('#btn-confirmDate').click(function(){
            var laDate = $('#choixDate').val();
            refresh(laDate);
        })

        $('.changeDate').click(function(){
            var change = $(this).data('change');
            var date = $('#choixDate').val();
            var dateEn = dateFr2En(date);
            var d = new Date(dateEn);
            // quel jour de la semaine?
            var j = d.getDay();
            // si lundi et -1 jour
            if ((change == -1) && (j == 1))
                change = -3;
            // si vendredi et +1 jour
            if ((change == +1) && (j == 5))
                change = +3;
            var laDateEn = moment(dateEn).add(change, 'days');
            laDate = new Date(laDateEn).toLocaleDateString();
            $('#choixDate').val(laDate);
            refresh(laDate);
        })

        $('#absences').on('click', '.btn-delAbs', function(){
            var td = $(this).closest('td');
            var acronyme = td.data('acronyme');
            var heure = td.data('heure');
            var laDate = td.data('date');
            var startTime = td.data('starttime');

            var title = 'Suppression de cette absence';
            var message = 'Veuillez confirmer la suppression de l\'absence de <strong>' + acronyme + '</strong> de <strong>' + heure + '</strong>';

            if (td.hasClass('dropped')){
                // la période est issue d'un déplacement; rien n'est encore dans la base de données
                bootbox.alert({
                    title: title,
                    message: 'Vos modifications ne sont pas encore enregistrées. Vous pouvez encore "Annuler"'
                    })
                }
                else {
                    // il s'agit d'une période déplacée (une copie, donc); on peut supprimer sans souci
                    if (td.hasClass('movedTo')){
                        bootbox.confirm({
                            title: title,
                            message: message,
                            callback: function(result){
                                if (result == true) {
                                    // suppression de l'absence sur base de la date et de l'heure (éventuellement déplacés)
                                    $.post('inc/delAbsenceDeplacee.inc.php', {
                                        acronyme: acronyme,
                                        date: laDate,
                                        heure: heure,
                                        startTime: startTime
                                    }, function(){
                                        refresh(laDate);
                                    })
                                }
                            }
                        })
                    }
                    else {
                        if (td.hasClass('movedFrom')){
                            message = message + '<br>ATTENTION, vous pouvez supprimer <span class="movedFrom">le cours original</span> et <span class="movedTo">le cours déplacé</span>';
                            bootbox.dialog({
                                title: title,
                                message: message,
                                onEscape: function() {},
                                show: true,
                                backdrop: true,
                                closeButton: true,
                                animate: true,
                                buttons: {
                                    danger: {
                                        label: "Cours original et déplacé <i class='fa fa-exclamation'></i>",
                                        className: "btn-danger pull-left",
                                        callback: function() {
                                            // suppression sur la base du starttime (commun à la période déplacée et à son origine)
                                            $.post('inc/delAbsenceTotale.inc.php', {
                                                acronyme: acronyme,
                                                startTime: startTime
                                            }, function(){
                                                refresh(laDate);
                                            })
                                        }
                                    },
                                    success: {
                                        label: "Seulement le cours original",
                                        className: "btn-success",
                                        callback: function() {
                                            console.log(startTime);
                                            // suppression de l'absence originale et acquisition
                                            // du statut "ordinaire" pour la période déplacée
                                            $.post('inc/delAbsenceOriginale.inc.php', {
                                                acronyme: acronyme,
                                                date: laDate,
                                                heure: heure,
                                                startTime: startTime
                                            }, function(){
                                                refresh(laDate);
                                                })
                                            }
                                        }
                                    }
                            })
                        }
                        else
                            bootbox.confirm({
                                title: title,
                                message: message,
                                callback: function (result) {
                                    if (result == true) {
                                        // suppression sur la base du starttime (commun à la période déplacée et à son origine)
                                        $.post('inc/delAbsenceOrdinaire.inc.php', {
                                            acronyme: acronyme,
                                            date: laDate,
                                            heure: heure,
                                            startTime: startTime
                                        }, function(){
                                            refresh(laDate);
                                        })
                                    }
                               }
                            })
                    }
                }
        })

        $('#absences').on('click', '.btn-delFuture', function(){
            var laDate = $(this).closest('th').data('date');
            var acronyme = $(this).closest('th').data('acronyme');
            var title = 'Suppression des absences futures';
            bootbox.confirm({
                title: title,
                message: 'Veuillez confirmer la suppression de toutes les absences futures de <strong>' + acronyme + '</strong> à partir du <strong>' + laDate + '</strong>',
                callback: function(result){
                    if (result == true) {
                        $.post('inc/delAbsencesFutures.inc.php', {
                            acronyme: acronyme,
                            dateFrom: laDate
                        }, function (){
                            $.post('inc/getAbsences4date.inc.php', {
                                laDate: laDate
                            }, function(resultat){
                                $('#gestionAbs').html(resultat);
                            })
                        })
                    }
                }
            })
        })


        // enregistrer la mention initiale si pas de sélection de prof
        var vide = $('#calendrier').html();

        $('#absences .datepicker').datepicker('update', '{$laDate}')

        // enregistrement des absences entre startDate et endDate pour le prof acronyme
        $('#modal').on('click', '#btn-confirmDates', function(){
            if ($('#formDates').valid()) {
                var acronyme = $('#listeProfs').val();
                var startDate = $('#start').val();
                var endDate = $('#end').val();
                var statutAbs = $('.statutAbs:checked').val();
                $.post('inc/transfertAbsenceProf.inc.php', {
                    acronyme: acronyme,
                    startDate: startDate,
                    endDate: endDate,
                    statutAbs: statutAbs
                }, function(nb){
                    $('#selectDates').modal('hide');
                    bootbox.alert({
                        title: 'Enregistrement',
                        message: '<strong>' + nb + ' périodes</strong> d\'absences enregistrées entre le <strong>' + startDate + ' et le ' + endDate,
                        callback: function(){
                            $.post('inc/getAbsences4date.inc.php', {
                                laDate: startDate
                            }, function(resultat){
                                $('#gestionAbs').html(resultat);
                                $('a[href="#absences"]').trigger('click');
                            })
                        }
                    })
                })

            }
            else alert('Enregistrement impossible');
        })

        // enregistrement des suppléments d'absences entre startDate et endDate
        // pour le prof acronyme
        $('#modal').on('click', '#btn-confirmDatesAdd', function(){
            if ($('#formDates').valid()) {
                var acronyme = $('#modalAcronyme').val();
                var startDate = $('#start').val();
                var endDate = $('#end').val();
                var statutAbs = $('.statutAbs:checked').val();

                $.post('inc/transfertAbsenceProf.inc.php', {
                    acronyme: acronyme,
                    startDate: startDate,
                    endDate: endDate,
                    statutAbs: statutAbs
                }, function(nb){
                    $('#selectDates').modal('hide');
                    bootbox.alert({
                        title: 'Enregistrement',
                        message: '<strong>' + nb + ' périodes</strong> d\'absences enregistrées entre le <strong>' + startDate + ' et le ' + endDate,
                        callback: function(){
                            $.post('inc/getAbsences4date.inc.php', {
                                laDate: startDate
                            }, function(resultat){
                                $('#gestionAbs').html(resultat);
                                $('a[href="#absences"]').trigger('click');
                            })
                        }
                    })
                })

            }
            else alert('Enregistrement impossible');
        })

        // changement des dates startDate et endDate dans la boîte modale
        // des dates de début et fin
        $('#modal').on('change', '#start', function(){
            var start = $('#start').val();
            if (start != '') {
                $('#end').datepicker('setStartDate', start);
                $('#end').prop('disabled', false);
                $('#modal').find('.help-block').text('');
                }
            })
        $('#modal').on('change', '#end', function(){
            var end = $('#end').val();
            if (start != '') {
                $('#start').datepicker('setEndDate', end);
                }
            })
        // appel de la boîte modale de sélection des dates début et fin
        $('#btn-selectDates').click(function(){
            var acronyme = $('#listeProfs').val();
            var laDate = '{$laDate}';
            $.post('inc/selectDates.inc.php', {
                acronyme: acronyme,
                laDate: laDate
            }, function(resultat){
                $('#modal').html(resultat);
                $('#selectDates').modal('show');
            })
        })
        // click sur le bouton associé à un prof pour ajout absence
        $('body').on('click', '.btn-addFuture', function(){
            var acronyme = $(this).closest('th').data('acronyme');
            var laDate = $(this).closest('th').data('date');
            $.post('inc/selectDatesAdd.inc.php', {
                acronyme: acronyme,
                laDate: laDate
            }, function(resultat){
                $('#modal').html(resultat);
                $('#selectDates').modal('show');
            })
        })

        $('#listeProfs').change(function() {
            var acronyme = $(this).val();
            if (acronyme != '') {
                $.post('inc/getModeleProf.inc.php', {
                    acronyme: acronyme
                }, function(resultat) {
                    $('#calendrier').html(resultat);
                    $.post('inc/getNomProf.inc.php', {
                        acronyme: acronyme
                    }, function(resultat){
                        $('#btn-selectDates').prop('disabled', false);
                        $('#nomProf').html(' pour ' + resultat);
                        })
                    })
                }
            else {
                $('#btn-selectDates').prop('disabled', true);
                $('#calendrier').html(vide);
                $('#nomProf').html('');
            }
        })

        $('#btn-selectProf').click(function() {
            var acronyme = $('#listeProfs').val();
            $.post('inc/getModeleProf.inc.php', {
                acronyme: acronyme
            }, function(resultat) {
                $('#calendrier').html(resultat);
                })
            })
    })
</script>
