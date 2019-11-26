<div class="container">

    <div class="row">

        <div class="col-md-8 col-xs-12">
        <h3>Modes de justifications d'absences</h3>

        <table class="table table-condensed">
            <thead>
                <tr>
                    <th style="width:1em">&nbsp;</th>
                    <th>Mention</th>
                    <th>Mention courte</th>
                    <th>Libellé</th>
                    <th>Ordre</th>
                    <th style="width:1em">&nbsp;</th>
                </tr>
            </thead>
            <tbody id="bodyEdit">
                {include file="bodyEdit.tpl"}
            </tbody>
        </table>
        <button type="button" class="btn btn-primary" id="btn-add">Ajouter un mode</button>
    </div>

    <div class="col-md-4 col-xs-12">
        <div class="panel panel-default">
          <div class="panel-heading">
            <h3 class="panel-title">Information</h3>
          </div>
          <div class="panel-body">
            <p>Les justifications "indetermine", "absent" et "present" sont obligatoires et ne peuvent être supprimées. Leur nom ne peut être modifié; mais leurs autres caractéristiques sont customisables.</p>
            <p>Les autres justifications peuvent être modifiées ou supprimées. Il faut toutefois être attentif au fait que si un mode de justification a été utilisé dans l'application, des résultats inattendus peuvent se produire s'il est supprimé.</p>
            <p>Pour la définition de nouveaux modes de justifications d'absences, il est conseillé de n'utiliser que des caractères alphanumériques non accentués pour la "mention" et pour la "mention courte".</p>
            <p>Les numéros d'ordre ne doivent pas être séquentiels.</p>
          </div>
          <div class="panel-footer">

          </div>
        </div>
    </div>

</div>  <!-- row -->

</div>  <!-- containre -->

<div class="modal fade" id="modalEdit" tabindex="-1" role="dialog" aria-labelledby="titleModalEdit" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h4 class="modal-title" id="titleModalEdit">Édition d'une justification d'absence: <strong id="nomJustif"></strong></h4>
            </div>
            <div class="modal-body" id="formEdit">

            </div>
            <div class="modal-footer">

            </div>
        </div>
    </div>
</div>

<div class="modal fade" id="modalDel" tabindex="-1" role="dialog" aria-labelledby="titleModalDel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
        <h4 class="modal-title" id="titleModalDel">Supprimer un mode de justification d'absence</h4>
      </div>
      <div class="modal-body" id="formDel">

      </div>
      <div class="modal-footer">
          <div class="btn-group pull-right">
            <button type="button" class="btn btn-default" data-dismiss="modal">Annuler</button>
            <button type="button" id="submitDel" class="btn btn-danger">Confirmer</button>
          </div>
      </div>
    </div>
  </div>
</div>

<script type="text/javascript">
    $(document).ready(function() {

        $("#bodyEdit").on('click', '.btn-edit', function() {
            var just = $(this).data('just');
            $("#submitEdit").data('justif', just);
            $.post('inc/formEdit.inc.php', {
                    just: just
                },
                function(resultat) {
                    $("#formEdit").html(resultat);
                    $("#nomJustif").text(just);
                    $("#modalEdit").modal('show');
                })
        })

        $("#bodyEdit").on('click', '.btn-del', function(){
            var just = $(this).data('justif');
            $.post('inc/formDel.inc.php', {
                just: just
            },
            function(resultat){
                $("#submitDel").data('justif', just);
                $("#formDel").html(resultat);
                $("#modalDel").modal('show');
            })
        })

        $("#submitDel").click(function(){
            var justif = $(this).data('justif');
            $.post('inc/delJustif.inc.php', {
                justif: justif
            },
            function(resultat){
                $("#bodyEdit").html(resultat);
                $("#modalDel").modal('hide');
            })
        })

        $("#btn-add").click(function(){
            $("#nomJustif").text('');
            $.post('inc/formEdit.inc.php', {
                    just: null,
                    edition: false
                },
                function(resultat) {
                    $("#formEdit").html(resultat);
                    $("#modalEdit").modal('show');
                })

        })
    })
</script>
