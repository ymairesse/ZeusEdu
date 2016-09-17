{if $listeAffectations|@count != 0}

<div class="panel panel-warning">
    <div class="panel-heading">
        <h4 class="panel-title">Affectations de {$nomProf}</h4>
    </div>
    <div class="panel-body">
        <table class="table table-condensed">
            <thead>
                <tr>
                    <th>Affectation</th>
                    <th>Libellé</th>
                </tr>
            </thead>
            <tbody>
                {foreach from=$listeAffectations key=coursGrp item=data}
                <tr>
                    <td>{$data.coursGrp}</td>
                    <td>{$data.libelle}</td>
                </tr>
                {/foreach}
            </tbody>
        </table>
    </div>
    <div class="panel-footer">
        <button type="button" class="btn btn-danger btn-block" id="warningDelAffectations" data-acronyme="{$acronyme}" data-nomprof="{$nomProf}">
            Supprimer ces affectations
        </button>
    </div>
</div>

<div class="modal fade" id="modalDelAffectations" tabindex="-1" role="dialog" aria-labelledby="titleDelAffectations" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h4 class="modal-title" id="titleDelAffectations">Suppression des affectations de {$nomProf}</h4>
            </div>
            <div class="modal-body">

                <p><i class="fa fa-warning fa-3x"></i> Veuillez confirmer la suppression définitive des affectations de</p>
                <p><strong>{$nomProf}</strong></p>
                <p>Attention, cette suppression est définitive.</p>

            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">Annuler</button>
                <button type="button" class="btn btn-danger" id="delAffectations" data-nomprof="{$nomProf}" data-acronyme="{$acronyme}">Confirmer</button>
            </div>
        </div>
    </div>
</div>

{else}

<div class="panel panel-warning">
    <div class="panel-heading">
        <h4 class="panel-title">Affectations de {$nomProf}</h4>
    </div>
    <div class="panel-body">
        <p>Aucune affectation pour ce membre du personnel</p>
    </div>
    <div class="panel-footer">
        <button type="button" class="btn btn-danger btn-block" id="warningDelMP" data-acronyme="{$acronyme}" data-nomprof="{$nomProf}">
            Supprimer ce membre du personnel
        </button>
    </div>
</div>

<div class="modal fade" id="modalDelMP" tabindex="-1" role="dialog" aria-labelledby="titleModalDel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h4 class="modal-title" id="titleModalDel">Suppression d'un membre du personnel</h4>
            </div>
            <div class="modal-body">

                <p><i class="fa fa-warning fa-3x"></i> Veuillez confirmer la suppression définitive de la base de données de </p>
                <p><strong>{$nomProf}</strong></p>
                <p>Attention, cette suppression est définitive.</p>

            </div>
            <div class="modal-footer">
                <form action="index.php" name="delMP" method="POST" class="form-inline" role="form">
                    <input type="hidden" name="action" value="gestUsers">
                    <input type="hidden" name="mode" value="delUser">
                    <input type="hidden" name="etape" value="delete">
                    <input type="hidden" name="acronyme" value="{$acronyme}">
                    <div class="btn-group pull-right">
                        <button type="button" class="btn btn-default" data-dismiss="modal">Annuler</button>
                        <button type="submit" class="btn btn-danger" id="delMP">Confirmer</button>
                    </div>
                    <div class="clearfix"></div>
                </form>
            </div>
        </div>
    </div>
</div>
{/if}

<script type="text/javascript">
    $(document).ready(function() {

        $('#warningDelAffectations').click(function() {
            $("#modalDelAffectations").modal('show');
        })

        $('#delAffectations').click(function() {
            var acronyme = $(this).data('acronyme');
            var nomProf = $(this).data('nomprof');
            $.post('inc/users/delAffectations.inc.php', {
                    acronyme: acronyme,
                    nomProf: nomProf
                },
                function(resultat) {
                    $("#listeCours").html(resultat);
                })
        })

        $('#warningDelMP').click(function() {
            $('#modalDelMP').modal('show');
        })

    })
</script>
