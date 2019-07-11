{foreach $listeArchives as $wtf => $anneeScolaire}
<div class="input-group">
    <input type="text" class="form-control" value="{$anneeScolaire}" readonly>
    <span class="input-group-addon">
        <button class="btn btn-danger btn-delArchive"
            data-anscol="{$anneeScolaire}"
            type="button"
            title="Effacer définitivement cette archive">
            <i class="fa fa-times"></i>
        </button>
    </span>
</div>
{/foreach}
