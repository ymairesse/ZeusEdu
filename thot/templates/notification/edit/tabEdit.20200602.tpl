<form name="notification" id="formNotification" role="form" class="form-vertical">

	<div class="row">

		<div class="col-md-3 col-sms-12" id="selecteurVertical">

			<button type="button" class="btn btn-danger btn-block" id="btn-raz" title="Remise à zéro du formulaire"><i class="fa fa-trash"></i> Remise à zéro</button>

			{* ------------------------------------------------------------------------------ *}
			{* choix du type de notification *}
			<div class="form-group" id="divType">
				<label for="type" class="sr-only">Cible</label>
				<select class="form-control" name="type" id="type">
					<option value="">Choisir le/les destinataire(s)</option>
					{foreach from=$selectTypes key=leType item=dataType}
					{if ($dataType.droits == Null) || in_array($userStatus, $dataType.droits)}
						<option
							data-disabled="{$dataType.editOnly}"
							value="{$leType}"
							{if $dataType.editOnly == true} disabled{/if}
							{if isset($type)  && ($type == $leType)} selected{/if}>
							{$dataType.texte}
						</option>
					{/if}
					{/foreach}
			  	</select>
			</div>

			{* ------------------------------------------------------------------------------ *}
			{* sélecteur factice: seule l'école peut être choisie *}
			<div class="sousType {if !(isset($type)) || ($type != 'ecole')}hidden{/if}" id="divEcole">
				<div class="form-group" id="selectEcole">
					<label for="tous" class="sr-only">Tous les élèves</label>
					<select class="form-control" id="tous" name="tous">
						<option value="ecole">Annonce pour tous les élèves</option>
					</select>
				</div>
			</div>

			{* ------------------------------------------------------------------------------ *}
			{* choix du niveau d'étude quand notification par niveau *}

			<div class="sousType {if !(isset($type)) || ($type != 'niveau')}hidden{/if}" id="divNiveau">
				<div class="form-group" id="niveau">
					<label for="niveau4niveau" class="sr-only">Niveau d'étude</label>
					<select class="form-control" name="niveau" id="niveau4niveau">
						<option value="">Choix du niveau d'étude</option>
						{foreach from=$listeNiveaux key=wtf item=leNiveau}
						<option value="{$leNiveau}"{if isset($type) && ($type == 'niveau') && ($niveau == $leNiveau)} selected{/if}>{$leNiveau}e année</option>
						{/foreach}
					</select>
				</div>
			</div>


			{* ------------------------------------------------------------------------------ *}
			{* notifications par classes *}
			<div class="sousType  {if !(isset($type)) || ($type != 'classes') || $notification.matricule != Null}hidden{/if}" id="divClasse">

				<div class="form-group">
					<label for="niveau4classe" class="sr-only">Niveau d'étude</label>
					<select class="form-control" name="niveau4classe" id="niveau4classe">
						<option value="">Choix du niveau d'étude</option>
						{foreach from=$listeNiveaux key=wtf item=leNiveau}
						<option value="{$leNiveau}"{if isset($type) && ($type == 'classes') && ($leNiveau == $niveau)} selected{/if}>{$leNiveau}e année</option>
						{/foreach}
					</select>
				</div>

				<div class="form-group" id="divSelectClasse">
					{* select des classes généré après sélection du niveau *}
					{* notification/inc/selectClasse.tpl  *}
					<label for="classe" class="sr-only">Classes</label>
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

				<div class="form-group">
					<label for="selectCoursGrp" class="sr-only">Vos cours</label>
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

				<div class="form-group">
					<label for="niveau4matiere" class="sr-only">Niveau d'étude</label>
					<select class="form-control" name="niveau4matiere" id="niveau4matiere">
						<option value="">Choix du niveau d'étude</option>
						{foreach from=$listeNiveaux key=wtf item=leNiveau}
						<option value="{$leNiveau}"{if isset($type) && $type == 'cours' && $niveau == $leNiveau} selected{/if}>{$leNiveau}e année</option>
						{/foreach}
					</select>
				</div>

				<div class="form-group" id="divSelectMatiere">

					{* select des matières généré après sélection du niveau *}
					{* notification/inc/selectMatiere.tpl  *}
					<label for="matiere" class="sr-only">Choisir la matière</label>
					<select class="form-control" name="matiere" id="matiere">
						<option value="">Choisir la Matière</option>
						{if isset($type) && $notification.type == 'cours'}<option value="{$destinataire}" selected>{$destinataire}</option>{/if}
					</select>
					{* ce fragment sera remplacé *}

				</div>

			</div>
			{* ------------------------------------------------------------------------------ *}

			{* sélection éventuelle de certains élèves (uniqument pour coursGrp et classe ) *}
			{* situé à gauche de l'écran *}
			<div class="hidden" id="choixEleves">

				{include file='notification/listeEleves.tpl'}

			</div>

		</div>

		<div class="col-md-9 col-sm-12" id="editeur">

			{include file="notification/formNotification.tpl"}

		</div>

	</div>

</form>
