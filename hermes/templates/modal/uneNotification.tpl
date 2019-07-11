<div class="form-group col-md-4 col-sm-12 hermesEntete">
    <label class="col-sm-2">De</label>
    <input class="col-sm-10" readonly value="{$notification.prenom} {$notification.nom}">
</div>

<div class="form-group col-md-8 col-sm-12 hermesEntete">
    <label class="col-sm-2">Objet</label>
    <input class="col-sm-10" readonly value="{$notification.objet}">
</div>

<div class="form-group col-md-4 col-sm-12 hermesEntete">
    <label class="col-sm-2">Le</label>
    <input class="col-sm-10" readonly value="{$notification.date} {$notification.heure|truncate:5:''}">
</div>

<div class="col-md-8 col-sm-12">
    <ul class="listePJ">
        {foreach from=$notification.piecesJointes item=unePJ}
        <li><i class="fa fa-paperclip"></i> <a href="download.php?type=idFile&amp;notif={$notification.id}&amp;n={$unePJ.n}&amp;file={$unePJ.PJ}">{$unePJ.PJ}</a></li>
        {/foreach}
    </ul>
</div>

<div class="col-md-12 col-sm-12 hermesMessage">
    {$notification.texte}
</div>
