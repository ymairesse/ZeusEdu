<div class="panel">

    <div class="panel-heading">
        <h4 class="panel-title">
            <a data-toggle="collapse" data-target="#collapse4" href="#collapse4">Mère de l'élève</a>
        </h4>
    </div>

    <div id="collapse4" class="panel-collapse collapse">

        <div class="row panel-body">

            <div class="col-md-6 col-sm-12">

                <div class="form-group">
                    <label for="nomMere">Nom</label>
                    <input type="text" name="nomMere" id="nomMere" maxlength="50" value="{$eleve.nomMere}" class="text-uppercase form-control">
                </div>

                <div class="form-group">
                    <label for="telMere">Téléphone</label>
                    <input type="text" name="telMere" id="telMere" maxlength="20" value="{$eleve.telMere}" class="form-control">
                </div>

            </div>
            <!-- col-md-... -->

            <div class="col-md-6 col-sm-12">

                <div class="form-group">
                    <label for="gsmMere">GSM</label>
                    <input type="text" name="gsmMere" id="gsmMere" maxlength="20" value="{$eleve.gsmMere}" class="form-control">
                </div>

                <div class="form-group">
                    <label for="mailMere">Courriel</label>
                    <input type="text" name="mailMere" id="mailMere" maxlength="40" value="{$eleve.mailMere}" class="form-control">
                </div>

            </div>
            <!-- col-md-... -->

        </div>
        <!-- row -->

    </div>
    <!-- collapse -->

</div>
<!-- panel -->
