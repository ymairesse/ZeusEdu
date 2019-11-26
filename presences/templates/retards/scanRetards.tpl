<div class="col-xs-12">

<ul class="nav nav-tabs">

  <li class="active"><a data-toggle="tab" href="#retards">Retards</a></li>

  <li><a data-toggle="tab" href="#neverdie"><img src="../images/coeur.gif" alt="coeur" style="width:14px" title="Staying alive" data-param="{$param|default:0}"></a></li>

</ul>

<div class="tab-content">
  <div id="retards" class="tab-pane fade in active">

      <div class="col-md-4 col-xs-6">

          <form id="formRetards">

              <div class="form-group">
                  <label for="matricule">Matricule</label>
                  <div class="input-group">
                      <input type="text"
                          class="input-lg form-control"
                          name="matricule"
                          placeholder="Scan ou matricule de l'élève"
                          id="matricule"
                          value=""
                          tabindex="1">
                      <span class="input-group-addon" tabindex="2" id="barcode"> <i class="fa fa-barcode fa-2x"></i> </span>
                  </div>
                  <span class="help-block">Matricule de l'élève (scanné)</span>
              </div>

              <div class="form-group">
                  <label for="periodes">Heure normale d'arrivée</label>
                  <select class="form-control input-lg" name="periode" id="periode">
                  {foreach from=$listePeriodesCours key=i item=unePeriode}
                  <option value="{$i}"{if $i == $periodeActuelle} selected{/if}>{$unePeriode.debut} - {$unePeriode.fin}</option>
                  {/foreach}
                  </select>
              </div>

              <div class="form-group">
                  <label for="heure">Heure actuelle</label>
                  <input type="time" name="heure" id="heure" value="" class="form-control input-lg">
                  <span class="help-block">Heure au moment du scan</span>
              </div>

              <div class="form-group">
                  <label for="date">Date du retard</label>
                  <input type="text" name="date" id="date" class="datepicker form-control input-lg" value="">
              </div>

              <div class="discret" id="lastRetards">

              </div>

          </form>
      </div>

      <div class="col-md-4 col-xs-6" id="laPhoto">
          <img src="../photos/nophoto.jpg" alt="Photo" class="img-responsive" style="width:250px" id="photo">
          <div class="form-group">
              <label for="nomEleve">Nom de l'élève</label>
              <input type="text" name="nomEleve" id="nomEleve" value="" class="form-control input-lg" placeholder="Nom de l'élève">
              <span class="help-block">Entrez ici le nom de l'élève</span>
          </div>

      </div>

      <div class="col-md-4 col-xs-12">

          <button type="button" data-checked="0" class="btn btn-default pull-right" id="directPrint">
              <i class="fa fa-toggle-on switchOff"> Impression directe</i>
          </button>

          <form name="formScans" id="formScans">

              <div class="clearfix"></div>
          </form>


          <div class="btn-group btn-group-justified">
              <a type="button" class="btn btn-default btn-lg" role="button" id="resetRetard">Nettoyer</a>
              <a type="button" class="btn btn-primary btn-lg" role="button" id="saveScan" tabindex="3">Enregistrer</a>
          </div>
          <button type="button" class="btn btn-success btn-lg btn-block" id="savePrintScan" tabindex="4">imprimer</button>

      </div>

  </div>

  <div id="neverdie" class="tab-pane fade">
    {include file="../neverdie.tpl"}
  </div>

</div>

</div>

{include file="modal/editRetard.tpl"}

