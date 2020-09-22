
<div class="container-fluid">

    <div class="row">

        <div class="col-md-3 col-sm-6">

            <div class="panel panel-info">
                <div class="panel-heading">
                    Mes groupes
                </div>
                <div class="panel-body" id="listeMesGroupes">

                    {include file="groupes/listeMesGroupes.tpl"}

                </div>
                <div class="panel-footer">
                    <button type="button" class="btn btn-success btn-block" id="btn-newGroupe">Nouveau groupe</button>
                </div>

            </div>

        </div>

        <div class="col-md-6 col-sm-6" id="editGroupe">
            Édition et création des groupes
        </div>

        <div class="col-md-3 col-sm-12">
            Infos
        </div>

    </div>

</div>

<script type="text/javascript">

    $(document).ready(function(){

        $('.btn-groupe').click(function(){
            var groupe = $(this).closest('tr').data('groupe');
            $.post('inc/groupes/detailsGroupe.inc.php', {
                groupe: groupe
            }, function(resultat){
                $('#editGroupe').html(resultat);
            })
        })

    })

</script>
