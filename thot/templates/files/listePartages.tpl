<div class="panel panel-default">

    <div class="panel-heading">
        Gestion des partages
    </div>

    <div class="panel-body">
        <p class="notice">Cliquer dans le tableau à gauche pour voir les partages des dossiers et des fichiers</p>

        <div id="listePartages" style="height: 25em; overflow: auto;">

        {if isset($listePartages)}
            <p class="active">
                {if $dirOrFile == 'dir'}<i class="fa fa-folder-open-o"></i>
                    {else}
                    <i class="fa fa-file-o"></i>
                {/if}
                <strong id="sharedFileName" data-filename="{$fileName}" title="{$fileName}">
                    {$fileName|truncate:40:'...'}
                </strong>

                <button type="button"
                    class="btn btn-xs pull-right btn-primary {$shareEnabled|default:'disabled'}"
                    id="btn-share"
                    data-filename="{$fileName}"
                    data-dirorfile="{$dirOrFile}"
                    data-arborescence="{$arborescence}"
                    title="Nouveau partage">
                    <i class="fa fa-plus"></i> <i class="fa fa-share-alt"></i>
                </button>
            </p>

            {* tableau des partages pour ce fichier $fileName *}
            <table class="table table-condensed table-striped">

                {foreach from=$listePartages key=shareId item=share}
                <tr data-shareid="{$share.shareId}">

                    <td class="shared share_{$share.type}" style="width:2em;">
                        <button type="button"
                            class="btn btn-success btn-xs shareEdit"
                            title="Édition"
                            data-shareid = "{$share.shareId}">
                            <i class="fa fa-edit"></i>
                        </button>
                    </td>
                    <td data-shareid='{$share.shareId}'>
                        {if $share.type == 'eleves'}
                            <i class="fa fa-user"></i>
                            {$share.prenomEleve} {$share.nomEleve} [{$share.classe}]
                        {elseif $share.type == 'ecole'}
                            <i class="fa fa-university"></i>
                            Tous les élèves
                        {elseif $share.type == 'niveau'}
                            <i class="fa fa-long-arrow-right "></i>
                            {$share.destinataire}e année
                        {elseif $share.type == 'cours'}
                            <i class="fa fa-files-o"></i>
                            Élèves qui suivent {$share.groupe}
                        {elseif $share.type == 'coursGrp'}
                            <i class="fa fa-book"></i>
                            Élèves du cours {$share.groupe} - {$share.nomCours|default:'cours sans nom'}
                        {elseif $share.type == 'classes'}
                            <i class="fa fa-users"></i>
                            Élèves de {$share.groupe}
                        {elseif $share.type == 'groupeArbitraire'}
                            <i class="fa fa-star"></i>
                            Élèves de {$share.groupe}
                        {elseif $share.type == 'prof'}
                            <i class="fa fa-graduation-cap"></i>
                            {if $share.nomProf != Null}
                                {$share.prenomProf} {$share.nomProf}
                            {else}
                                Tous les collègues
                            {/if}
                        {/if}
                        &nbsp;[<span data-shareid="{$share.shareId}">{$share.commentaire}</span>]
                    </td>
                    <td style="width:2em;">
                        <button type="button"
                            class="btn btn-danger btn-xs unShare"
                            data-fileId="{$share.fileId}"
                            data-shareid = "{$share.shareId}"
                            data-libelle="Tous les élèves"
                            title="Arrêter le partage">
                        <i class="fa fa-share-alt"></i>
                    </button>
                    </td>
                </tr>

                {/foreach}
            </table>

        {/if}
        
        </div>
    </div>

    <div class="panel-footer">
        <p><button type="button" class="btn btn-xs btn-primary" title="Nouveau partage"><i class="fa fa-plus"></i> <i class="fa fa-share-alt"></i></button> Pour partager l'élément (document ou dossier) sélectionné à gauche avec d'autres utilisateurs.<br>Dans le cas d'un partage de dossier, tous les fichiers existants dans le dossier ET TOUS CEUX QUI SERONT AJOUTÉS PAR LA SUITE deviennent accessibles aux destinataires.</p>

        <p><button type="button" class="btn btn-success btn-xs" title="Édition" ><i class="fa fa-edit"></i></button> Pour modifier le commentaire lié à un fichier ou un dossier partagé.</p>
        <p><button type="button" class="btn btn-danger btn-xs" title="Arrêter le partage"><i class="fa fa-share-alt"></i></button> Interrompre le partage du document ou du dossier. L'élément dé-partagé n'est pas effacé; <strong>il devient totalement inaccessible aux anciens bénéficiaires</strong> (même s'ils ont noté l'adresse du document).</p>
    </div>

</div>
