{* <pre>
{$dir|print_r}
</pre> *}
<link href="css/filetree.css" type="text/css" rel="stylesheet">

<div class="panel panel-default">

  <div class="panel-body" style="height:30em; overflow: auto;">

      {if $dir|@count > 0}

      {include file="files/filesVueDir.tpl"}

      {else}
        <p class="avertissement">Dossier vide</p>
      {/if}

  </div>

  <div class="panel-footer pull-right">

      {include file="files/helpFiles.tpl"}

  </div>

</div>
