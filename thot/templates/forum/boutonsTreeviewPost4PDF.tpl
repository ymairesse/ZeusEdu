<div style="float:left; border: 1px solid black; padding: 3px 5px; background-color: #ccc">
    {$post.initiales}
</div>

{if $post.post != ''}
<div style="border-bottom: 1px solid black">{$post.post}</div>
{else}
<span class='supprime'>Cette contribution a été supprimée</span>
{/if}

<p style="text-align:right; font-size: 10pt;">
    {$post.ladate} - {$post.heure}
    {if $post.modifie == 1}<i class="discret">Modifié le {$post.dateModif} à {$post.heureModif}</i>{/if}
</p>
