<form name="notification" id="notification" role="form" class="form-vertical">

		<div class="row" id="selecteur">

		<div class="col-sm-1">
			<button type="button" class="btn btn-danger btn-block" id="btn-raz" title="Remise à zéro du formulaire"><i class="fa fa-trash fa-3x"></i> </button>
		</div>
		
		{* ------------------------------------------------------------------------------ *}
		{* choix du type de notification *}
		<div class="col-sm-4">
				<div class="form-group" id="divType">
				<label for="type">Cible</label>
				<select class="form-control" name="type" id="type">
				<option value="">Choisir</option>
				{foreach from=$selectTypes key=leType item=dataType}
				{if ($dataType.droits == Null) || in_array($userStatus, $dataType.droits)}
					<option value="{$leType}">{$dataType.texte}</option>
				{/if}
				{/foreach}
			  </select>
			</div>
		</div>

		{* ------------------------------------------------------------------------------ *}
		{* sélecteur factice: seule l'école peut être choisie *}
		<div class="col-sm-7 sousType {if !(isset($type))|| ($type != 'ecole')}hidden{/if}" id="divEcole">
			<div class="form-group" id="selectEcole">
				<label for="tous">Tous les élèves</label>
				<select class="form-control hidden" id="tous" name="tous">
					<option value="ecole">Annonce pour tous les élèves</option>
				</select>
			</div>
		</div>

		{* ------------------------------------------------------------------------------ *}
		{* choix du niveau d'étude quand notification par niveau *}

		<div class="sousType {if !(isset($type)) || ($type != 'niveau')}hidden{/if}" id="divNiveau">
			<div class="col-sm-7 form-group" id="niveau">
				<label for="niveau4niveau">Niveau d'étude</label>
				<select class="form-control" name="niveau" id="niveau4niveau">
					<option value="">Choix du niveau d'étude</option>
					{foreach from=$listeNiveaux key=wtf item=leNiveau}
					<option value="{$leNiveau}"{if isset($type) && ($type == 'niveau') && ($destinataire == $leNiveau)} selected{/if}>{$leNiveau}e année</option>
					{/foreach}
				</select>
			</div>
		</div>


		{* ------------------------------------------------------------------------------ *}
		{* notifications par classe *}
		<div class="sousType  {if !(isset($type)) || ($type != 'classes') || $notification.matricule != Null}hidden{/if}" id="divClasse">

			<div class="col-sm-3 form-group">
				<label for="niveau4classe">Niveau d'étude</label>
				<select class="form-control" name="niveau4classe" id="niveau4classe">
					<option value="">Choix du niveau d'étude</option>
					{foreach from=$listeNiveaux key=wtf item=leNiveau}
					<option value="{$leNiveau}"{if isset($type) && ($type == 'classes') && ($leNiveau == $notification.niveau)} selected{/if}>{$leNiveau}e année</option>
					{/foreach}
				</select>
			</div>

			<div class="col-sm-4 form-group" id="divSelectClasse">
				{* select des classes généré après sélection du niveau *}
				{* notification/inc/selectClasse.tpl  *}
			    <label for="classe">Classe</label>
			    <select class="form-control" name="classe" id="classe">
			        <option value="">Choisir la classe</option>
					{if isset($type) && $type == 'classes'}<option value="{$destinataire}" selected>{$destinataire}</option>{/if}
			    </select>
				{* ce fragment sera remplacé en cas de nouvelle notification *}
			</div>
		</div>
		{* ------------------------------------------------------------------------------ *}


		{* ------------------------------------------------------------------------------ *}
		{** notification par coursGrp *}
		<div class="sousType {if !(isset($type))|| ($type != 'coursGrp')}hidden{/if}" id="divCoursGrp">

			<div class="col-sm-7 form-group">
				<label for="selectCoursGrp">Vos cours</label>
				<select class="form-control" name="coursGrp" id="selectCoursGrp">
				<option value="">Cours</option>
				{foreach from=$listeCours key=coursGrp item=dataCours}
				<option value="{$coursGrp}"{if isset($type) && $type == 'coursGrp' && $coursGrp == $destinataire} selected{/if}>
					{$dataCours.statut} {$coursGrp} {$dataCours.libelle} {$dataCours.nbheures}h
				</option>
				{/foreach}
				</select>
			</div>

		</div>
		{* ------------------------------------------------------------------------------ *}


		{* ------------------------------------------------------------------------------ *}
		{* notification par matière *}
		<div class="sousType{if !(isset($type)) || ($type != 'cours')} hidden{/if}" id="divMatiere">

			<div class="col-sm-3 form-group">
				<label for="niveau4matiere">Niveau d'étude</label>
				<select class="form-control" name="niveau4matiere" id="niveau4matiere">
					<option value="">Choix du niveau d'étude</option>
					{foreach from=$listeNiveaux key=wtf item=leNiveau}
					<option value="{$leNiveau}"{if isset($type) && $type == 'cours' && $niveau == $leNiveau} selected{/if}>{$leNiveau}e année</option>
					{/foreach}
				</select>
			</div>

			<div class="col-sm-4 form-group" id="divSelectMatiere">

				{* select des matières généré après sélection du niveau *}
				{* notification/inc/selectMatiere.tpl  *}
				<label for="matiere">Choisir la matière</label>
				<select class="form-control" name="cours" id="cours">
					<option value="">Choisir la Matière</option>
					{if isset($type) && $notification.type == 'cours'}<option value="{$destinataire}" selected>{$destinataire}</option>{/if}
				</select>
				{* ce fragment sera remplacé *}

			</div>

		</div>
		{* ------------------------------------------------------------------------------ *}

	</div>

	<div class="row">
		{* sélection éventuelle de certains élèves (uniqument pour coursGrp et classe ) *}
		{* situé à gauche de l'écran *}
		<div class="col-md-3 col-sm-12 hidden" id="choixEleves">

			{include file='notification/listeEleves.tpl'}

		</div>

		{* emplcament de l'éditeur de texte et upload de documents *}
		{* situé à droite de l'écran *}
		<div class="col-md-9 col-sm-12" id="editeur">

			{include file="notification/formNotification.tpl"}

		</div>

	</div>

</form>
