{if isset($infoPerso)}
<div class="container-fluid">

	<h1 style="clear:both" title="{$infoPerso.matricule}">{$infoPerso.nom} {$infoPerso.prenom} : {$infoPerso.classe} | Bulletin n° {$bulletin}</h1>
	<img src="../photos/{$infoPerso.matricule}.jpg" title="{$infoPerso.matricule}" alt="{$infoPerso.matricule}"
		style="position: absolute; top: 0em; right: 0; width: 100px" class="photo">

	{if isset($listeCoursGrp)}

	{foreach from=$listeCoursGrp key=coursGrp item=unCours}

	<div class="row" style="border-bottom: 1px solid black; padding-bottom:0.5em">
		<div class="col-md-6 col-sm-12">
			<h2 class="titreCours" title="{$coursGrp}">{$unCours.libelle} {$unCours.nbheures}h</h2>
			<p>{$listeProfsCoursGrp.$coursGrp}</p>

			{if isset($commentaires.$matricule.$coursGrp) && ($commentaires.$matricule.$coursGrp.$bulletin != '')}
			<table class="tableauBulletin">
				<tr>
					<th>Remarque</th>
				</tr>
				<tr>
					<td>{$commentaires.$matricule.$coursGrp.$bulletin|default:'&nbsp;'}</td>
				</tr>
			</table>
			{/if}
		</div>
		<div class="col-md-6 col-sm-12">&nbsp; </div>
		<div class="col-md-6 col-sm-12">
			{if isset($sitPrecedentes.$matricule.$coursGrp.sit)}
				<strong>Situation précédente: {$sitPrecedentes.$matricule.$coursGrp.sit} / {$sitPrecedentes.$matricule.$coursGrp.maxSit}</strong>
			{/if}
		</div>
		<div class="col-md-6 col-sm-12">
			<div style="display:block; border: 1px solid black; min-height: 1.5em; color: white; background-color: #555;">
			{if isset($sitActuelles.$matricule.$coursGrp.sit) && ($sitActuelles.$matricule.$coursGrp.sit|is_numeric)}
				{assign var=sitActuelle value=$sitActuelles.$matricule.$coursGrp}

				<strong>Situation actuelle: {$sitActuelle.sit} / {$sitActuelle.maxSit}</strong>
				{if $sitActuelle.maxSit > 0}
					{assign var=sitAct value=100*$sitActuelle.sit/$sitActuelle.maxSit}
					<span class="micro">soit {$sitAct|number_format:1}%</span>
				{/if}

				{if isset($sitActuelle.sitDelibe) && $sitActuelle.sitDelibe != ''}
					<strong class="pull-right">Délibé:
					{if isset($sitActuelle.attribut) && ($sitActuelle.attribut == 'hook')}[{$sitActuelle.sitDelibe}] %
					{else}
					{$sitActuelle.sitDelibe}
						<sup>{$sitActuelle.symbole}</sup> %
					{/if}
					</strong>
				{/if}

			{/if}
			</div>
		</div>

		<div class="col-md-6 col-sm-12">

				<table class="tableauBulletin">
					<tr>
						<th style="width:15em">Compétence</th>

						<th style="width: 6em; text-align:center" colspan="2" class="{$cotesPonderees.$matricule.$coursGrp.form.echec|default:''}">
							TJ: <strong>
								{if isset($cotesPonderees.$matricule.$coursGrp.form.cote)}
									{$cotesPonderees.$matricule.$coursGrp.form.cote}/{$cotesPonderees.$matricule.$coursGrp.form.max}
								{else}
									&nbsp;
								{/if}
								</strong>
						</th>

						<th style="width: 6em; text-align:center" colspan="2" class="{$cotesPonderees.$matricule.$coursGrp.cert.echec|default:''}">
							Cert: <strong>
								{if isset($cotesPonderees.$matricule.$coursGrp.cert.cote)}
									{$cotesPonderees.$matricule.$coursGrp.cert.cote}/{$cotesPonderees.$matricule.$coursGrp.cert.max}
								{else}
									&nbsp;
							{/if}
							</strong>
						</th>

					</tr>
					{* s'il y a des cotes pour ce coursGrp *}
					{if isset($listeCotes.$matricule.$coursGrp)}

					{assign var='lesCotes' value=$listeCotes.$matricule.$coursGrp}
					{assign var='cours' value=$unCours.cours}
						{foreach from=$listeCotes.$matricule.$coursGrp key=idComp item=uneCote}
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
						{/if}
						{/foreach}

					{/if}
				</table>
			</div>



		</div>  <!-- row -->

		{/foreach}

		<div class="row">
		<!-- attitudes -->
		{if $attitudes}
		<div class="col-md-6 col-sm-12">
			<table class="table table-condensed">
				<tr>
					<th style="vertical-align:bottom; text-align:center;">Attitudes</th>
					{foreach from=$attitudes.$bulletin.$matricule key=coursGrp item=uneBranche}
						<th><img src="imagesCours/{$uneBranche.cours}.png" alt="{$uneBranche.cours}"></th>
					{/foreach}
				</tr>
				<tr>
					<td>Respect des autres</td>
					{foreach from=$attitudes.$bulletin.$matricule item=uneBranche}
						<td {if $uneBranche.att1 == 'N'}class="echec"{/if}>{$uneBranche.att1}</td>
					{/foreach}
				</tr>
					<tr>
					<td>Respect des consignes</td>
					{foreach from=$attitudes.$bulletin.$matricule item=uneBranche}
						<td {if $uneBranche.att2 == 'N'}class="echec"{/if}>{$uneBranche.att2}</td>
					{/foreach}
				</tr>
					<tr>
					<td>Volonté de progresser</td>
					{foreach from=$attitudes.$bulletin.$matricule item=uneBranche}
						<td {if $uneBranche.att3 == 'N'}class="echec"{/if}>{$uneBranche.att3}</td>
					{/foreach}
				</tr>
					<tr>
					<td>Ordre et soin</td>
					{foreach from=$attitudes.$bulletin.$matricule item=uneBranche}
						<td {if $uneBranche.att4 == 'N'}class="echec"{/if}>{$uneBranche.att4}</td>
					{/foreach}
				</tr>
			</table>
			</div>
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
			<div class="alert alert-info"
				{if $laMention != Null}
					title="figure dans la feuille de délibé individuelle; sera reportée dans le bulletin imprimé"
				{else}
					title="La mention obtenue par l'élève ne figure pas encore dans la feuille de délibé individuelle"
				{/if}>
				<strong><i class="fa fa-graduation-cap fa-lg"></i> Mention: {$laMention|default:''}</strong>
			</div>

			{if isset($remTitu) && ($remTitu != Null)}
			<div class="panel panel-info">
				<div class="panel-heading">
					Avis du titulaire ou du Conseil de Classe
				</div>
				<div class="panel-body">
					{$remTitu}
				</div>
			</div>
			{/if}

			{if isset($noticeDirection)}
			<div class="panel panel-info">
				<div class="panel-heading">
					Informations de la direction et des coordinateurs
				</div>
				<div class="panel-body">
					{$noticeDirection}
				</div>
			</div>
			{/if}

		</div>

		<div class="col-md-6 col-sm-12">

			{if $noticeParcours != Null}
			<div class="panel panel-default">
				<div class="panel-header">
					Poursuite des études
				</div>
				<div class="panel-body">
					{$noticeParcours}
				</div>
			{/if}
			</div>
		</div>
	</div>  <!-- row -->

</div>  <!-- container -->
{/if}

{/if}  {* if $infoPerso *}


<script type="text/javascript">

	$(document).ready(function(){

		$().UItoTop({ easingType: 'easeOutQuart' });

	})

</script>
