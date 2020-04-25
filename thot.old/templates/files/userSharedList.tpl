<ul class="list-unstyled">

{foreach from=$sharedFiles key=fileId item=fileShare}

    <li data-fileid="{$fileId}" data-path="{$fileShare.path}" data-filename="{$fileShare.fileName}" class="memoFile">
        {if $fileShare.fileName == ''}<i class="fa fa-folder-open"></i>{else}<i class="fa fa-files-o"></i> {/if}{$fileShare.path} {$fileShare.fileName}

        {assign var=shares value=$fileShare.share}
        <ul class="shareList">
        {foreach from=$shares key=shareId item=oneShare}

            {if $oneShare.type == 'ecole'}
            <li data-shareid="{$oneShare.shareId}" title="{$onShare.commentaire}" class="liMemoShared">
                <span class="memoSharedFile">{$oneShare.commentaire} [Tous les élèves]</span>
                <button type="button" class="btn btn-danger btn-xs pull-right btnEndShare" data-shareid="{$oneShare.shareId}"><i class="fa fa-eye-slash"></i></button>
            </li>
            {elseif $oneShare.type == 'niveau'}
            <li data-shareid="{$oneShare.shareId}" title="{$oneShare.commentaire}" class="liMemoShared">
                <span class="memoSharedFile">[Tous les élèves de {$oneShare.destinataire}e année]</span>
                <button type="button" class="btn btn-danger btn-xs pull-right btnEndShare" data-shareid="{$oneShare.shareId}"><i class="fa fa-eye-slash"></i></button>
            </li>

            {elseif $oneShare.type == 'classe'}
                {if $oneShare.destinataire == 'all'}
                <li data-shareid="{$oneShare.shareId}" title="{$oneShare.commentaire}">
                    <span class="memoSharedFile">[Tous les élèves de {$oneShare.groupe}]</span>
                    <button type="button" class="btn btn-danger btn-xs pull-right btnEndShare" data-shareid="{$oneShare.shareId}"><i class="fa fa-eye-slash"></i></button>
                </li>
                {else}
                <li data-shareid="{$oneShare.shareId}" title="{$oneShare.commentaire}">
                    <span class="memoSharedFile">[{$oneShare.nomEleve} {$oneShare.classe}]</span>
                    <button type="button" class="btn btn-danger btn-xs pull-right btnEndShare" data-shareid="{$oneShare.shareId}"><i class="fa fa-eye-slash"></i></button>
                </li>
                {/if}

            {elseif $oneShare.type == 'cours'}
                {if $oneShare.destinataire == 'all'}
                <li data-shareid="{$oneShare.shareId}" data-coursgrp="{$oneShare.groupe}" title="{$oneShare.commentaire}">
                    <span class="memoSharedFile">[{$oneShare.libelle} {$oneShare.nomCours}]</span>
                    <button type="button" class="btn btn-danger btn-xs pull-right btnEndShare" data-shareid="{$oneShare.shareId}"><i class="fa fa-eye-slash"></i></button>
                </li>
                {else}
                <li data-shareid="{$oneShare.shareId}" data-coursgrp="{$oneShare.groupe}" title="{$oneShare.commentaire}">
                    <span class="memoSharedFile">[{$oneShare.nomEleve} {$oneShare.libelle} {$oneShare.nomCours}]</span>
                    <button type="button" class="btn btn-danger btn-xs pull-right btnEndShare" data-shareid="{$oneShare.shareId}"><i class="fa fa-eye-slash"></i></button>
                </li>
                {/if}


            {elseif $oneShare.type == 'prof'}
                {if $oneShare.destinataire == 'all'}
                <li data-shareid="{$oneShare.shareId}" title="{$oneShare.commentaire}">
                    <span class="memoSharedFile">[Tous les collègues]</span>
                    <button type="button" class="btn btn-danger btn-xs pull-right btnEndShare" data-shareid="{$oneShare.shareId}"><i class="fa fa-eye-slash"></i></button>
                </li>
                {else}
                <li data-shareid="{$oneShare.shareId}" title="{$oneShare.commentaire}">
                    <span class="memoSharedFile">[{$oneShare.nomProf}]</span>
                    <button type="button" class="btn btn-danger btn-xs pull-right btnEndShare" data-shareid="{$oneShare.shareId}"><i class="fa fa-eye-slash"></i></button>
                </li>
                {/if}

            {/if}


        {/foreach}
        </ul>
    </li>
{/foreach}

</ul>
