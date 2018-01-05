<div class="container">

    <div class="row">

        <div class="col-xs-12">

            <h3>Liste des demandes en attente</h3>

            <table class="table table-condensed" id="listeDemandes">
                <thead>
                    <tr>
                        <th style="width:2em">&nbsp;</th>
                        <th style="width:8em">Date</th>
                        <th style="width:4em">Classe</th>
                        <th style="width: 20em">Nom</th>
                        <th>Motif</th>
                        <th>Envoyé par</th>
                        <th style="width: 3em">&nbsp;</th>
                        <th style="width: 8em">&nbsp;</th>
                    </tr>

                </thead>

                {foreach from=$listeDemandes key=id item=data name=boucle}
                <tr class="urgence{$data.urgence}" data-id="{$data.id}">
                    <td>{$smarty.foreach.boucle.iteration}</td>
                    <td>{$data.date}</td>
                    <td>{$data.groupe}</td>
                    <td>{$data.prenom} {$data.nom}</td>
                    <td title="{$data.motif}"
                        data-placement="bottom"
                        data-container="body">
                        {$data.motif|truncate:100:'...'}
                    </td>
                    <td>{$data.envoyePar}</td>
                    <td><button type="button" data-id="{$data.id}" class="btn btn-info btn-sm voir" title="Voir la demande"><i class="fa fa-eye"></i> </button> </td>
                    <td><button type="button" data-id="{$data.id}" class="btn btn-primary btn-sm adopter" title="Je prends en charge">Prise en charge</button></td>
                </tr>
                {/foreach}
            </table>

        </div>

    </div>

</div>


<div id="modalLook" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="modalLookLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
        <h4 class="modal-title" id="modalLookLabel">Demande de prise en charge</h4>
      </div>
      <div class="modal-body">

      </div>
      <div class="modal-footer">
          <button type="button" class="btn btn-primary pull-left adopter">Prise en charge</button>
          <button type="button" class="btn btn-default" data-dismiss="modal">Fermer</button>
      </div>
    </div>
  </div>
</div>

<script type="text/javascript">

    $('document').ready(function(){

        $('.voir').click(function(){
            var id = $(this).data('id');
            $('#modalLook .adopter').data('id', id);
            $.post('inc/eleves/lookDemande.inc.php', {
                id: id
            }, function(resultat){
                $('#modalLook .modal-body').html(resultat);
                $('#modalLook').modal('show');
            })
        })

        $('.adopter').click(function(){
            var id = $(this).data('id');
            $.post('inc/eleves/adopter.inc.php', {
                id: id
            }, function(){
                $('#listeDemandes tr[data-id="' + id + '"]').remove();
                $('#modalLook').modal('hide');
                bootbox.alert('Cet-te élève est maintenant dans votre liste.')
            })
        })
    })

</script>
