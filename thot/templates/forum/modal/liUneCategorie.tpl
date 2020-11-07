{if $noeud == "true"}
    <li class="{$userStatus}" data-idcategorie="{$idCategorie}" style="">
        <a href="javascript:void(0)" data-idcategorie="{$idCategorie}" data-userstatus="{$userStatus}">
            {$libelle}
        </a>
    </li>
{else}
    <ul class="">
        <li class="{$userStatus}" data-idcategorie="{$idCategorie}" style="">
            <a href="javascript:void(0)" data-idcategorie="{$idCategorie}" data-userstatus="{$userStatus}">
                {$libelle}
            </a>
        </li>
    </ul>
{/if}
