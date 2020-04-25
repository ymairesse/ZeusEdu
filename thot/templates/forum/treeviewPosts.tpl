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

<script type="text/javascript" src="js/treeview.js"></script>

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
