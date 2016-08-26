<div class="modal fade" id="modalFormPerso" tabindex="-1" role="dialog" aria-labelledby="titleFormPerso" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">

            <form>

                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                    <h4 class="modal-title" id="titleFormPerso">Informations personnelles</h4>
                </div>
                <div class="modal-body">

                    <div class="row">

                        <div class="col-md-6 col-sm-12">

                            <h4>Domicile</h4>
                            <div class="form-group">
                                <label class="sr-only" for="adresse">Adresse</label>
                                <input type="text" class="form-control" maxlength="40" name="adresse" id="adresse" value="{$identite.adresse}" placeholder="Adresse">
                            </div>

                            <div class="form-group">
                                <label class="sr-only" for="codePostal">Code Postal</label>
                                <input type="text" class="form-control" maxlength="6" name="codePostal" id="codePostal" value="{$identite.codePostal}" placeholder="Code postal">
                            </div>
                            <div class="form-group">
                                <label class="sr-only" for="commune">Commune</label>
                                <input type="text" class="form-control" maxlength="40" name="commune" id="commune" value="{$identite.commune}" placeholder="Commune">
                            </div>
                            <div class="form-group">
                                <label class="sr-only" for="pays">Pays</label>
                                <input type="text" class="form-control" maxlength="10" name="pays" id="pays" value="{$identite.pays}" placeholder="Pays">
                            </div>

                        </div>

                        <div class="col-md-6 col-sm-12">

                            <h4>Contact</h4>
                            <div class="form-group">
                                <label class="sr-only" for="fonction">Fonction</label>
                                <input type="text" class="form-control" maxlength="40" name="fonction" id="fonction" value="{$identite.titre}" placeholder="Fonction dans l'école">
                            </div>

                            <div class="form-group">
                                <label class="sr-only" for="mail">Mail *</label>
                                <input type="email" class="form-control" maxlength="40" name="mail" id="mail" value="{$identite.mail}" placeholder="adresse mail">
                                <span class="bg-danger hidden" id="erreurMail">Adresse incorrecte ou manquante</span>
                            </div>
                            <div class="form-group">
                                <label class="sr-only" for="telephone">Téléphone</label>
                                <input type="text" class="form-control" maxlength="40" name="telephone" id="telephone" value="{$identite.telephone}" placeholder="Téléphone">
                            </div>
                            <div class="form-group">
                                <label class="sr-only" for="GSM">GSM</label>
                                <input type="text" class="form-control" maxlength="40" name="GSM" id="GSM" value="{$identite.GSM}" placeholder="Téléphone portable">
                            </div>

                        </div>

                    </div>

                </div>
                <div class="modal-footer">
                    <p class="alert alert-info">L'adresse mail est obligatoire. Un numéro de téléphone est souhaitable.</p>
                    <div class="btn-group pull-right">
                        <button type="reset" class="btn btn-default">Annuler</button>
                        <button type="button" class="btn btn-primary" id="btn-confirm-perso">Enregistrer</button>
                    </div>
                </div>
        </div>

        </form>
    </div>
</div>



<script type="text/javascript">
    {literal}

    function isEmail(email) {
        var regex = /^([a-zA-Z0-9_.+-])+\@(([a-zA-Z0-9-])+\.)+([a-zA-Z0-9]{2,4})+$/;
        return regex.test(email);
    }

    {/literal}

        $(document).ready(function() {

            $("#mail").keyup(function() {
                if (isEmail($(this).val())) {
                    $('#erreurMail').addClass('hidden');
                    $('#btn-confirm-perso').attr('disabled', false);
                    }
                else {
                    $('#erreurMail').removeClass('hidden');
                    $('#btn-confirm-perso').attr('disabled', true);
                }
            })


        })
</script>
