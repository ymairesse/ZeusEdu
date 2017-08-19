{if $shareList|count != 0}
<div class="alert alert-warning">
    <h4>Ce document est partagé avec</h4>
    <table class='table table-condensed'>
        {foreach from=$shareList key=shareId item=share}
        <tr>
            {if $share.type == 'ecole'}
            <td class="shared {$share.type}">
                Tous les élèves de l'école
            </td>
            {elseif $share.type == 'niveau'}
            <td class="shared {$share.type}">
                Tous les élèves de {$share.destinataire}e
            </td>
            {elseif $share.type == 'classe'} {if $share.destinataire == 'all'}
            <td class="shared {$share.type}">
                Tous les élèves de {$share.groupe}
            </td>
            {else}
            <td class="shared {$share.type}">
                {$share.nomEleve} {$share.prenomEleve} de {$share.classe}
            </td>
            {/if} {elseif $share.type == 'cours'} {if $share.destinataire == 'all'}
            <td class="shared {$share.type}">
                Tous les élèves de {$share.groupe}
            </td>
            {else}
            <td class="shared {$share.type}">
                {$share.nomEleve} {$share.prenomEleve} de {if $share.nomCours != ''} {$share.nomCours|escape:'htmlall'} {else} {$share.trbelle|escape:'htmlall'} {/if}
            </td>
            {/if} {elseif $share.type == 'prof'} {if $share.destinataire == 'all'}
            <td class="shared {$share.type}">
                Tous les collègues
            </td>
            {else}
            <td class="shared {$share.type}">
                Collègue: {$share.prenomProf} {$share.nomProf}
            </td>
            {/if} {/if}
        </tr>

        {/foreach}
    </table>
</div>
{{/if}}
