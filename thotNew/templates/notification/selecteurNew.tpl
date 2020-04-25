<form id="formSelecteur">
    
<div class="panel panel-default">
    <div class="panel-heading">
        Sélection
    </div>
    <div class="panel-body">
        <div class="input-group">
            <select class="form-control" name="type" id="selectPrincipal">
                <option value="">Choisir la cible</option>
                <option value="ecole">Tous les élèves</option>
                <option value="niveau">Un niveau d'étude</option>
                <option value="classes">Une classe *</option>
                <option value="coursGrp">Un cours *</option>
                <option value="cours">Une matière</option>
                <option value="groupe">Un groupe *</option>
            </select>
            <span class="input-group-btn">
                <button type="button" class="btn btn-primary" name="button" data-type="tous" disabled>
                    <i class="fa fa-arrow-right"></i>
                </button>
            </span>
        </div>

        <div class="hidden sousSelecteur input-group" id="formNiveau">
            <select class="form-control" name="niveau" id="niveau">
                <option value="">Choix du niveau</option>
                {foreach from=$listeNiveaux key=wtf item=niveau}
                    <option value="{$niveau}">{$niveau}e année</option>
                {/foreach}
            </select>
            <span class="input-group-btn">
                <button type="button" class="btn btn-primary" name="button" data-type="niveau" disabled>
                    <i class="fa fa-arrow-right"></i>
                </button>
            </span>
        </div>

        <div class="hidden sousSelecteur input-group" id="formCoursGrp">
            <select class="form-control" name="coursGrp" id="coursGrp">
                <option value="">Choix du cours</option>
                {foreach from=$listeCours key=coursGrp item=data}
                <option value="{$coursGrp}">
                    {$data.statut} {$data.nbheures}h {if ($data.nomCours != '')} {$data.nomCours}{else}{$data.libelle}{/if} [{$coursGrp}]
                </option>
                {/foreach}
            </select>
            <span class="input-group-btn">
                <button type="button" class="btn btn-primary" name="button" data-type="coursgrp" disabled>
                    <i class="fa fa-arrow-right"></i>
                </button>
            </span>
        </div>

        <div class="hidden sousSelecteur input-group" id="formClasses">
        </div>

        <div class="hidden sousSelecteur input-group" id="formMatieres">
        </div>

        <div class="hidden sousSelecteur input-group" id="formGroupes">
            <select class="form-control" name="groupe" id="groupe">
                <option value="">Choix du groupe</option>
                {foreach from=$listeGroupes key=nomGroupe item=data}
                <option value="{$nomGroupe}">
                    {$data.intitule}
                </option>
                {/foreach}
            </select>
            <span class="input-group-btn">
                <button type="button" class="btn btn-primary" name="button" data-type="groupe" disabled>
                    <i class="fa fa-arrow-right"></i>
                </button>
            </span>
        </div>


        <div class="hidden sousSelecteur btn-group btn-group-justified" id="formEleves">

        </div>

        <div class="hidden sousSelecteur" id="selectEleves">

        </div>
    </div>

    <div class="panel-footer">
        * sélection par élève(s) possible
    </div>

    <input type="hidden" id="TOUS" name="TOUS" value="TOUS">
    <input type="hidden" name="destinataire" id="destinataire" value="">

</div>
</form>
