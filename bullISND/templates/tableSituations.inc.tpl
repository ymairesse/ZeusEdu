{* ---------------------------------------------------------------------- *}
{* tableau récapitulatif période, situation, étoile, crochets, délibé     *}
{* ---------------------------------------------------------------------- *}
{assign var="cotes" value=$listeGlobalPeriodePondere.$matricule.$coursGrp|default:Null}
{assign var="bullPrec" value=$bulletin-1}
<table class="table tableauBull situationActuelle">
	<tr>
		<th width="20%">Situation Précédente</th>
		<th width="20%">Période</th>
		<th width="20%">Situation au bulllletin <strong>{$bulletin}</strong></th>
		<th width="20%">Choix de situation</th>
		<th width="20%">Délibé</th>
	</tr>
	<tr>
		{* ------------------------------------------------------ *}
		{* situation au bulletin précédent ---------------------- *}
		{* ------------------------------------------------------ *}
		<td width="15%">
		{if isset($situationsPrecedentes.$matricule.$coursGrp.maxSit) &&  ($situationsPrecedentes.$matricule.$coursGrp.maxSit!= Null)}
			{assign var=sit value=$situationsPrecedentes.$matricule.$coursGrp.sit}
			{assign var=max value=$situationsPrecedentes.$matricule.$coursGrp.maxSit}
		<div class="fraction">
			<div class="num">{$sit|default:'&nbsp;'}</div>
			<div class="den">{$max|default:'&nbsp;'}</div>
		</div>
		{assign var=pourcent value= 100 * $sit / $max}
		<span class="micro">= {$pourcent|string_format:"%.0f"} %</span>
		{/if}
		</td>

		{* ------------------------------------------------------ *}
		{* cotes de période, Formatif et/ou Certificatif ---------*}
		{* ------------------------------------------------------ *}
		<td width="30%">
			{if is_numeric($cotes.form.cote)}
			<div class="lblFraction">TJ</div>
			<div class="fraction">
			<div class="num">{$cotes.form.cote}</div>
			<div class="den">{$cotes.form.max}</div>
			</div>
			{/if}
			{if is_numeric($cotes.cert.cote)}
			<div class="lblFraction">Cert.</div>
			<div class="fraction">
			<div class="num">{$cotes.cert.cote}</div>
			<div class="den">{$cotes.cert.max}</div>
			</div>
			{/if}
		</td>

		{* -------------------------------------------------------*}
		{* nouvelle cote de situation y compris en % -------------*}
		{* ------------------------------------------------------ *}
		<td width="15%">
			{if isset($listeSituations.$matricule.$coursGrp.$bulletin)}
				{if isset($listeSituations.$matricule.$coursGrp.$bulletin.sit) && is_numeric($listeSituations.$matricule.$coursGrp.$bulletin.sit)}
					{if $listeSituations.$matricule.$coursGrp.$bulletin.max neq 0}
					<div class="fraction">
						<div class="num">{$listeSituations.$matricule.$coursGrp.$bulletin.sit}</div>
						<div class="den">{$listeSituations.$matricule.$coursGrp.$bulletin.max}</div>
					</div>
					<span class="micro">= {$listeSituations.$matricule.$coursGrp.$bulletin.pourcent}%</span>
					{/if}
				{/if}
			{else}
			&nbsp;
			{/if}
		</td>

		{* Faut-il traiter le cas d'une période avec délibération? *}
		{if in_array($bulletin,$PERIODESDELIBES)}

		{* ------------------------------------------------------ *}
		{*  Choix de la cote de délibé     ---------------------- *}
		{* ------------------------------------------------------ *}
		<td style="width:20%; text-align:center">
			{if $blocage == 0}
			{* champs destinés à retenir si les cotes sont entre [], magiques, étoilées ou ² (réussite deuxième année du degré) *}
			{if isset($listeSituations.$matricule.$coursGrp.$bulletin)}
				{assign var=attribut value=$listeSituations.$matricule.$coursGrp.$bulletin.attribut}
			{else}
				{assign var=attribut value=Null}
			{/if}
			{* ----->>>> attribut de la cote de délibé: * ² [] ... --------*}
			<input type="hidden" name="attribut-eleve_{$matricule}"
				id="attribut-eleve_{$matricule}" value="{$attribut}"
				{if $blocage > 0}disabled="disabled"{/if}>

			{* ------------------------------------------------------ *}
			{* cote entre crochets? ----------------------------------*}
			{* Deux boutons: avec ou sans crochets -------------------*}
			{* ------------------------------------------------------ *}

			{if isset($listeSituations.$matricule.$coursGrp.$bulletin)}
				<input style="font-size:8pt" type="button" name="btnHook-eleve_{$matricule}"
					tabIndex="{$tabIndexAutres+1}"
					class="hook"
					value="[{$listeSituations.$matricule.$coursGrp.$bulletin.pourcent|default:''} %]"
					{if $blocage > 0}disabled="disabled"{/if}>
				<input style="font-size:8pt" type="button" name="btnNohook-eleve_{$matricule}"
					tabIndex="{$tabIndexAutres+2}"
					class="nohook"
					value="{$listeSituations.$matricule.$coursGrp.$bulletin.pourcent|default:''} %"
					{if $blocage > 0}disabled="disabled"{/if}>

					{if ($listeSituations.$matricule.$coursGrp.$bulletin.sitDelibe == Null)}
						<img src="images/led.gif" alt="!!"
							 data-container="body"
							 title="Sélectionnez une cote de délibération">
					{/if}
				{else}
					-
				{/if}
			{else}
				&nbsp;
			{/if}

			{* ------------------------------------------------------ *}
			{* ces boutons n'apparaîssent qu'à la dernière période    *}
			{* Quand le bulletin est le dernier de l'année            *}
			{* ------------------------------------------------------ *}
			{if $bulletin == $nbBulletins}

				{* cote étoilée? -----------------------------------------*}
				{* Un bouton à cliquer si la situation le permet----------*}
				{if isset($listeSituations.$matricule.$coursGrp.$bulletin) && ($listeSommesFormCert.$matricule.pourcentCert > $listeSituations.$matricule.$coursGrp.$bulletin.pourcent)}
				<input
					type="button"
					class="btn btn-primary btn-sm star"
					name="btnStar-eleve_{$matricule}"
					tabIndex="{$tabIndexAutres+3}"
					value="{$listeSommesFormCert.$matricule.pourcentCert} % *"
					title="Attribuer la cote étoilée"
					data-container="body"
					data-placement="top"
					{if $blocage > 0} disabled="disabled"{/if}
					>
				{/if}

				{* baguette magique? -----------------------------------------*}
				<button
					type="button"
					class="btn btn-primary btn-sm magic"
					name="magic-eleve_{$matricule}"
					title="Attribuer une cote arbitraire"
					data-container="body"
					data-placement="top" 
					{if $blocage > 0} disabled="disabled"{/if}
					><i class="fa fa-magic"></i></button>


				{* cote réussite du degré? ------------------------------------*}
				{* Un bouton à cliquer si l'élève est en échec pour le degré---*}
				{* et s'il y a une cote de première année du degré             *}
				{if isset($listeSituations.$matricule.$coursGrp.$bulletin) && ($listeSituations.$matricule.$coursGrp.$bulletin.pourcent < 50)
						&& ($sitDeuxiemes.$coursGrp.$matricule.sit2)}
				<div class="cote1erDegre">
				{* attribution de la cote 50% en cas de réussite en deuxième; la cote de deuxième se trouve dans sit2 *}
				{* la cote de deuxième exclusivement est affichée pour information *}

					{$sitDeuxiemes.$coursGrp.$matricule.sit2}% en 2<sup>e</sup>
					{if $sitDeuxiemes.$coursGrp.$matricule.sit2 >= 50}
					=>
					{assign var=reussite50 value=50}
						<input
							type="button"
							class="btn btn-success btn-sm degre"
							name="btnDegre-eleve_{$matricule}"
							tabIndex="{$tabIndexAutres+4}"
							title="Cote de réussite du degré, soit 50%"
							data-container="body"
							data-placement="top"
							value="{$reussite50} %"
							{if $blocage > 0}disable="disabled"{/if}
							>
					{/if}
				</div>
				{/if}
			{/if}
		</td>

		{* ------------------------------------------------------- *}
		{* situation de délibé de l'élève -------------------------*}
		{* Une fois dans un texte à l'écran -----------------------*}
		{* Une fois dans un champ text caché (pour POST)-----------*}
		{* ------------------------------------------------------- *}
		<td style="width:20%; text-align:center"{if isset($tableErreurs.$matricule['sitDelibe'])} class="erreurEncodage"{/if}>
		{if isset($listeSituations.$matricule.$coursGrp.$bulletin)}
			{assign var="sitDelibe" value=$listeSituations.$matricule.$coursGrp.$bulletin.sitDelibe|default:Null}
			{else}
			{assign var="sitDelibe" value=Null}
		{/if}
		{if isset($listeSituations.$matricule.$coursGrp.$bulletin)}
		{assign var="symbole" value=$listeSituations.$matricule.$coursGrp.$bulletin.symbole}
		<strong id="situationFinale_{$matricule}">
			{if $listeSituations.$matricule.$coursGrp.$bulletin.attribut == 'hook'}
			[{$sitDelibe}]%
			{else}
			{$sitDelibe}<sup>{$symbole}</sup>%{/if}
		{else}
		&nbsp;
		{/if}
		</strong>
		<input type="text" maxlength="4" name="situation-eleve_{$matricule}"
			id="situation-eleve_{$matricule}" value="{$sitDelibe}" class="sitDelibe form-control" style="display:none">

			{* balayette pour effacer la cote de délibé *}
			
			{if ($sitDelibe != '') && ($blocage == 0)}
				<span class="glyphicon glyphicon-fire balayette"
					  style="font-size:1.5em; color:red; cursor:pointer"
					  title="Effacer la cote de délibération"
					  id="bal_{$matricule}" ></span>
			{/if}
		</td>
	{else}
		<td>&nbsp;</td>
		<td>&nbsp;</td>
	{/if}
	</tr>
</table>
{assign var="tabIndexAutres" value=$tabIndexAutres+5}