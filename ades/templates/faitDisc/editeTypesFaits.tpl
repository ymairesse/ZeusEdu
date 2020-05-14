<div class="container-fluid">

    <div class="row">

        <h3>Faits disciplinaires</h3>

        <div class="col-md-9 col-xs-12 ombre" id="tableauFaits">

            {include file='faitDisc/tableauFait.tpl'}

        </div>

        <div class="col-md-3 col-xs-12">
            <div class="panel-group">
                <div class="panel panel-success ombre">
                    <div class="panel-heading"><i class="fa fa-file fa-lg"></i> Nouveau</div>
                    <div class="panel-body">
                        <button type="button" class="btn btn-success btn-block btn-newType" data-retenue='0'>Nouveau type de Fait</button>
                        <button type="button" class="btn btn-danger btn-block btn-newType" data-retenue='1'>Nouveau type de retenue</button>
                    </div>
                </div>

                <div class="panel panel-info">
                    <div class="panel-heading"><i class="fa fa-info-circle fa-lg" style="color:blue"></i> Information</div>
                    <div class="panel-body">
                        <p>Pour supprimer un fait disciplinaire, cliquer sur le bouton <button type="button" class="btn btn-danger btn-xs"><i class="fa fa-minus"></i></button>. Seuls les faits disciplinaires jamais utilisés peuvent être supprimés. <strong>Le bouton de suppression est désactivé pour les autres.</strong></p>
                        <p>Pour modifier un type de fait, cliquer sur le bouton <button type="button" class="btn btn-success btn-xs"><i class="fa fa-edit"></i></button>.</p>
                        <p>Pour modifier l'ordre de présentation des faits, utilisez les boutons fléchés <button type="button" class="btn btn-warning btn-xs"><i class="fa fa-arrow-down"></i></button> et <button type="button" class="btn btn-warning btn-xs"><i class="fa fa-arrow-up"></i></button>.
                            L'application du changement de position est immédiate.</p>
                    </div>
                </div>
            </div>
        </div>
    </div>

</div>


<div id="modalDelFait" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="modalDelFaitLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
                <h4 class="modal-title" id="modalDelFaitLabel">suppression d'un type de fait disciplinaire</h4>
            </div>
            <div class="modal-body">
                <p>Vous allez supprimer définitivement le type de fait disciplinaire <strong id="modalTitreFait"></strong></p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-danger pull-right" name="button" id="btn-delTypeFait" data-type=''>Veuillez confirmer</button>
            </div>
        </div>
    </div>
</div>

<div id="modalEditFait" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="modalEditFaitLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
                <h4 class="modal-title" id="modalEditFaitLabel">Création ou modification d'un type de fait disciplinaire</h4>
            </div>
            <div class="modal-body">
                <form id="formEditFait">

                </form>
            </div>
            <div class="modal-footer">
            <button type="button" class="btn btn-primary pull-right" id="btn-submitTypeFait">Enregistrer</button>
            </div>
        </div>
    </div>
</div>


<script type="text/javascript">

    $(document).ready(function() {

        $(".btn-newType").click(function() {
            var retenue = $(this).data('retenue');
            $.post('inc/faits/newTypeFait.inc.php', {
                    retenue: retenue
                },
                function(resultat) {
                    $("#formEditFait").html(resultat);
                    $("#modalEditFait").modal('show');
                })
        })

        $("#btn-submitTypeFait").click(function() {
            if ($("#titreFait").val() == '') {
                $("#titreFait").focus();
                $("#titreFait").closest('.form-group').find('.help-block').html('<span class="error">Veuillez compléter</span>');
                return false;
            }
            var formulaire = $("#formEditFait").serialize();
            $.post('inc/faits/saveTypeFait.inc.php', {
                    formulaire: formulaire
                },
                function(resultat) {
                    $("#tableauFaits").html(resultat);
                    $("#modalEditFait").modal('hide');
                     bootbox.alert('Ce type de fait a été enregistré');
                })
        })

        $("#tableauFaits").on('click', '.btn-edit', function() {
            var type = $(this).data('type');
            $.post('inc/faits/formEditTypeFait.inc.php', {
                type: type
            }, function(resultat) {
                $("#formEditFait").html(resultat);
                $("#modalEditFait").modal('show');
            })
        })

        $("#tableauFaits").on('click', '.btn-up', function() {
            var type = $(this).data('type');
            $.post('inc/faits/changeOrdre.inc.php', {
                    type: type,
                    sens: 'up'
                },
                function(resultat) {
                    $("#tableauFaits").html(resultat);
                })
        })

        $("#tableauFaits").on('click', '.btn-down', function() {
            var type = $(this).data('type');
            $.post('inc/faits/changeOrdre.inc.php', {
                    type: type,
                    sens: 'down'
                },
                function(resultat) {
                    $("#tableauFaits").html(resultat);
                })
        })

        $("#tableauFaits").on('click', '.btn-delFait', function() {
            var type = $(this).data('type');
            var titreFait = $(this).closest('tr').find('.titreFait').text();
            $("#modalTitreFait").text(titreFait);
            $("#btn-delTypeFait").data('type', type);
            $("#modalDelFait").modal('show');
        })

        $("#btn-delTypeFait").click(function() {
            var type = $(this).data('type');
            $.post('inc/faits/delTypeFaits.inc.php', {
                    type: type
                },
                function(resultat) {
                    $("#tableauFaits").html(resultat);
                    $("#modalDelFait").modal('hide');
                })
        })

    })
</script>
