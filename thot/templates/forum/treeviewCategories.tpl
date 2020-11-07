{function name=repertoire level=0}

<ul class="{if $level > 0}hidden{/if}" data-level="{$level}">

    {foreach $data as $categorie}
        {assign var=idCategorie value=$categorie.idCategorie}
        {if isset($categorie.children)}
            <li class="{$categorie.userStatus}" data-idcategorie="{$categorie.idCategorie}">
                <a href="javascript:void(0)"
                    data-idcategorie="{$categorie.idCategorie}"
                    data-userstatus="{$categorie.userStatus}">
                {$categorie.libelle}
                </a>

                {repertoire data=$categorie.children level=$level+1}

            </li>
        {else}
            <li class="{$categorie.userStatus}" data-idcategorie="{$categorie.idCategorie}">
                <a href="javascript:void(0)"
                    data-idcategorie="{$categorie.idCategorie}"
                    data-userstatus="{$categorie.userStatus}">
                {$categorie.libelle}
                </a>
            </li>
        {/if}
    {/foreach}
</ul>

{/function}

<ul class="treeview">

    {repertoire data=$listeCategories}

</ul>

<script type="text/javascript" src="js/treeview.js"></script>

<script type="text/javascript">

    $(document).ready(function(){

        $('.treeview').treeview();

    })

</script>
