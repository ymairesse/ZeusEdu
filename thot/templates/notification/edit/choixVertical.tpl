<div class="btn-group btn-group-justified">
    <a href="#" class="btn btn-danger" id="btn-raz" title="Remise à zéro du formulaire" data-container="body"><i class="fa fa-trash"></i> Remise à zéro</a>
    <a href="#" class="btn btn-success" id="btn-cloner" title="Cloner cette annonce" data-container="body"><i class="fa fa-clone"></i> Cloner</a>
</div>

{* ------------------------------------------------------------------------------ *}
{* choix du type de notification *}
<div class="form-group" id="divType">
    <label for="type" class="sr-only">Cible</label>
    <select class="form-control selection" name="type" id="type">
        <option value="">Choisir le/les destinataire(s)</option>

        {foreach from=$selectTypes key=leType item=dataType}
        {if ($dataType.droits == Null) || in_array($userStatus, $dataType.droits)}
            <option value="{$leType}" {if $leType == $type} selected{/if}>
                {$dataType.texte}
            </option>
        {/if}
        {/foreach}

    </select>
</div>


{* ------------------------------------------------------------------------------ *}
{* sélecteur factice: seule l'école peut être choisie *}
<div class="sousType {if !(isset($type))|| ($type != 'ecole')}hidden{/if}" id="divEcole">
    <div class="form-group" id="selectEcole">
        <label for="tous" class="sr-only">Tous les élèves</label>
        <select class="form-control hidden" id="tous" name="">
            <option value="">Annonce pour tous les élèves</option>
        </select>
    </div>
</div>
{* ------------------------------------------------------------------------------ *}


{* ------------------------------------------------------------------------------ *}
{* choix du niveau d'étude quand notification par niveau *}
<div class="sousType {if !(isset($type)) || ($type != 'niveau')}hidden{/if}" id="divNiveau">
    <div class="form-group" id="niveau">
        <label for="niveau4niveau" class="sr-only">Niveau d'étude</label>
        <select class="form-control selection" name="niveau" id="niveau4niveau" disabled>
            <option value="">Choix du niveau d'étude</option>
            {foreach from=$listeNiveaux key=wtf item=leNiveau}
            <option value="{$leNiveau}"{if isset($type) && isset($destinataire) && ($type == 'niveau') && ($destinataire == $leNiveau)} selected{/if}>{$leNiveau}e année</option>
            {/foreach}
        </select>
    </div>
</div>
{* ------------------------------------------------------------------------------ *}


{* ------------------------------------------------------------------------------ *}
{* notifications par niveau puis par classe *}
<div class="sousType  {if !(isset($type)) || ($type != 'classes') || $notification.matricule != Null}hidden{/if}" id="divClasse">

    <div class="form-group">
        <label for="niveau4classe" class="sr-only">Niveau d'étude</label>
        <select class="form-control selection" name="niveau4classe" id="niveau4classe" disabled>
            <option value="">Choix du niveau d'étude</option>
            {foreach from=$listeNiveaux key=wtf item=leNiveau}
            <option value="{$leNiveau}"{if isset($type) && isset($destinataire) && ($type == 'classes') && ($leNiveau == $niveau)} selected{/if}>{$leNiveau}e année</option>
            {/foreach}
        </select>
    </div>

    <div class="form-group" id="divSelectClasse">
        {if isset($destinataire)}
            <label for="classe" class="sr-only">Classe</label>
            <select class="form-control selection" name="classe" id="classe">
                <option value="">Choix d'une classe</option>
                {foreach from=$listeClasses item=classe}
                    <option value="{$classe}"{if $classe == $destinataire} selected{/if}>{$classe}</option>
                {/foreach}
            </select>
        {/if}
        {* ce fragment sera remplacé par selectClasse.tpl en cas de notification par classe *}
    </div>
</div>
{* ------------------------------------------------------------------------------ *}


{* ------------------------------------------------------------------------------ *}
{** notification par coursGrp *}
<div class="sousType {if !(isset($type))|| ($type != 'coursGrp')}hidden{/if}" id="divCoursGrp">

    <div class="form-group">
        <label for="selectCoursGrp" class="sr-only">Vos cours</label>
        <select class="form-control selection" name="coursGrp" id="selectCoursGrp">
        <option value="">Cours</option>
        {foreach from=$listeCours key=coursGrp item=dataCours}
        <option value="{$coursGrp}"{if isset($type) && isset($destinataire) && $type == 'coursGrp' && $coursGrp == $destinataire} selected{/if}>
            {$dataCours.statut} {$coursGrp} {$dataCours.libelle} {$dataCours.nbheures}h
        </option>
        {/foreach}
        </select>
    </div>

</div>
{* ------------------------------------------------------------------------------ *}


{* ------------------------------------------------------------------------------ *}
{* notification par niveau puis par matière *}
<div class="sousType{if !(isset($type)) || ($type != 'cours')} hidden{/if}" id="divMatiere">

    <div class="form-group">
        <label for="niveau4matiere" class="sr-only">Niveau d'étude</label>
        <select class="form-control selection" name="niveau4matiere" id="niveau4matiere" disabled>
            <option value="">Choix du niveau d'étude</option>
            {foreach from=$listeNiveaux key=wtf item=leNiveau}
            <option value="{$leNiveau}"{if isset($type) && $type == 'cours' && $niveau == $leNiveau} selected{/if}>{$leNiveau}e année</option>
            {/foreach}
        </select>
    </div>

    <div class="form-group" id="divSelectMatiere">
        {* select des matières généré après sélection du niveau *}
        {* notification/inc/selectMatiere.tpl  *}
        {* ce fragment sera remplacé *}

    </div>

</div>
{* ------------------------------------------------------------------------------ *}


{* ------------------------------------------------------------------------------ *}
{* notification par profsCours *}
<div class="sousType{if !(isset($type)) || ($type != 'profsCours')} hidden{/if}" id="divprofsCours">
    <div class="form-group">
        <label for="prof" class="sr-only">Professeur</label>
        <select class="form-control selection" name="acronyme" id="acronyme" disabled>
            <option value="">Choix du professeur</option>
            {foreach from=$listeProfs key=acronyme item=data}
                <option value="{$acronyme}"{if $prof4Cours == $acronyme} selected{/if}>
                    {$data.nom} {$data.prenom}
                </option>
            {/foreach}
        </select>
    </div>

    <div class="form-group" id="divSelectCoursProf">
        {* liste des cours du prof sélectionné*}
        {if isset($listeCours4prof)}
            {* Liste des cours pour un prof différent de l'utilisateur courant *}
            <label for="coursGrpProf" class="sr-only">Cours</label>

            <select class="form-control" name="coursGrpProf" id="coursGrpProf" disabled>
                <option value="">Choisir le cours</option>
                {foreach from=$listeCours4prof key=coursGrp item=data}
                <option value="{$coursGrp}"{if $coursGrp == $destinataire} selected{/if}>
                    [{$coursGrp}] {$data.statut} {$data.libelle} {$data.nbheures}h {$data.classes}{if $data.virtuel == 1} *{/if}
                </option>
                {/foreach}
            </select>
            * = cours virtuel
        {/if}
    </div>

</div>


{* ------------------------------------------------------------------------------ *}

{* sélection éventuelle de certains élèves (uniqument pour coursGrp, profsCours et classe ) *}
{* situé à gauche de l'écran *}
<div class="hidden" id="choixEleves">

    {include file='notification/edit/listeEleves.tpl'}

</div>
