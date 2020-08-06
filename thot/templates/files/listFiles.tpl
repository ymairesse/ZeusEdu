<div class="alert alert-warning">
    <p>Attention, ce dossier contient les fichiers suivants:</p>
    <ul class="list-unstyled" style="height:5em; overflow: auto">
		{if isset($listFiles)}
			{foreach from=$listFiles item=file}
				<li>
				{if $file.type == 'dir'}<i class="fa fa-folder-open-o"></i>{else}<i class="fa fa-file-o"></i>{/if}
				{$file.fileName} {$file.size}
				</li>
			{/foreach}
        {/if}
    </ul>
</div>
