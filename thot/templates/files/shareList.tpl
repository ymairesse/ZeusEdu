<ul class='list-unstyled'>
    {foreach from=$shareList item=share}
    <li>
        {if $share.type == 'ecole'}
        <div class="shared {$share.type} pop" title="{$share.commentaire}">
            <span
                class="shareEdit"
                title="Édition"
                data-fileId="{$share.fileId}"
                data-shareid = "{$share.shareId}"
                data-commentaire="{$share.commentaire}">
                <i class="fa fa-edit fa-2x"></i>
            </span>
            &nbsp;|&nbsp;
            Tous les élèves de l'école
            <span
                class="pull-right unShare"
                data-fileId="{$share.fileId}"
                data-shareid = "{$share.shareId}"
                data-libelle="Tous les élèves"
                title="Arrêter le partage">&nbsp;|&nbsp;
            <i class="fa fa-eye-slash fa-lg text-danger"></i>
            </span>
        </div>
            {elseif $share.type == 'niveau'}
            <div class="shared {$share.type} pop" title="{$share.commentaire}">
                <span
                    class="shareEdit"
                    title="Édition"
                    data-fileId="{$share.fileId}"
                    data-shareid = "{$share.shareId}"
                    data-commentaire="{$share.commentaire}">
                    <i class="fa fa-edit fa-2x"></i>
                </span>
                &nbsp;|&nbsp;
                Tous les élèves de {$share.destinataire}e
                <span
                    class="pull-right unShare"
                    data-fileId="{$share.fileId}"
                    data-shareid = "{$share.shareId}"
                    data-libelle="Tous les élèves de {$share.destinataire}e"
                    title="Arrêter le partage">&nbsp;|&nbsp;
                <i class="fa fa-eye-slash fa-lg text-danger"></i>
                </span>
            </div>
            {elseif $share.type == 'classe'}
                {if $share.destinataire == 'all'}
                    <div class="shared {$share.type} pop" title="{$share.commentaire}">
                        <span
                            class="shareEdit"
                            title="Édition"
                            data-fileId="{$share.fileId}"
                            data-shareid = "{$share.shareId}"
                            data-commentaire="{$share.commentaire}">
                            <i class="fa fa-edit fa-2x"></i>
                        </span>
                        &nbsp;|&nbsp;
                        Tous les élèves de {$share.groupe}
                        <span
                            class="pull-right unShare"
                            data-fileId="{$share.fileId}"
                            data-shareid = "{$share.shareId}"
                            data-libelle="Tous les élèves de {$share.groupe}"
                            title="Arrêter le partage">&nbsp;|&nbsp;
                        <i class="fa fa-eye-slash fa-lg text-danger"></i>
                        </span>
                </div>
                {else}
                    <div class="shared {$share.type} pop" title="{$share.commentaire}">
                        <span
                            class="shareEdit"
                            title="Édition"
                            data-fileId="{$share.fileId}"
                            data-shareid = "{$share.shareId}"
                            data-commentaire="{$share.commentaire}">
                            <i class="fa fa-edit fa-2x"></i>
                        </span>
                        &nbsp;|&nbsp;
                        {$share.nomEleve} {$share.prenomEleve} de {$share.classe}
                        <span
                            class="pull-right unShare"
                            data-fileId="{$share.fileId}"
                            data-shareid = "{$share.shareId}"
                            data-libelle="{$share.nomEleve|escape:'htmlall'} {$share.prenomEleve|escape:'htmlall'} de {$share.classe}"
                            title="Arrêter le partage">&nbsp;|&nbsp;
                        <i class="fa fa-eye-slash fa-lg text-danger"></i>
                        </span>
                </div>
                {/if}
            {elseif $share.type == 'cours'}
                {if $share.destinataire == 'all'}
                    <div class="shared {$share.type} pop" title="{$share.commentaire}">
                        <span
                            class="shareEdit"
                            title="Édition"
                            data-fileId="{$share.fileId}"
                            data-shareid = "{$share.shareId}"
                            data-commentaire="{$share.commentaire}">
                            <i class="fa fa-edit fa-2x"></i>
                        </span>
                        &nbsp;|&nbsp;
                        Tous les élèves de {$share.groupe}
                        <span
                            class="pull-right unShare"
                            data-fileId="{$share.fileId}"
                            data-shareid = "{$share.shareId}"
                            data-libelle="Tous les élèves du cours {$share.groupe}"
                            title="Arrêter le partage">&nbsp;|&nbsp;
                        <i class="fa fa-eye-slash fa-lg text-danger"></i>
                        </span>
                </div>
                {else}
                    <div class="shared {$share.type} pop" title="{$share.commentaire}" title="{$share.groupe}">
                        <span
                            class="shareEdit"
                            title="Édition"
                            data-fileId="{$share.fileId}"
                            data-shareid = "{$share.shareId}"
                            data-commentaire="{$share.commentaire}">
                            <i class="fa fa-edit fa-2x"></i>
                        </span>
                        &nbsp;|&nbsp;
                        {$share.nomEleve} {$share.prenomEleve} de
                        {if $share.nomCours != ''}
                            {$share.nomCours|escape:'htmlall'}
                            {else}
                            {$share.libelle|escape:'htmlall'}
                        {/if}
                        <span
                            class="pull-right unShare"
                            data-fileId="{$share.fileId}"
                            data-shareid = "{$share.shareId}"
                            data-libelle="{$share.nomEleve|escape:'htmlall'} {$share.prenomEleve|escape:'htmlall'} du cours  {$share.libelle|escape:'htmlall'}"
                            title="Arrêter le partage">&nbsp;|&nbsp;
                        <i class="fa fa-eye-slash fa-lg text-danger"></i>
                        </span>
                </div>
                {/if}
            {elseif $share.type == 'prof'}
                {if $share.destinataire == 'all'}
                    <div class="shared {$share.type} pop" title="{$share.commentaire}">
                        <span
                            class="shareEdit"
                            title="Édition"
                            data-fileId="{$share.fileId}"
                            data-shareid = "{$share.shareId}"
                            data-commentaire="{$share.commentaire}">
                            <i class="fa fa-edit fa-2x"></i>
                        </span>
                        &nbsp;|&nbsp;
                        Tous les collègues
                        <span
                            class="pull-right unShare"
                            data-fileId="{$share.fileId}"
                            data-shareid = "{$share.shareId}"
                            data-libelle="Tous les collègues"
                            title="Arrêter le partage">&nbsp;|&nbsp;
                        <i class="fa fa-eye-slash fa-lg text-danger"></i>
                        </span>
                </div>
                {else}
                    <div class="shared {$share.type} pop" title="{$share.commentaire}">
                        <span
                            class="shareEdit"
                            title="Édition"
                            data-fileId="{$share.fileId}"
                            data-shareid = "{$share.shareId}"
                            data-commentaire="{$share.commentaire}">
                            <i class="fa fa-edit fa-2x"></i>
                        </span>
                        &nbsp;|&nbsp;
                        Collègue: {$share.prenomProf} {$share.nomProf}
                        <span
                            class="pull-right unShare"
                            data-fileId="{$share.fileId}"
                            data-shareid = "{$share.shareId}"
                            data-libelle="{$share.prenomProf|escape:'htmlall'} {$share.nomProf|escape:'htmlall'}"
                            title="Arrêter le partage">&nbsp;|&nbsp;
                        <i class="fa fa-eye-slash fa-lg text-danger"></i>
                        </span>
                </div>
                {/if}
            {/if}
    </li>

    {/foreach}
</ul>
