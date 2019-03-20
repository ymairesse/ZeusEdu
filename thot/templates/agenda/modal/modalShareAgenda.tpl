<div id="modalShareAgenda" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="modalShareAgendaLabel" aria-hidden="true">
  <div class="modal-dialog modal-lg">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
        <h4 class="modal-title" id="modalShareAgendaLabel">{$nomAgenda}</h4>
      </div>
      <div class="modal-body row">

          <div class="col-xs-4" id="dejaLa">
              <h4>Déjà partagé avec</h4>
              <ul class="list-unstyled"
                    id="listeDejaLa"
                    style="max-height:15em;overflow:auto;">

                {include file='agenda/include/listePartages.tpl'}

              <ul>
          </div>


          <div class="col-xs-8" id="new">
              <form id="formShare" name="formShare">
              <div class="row">

                  <div class="col-xs-4" id="destinataire">

                      <h4>Partager avec</h4>
                      <select id="selectDestinataire" class="form-control" name="selectDestinataire" size="{$listeDestinataires|@count}">
                          {foreach from=$listeDestinataires key=type item=data}
                          <option title="{$data}" value="{$type}">{$data}</option>
                          {/foreach}
                      </select>

                  </div>

                  <div class="col-xs-8" id="supplement">

                  </div>

              </div>

              <div class="clearfix"></div>
              <input type="hidden" name="idAgenda" value="{$idAgenda}">

            </form>

            <button type="button" class="btn  btn-default" id="btn-endShare" class="close" data-dismiss="modal"><i class="fa fa-times"></i> Terminer</button>
            <button type="button" class="btn btn-primary pull-right" id="btn-share">Partager</button>

          </div>


      </div>

    </div>
  </div>
</div>

<style media="screen" type="text/css">
    .row div {
        transition: width 0.5s ease-out, margin 0.5s ease-out;
    }
</style>

<script type="text/javascript">

    function clicDestinataire(){
        $('#destinataire').removeClass('col-xs-2').addClass('col-xs-4');
        $('#supplement').removeClass('col-xs-10').addClass('col-xs-8');
    }
    function clicSupplement(){
        $('#destinataire').removeClass('col-xs-4').addClass('col-xs-2');
        $('#supplement').removeClass('col-xs-8').addClass('col-xs-10');
    }

    function dejaLa(){
        $('#dejaLa').removeClass('col-xs-2').addClass('col-xs-4');
        $('#new').removeClass('col-xs-10').addClass('col-xs-8');
    }
    function new0(){
        $('#dejaLa').removeClass('col-xs-4').addClass('col-xs-2');
        $('#new').removeClass('col-xs-8').addClass('col-xs-10');
    }

    $(document).ready(function(){

        $('#btn-share').click(function(){
            var formulaire = $('#formShare').serialize();
            $.post('inc/agenda/saveShares4Agenda.inc.php', {
                formulaire: formulaire
            }, function(resultat){
                $('#listeDejaLa').html(resultat);
                dejaLa();
            })
        })

        $('#modalShareAgenda').on('hidden.bs.modal', function () {
            var idAgenda = $('#idAgenda').val();
            $.post('inc/agenda/listeMesAgendas.inc.php', {
                idAgenda: idAgenda
            }, function(resultat){
                $('#unTravail').html(resultat);
            })
        })

        $('#formShare').on('click', '#destinataire', function(){
            clicDestinataire();
        })
        $('#formShare').on('click', '#selectNiveau', function(){
            clicSupplement();
        })

        $('#modalShareAgenda').on('click', '#new', function(){
            new0();
        })
        $('#modalShareAgenda').on('click', '#dejaLa', function(){
            dejaLa();
        })

        $('#selectDestinataire').change(function(){
            var type = $('#selectDestinataire').val();
            $.post('inc/agenda/getSupplementModal.inc.php', {
                type: type
            }, function(resultat){
                $('#supplement').html(resultat);
            })
        })

        $('#dejaLa').on('click', '.btn-delShare', function(){
            var idAgenda = $(this).data('idagenda');
            var type = $(this).data('type');
            var destinataire = $(this).data('destinataire');
            var lblDestinataire = $(this).closest('li').find('span').text();
            var bouton = $(this);
            bootbox.confirm({
                title: 'Confirmation',
                message: '<i class="fa fa-exclamation-triangle fa-3x"></i> Fin du partage avec "<strong>' + lblDestinataire + '</strong>"?',
                callback: function(result){
                    if (result == true) {
                        $.post('inc/agenda/delSharedAgenda.inc.php', {
                            type: type,
                            destinataire: destinataire,
                            idAgenda: idAgenda
                        }, function(){
                            bouton.closest('li').remove();
                        });
                        $.post('inc/agenda/listeMesAgendas.inc.php', {
                            idAgenda: idAgenda
                        }, function(resultat){
                            $('#unTravail').html(resultat);
                        })
                    }
                }
            })

        })

    })

</script>
