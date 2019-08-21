<div class="file-container">

    {foreach from=$dir item=file}

    {if $file.type == 'file'}
        {* <div class="file">
            <span class="carette"></span>
            <div class="ico x-{$file.ext}">
                <div class="filename" data-filename="{$file.fileName}" data-type="{$file.type}">
                    <span>{$file.fileName}<br>{$file.size}</spane>
                </div>
            </div>
        </div> *}

        <div class="file" title="nom:freeplaneApplications.pdf
taille:166.3K
modifié : 19/07/2019 17:42:07" data-size="170326">
	<div class="item-select"><div class="item-check"></div></div>
	<div class="item-menu"><div class="cert"></div></div>
	<div class="ico" filetype="pdf"><i class="x-pdf"></i></div>

	<div class="filename">
		<span class="title db-click-rename" title="Double-cliquez sur le Renaming">
			{$file.fileName}<br>{$file.size}
		</span>
	</div>
</div>

    {else}
        <div class="directory">
            <a title="{$file.fileName}" href="javascript:void(0)" class="directory" data-dir="{$file.fileName}">{$file.fileName}</a>
        </div>
    {/if}

     {/foreach}

</div>
