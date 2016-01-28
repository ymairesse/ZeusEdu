<div class="container">

    <div class="col-md-7 col-sm-12">

        {if $listeRV != Null}
        <h3>Réunion de parents du {$date}</h3>

        <table class="table table-condensed">
            <thead>
                <tr>
                    <td>&nbsp;</td>
                    <td>Heure</td>
                    <td>Parent</td>
                    <td>Élève</td>
                    <td>&nbsp;</td>
                </tr>
            </thead>

            <tbody>
                {foreach from=$listeRV key=heure item=data name=boucle}
                <tr{if $data.dispo == 0} class="indisponible"{/if}
                    {if ($data.matricule != Null)}
                        class="pop"
                        data-toggle="popover"
                        data-content="<img src='../photos/{$data.photo}.jpg' alt='{$data.matricule}' style='width:100px'>"
                        data-html="true"
                        data-container="body"
                        data-original-title="{$data.photo}"
                    {/if}>
                    <td class="discret">{$smarty.foreach.boucle.iteration}</td>
                    <td>{$data.heure}</td>
                    <td><a href="mailto:{$data.mail}">{$data.formule} {$data.nomParent}</a></td>
                    <td>
                    {$data.classe} {$data.nomEleve} {$data.prenomEleve}</td>
                    <td>
                        {if ($data.matricule == Null)}
                        <button type="button" data-id="{$data.id}" class="btn btn-default btn-xs dis pull-right">
                        <i class="fa {if $data.dispo == 0}fa-toggle-on{else}fa-toggle-off{/if}"></i>
                        </button>
                        {/if}
                </td>
                </tr>
                {/foreach}
            </tbody>
            <tfoot>
                <tr>
                    <td colspan="5" class="indisponible"><strong>Lignes grisées = indisponibles</strong></td>
                </tr>
            </tfoot>

        </table>

        {/if}
    </div>

</div>

<script type="text/javascript">

$(document).ready(function(){

    $(".dis").attr('title','Disponible/indisponible')

    $(".dis").click(function(){
        var id=$(this).data('id');
        var btnIcon = $(this).find('i');
        if (btnIcon.hasClass('fa-toggle-on'))
            $(this).find('i').removeClass('fa-toggle-on').addClass('fa-toggle-off');
            else
            $(this).find('i').removeClass('fa-toggle-off').addClass('fa-toggle-on');
        $.post('inc/reunionParents/toggleDispo.inc.php', {
            id:id
            },
            function (resultat) {
                var ligne = btnIcon.closest('tr');
                if (resultat == 1) {
                    ligne.removeClass('indisponible');
                    ligne.attr('title',' ');
                    }
                    else {
                        ligne.addClass('indisponible');
                        ligne.attr('title','Période indisponible')
                        }
            }
        )

    })

})

</script>
