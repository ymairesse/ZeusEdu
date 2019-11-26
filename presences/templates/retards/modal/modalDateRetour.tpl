<div id="modalEditRetour" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="modalEditRetourLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
        <h4 class="modal-title" id="modalEditRetourLabel">Notification du retour</h4>
      </div>
      <div class="modal-body">

            <div class="col-md-8 col-xs-12">

                <form id="formDateRetour">

                <h3>{$dataEleve.nom} {$dataEleve.prenom} {$dataEleve.classe}</h3>

                  <p>Dernier traitement par: <strong>{if $dataTraitement.nom != ''}{$dataTraitement.nom} {$dataTraitement.prenom}{else}{$dataTraitement.acronyme}{/if}</strong></p>
                  <p>Dernière modification: <strong>{$dataTraitement.dateTraitement}</strong> </p>
                  <p>Nombre d'impressions: <strong>{$dataTraitement.impression}</strong> </p>

                  <div class="input-group">
                      <input type="text" class="form-control datepicker" name="dateRetour" id="dateRetour" value="{$dataTraitement.dateRetour}">
                      <span class="input-group-btn">
                          <button type="button" class="btn btn-danger" id="btn-resetDate"><i class="fa fa-times"></i></button>
                      </span>
                  </div>
                  <div class="help-block">Date de retour de la fiche</div>

                <input type="hidden" name="idTraitement" id="idTraitement" value="{$idTraitement}">
                <input type="hidden" name="matricule" id="matricule" value="{$matricule}">

                <button type="button" class="btn btn-primary btn-block" id="btn-saveRetour" name="button">Enregistrer</button>

                </form>

            </div>

            <div class="col-md-4 col-xs-12">
                <img src="../photos/{$dataEleve.photo}.jpg" alt="{$matricule}" class="img-responsive">

                <div class="clearfix"></div>
            </div>

      </div>

      <div class="modal-footer">
      </div>

    </div>
  </div>
</div>

<script type="text/javascript">

    $('document').ready(function(){

        $('#formDateRetour').validate();

        $('#btn-resetDate').click(function(){
            $('#dateRetour').val('');
        })

        $('#btn-saveRetour').click(function(){
            var form = $('#formDateRetour');
            if (form.valid()) {
                var idTraitement = $('#idTraitement').val();
                var formulaire = form.serialize();
                $.post('inc/retards/saveEditedDateRetour.inc.php', {
                    formulaire: formulaire
                }, function(resultat){
                    if (resultat != '') {
                        $('.btn-retour[data-idtraitement="' + idTraitement + '"]').text(resultat);
                        bootbox.alert({
                            title: "Modifications",
                            message: "Date enregistrée au " + resultat,
                            });
                        }
                        else
                            $('.btn-retour[data-idtraitement="' + idTraitement + '"]').html('<i class="fa fa-pencil"></i>');
                    $('#modalEditRetour').modal('hide');
                    })
                }
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
