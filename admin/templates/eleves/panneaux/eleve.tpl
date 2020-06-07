<div class="panel panel-default" id="panel1">

    <div class="panel-heading">
        <h4 class="panel-title">
        <a data-toggle="collapse" data-target="#collapse1" href="#collapse1">Élève</a>
        </h4>
    </div>

    <div id="collapse1" class="panel-collapse collapse">

        <div class="row panel-body">

            <div class="col-md-4 col-sm-12">

                <div class="form-group">
                    <label for="nom">Nom:</label>
                    <input type="text" maxlength="30" size="20" name="nom" id="nom" value="{$eleve.nom}" class="text-uppercase form-control">
                    <br>
                </div>

                <div class="form-group">
                    <label for="prenom">Prénom:</label>
                    <input type="text" maxlength="30" size="20" name="prenom" id="prenom" value="{$eleve.prenom}" class="form-control">
                </div>

                <div class="form-group">
                    <label for="annee">Année:</label>
                    <input type="text" maxlength="2" size="2" name="annee" id="annee" value="{$eleve.annee}" class="text-uppercase form-control">
                    <div class="help-block">(SEULEMENT L'ANNÉE - attention à distinguer les 1C, des 1S et des 1D)</div>
                </div>

                <div class="form-group">
                    <label for="sexe">Sexe</label>
                    <input type="text" maxlength="1" size="1" name="sexe" id="sexe" value="{$eleve.sexe}" class="text-uppercase form-control">
                    <div class="help-block">(M ou F)</div>
                </div>

            </div>

            <div class="col-md-4 col-sm-12">

                <div class="form-group">
                    <label for="classe">Classe:</label>
                    <input type="text" maxlength="6" size="6" name="classe" id="classe" value="{$eleve.classe}" class="text-uppercase form-control">
                </div>

                <div class="form-group">
                    <label for="groupe">Groupe:</label>
                    <input type="text" maxlength="6" size="6" name="groupe" id="groupe" value="{$eleve.groupe}" class="text-uppercase form-control">
                </div>

                <div class="form-group">
                    <label for="section">Section</label>
                    <select name="section" id="section" class="form-control">
                        <option value=''>Section</option>
                        <option value='TQ' {if $eleve.section=='TQ' } selected{/if}>TQ</option>
                        <option value='GT' {if $eleve.section=='GT' } selected{/if}>GT</option>
                        <option value='TT' {if $eleve.section=='TT' } selected{/if}>TT</option>
                        <option value='S' {if $eleve.section=='S' } selected{/if}>S</option>
                        <option value='P' {if $eleve.section=='P' } selected{/if}>P</option>
                        <option value='PARTI' {if $eleve.section=='PARTI' } selected{/if}>PARTI</option>
                    </select>
                </div>


                <div class="form-group">
                    <label for="matricule">Matricule:</label>
                    <input type="text" maxlength="6" size="6" name="matricule" id="matricule" value="{$eleve.matricule}" class="form-control" {if $recordingType=='modif' }readonly="readonly" {/if}>
                    <div class="help-block">
                        {if $recordingType == 'modif'} non modifiable.{/if} Veiller à indiquer exclusivement le matricule officiel
                    </div>
                </div>

            </div>
            <!-- col-md-... -->

            <div class="col-md-4 col-sm-12">

                <div class="form-group">
                    <label for="DateNaiss">Date de naissance:</label>
                    <input type="text" name="DateNaiss" id="DateNaiss" maxlength="11" type="text" value="{$eleve.DateNaiss}" class="form-control">
                    <div class="help-block">Utiliser le format jj/mm/AAAA</div>
                </div>

                <div class="form-group">
                    <label for="commNaissance">Commune de naissance</label>
                    <input type="text" name="commNaissance" id="commNaissance" maxlength="30" value="{$eleve.commNaissance}" class="form-control">
                </div>

                <div class="form-group">
                    <label for="adresseEleve">Adresse</label>
                    <input type="text" name="adresseEleve" id="adresseEleve" maxlenght="40" value="{$eleve.adresseEleve}" class="form-control">
                </div>

                <div class="form-group">
                    <label for="cpostEleve">Code Postal</label>
                    <input type="text" name="cpostEleve" id="cpostEleve" maxlength="6" value="{$eleve.cpostEleve}" class="form-control">
                </div>

                <div class="form-group">
                    <label for="localiteEleve">Commune</label>
                    <input type="text" name="localiteEleve" id="localiteEleve" maxlength="30" value="{$eleve.localiteEleve}" class="form-control">
                </div>

            </div>
            <!-- col-md-... -->

        </div>
        <!-- row -->

    </div>
    <!-- collapse -->

</div>
<!-- panel -->
