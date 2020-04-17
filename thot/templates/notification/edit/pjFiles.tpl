{if isset($pjFiles)}

    {foreach from=$pjFiles key=notifId item=files}
        {foreach from=$files key=shareId item=file}
        <li>
            <a href="javascript:void(0)"
                class="delPJ"
                data-path="{$file.path}"
                data-filename="{$file.fileName}">
                    <i class="fa fa-times text-danger" title="Supprimer"></i>
            </a>
            {$file.path}{$file.fileName}
            <input name="files[]" value="{$file.path}|//|{$file.fileName}" type="hidden">
        </li>
        {/foreach}
    {/foreach}

{/if}
