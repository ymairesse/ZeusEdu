{function name=arborescence level=0}

<ul class="" data-level="{$level}">

    {foreach $data as $post}
        {assign var=postId value=$post.postId}
        {if isset($post.children)}
            <li>
                <a href="javascript:void(0)"
                    data-postid="{$post.postId}"
                    data-idcategorie="{$post.idCategorie}"
                    data-idsujet="{$post.idSujet}"
                    data-content="{$post.post|mb_substr:0:200|cat:'...'}"
                    data-title="{$post.user}"
                    class="pop">
                {$post.user} <span class="pull-right">{$post.ladate} - {$post.heure}</span>
                </a>

                {arborescence data=$post.children level=$level+1}

            </li>
        {else}
            <li>
                <a href="javascript:void(0)"
                    data-postId="{$post.postId}"
                    data-idcategorie="{$post.idCategorie}"
                    data-idsujet="{$post.idSujet}"
                    data-content="{$post.post|mb_substr:0:200|cat:'...'}"
                    class="pop"
                    data-title="{$post.user}">
                    {$post.user} <span class="pull-right">{$post.ladate} - {$post.heure}</span>
                </a>
            </li>
        {/if}
    {/foreach}
</ul>

{/function}

<ul class="treeviewPost">

    <li>
        <a class="active pop"
            href="javascript:void(0)"
            data-postId="0"
            data-idcategorie="{$idCategorie}"
            data-idsujet="{$idSujet}"
            data-content="Cliquez pour créer un post pour <strong>{$sujet.sujet}</strong>">
        Racine
        </a>
    </li>

    {arborescence data=$listePosts}

</ul>

<script type="text/javascript" src="js/treeview.js"></script>

<script type="text/javascript">

    $(document).ready(function(){

        $('.pop').popover({
            container: 'body',
            html: true,
            placement: top,
            trigger: 'hover'
        });

        $('.treeviewPost').treeview();
    })

</script>
