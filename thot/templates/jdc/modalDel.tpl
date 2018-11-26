<div id="modalDel" class="modal fade" aria-hidden"=true">

    <div class="modal-dialog">

        <div class="modal-content">

            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" data-target="#modalDel">&times;</button>
                <h4 class="modal-title">Confirmation</h4>
            </div>

            <form action="index.php" method="POST" name="delete" id="delete" role="form" class="form-vertical">
                <div class="modal-body">
                    <p>Voulez-vous supprimer cette mention au journal de classe?</p>
                    <h4>{$travail.categorie}</h4>
                    {if $travail.type == 'cours'}
                        <p><strong>{if ($travail.nomCours != '')}{$travail.nomCours}: {/if}{$travail.libelle} {$travail.nbheures}h</strong> [{$travail.destinataire}]</p>
                        {else}
                        <p>Classe: {$travail.destinataire}</p>
                    {/if}

                    <p>Professeur <strong>{$travail.nom}</strong></p>
                    <p><strong>{$travail.title}</strong></p>
                    <div>{$travail.enonce}</div>
                </div>

                <div class="modal-footer">

                        <input type="hidden" name="id" id="id" value="{$travail.id}">
                        <input type="hidden" name="startDate" value="{$startDate}">
                        <input type="hidden" name="destinataire" value="{$destinataire}">
                        <input type="hidden" name="type" value="{$type}">
                        <input type="hidden" name="coursGrp" value="{$coursGrp|default:''}">
                        <input type="hidden" name="classe" value="{$classe|default:''}">
                        <input type="hidden" name="action" value="jdc">
                        <input type="hidden" name="mode" value="delete">
                    <button type="button" class="btn btn-danger" id="btn-modalDel"><i class="fa fa-eraser fa-lg"></i> Supprimer</button>

                </div>  <!-- modal-footer -->
            </form>

        </div>  <!-- modal-content -->

    </div>  <!-- modal-dialog -->

</div>  <!-- modalDel -->

<script type="text/javascript">

    $(document).ready(function(){

        $('#btn-modalDel').click(function(){
            var id = $('#id').val();
            $.post('inc/jdc/delJdc.inc.php', {
                id: id
            }, function(resultat){
                if (resultat == 1) {
                    bootbox.alert({
                        message: "Événement supprimé",
                        size: 'small'
                    });
                    $('#unTravail').load('templates/jdc/selectItem.html');
                }
                $('#calendar').fullCalendar('refetchEvents');
                $('#modalDel').modal('hide');
            })
        })

    })

</script>
