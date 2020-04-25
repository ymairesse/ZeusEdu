<div class="panel panel-default">
    <div class="panel-heading">
        Sélection
    </div>
    <div class="panel-body">
        {foreach from=$listeTypes key=type item=data}
            <button type="button" class="btn btn-primary btn-block btn-type" data-type="{$type}">
                {$data.texte} <span class="badge pull-right">{$listeNotifications.$type|@count|default:0}</span>
            </button>
        {/foreach}
    </div>
    <div class="panel-footer">
        <img src="../images/ajax-loader.gif" alt="wait" class="hidden" id="ajaxLoader">
    </div>
</div>
