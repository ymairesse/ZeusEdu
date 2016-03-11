<div class="panel panel-default">

    <div class="panel-heading">
        <h4 class="panel-title">
        <a data-toggle="collapse" data-target="#collapse2" href="#collapse2">Personne responsable</a>
        </h4>
    </div>

    <div id="collapse2" class="panel-collapse collapse">
        <div class="row panel-body">

            <div class="col-md-4 col-sm-12">

                <div class="form-group">
                    <label for="nomResp">Responsable</label>
                    <input type="text" name="nomResp" id="nomResp" maxlength="50" value="{$eleve.nomResp}" class="text-uppercase form-control">
                </div>

                <div class="form-group">
                    <label for="courriel">Courriel</label>
                    <input type="text" name="courriel" id="courriel" maxlength="40" value="{$eleve.courriel}" class="form-control">
                </div>

                <div class="form-group">
                    <label for="telephone1">Téléphone</label>
                    <input type="text" name="telephone1" id="telephone1" maxlength="20" value="{$eleve.telephone1}" class="form-control">
                </div>

            </div>

            <div class="col-md-4 col-sm-12">

                <div class="form-group">
                    <label for="telephone2">GSM</label>
                    <input type="text" name="telephone2" id="telephone2" maxlength="20" value="{$eleve.telephone2}" class="form-control">
                </div>

                <div class="form-group">
                    <label for="telephone3">Téléphone bis</label>
                    <input type="text" name="telephone3" id="telephone3" maxlength="20" value="{$eleve.telephone3}" class="form-control">
                </div>

                <div class="form-group">
                    <label for="adresseResp">Adresse</label>
                    <input type="text" name="adresseResp" id="adresseResp" maxlenght="40" value="{$eleve.adresseResp}" class="form-control">
                </div>

            </div>

            <div class="col-md-4 col-sm-12">

                <div class="form-group">
                    <label for="cpostResp">Code Postal</label>
                    <input type="text" name="cpostResp" id="cpostResp" maxlength="6" value="{$eleve.cpostResp}" class="form-control">
                </div>

                <div class="form-group">
                    <label for="localiteResp">Commune</label>
                    <input type="text" name="localiteResp" id="localiteResp" maxlength="30" value="{$eleve.localiteResp}" class="form-control">
                </div>

            </div>
            <!-- col-md-... -->

        </div>
        <!-- row -->

    </div>
    <!-- collapse -->

</div>
<!-- panel -->
