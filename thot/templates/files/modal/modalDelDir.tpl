<div class="modal fade" id="modalDelDir" tabindex="-1" role="dialog" aria-labelledby="titleModalDelDir" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h4 class="modal-title" id="titleModalDelDir">Effacement d'un dossier</h4>
            </div>
            <div class="modal-body">
                <div class="alert alert-danger">
                    <i class="fa fa-warning fa-2x pull-right text-danger"></i>
                    <p>Veuillez confirmer la suppression définititve du dossier
                        <br><strong id="delRep" data-filename="{$fileName}">{$fileName}</strong>
                        <br> qui fait partie du dossier
                        <br>
                        <strong id="rootRep" data-arborescence="{$arborescence}">{$arborescence}</strong></p>

                        <p><strong><i class="fa fa-warning fa-2x text-danger"></i> Attention! Tous les partages du dossier et des documents qu'il contient seront supprimés.</strong></p>
                </div>
                <div id="listFiles">
                    {if $listFiles|count > 0}
                    <div class="alert alert-warning">
                        <p>Ce dossier contient les fichiers suivants:</p>
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
                    {else}
                        <p>Ce dossier est vide</p>
                    {/if}
                </div>

            </div>
            <div class="modal-footer">
                <div class="btn-group pull-right">
                    <button type="button" class="btn btn-default" data-dismiss="modal">Annuler</button>
                    <button type="button" class="btn btn-primary" id="btnConfirmDelDir">Effacer ce dossier</button>
                </div>
            </div>
        </div>
    </div>
</div>
