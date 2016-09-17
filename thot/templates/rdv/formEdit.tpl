<form class="form-vertical" action="index.php" method="POST" role="form" id="editForm">

    <p>Date: <strong>{$rv.date}</strong> Heure: <strong>{$rv.heure}</strong></p>

    <div class="row">

        <div class="col-sm-6">

            <div class="form-group">
                <label for="nom"></label>
                <input type="text" class="form-control" id="nom" name="nom" placeholder="Nom" value="{$rv.nom}">
                <p class="help-block">Nom du/de la futur-e élève</p>
            </div>

        </div>

        <div class="col-sm-6">

            <div class="form-group">
                <label for="prenom"></label>
                <input type="text" class="form-control" id="prenom" name="prenom" placeholder="Prénom" value="{$rv.prenom}">
                <p class="help-block">Prénom du/de la futur-e élève</p>
            </div>

        </div>

    </div>

    <div class="row">
        <div class="col-sm-6">

            <div class="form-group">
                <label for="email"></label>
                <input type="text" class="form-control" id="email" name="email" placeholder="Adresse de courriel" value="{$rv.email}">
                <p class="help-block">Adresse mail de contact</p>
            </div>

        </div>

        <div class="col-sm-6">

            <div class="form-group">
                <label class="radio-inline">
                  <input type="checkbox" name="confirme" value="{$rv.confirme}" {if $rv.confirme == 1}checked{/if}> Confirmation du RV
                </label>
            </div>

        </div>

    </div>

    <input type="hidden" name="action" value="gestion">
    <input type="hidden" name="mode" value="rv">
    <input type="hidden" name="etape" value="save">
    <input type="hidden" name="id" id="id" value="{$rv.id}">
    <div class="btn-group pull-right">
        <button type="reset" class="btn btn-default">Annuler</button>
        <button type="submit" class="btn btn-primary">Enregistrer</button>
    </div>
    <div class="clearfix"></div>
</form>


<script type="text/javascript">
    $(document).ready(function() {

        $("#editForm").validate({
                rules: {
                    email: {
                        email: true
                    },
                    nom: {
                        required: true
                    },
                    prenom: {
                        required: true
                    }
                }
            }


        );
    })
</script>
