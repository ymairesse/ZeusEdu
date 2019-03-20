<form id="formCible">
    <div class="row">

        <div class="col-sm-4">
            <div class="form-group">
                <label for="type">Cible</label>
                <select class="form-control" name="type" id="type" required>
                {foreach from=$types key=type item=leType}
                <option value="{$type}">{$leType}</option>
                {/foreach}
              </select>
            </div>
        </div>

        <div class="col-sm-8" id="detailsCible">

            <div class="form-group selecteurRem hidden" id="selectEcole">
                <label for="selectEcole">Sélection</label>
                <p class="form-control-static">Remédiation ouverte à tous</p>
            </div>

            <div class="form-group selecteurRem hidden">
                <label for="selectNiveauGroupe">Niveau d'étude</label>
                <select class="form-control" name="niveau" id="selectNiveauGroupe" required>
                <option value=""></option>
                </select>
            </div>

            <div class="selecteurRem hidden">
                <div class="col-sm-7">
                    <div class="form-group">
                        <label for="niveauClasse">Niveau d'étude</label>
                        <select class="form-control" name="niveauClasse" id="niveauClasse" required>
            <option value="">Choisir le niveau</option>
          </select>
                    </div>
                </div>

                <div class="col-sm-5">
                    <div class="form-group">
                        <label for="classe">Classe</label>
                        <select class="form-control" name="classe" id="classe" required>
                        <option value="">Classe</option>
                        </select>
                    </div>
                </div>
            </div>


            <div class="selecteurRem hidden">
                <div class="col-sm-4">
                    <div class="form-group">
                        <label for="niveauMatiere">Niveau</label>
                        <select class="form-control" name="niveauMatiere" id="niveauMatiere" required>
                        <option value="">Choisir le niveau</option>
                        </select>
                    </div>
                </div>

                <div class="col-sm-8" id="selectMatiere">
                    <div class="form-group">
                        <label for="matiere">Matière</label>
                        <select class="form-control" name="matiere" id="matiere" required>
                        <option value="">Matière</option>
                        </select>
                    </div>
                </div>
            </div>


            <div class="selecteurRem hidden">
                <div class="form-group">
                    <label for="coursGrp">Vos cours</label>
                    <select class="form-control" name="coursGrp" id="coursGrp" required>
                    <option value="">Cours</option>
                    </select>
                </div>
            </div>

        </div>

    </div>

    <input type="hidden" name="idOffre" id="idOffre" value="{$idOffre}">

</form>

<script type="text/javascript">

    $(document).ready(function(){

        $('#formCible').validate();

    })

</script>
