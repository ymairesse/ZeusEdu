{if isset($noBulletin)}

<h1>Bulletin n° {$noBulletin}</h1>

{if isset($listeCoursGrp)} {foreach from=$listeCoursGrp key=coursGrp item=unCours}

<div class="row" style="border-bottom: 1px solid black; padding-bottom:0.5em">

	<div class="col-md-6 col-sm-12">
		<h2 class="titreCours" title="{$coursGrp}">{$unCours.libelle} {$unCours.nbheures}h</h2>
		<p>{$listeProfsCoursGrp.$coursGrp}</p>

		{if isset($commentaires.$matricule.$coursGrp.$noBulletin) && ($commentaires.$matricule.$coursGrp.$noBulletin != '')}
		<table class="tableauBulletin">
			<tr>
				<th>Remarque</th>
			</tr>
			<tr>
				<td>{$commentaires.$matricule.$coursGrp.$noBulletin|default:'&nbsp;'}</td>
			</tr>
		</table>
		{/if}
	</div>

	<div class="col-md-6 col-sm-12">&nbsp;
	</div>

	<div class="col-md-6 col-sm-12">
		{if isset($sitPrecedentes.$matricule.$coursGrp.sit)}
		<strong>Situation précédente: {$sitPrecedentes.$matricule.$coursGrp.sit} / {$sitPrecedentes.$matricule.$coursGrp.maxSit}</strong>
		{/if}
	</div>

	<div class="col-md-6 col-sm-12">
		{if isset($sitActuelles.$matricule.$coursGrp.sit)} {assign var=sitActuelle value=$sitActuelles.$matricule.$coursGrp}
		<span style="display:block; border: 1px solid black; color: white; background-color: #555;">
			<strong>Situation actuelle: {$sitActuelle.sit} / {$sitActuelle.maxSit}</strong>
			{if $sitActuelle.maxSit > 0} {assign var=sitAct value=100*$sitActuelle.sit/$sitActuelle.maxSit}
			<span class="micro">soit {$sitAct|number_format:1}%</span>
			{/if}
		</span>
		{/if}
	</div>

	<div class="col-md-6 col-sm-12">

		<table class="tableauBulletin">
			<tr>
				<th style="width:15em">Compétence</th>

				<th style="width: 6em; text-align:center" colspan="2" class="{$cotesPonderees.$matricule.$coursGrp.form.echec|default:''}">
					TJ:
					<strong>
						{if isset($cotesPonderees.$matricule.$coursGrp.form.cote)} {$cotesPonderees.$matricule.$coursGrp.form.cote}/{$cotesPonderees.$matricule.$coursGrp.form.max} {else} &nbsp; {/if}
					</strong>
				</th>

				<th style="width: 6em; text-align:center" colspan="2" class="{$cotesPonderees.$matricule.$coursGrp.cert.echec|default:''}">
					Cert:
					<strong>
						{if isset($cotesPonderees.$matricule.$coursGrp.cert.cote)} {$cotesPonderees.$matricule.$coursGrp.cert.cote}/{$cotesPonderees.$matricule.$coursGrp.cert.max} {else} &nbsp; {/if}
					</strong>
				</th>

			</tr>
			{* s'il y a des cotes pour ce coursGrp *} {if isset($listeCotes.$matricule.$coursGrp)} {assign var='lesCotes' value=$listeCotes.$matricule.$coursGrp} {assign var='cours' value=$unCours.cours} {foreach from=$listeCotes.$matricule.$coursGrp key=idComp item=uneCote}
			{if ($uneCote.form.cote != '') || ($uneCote.cert.cote != '')}
			<tr>
				<td>{$listeCompetences.$cours.$idComp.libelle}</td>
				<td style="width: 3em; text-align:center" class="{$uneCote.form.echec|default:''}">
					{$uneCote.form.cote|default:'&nbsp;'}</td>
				<td style="width: 3em; text-align:center" class="{$uneCote.form.echec|default:''}">
					{$uneCote.form.maxForm|default:'&nbsp;'}</td>
				<td style="width: 3em; text-align:center" class="{$uneCote.cert.echec|default:''}">
					{$uneCote.cert.cote|default:'&nbsp;'}</td>
				<td style="width: 3em; text-align:center" class="{$uneCote.cert.echec|default:''}">
					{$uneCote.cert.maxCert|default:'&nbsp;'}</td>
			</tr>
			{/if} {/foreach} {/if}
		</table>

	</div>
	<!-- col-md-... -->

</div>
<!-- row -->

{/foreach} {/if} {* isset($listeCoursGrp *}

<div class="row">

	<!-- attitudes -->
	{if $attitudes}
	<div class="col-md-6 col-sm-12">
		<div class="table-responsive">
			<table class="table table-condensed table-header-rotated">
				<thead>
					<tr>
						<th></th>
						{foreach from=$attitudes.$noBulletin.$matricule key=coursGrp item=uneBranche}
						<th class="rotate">
							<div><span>{$uneBranche.cours}</span></div>
						</th>
						{/foreach}
					</tr>
				</thead>
				<tr>
					<td>Respect des autres</td>
					{foreach from=$attitudes.$noBulletin.$matricule item=uneBranche}
					<td {if $uneBranche.att1=='N' }class="echec" {/if}>{$uneBranche.att1}</td>
					{/foreach}
				</tr>
				<tr>
					<td>Respect des consignes</td>
					{foreach from=$attitudes.$noBulletin.$matricule item=uneBranche}
					<td {if $uneBranche.att2=='N' }class="echec" {/if}>{$uneBranche.att2}</td>
					{/foreach}
				</tr>
				<tr>
					<td>Volonté de progresser</td>
					{foreach from=$attitudes.$noBulletin.$matricule item=uneBranche}
					<td {if $uneBranche.att3=='N' }class="echec" {/if}>{$uneBranche.att3}</td>
					{/foreach}
				</tr>
				<tr>
					<td>Ordre et soin</td>
					{foreach from=$attitudes.$noBulletin.$matricule item=uneBranche}
					<td {if $uneBranche.att4=='N' }class="echec" {/if}>{$uneBranche.att4}</td>
					{/foreach}
				</tr>
			</table>
		</div>
		<!-- table-responsive -->

	</div>
	<!-- col-md-... -->
	{/if}

	<!-- Éducateurs -->
	{if $commentairesEducs != Null}
	<div class="col-md-6 col-sm-12">
		<h3>Note des éducateurs</h3>
		<table class="tableauBulletin remarque">
			{foreach from=$commentairesEducs key=acronyme item=data}
			<tr>
				<td>{$data.commentaire}</td>
			</tr>
			<tr style="text-align:right">
				<td>{$data.prenom|substr:0:1}. {$data.nom}{if $data.titre != ''}<span class="small"> ({$data.titre})</span>{/if}</td>
			</tr>
			{/foreach}

		</table>
	</div>
	{/if}

	{assign var=laMention value=$mention.$matricule.$ANNEESCOLAIRE.$annee.$bulletin|default:Null}
	<div class="col-md-6 col-sm-12">
		{if isset($laMention)}
		<div class="alert alert-info">
			<strong><i class="fa fa-graduation-cap fa-lg"></i> Mention: {$laMention|default:''}</strong>
		</div>
		{/if}

		<table class="table table-condensed">
			<thead>
				<tr>
					<th>
						<h3>Avis du titulaire ou du Conseil de Classe</h3>
					</th>
				</tr>
			</thead>
			<tr>
				<td>{$remTitu|default:'&nbsp;'}</td>
			</tr>
		</table>

		{if isset($noticeDirection)}
		<table class="table">
			<tr>
				<thead>
					<th>
						<h3>Informations de la direction et des coordinateurs</h3>
					</th>
				</thead>
			</tr>
			<tr>
				<td>{$noticeDirection}</td>
			</tr>
		</table>
		{/if}
	</div>

</div>
<!-- row -->


{/if} {* if $noBulletin *}
