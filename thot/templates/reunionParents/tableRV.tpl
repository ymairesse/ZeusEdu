<h4>Les RV de {$nomProf}</h4>
<table class="table table-condensed">
    <thead>
        <tr>
            <td>Heure</td>
            <td>Élève</td>
            <td>Parent</td>
            <td style="width:1em">Dispo</td>
            <td style="width:1em">&nbsp;</td>
        </tr>
    </thead>
    <tbody>
        {foreach from=$listeRV key=id item=data}
        <tr data-nomparent="{$data.formule} {$data.nomParent} {$data.prenomParent}" data-id="{$data.id}" {if $data.dispo==0 } class="indisponible" {/if}>
            <td>{$data.heure}</td>
            <td {if ($data.matricule !=N ull)} class="pop" data-toggle="popover" data-content="<img src='../photos/{$data.photo}.jpg' alt='{$data.matricule}' style='width:100px'>" data-html="true" data-container="body" data-original-title="{$data.photo}" {/if}>
                {$data.nom} {$data.prenom}</td>
            <td><a title="{$data.mail}" href="mailto:{$data.mail}">{$data.formule} {$data.nomParent} {$data.prenomParent}</a></td>
            <td>
                {if ($data.matricule == Null)}
                <button type="button" data-id="{$data.id}" class="btn btn-default btn-xs dis pull-right">
                    <i class="fa {if $data.dispo == 0}fa-toggle-on{else}fa-toggle-off{/if}"></i>
                </button>
                {/if}
            </td>
            <td>
                {if $data.matricule != ''}
                <button type="button" class="btn btn-danger btn-xs unlink" title="Annuler ce RV"><i class="fa fa-chain-broken"></i></button>
                {else} &nbsp; {/if}
            </td>
        </tr>
        {/foreach}
    </tbody>

    <tfoot>
        <tr>
            <td colspan="5" class="indisponible">
                <strong>Lignes grisées = indisponibles</strong>
            </td>
        </tr>
    </tfoot>

</table>

<script type="text/javascript">
    $(document).ready(function() {

        $(".dis").attr('title', 'Disponible/indisponible')

        $(".dis").click(function() {
            var id = $(this).data('id');
            var btnIcon = $(this).find('i');
            if (btnIcon.hasClass('fa-toggle-on'))
                $(this).find('i').removeClass('fa-toggle-on').addClass('fa-toggle-off');
            else
                $(this).find('i').removeClass('fa-toggle-off').addClass('fa-toggle-on');
            $.post('inc/reunionParents/toggleDispo.inc.php', {
                    id: id
                },
                function(resultat) {
                    var ligne = btnIcon.closest('tr');
                    if (resultat == 1) {
                        ligne.removeClass('indisponible');
                        ligne.attr('title', ' ');
                    } else {
                        ligne.addClass('indisponible');
                        ligne.attr('title', 'Période indisponible')
                    }
                }
            )

        })

        $(".unlink").click(function() {
            var nom = $(this).closest('tr').data('nomparent');
            var id = $(this).closest('tr').data('id');
            $("#id").val(id);
            $("#nomParent").html(nom);
            $("#modalDelRV").modal('show');
        })

    })
</script>
