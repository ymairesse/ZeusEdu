<div class="container-fluid">

    <div class="row">

        <div class="col-md-6 col-xs-12">

            <h3>Liste des demandes "profs" en attente <span class="badge badge-info pull-right">{$listeDemandesProfs|@count}</span></h3>

            <table class="table table-condensed" id="listeDemandes">
                <thead>
                    <tr>
                        <th style="width:2em">&nbsp;</th>
                        <th style="width:8em">Date</th>
                        <th style="width:4em">Classe</th>
                        <th style="width: 20em">Nom</th>
                        <th>Motif</th>
                        <th style="text-align:center">Envoyé par</th>
                        <th style="width: 3em">&nbsp;</th>
                        <th style="width: 8em">&nbsp;</th>
                    </tr>

                </thead>

                {foreach from=$listeDemandesProfs key=id item=data name=boucle}
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
                    <td><button type="button" data-id="{$data.id}" class="btn btn-info btn-xs voir" title="Voir la demande"><i class="fa fa-eye"></i> </button> </td>
                    <td>
                        <button type="button" data-id="{$data.id}" class="btn btn-success btn-xs adopter" title="Je prends en charge">Prise en charge</button>
                    </td>
                </tr>
                {/foreach}
            </table>

        </div>

        <div class="col-md-6 col-xs-12">
            <h3>Liste des demandes "élèves" en attente <span class="badge badge-info pull-right">{$listeDemandesEleves|@count}</span></h3>
            {if $listeDemandesEleves|@count > 0}
            <table class="table table-condensed">
                <tr>
                    <th style="width:2em">&nbsp;</th>
                    <th style="width:16em">Date</th>
                    <th style="width:4em">Classe</th>
                    <th style="">Nom</th>

                    <th style="width: 3em">&nbsp;</th>
                    <th style="width: 5em">&nbsp;</th>
                    <th style="width: 3em">&nbsp;</th>
                </tr>

                {foreach from=$listeDemandesEleves key=id item=data name=boucle2}
                <tr>
                    <td>{$smarty.foreach.boucle2.iteration}</td>
                    <td>Le {$data.laDate} à {$data.heure}</td>
                    <td>{$data.groupe}</td>
                    <td title="{$data.commentaire}"
                    data-placement="bottom"
                    data-container="body">
                        {$data.nom} {$data.prenom}
                    </td>

                    <td style="width:2em;">
                        <button type="button" class="btn btn-info btn-xs btn-show" data-id="{$id}" title="Voir la demande"><i class="fa fa-eye"></i> </button>
                    </td>
                    <td>
                        {if $data.adopte == ''}
                        <button type="button"
                            class="btn btn-success btn-xs btn-block pull-right btn-adopt"
                            data-id="{$id}"
                            data-nom="{$data.prenom} {$data.nom}"
                            title="Je prends en charge">
                            Prise en charge
                        </button>
                        {else}
                            <button type="button"
                                class="btn btn-info btn-xs btn-block pull-right btn-adopt"
                                disabled
                                title="Pris en charge">
                                {$data.adopte}
                            </button>
                        {/if}
                    </td>
                    <td>
                        <button type="button" class="btn btn-danger btn-xs btn-block btn-del {if $acronyme != $data.adopte}hidden{/if}" data-id="{$id}"><i class="fa fa-times"></i></button>
                    </td>
                </tr>
                {/foreach}

            </table>

            {/if}

        </div>

    </div>

</div>

<div id="modal"></div>

<script type="text/javascript">

    $('document').ready(function(){

        $('.btn-del').click(function(){
            var ceci = $(this);
            var id = ceci.data('id');
            $.post('inc/eleves/delDemandeEleve.inc.php', {
                id: id
            }, function(resultat){
                ceci.closest('tr').remove();
            })
        })

        $('.btn-adopt').click(function(){
            var id = $(this).data('id');
            var nom = $(this).data('nom');
            bootbox.confirm({
                title: 'Prise en charge',
                message: 'Veuillez confirmer la prise en charge de ' + nom,
                callback : function(result){
                    if (result == true){
                        $.post('inc/eleves/adoptEleve.inc.php', {
                            id: id
                        }, function(resultat){
                            $('.btn-adopt[data-id="' + id + '"]').text(resultat);
                            $('.btn-adopt[data-id="' + id + '"]').removeClass('btn-success').addClass('btn-info').attr('disabled', true);
                            $('.btn-del[data-id="' + id + '"]').removeClass('hidden');
                        })
                    }
                }
            })

        })

        $('.btn-show').click(function(){
            var id = $(this).data('id');
            $.post('inc/eleves/lookDemandeEleve.inc.php', {
                id: id
            }, function(resultat){
                $('#modal').html(resultat);
                $('#modalLook').modal('show');
            })
        })

        $('.voir').click(function(){
            var id = $(this).data('id');
            // $('#modalLook .adopter').data('id', id);
            $.post('inc/eleves/lookDemandeProf.inc.php', {
                id: id
            }, function(resultat){
                $('#modal').html(resultat);
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
