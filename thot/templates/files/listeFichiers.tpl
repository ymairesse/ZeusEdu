<style>

.grille {
    	margin: 0 2px;
    	text-align: center;
    	text-decoration: none;
    	display: inline-block;
    	transition: all 0.3s;
    }

.grille:after {
    content: '\f00a';
	font-family: FontAwesome;
	padding: 6px;
}

.liste:after {
    content: '\f03a';
    font-family: FontAwesome;
    padding: 6px;
}

</style>

<div class="panel panel-default">

    <div class="panel-heading">

        <div class="row">

            <div class="col-md-7 col-xs-5">
                <button type="button"
                    class="btn btn-danger btn-xs disabled"
                    id="btn-del"
                    data-filename="" data-dirorfile="">
                    <i class="fa fa-times"></i> Effacer
                </button>
            </div>

            <div class="col-md-2 col-xs-3">
                <button type="button"
                    title="Changer le mode de visualisation"
                    class="btn btn-primary btn-xs"
                    id="btn-grilleOrListe">
                    <span class="{$viewMode}"></span>
                </button>
            </div>

            <div class="col-md-3 col-xs-4">
                <div class="btn-group pull-right">
                    <button type="button" class="btn btn-success btn-xs" id="btn-mkdir" title="Créer un dossier"><i class="fa fa-plus"></i> <i class="fa fa-folder-open-o"></i></button>
                    <button type="button" class="btn btn-info btn-xs" id="btn-upload" title="Ajouter un document"><i class="fa fa-plus"></i> <i class="fa fa-file-o"></i></button>
                </div>
            </div>

        </div>

    </div>
    <div class="panel-body">

        <div style="max-height:30em; overflow: auto;">

                {if $dir|@count > 0}
                    {if $viewMode == 'grille'}
                        {include file="files/listeFichiersIcones.tpl"}
                    {else}
                        {include file="files/listeFichiersListe.tpl"}
                    {/if}
                {else}
                    <p class="avertissement">Dossier vide</p>
                {/if}

        </div>

    </div>

    <div class="panel-footer pull-right">
        <p><button type="button" class="btn btn-success btn-xs" title="Créer un dossier"><i class="fa fa-plus"></i> <i class="fa fa-folder-open-o"></i></button> Activer ce bouton pour créer un sous-dossier dans votre répertoire de fichiers. On peut créer,
            sans limite, des sous-dossiers dans un sous-dossier.</p>
        <p><button type="button" class="btn btn-info btn-xs" title="Ajouter un document"><i class="fa fa-plus"></i> <i class="fa fa-file-o"></i></button> Activer ce bouton pour déposer des nouveaux documents dans votre répertoire de fichiers. Chaque
            nouveau document est déposé dans le sous-dossier actif.</p>
    </div>

</div>
