<div id="modalEditRetard" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="modalEditRetardLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
        <h4 class="modal-title" id="modalEditRetardLabel">Modification du traitement d'un retard</h4>
      </div>
      <div class="modal-body">

              <div class="col-md-8 col-xs-12">

                <form id="formModifSanctions">

                  <p>Dernier traitement par: <strong>{if $dataTraitement.nom != ''}{$dataTraitement.nom} {$dataTraitement.prenom}{else}{$dataTraitement.acronyme}{/if}</strong></p>
                  <p>Dernière modification: <strong>{$dataTraitement.dateTraitement}</strong> </p>
                  <p>Nombre d'impressions: <strong>{$dataTraitement.impression}</strong> </p>

                  <div class="input-group">
                      <label for="retour">Date de retour</label>
                      <input type="text" class="form-control datepicker" name="dateRetour" value="{$dataTraitement.dateRetour}">
                  </div>

                  <label>Dates des retards</label>
                  {foreach from=$datesRetards key=idRetard item=date}
                    <div class="input-group">
                        <span class="input-group-addon">
                            <input type="checkbox" checked class="cbDisable" name="idRetards[]" value="{$date.idRetard}">
                        </span>
                        <input type="text" class="form-control" value="{$date.date}" name="datesRetards[]" readonly>
                    </div>
                  {/foreach}

                  <label>Dates de sanction</label>
                  {foreach from=$datesSanction item=date}
                    <div class="input-group">
                        <input type="text" class="form-control" value="{$date}" name="datesSanction[]" readonly>
                        <span class="input-group-addon">
                            <input type="checkbox" checked class="sanctionDisable" name="cbIdTraitement[]" value="{$idTraitement}">
                        </span>
                    </div>
                  {/foreach}

                <button type="button" class="btn btn-danger btn-block" id="btn-deleteTraitement" data-idtraitement="{$dataTraitement.idTraitement}">Effacer tout</button>

                <div class="clearfix"></div>

                <input type="hidden" name="idTraitement" value="{$idTraitement}">
                <input type="hidden" name="matricule" value="{$matricule}">

                </form>

            </div>

          <div class="col-md-4 col-xs-12">
              <img src="../photos/{$dataEleve.photo}.jpg" alt="{$matricule}" class="img-responsive">
              {$dataEleve.nom} {$dataEleve.prenom}<br>
              {$dataEleve.classe}

              <div class="clearfix"></div>

              <div class="btn-group-vertical pull-right btn-block">
                  <button type="button" class="btn btn-default" id="btn-reset">Annuler</button>
                  <button type="button" class="btn btn-primary" id="btn-save" name="button">Enregistrer</button>
              </div>

          </div>

      </div>

      <div class="modal-footer">
      </div>

    </div>
  </div>
</div>

<script type="text/javascript">

    $('document').ready(function(){

        $('#formModifSanctions').validate({
            rules: {
                "idRetards[]": {
                    required: true,
                    minlength: 1
                },
                "cbIdTraitement[]": {
                    required: true,
                    minlength: 1
                }
            },
            debug: true
        })

        $('#btn-save').click(function(){
            var form = $('#formModifSanctions');
            if (form.valid()) {
                    var formulaire = form.serialize();
                    $.post('inc/retards/saveEditedRetard.inc.php', {
                        formulaire: formulaire
                    }, function(resultat){
                        bootbox.alert({
                            title: "Modifications",
                            message: resultat + " date(s) supprimée(s)",
                        });
                    });
                }
                else bootbox.alert('Quelque chose ne va pas');
            })

        $('#btn-deleteTraitement').click(function(){
            var idTraitement = $(this).data('idtraitement');
            bootbox.confirm({
                title: 'Veuillez confirmer',
                message: 'Les sanctions seront supprimées, les retards ne sont pas effacés.<br><strong>Veuillez confirmer</strong>.',
                callback: function (resultat) {
                    if (resultat == true) {
                        $.post('inc/retards/delTraitement.inc.php', {
                            idTraitement: idTraitement
                        }, function(nb){
                            if (nb == 1)
                                $('#btn-getRetards').trigger('click');
                                $('#modalEditRetard').modal('hide');
                        })
                    }
                }
            })
        })

        $('#btn-reset').click(function(){
            $('#formModifSanctions')[0].reset();
            $('input:text').removeClass('btn-info');
            $('input:text').removeClass('btn-warning');

        })

        $('.datepicker').datepicker({
            format: "dd/mm/yyyy",
            clearBtn: true,
            language: "fr",
            calendarWeeks: true,
            autoclose: true,
            todayHighlight: true
        })

        $('.cbDisable').change(function(){
            var cb = $(this);
            if (cb.is(':checked'))
                $(this).parent().next('input').prop('disabled', false).removeClass('btn-info');
                else $(this).parent().next('input').prop('disabled', true).addClass('btn-info');
        })

        $('.sanctionDisable').change(function(){
            var cb = $(this);
            if (cb.is(':checked'))
                $(this).parent().prev('input').prop('disabled', false).removeClass('btn-warning');
                else $(this).parent().prev('input').prop('disabled', true).addClass('btn-warning');
        })

    })

</script>
