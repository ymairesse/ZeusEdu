<form class="form-vertical" action="index.php" method="POST" id="delForm" role="form">

    <p>Date: <strong>{$rv.date}</strong> Heure: <strong>{$rv.heure}</strong></p>

    <div class="row">

        <div class="col-sm-6">

            <div class="form-group">
                <label for="nom"></label>
                <div class="form-control-static">{$rv.nom}</div>
                <p class="help-block">Nom du/de la futur-e élève</p>
            </div>

        </div>

        <div class="col-sm-6">

            <div class="form-group">
                <label for="prenom"></label>
                <div class="form-control-static">{$rv.prenom}</div>
                <p class="help-block">Prénom du/de la futur-e élève</p>
            </div>

        </div>

    </div>

    <div class="row">
        <div class="col-sm-12">

            <div class="form-group">
                <label for="email"></label>
                <div class="form-control-static">{$rv.email}</div>
                <p class="help-block">Adresse mail de contact</p>
            </div>

        </div>

    </div>

    <input type="hidden" name="action" value="gestion">
    <input type="hidden" name="mode" value="rv">
    <input type="hidden" name="etape" value="delete">
    <input type="hidden" name="id" id="id" value="{$rv.id}">
    <button type="submit" class="btn btn-danger pull-right">Supprimer</button>
    <div class="clearfix"></div>

</form>
