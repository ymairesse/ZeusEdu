<div class="panel panel-default">

    <div class="panel-heading">
        <h3 class="panel-title">Les RV de <span id="nomProf">{$nomProf}</span> [{$acronyme}]</button></h3>
    </div>

    <div class="panel-body">
        <table class="table table-condensed">
            <thead>
                <tr>
                    <td>Heure</td>
                    <td>Élève</td>
                    <td>Parent</td>
                    <td style="width:1em">Dispo</td>
                    <td style="width:2.5em">&nbsp;</td>
                    <td style="width:1em"><i class="fa fa-calendar-o"></i></td>
                    <td style="width:2.5em"><i class="fa fa-arrow-left"></i></td>

                </tr>
            </thead>
            <tbody>
                {foreach from=$listeRV key=idRV item=data}
                <tr class="{if $data.heure >= $listePeriodes[3].min}attente3
                            {elseif $data.heure >= $listePeriodes[2].min}attente2
                            {else}attente1
                            {/if}
                            {if $data.dispo==0} indisponible{/if}"
                    data-nomparent="{$data.formule|default:''} {$data.nomParent|default:''} {$data.prenomParent|default:''}" data-idrv="{$data.idRV}">
                    <td>{$data.heure}</td>
                    <td {if ($data.matricule !=Null)}
                        class="pop"
                        data-toggle="popover"
                        data-content="<img src='../photos/{$data.photo}.jpg' alt='{$data.matricule}' style='width:100px'>"
                        data-html="true"
                        data-container="body"
                        data-original-title="{$data.photo}"
                        {/if}>
                        {$data.groupe|default:''} {$data.nom|default:''} {$data.prenom|default:''}</td>
                    <td><a title="{$data.mail}" href="mailto:{$data.mail}">{$data.formule} {$data.nomParent} {$data.prenomParent}</a></td>
                    <td class="td_{$idRV}">
                        {if ($data.matricule == Null)}
                        <button type="button" data-idrv="{$idRV}" class="btn btn-default btn-xs dispo pull-right">
                            <i class="fa {if $data.dispo == 0}fa-toggle-on switchOff{else}fa-toggle-off switchOn{/if}"></i>
                        </button>
                        {/if}
                    </td>
                    <td>
                        {if $data.matricule != ''}
                        <button
                            type="button"
                            class="btn btn-danger btn-xs unlink"
                            data-idrv="{$idRV}"
                            data-eleve="{$data.prenom} {$data.nom}"
                            data-matricule="{$data.matricule}"
                            data-mail="{$data.mail}"
                            title="Annuler ce RV">
                                <i class="fa fa-trash"></i>
                        </button>
                        {else} &nbsp; {/if}
                    </td>

                    <td>
                        <input type="radio" name="idRV[]" class="idRV" value="{$idRV}"{if ($data.dispo == 0)} disabled{/if}>
                    </td>
                    <td>
                        <button
                            type="button"
                            class="btn btn-success btn-xs lien"
                            data-idrv="{$idRV}"
                            style="display: none">
                            <i class="fa fa-arrow-left"></i>
                        </button>
                    </td>

                </tr>
                {/foreach}
            </tbody>
        </table>

     </div>

    <div class="panel-footer">
        <strong class="indisponible pull-right">Lignes grisées = indisponibles</strong>
        <div class="clearfix"></div>
    </div>

</div>

<script type="text/javascript">

    var dispo = 'Disponible/indisponible';

    $(document).ajaxStart(function(){
        $('body').addClass("wait");
    }).ajaxComplete(function(){
        $('body').removeClass("wait");
    });

    $(document).ready(function() {

        $(".dispo").click(function() {
            var idRV = $(this).data('idrv');
            var idRP = $('#idRP').val();
            var btnIcon = $(this).find('i');
            // cacher un éventuel bouton d'attribution du RV
            $(this).closest('tr').find('.lien').hide();
            if (btnIcon.hasClass('fa-toggle-on'))
                $(this).find('i').removeClass('fa-toggle-on switchOff').addClass('fa-toggle-off switchOn');
            else
                $(this).find('i').removeClass('fa-toggle-off switchOn').addClass('fa-toggle-on switchOff');
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

    $('.idRV').click(function(){
        $('.lien').hide();
        $(this).parent().next('td').find('button').show();
    })

    })
</script>
