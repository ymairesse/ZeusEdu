<form id="formSelectEleve">

{assign var=offre value = $offre|current}

    <div class="row">

        <div class="col-md-6 col-sm-12">
            <div class="form-group">
                <label for="critereEleve">Critère de sélection</label>
                <select class="form-control" name="critere" id="critereEleve">
                    <option value="">Sélection par</option>
                    <option value="classe">La classe</option>
                    <option value="cours">Un cours</option>
                </select>
            </div>

            <div class="hidden" id="selectByNiveauClasse">

                <div class="form-group">
                    <label for="selectNiveauEleve">Niveau</label>
                    <select class="form-control" name="niveau" id="selectNiveauEleve">
                    </select>
                </div>

                <div class="form-group" id="selectClasse">
                    <label for="classe">Classe</label>
                    <select class="form-control" name="classe" id="classeEleve">
                        <option value="">Choisir la classe</option>
                    </select>
                </div>
            </div>

            <div class="hidden" id="selectByCours">

                <div class="form-group">
                    <label for="coursGrp">Votre cours</label>
                    <select class="form-control" name="coursGrp" id="coursGrp">
                        <option value="">Choisir le cours</option>

                    </select>
                </div>
            </div>
        </div>

        <div class="col-md-6 col-sm-12">

            <div class="form-group hidden" id="blocSelectEleves">
                <label for="listeEleves">Élèves</label>
                <select class="form-control" name="listeEleves[]" id="listeEleves" size="10" multiple>
                    <option value="">Sélection les élèves</option>
                </select>
                <div class="help-block">
                    Ctrl/Maj clic = sél. multiple
                </div>

            </div>

        </div>

    </div>

    <input type="hidden" name="idOffre" id="modalIdOffre" value="">
</form>
