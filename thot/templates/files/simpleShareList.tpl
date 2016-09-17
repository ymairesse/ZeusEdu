{if $shareList|count != 0}
<div class="alert alert-warning">
    <h4>Ce document est partagé avec</h4>
    <ul class='list-unstyled'>
        {foreach from=$shareList key=shareId item=share}
        <li>
            {if $share.type == 'ecole'}
            <div class="shared {$share.type}">
                Tous les élèves de l'école
            </div>
            {elseif $share.type == 'niveau'}
            <div class="shared {$share.type}">
                Tous les élèves de {$share.destinataire}e
            </div>
            {elseif $share.type == 'classe'} {if $share.destinataire == 'all'}
            <div class="shared {$share.type}">
                Tous les élèves de {$share.groupe}
            </div>
            {else}
            <div class="shared {$share.type}">
                {$share.nomEleve} {$share.prenomEleve} de {$share.classe}
            </div>
            {/if} {elseif $share.type == 'cours'} {if $share.destinataire == 'all'}
            <div class="shared {$share.type}">
                Tous les élèves de {$share.groupe}
            </div>
            {else}
            <div class="shared {$share.type}">
                {$share.nomEleve} {$share.prenomEleve} de {if $share.nomCours != ''} {$share.nomCours|escape:'htmlall'} {else} {$share.libelle|escape:'htmlall'} {/if}
            </div>
            {/if} {elseif $share.type == 'prof'} {if $share.destinataire == 'all'}
            <div class="shared {$share.type}">
                Tous les collègues
            </div>
            {else}
            <div class="shared {$share.type}">
                Collègue: {$share.prenomProf} {$share.nomProf}
            </div>
            {/if} {/if}
        </li>

        {/foreach}
    </ul>
</div>
{{/if}}
