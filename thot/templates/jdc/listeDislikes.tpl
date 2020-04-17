{if $listeDislikes|@count != 0}
    <ul class="list-unstyled">
        {foreach from=$listeDislikes key=matricule item=data name=boucle}
            <li>{$smarty.foreach.boucle.iteration}. {$data.prenom} {$data.nom}: {$data.commentaire}</li>
        {/foreach}
    </ul>

{else}
    Aucun problème signalé
{/if}
