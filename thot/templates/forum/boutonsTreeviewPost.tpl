<div class="postForum"
    id="post_{$postId}"
    data-date="{$post.ladate}"
    data-postid="{$postId}"
    data-toggle="popover"
    data-content="{$post.user}"
    data-container="body"
    data-placement="top">
    
    <button type="button" class="btn btn-primary btn-xs initiales" title="{$post.user}">
        {if $post.userStatus == 'prof'}<i class="fa fa-graduation-cap"></i>
        {else}<i class="fa fa-user"></i>
        {/if}
        {$post.initiales}
    </button>
    
    {if $post.post != ''}
        {$post.post}
    {else}
        <span class='supprime'>Cette contribution a été supprimée</span>
    {/if}
</div>

<div class="repondre" data-postid="{$post.postId}">
    <button type="button"
        style="color:#11036f"
        class="btn btn-success btn-xs btn-forum btn-repondre"
        data-postid="{$post.postId}"
        data-idcategorie="{$post.idCategorie}"
        data-idsujet="{$post.idSujet}"
        {if $post.post == ''}disabled{/if}>
        <i class="fa fa-arrow-up"></i> Répondre à {$post.user}
        </button>

        {* Si l'utilistaeur courant est l'auteur du post *}
        {if ($acronyme == $post.auteur)}
            <button type="button"
                style="color:black"
                class="btn btn-warning btn-xs btn-forum btn-edit"
                data-postid="{$post.postId}"
                data-idcategorie="{$post.idCategorie}"
                data-idsujet="{$post.idSujet}"
                {if $post.post == ''}disabled{/if}>
                Modifier <i class="fa fa-arrow-up"></i>
            </button>
            <button type="button"
                class="btn btn-danger btn-xs btn-forum btn-delPost"
                data-postid="{$post.postId}"
                data-idcategorie="{$post.idCategorie}"
                data-idsujet="{$post.idSujet}"
                {if $post.post == ''}disabled{/if}>
            <i class="fa fa-times"></i>
            </button>

        {* Si l'utilisateur courant est le propriétaire du post *}
        {elseif ($acronyme == $post.acronyme)}
            <button type="button"
                class="btn btn-warning btn-xs btn-forum btn-edit"
                data-postid="{$post.postId}"
                data-idcategorie="{$post.idCategorie}"
                data-idsujet="{$post.idSujet}"
                {if $post.post == ''}disabled{/if}>
                <i class="fa fa-mortar-board"></i> Modifier <i class="fa fa-arrow-up"></i>
            </button>
            <button type="button"
                class="btn btn-danger btn-xs btn-forum btn-delPost"
                data-postid="{$post.postId}"
                data-idcategorie="{$post.idCategorie}"
                data-idsujet="{$post.idSujet}"
                {if $post.post == ''}disabled{/if}>
            <i class="fa fa-flash"></i>
            </button>
        {/if}
     <span class="pull-right">{$post.ladate} - {$post.heure}</span>
</div>
