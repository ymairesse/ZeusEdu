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
{* <pre>
    {$listeRV|print_r}
</pre> *}
        {foreach from=$listeRV key=idRV item=data}
        <tr class="{if $data.heure >= $listePeriodes[3].min}attente3
                    {elseif $data.heure >= $listePeriodes[2].min}attente2
                    {else}attente1
                    {/if}
                {if $data.dispo==0} indisponible{/if}"
             data-nomparent="{$data.formule} {$data.nomParent} {$data.prenomParent}" data-idrv="{$data.idRV}">
            <td>{$data.heure}</td>
            <td {if ($data.matricule !=Null)} class="pop" data-toggle="popover"
                data-content="<img src='../photos/{$data.photo}.jpg' alt='{$data.matricule}' style='width:100px'>"
                data-html="true"
                data-container="body"
                data-original-title="{$data.prenom} {$data.nom}"
                {/if}>
                {$data.groupe} {$data.nom} {$data.prenom}</td>
            <td><a title="{$data.mail}" href="mailto:{$data.mail}">{$data.formule} {$data.nomParent} {$data.prenomParent}</a></td>
            <td>
                {if ($data.matricule == Null)}
                <button
                    type="button"
                    data-idrv="{$data.idRV}"
                    data-eleve="{$data.prenom} {$data.nom}"
                    data-mail="{$data.mail}"
                    class="btn btn-default btn-xs dispo pull-right">
                    <i class="fa {if $data.dispo == 0}fa-toggle-on switchOff{else}fa-toggle-off switchOn{/if}"></i>
                </button>
                {/if}
            </td>
            <td>
                {if (isset($listeAttente) && ($listeAttente != Null))}
                <input type="radio" name="idRV" class="idRV" value="{$idRV}"{if ($data.dispo == 0)} disabled{/if}>
                {else}
                &nbsp;
                {/if}
            </td>

        </tr>
        {/foreach}
    </tbody>

</table>


<script type="text/javascript">

    var dispo = 'Disponible/indisponible';

    $(document).ajaxStart(function(){
        $('body').addClass("wait");
    }).ajaxComplete(function(){
        $('body').removeClass("wait");
    });

    $(document).ready(function() {

        $(".dispo").attr('title', dispo)

        $(".dispo").click(function() {
            var idRV = $(this).data('idrv');
            var idRP = $('#idRP').val();
            var btnIcon = $(this).find('i');
            if (btnIcon.hasClass('fa-toggle-on'))
                $(this).find('i').removeClass('fa-toggle-on switchOff').addClass('fa-toggle-off switchOn');
            else
                $(this).find('i').removeClass('fa-toggle-off switchOn').addClass('fa-toggle-on switchOff');
                // modification du statut en base de données
                $.post('inc/reunionParents/toggleDispo.inc.php', {
                    idRV: idRV,
                    idRP: idRP
                },
                function(resultat) {
                    var ligne = btnIcon.closest('tr');
                    if (resultat == 1) {
                        ligne.removeClass('indisponible');
                        ligne.attr('title', ' ');
                        ligne.find('input:radio.idRV').attr('disabled',false).attr('checked',false);
                    } else {
                        ligne.addClass('indisponible');
                        ligne.attr('title', 'Période indisponible');
                        ligne.find('input:radio.idRV').attr('disabled',true).attr('checked',false);
                    }

                }
            )

        })

    })
</script>
