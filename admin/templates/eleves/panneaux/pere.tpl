<div class="panel">

    <div class="panel-heading">
        <h4 class="panel-title">
            <a data-toggle="collapse" data-target="#collapse3" href="#collapse3">Père de l'élève</a>
        </h4>
    </div>

    <div id="collapse3" class="panel-collapse collapse">

        <div class="row panel-body">

            <div class="col-md-6 col-sm-12">

                <div class="form-group">
                    <label for="nomPere">Nom</label>
                    <input type="text" name="nomPere" id="nomPere" maxlength="50" value="{$eleve.nomPere}" class="text-uppercase form-control">
                </div>

                <div class="form-group">
                    <label for="telPere">Téléphone</label>
                    <input type="text" name="telPere" id="telPere" maxlength="20" value="{$eleve.telPere}" class="form-control">
                </div>

            </div>
            <!-- col-md-... -->

            <div class="col-md-6 col-sm-12">

                <div class="form-group">
                    <label for="gsmPere">GSM</label>
                    <input type="text" name="gsmPere" id="gsmPere" maxlength="20" value="{$eleve.gsmPere}" class="form-control">
                </div>

                <div class="form-group">
                    <label for="mailPere">Courriel</label>
                    <input type="text" name="mailPere" id="mailPere" maxlength="40" value="{$eleve.mailPere}" class="form-control">
                </div>

            </div>
            <!-- col-md-... -->

        </div>
        <!-- row -->

    </div>
    <!-- collapse  -->

</div>
<!-- panel -->