<script type="text/javascript">

    function setHeure() {
        var today = new Date();
        var heure = today.getHours();
        if (heure < 10)
            heure = "0" + heure;
        var minutes = today.getMinutes();
        if (minutes < 10)
            minutes = "0" + minutes;
        return heure + ":" + minutes
    }

    $('#heure').val(setHeure());
    var SESSIONEXPIREE = 'Votre session a expiré. Veuillez vous reconnecter.';

    function sleep(ms) {
        return new Promise(resolve => setTimeout(resolve, ms));
    }

    $(document).ready(function() {

        var directPrint = Cookies.get('directPrint');
        $('#directPrint').data('checked', directPrint);
        if (directPrint == 1) {
            $('#directPrint').removeClass('btn-default').addClass('btn-success');
            }
            else {
                $('#directPrint').removeClass('btn-success').addClass('btn-default');
            }

        $('#directPrint').click(function(){
            var btnIcon = $(this).find('i');
            var directPrint = $(this).data('checked');
            if (directPrint == 0) {
                btnIcon.removeClass('fa-toggle-on switchOff').addClass('fa-toggle-off switchOn');
                $(this).removeClass('btn-default').addClass('btn-success');
                $('#directPrint').data('checked', 1);
                Cookies.set('directPrint', 1, { expires: 30 });
                }
            else {
                btnIcon.removeClass('fa-toggle-off switchOn').addClass('fa-toggle-on switchOff');
                $(this).removeClass('btn-success').addClass('btn-default');
                $('#directPrint').data('checked', 0);
                Cookies.set('directPrint', 0, { expires: 30 });
                }
            })

        $('#btn-changeModalRetard').click(function(){
            var matricule = $('#modal_matricule').val();
            var periode = $('#modal_periode').val();
            var heure = $('#modal_heure').val();
            var date = $('#modal_date').val();

            var eleve = $('.eleve[data-matricule="' + matricule +'"]');
            eleve.find('.periode').val(periode);
            eleve.find('.heure').val(heure);
            eleve.find('.date').val(date);
            $('#modalEdit').modal('hide');
        })

        $('#resetRetard').click(function(){
            bootbox.confirm({
                title: 'Veuillez confirmer',
                message: 'Attention! Vous allez supprimer tous les scans',
                callback: function(result) {
                    if (result == true) {
                        $('.eleve').remove();
                    }
                }
            })
        })

        $('#savePrintScan').click(function(){
            var formulaire = $('#formScans').serialize();
            $.post('inc/retards/getTicketsRetard.inc.php', {
                formulaire: formulaire
            }, function(resultat){
                w=window.open("", "MsgWindow","toolbar=no, location=no, status=no, menubar=no, scrollbars=no, resizable=no, width=200, height=100");
                w.document.write(resultat);
                w.print();
                w.close();
            })
        })

        $('#saveScan').click(function(){
            var formulaire = $('#formScans').serialize();
            $.post('inc/retards/saveScanRetard.inc.php', {
                formulaire: formulaire
            }, function(nb){
                $('#formScans .eleve').remove();
                $('#formScans').html('<p class="discret">' + nb + ' retard(s) enregistré(s)</p><div class="clearfix"></div>');
                $('#formRetards #matricule').focus().select();
            });
        })

        $('#formScans').on('click', '.delRetard', function(){
            $(this).closest('.eleve').remove();
        })

        $('#formScans').on('click', '.editRetard', function(){
            var input = $(this).closest('.eleve');
            var matricule = input.data('matricule');
            var nomEleve = input.data('nomeleve');

            var photo = input.data('photo');
            var periode = input.find('.periode').val();
            var heure = input.find('.heure').val();
            var date = input.find('.date').val();

            $('#modal_matricule').val(matricule);
            $('#modal_periode').val(periode);
            $('#modal_heure').val(heure);
            $('#modal_date').val(date);
            $('#modal_photo').attr('src', photo).attr('alt', matricule);
            $('#modal_nomEleve').text(nomEleve);
            $('#modalEdit').modal('show');
        })

        $('#matricule').keypress(function (e) {
          if ((e.which == 13) && $('#nomEleve').val() != 'INCONNU') {
            bootbox.confirm({
                title: 'Veuillez confirmer',
                message: '<strong>OK</strong> ou <strong>Enter</strong> pour accepter<br><strong>Esc</strong> pour annuler',
                callback: function(result){
                    if (result == true) {
                        var matricule = $('#matricule').val();
                        var periode = $('#periode').val();
                        var date = $('#date').val();
                        var  heure = $('#heure').val();
                        var photo = $('#photo').attr('src');
                        var nomEleve = $('#nomEleve').val();
                        $.post('inc/retards/addInputRetard.inc.php', {
                            matricule: matricule,
                            date: date,
                            heure: heure,
                            periode: periode,
                            photo: photo,
                            nomEleve: nomEleve
                        }, function(resultat){
                            $('#formScans .discret').remove();
                            $('#formScans').prepend(resultat);
                            $('#matricule').focus().select();
                        });
                        // impression immédiate du billet de retard.
                        if ($('#directPrint').data('checked') == 1) {
                            $.post('inc/retards/getSingleTicketsRetard.inc.php', {
                                matricule: matricule,
                                nomEleve: nomEleve,
                                date: date,
                                heure: heure,
                                periode: periode
                            }, function(resultat){
                                w = window.open("", "MsgWindow","toolbar=no, location=no, status=no, menubar=no, scrollbars=no, resizable=no, width=200, height=100");
                                w.document.write(resultat);
                                w.print();
                                w.close();
                            })
                        }

                    }
                }
            });
          }
        });

        $("#nomEleve").typeahead({
            minLength: 2,
            source: function(query, process) {
                $.ajax({
                    url: 'inc/searchNom.php',
                    type: 'POST',
                    data: 'query=' + query,
                    dataType: 'JSON',
                    async: true,
                    success: function(data) {
                        $("#matricule").val('');
                        process(data);
                    }
                })
            },
            afterSelect: function(item) {
                $.ajax({
                    url: 'inc/searchMatricule.php',
                    type: 'POST',
                    data: 'nomPrenomClasse=' + item,
                    dataType: 'text',
                    async: true,
                    success: function(matricule) {
                        if (matricule != '') {
                            var heure = setHeure();
                            $('#heure').val(heure);
                            $('#matricule').val(matricule).trigger('change').select();
                            $('#matricule').trigger('keyup');
                        }
                    }
                })
            }
        })

        $('#matricule').keyup(function(event) {
            var original = this.value;
            // n'accepter que les valeurs numériques
            if (/\D/g.test(this.value)) {
                this.value = this.value.replace(/\D/g, '');
                }
            // a-t-on procédé à un remplacement d'un caractère non autorisé?
            if (original != this.value)
                bootbox.alert({
                    title: 'Erreur',
                    message: 'Carctère non numérique entré. Vérifier <strong>Caps-Lock</strong> au clavier.'
                });
            $('#heure').val(setHeure());
            var matricule = $('#matricule').val();
            $.post('inc/retards/getIdentiteEleve.inc.php', {
                matricule: matricule
            }, function(resultat) {
                switch (resultat) {
                    case 'ERREURSESSION':
                        bootbox.alert({
                            title: 'Avertissement',
                            message: SESSIONEXPIREE,
                            className: 'rubberBand animated'
                            })
                        break;
                    case 'false':
                        $('#saveRetard').attr('disabled', true);
                        $('#nomEleve').val('INCONNU');
                        $('#laPhoto').find('img').attr('src', '../photos/nophoto.jpg');
                        break;
                    case '':
                        // ne rien faire: la fonction n'a rien renvoyé
                        $('#saveRetard').attr('disabled', true);
                        $('#nomEleve').val('INCONNU');
                        $('#laPhoto').find('img').attr('src', '../photos/nophoto.jpg');
                        break;
                    default:
                        var resultJSON = JSON.parse(resultat);
                        $('#nomEleve').val(resultJSON.prenom + ' ' + resultJSON.nom + ' : ' + resultJSON.groupe);
                        $('#saveRetard').attr('disabled', false);
                        $('#laPhoto').find('img').attr('src', '../photos/' + resultJSON.photo + '.jpg');
                    }
                }
            )
        })

        $(".datepicker").datepicker({
            format: "dd/mm/yyyy",
            clearBtn: true,
            language: "fr",
            calendarWeeks: true,
            autoclose: true,
            todayHighlight: true
        });

        $(".datepicker").datepicker("setDate", new Date())

        $('#resetRetard').click(function() {
            $('#matricule').val('');
            $('#nomEleve').val('');
            $('#laPhoto').find('img').attr('src', '../photos/nophoto.jpg');
            $('#saveRetard').attr('disabled', true);
            $('#idRetard').val('');
            $('#heure').val(setHeure());
        })

        // $('#saveRetard').click(function() {
        //     var formulaire = $('#formRetards').serialize();
        //     $.post('inc/eleves/saveRetard.inc.php', {
        //         formulaire: formulaire
        //     }, function(resultat) {
        //         if (resultat == 1) {
        //             bootbox.alert('Retard enregistré');
        //             $('#saveRetard').attr('disabled', true);
        //         }
        //         $.post('inc/eleves/getLastRetards.inc.php', {
        //             limite: 5
        //         }, function(resultat) {
        //             $('#lastRetards').html(resultat);
        //         })
        //     })
        // })
        //
        // $('#lastRetards').on('click', '.delRetard', function() {
        //     var idRetard = $(this).data('idretard');
        //     var ligne = $(this).closest('li');
        //     bootbox.confirm({
        //         title: "Effacement de la notification de retard",
        //         message: "Veuillez confirmer l'effacement définitif",
        //         callback: function(result) {
        //             if (result == true) {
        //                 $.post('inc/eleves/delRetard.inc.php', {
        //                     idRetard: idRetard
        //                 }, function(resultat) {
        //                     if (resultat == 1)
        //                         ligne.remove();
        //                 })
        //             }
        //         }
        //     })
        // })
        //
        // $('#lastRetards').on('click', '.editRetard', function() {
        //     var idRetard = $(this).data('idretard');
        //     $.post('inc/eleves/getRetard.inc.php', {
        //         idRetard: idRetard
        //     }, function(resultat) {
        //         try {
        //             var resultJSON = JSON.parse(resultat);
        //         } catch (e) {
        //             bootbox.alert({
        //                 title: 'Avertissement',
        //                 message: SESSIONEXPIREE,
        //                 className: 'rubberBand animated'
        //             })
        //         }
        //         var matricule = resultJSON.matricule;
        //         $('#matricule').val(matricule);
        //         var classe = resultJSON['groupe'];
        //
        //         $.post('inc/getPhotoEleve.inc.php', {
        //             matricule: matricule
        //         }, function(photo){
        //             $('#laPhoto').find('img').attr('src', '../photos/' + photo + '.jpg');
        //         })
        //
        //         var nom = resultJSON['prenom'] + " " + resultJSON['nom'];
        //         $('#nomEleve').val(classe + " " + nom);
        //         $('#date').val(resultJSON['date']);
        //         $('#heure').val(resultJSON['heure']);
        //         $('#periode').val(resultJSON['periode']);
        //         $('#idRetard').val(resultJSON['idRetard']);
        //         $('#saveRetard').attr('disabled', false);
        //     })
        // })
    })
</script>
