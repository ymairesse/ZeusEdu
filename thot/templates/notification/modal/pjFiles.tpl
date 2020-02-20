{if isset($pjFiles) && ($pjFiles|@count > 0)}

    <p class="alert-danger"><i class="fa fa-warning"></i> Cette annonce est liée à {$pjFiles|current|@count} document(s) partagé(s).<br>
    Si vous ne souhaitez pas poursuivre ces partages, veuillez supprimer les PJ ci-dessous. <strong>Vos documents ne seront pas supprimés, seulement les partages.</strong></p>
    <form id="listePJ" action="">
        <ul class="list-unstyled">

        {foreach from=$pjFiles key=notifId item=files}
            {foreach from=$files key=shareId item=file}
            <li>
                <a href="javascript:void(0)"
                    class="delPJ"
                    data-notifId="{$notifId}"
                    data-shareid="{$shareId}"
                    data-path="{$file.path}"
                    data-filename="{$file.fileName}">
                        <i class="fa fa-times text-danger" title="Supprimer"></i>
                </a>
                {$file.path}{$file.fileName}
                <input name="shareId[]" value="{$shareId}" type="hidden">
            </li>
            {/foreach}
        {/foreach}

        </ul>
    </form>
{/if}
