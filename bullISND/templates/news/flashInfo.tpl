{if $userStatus == 'admin'}
    <a class="btn btn-primary pull-right" href="index.php?action=news&amp;mode=edit"><span class="glyphicon  glyphicon-envelope"></span> Ajouter une nouvelle</a>
{/if}

{if $flashInfos|@count > 0}
<h2>Dernières nouvelles</h2>

{foreach from=$flashInfos item="uneInfo"}
    <div id="flashInfo{$uneInfo.id}">
        <h3 style="clear:both">Ce {$uneInfo.date|date_format:"%d/%m/%Y"} - <span id="titre{$uneInfo.id}">{$uneInfo.titre}</span></h3>
        {if $userStatus == 'admin'}
        <a style="float:left" href="index.php?action=news&amp;mode=edit&amp;id={$uneInfo.id}" class="editInfo"><span class="glyphicon glyphicon glyphicon-edit" style="color: green; font-size: 200%"></span></a>
        <a href="javascript:void()" style="float:right" id="{$uneInfo.id}" class="delInfo"><span class="glyphicon glyphicon glyphicon-remove" style="color:red; font-size:200%"></span></a>
        {/if}
        <div class="flashInfo"><p>{$uneInfo.texte}</p></div>
    </div>  <!-- flashInfo id -->
{/foreach}

{/if}  {* flashinfo count > 0 *}
