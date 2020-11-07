{function name=arborescence level=0}

<ul class="" data-level="{$level}">

    {foreach $data as $post}
        {assign var=postId value=$post.postId}
        {if isset($post.children)}
            <li>

                {include file="forum/boutonsTreeviewPost.tpl"}

                {arborescence data=$post.children level=$level+1}

            </li>
        {else}
            <li>

                {include file="forum/boutonsTreeviewPost.tpl"}

            </li>
        {/if}
    {/foreach}
</ul>

{/function}

<ul class="treeviewPost">
    <li>
        <a type="button"
            class="btn btn-primary pull-right btn-xs"
            href="inc/forum/printSubject.php?idCategorie={$idCategorie}&amp;idSujet={$idSujet}">
        <i class="fa fa-archive"></i> Archiver
    </a>

        <div class="repondre">
            <a class="active"
                id="racinePosts"
                href="javascript:void(0)"
                data-postId="0"
                data-idcategorie="{$idCategorie}"
                data-idsujet="{$idSujet}">
            <strong>[{$infoSujet.libelle}]</strong> {$infoSujet.sujet}
            </a>
        </div>
    </li>

    {arborescence data=$listePosts}

</ul>

<script type="text/javascript" src="js/treeviewForum.js"></script>

<style type="text/css">

.treeviewPost img.note-float-left {
        margin-right: 1em;
    }
.treeviewPost img.note-float-right {
        margin-left: 1em;
    }

</style>

<script type="text/javascript">

    $(document).ready(function(){

        $('.treeviewPost').treeview();

        $('.FB_reactions').facebookReactions({
            postUrl: 'inc/forum/saveLike.inc.php',
            defaultText: "J'aime",
            }
        );

    })

</script>
