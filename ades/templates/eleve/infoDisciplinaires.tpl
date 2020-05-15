{if ($userStatus == 'educ') || ($userStatus == 'admin')}

	{* boutons pour ajouter un fait disciplinaire *}
	<div class="btn-group hidden-print">
		{foreach from=$listeTypesFaits item=unTypeFait}
		<button class="btn newFait" type="button"
			style="color:{$unTypeFait.couleurTexte};background-color:{$unTypeFait.couleurFond}"
			data-matricule="{$eleve.matricule}"
			data-classe="{$eleve.classe}"
			data-typefait="{$unTypeFait.type}">
			{$unTypeFait.titreFait}
		</button>
		{/foreach}
	</div>

{/if}

<div class="container-fluid">

	<div class="row">

		<div class="col-xs-12">
			<!-- Tabs différentes années scolaires -->
			<ul class="nav nav-tabs navbar-right hidden-print" id="tabsDisc">
				{foreach from=$listeTousFaits key=anneeScolaire item=wtf name=boucleAnScol}
				<li {if $smarty.foreach.boucleAnScol.iteration == 1}class="active"{/if} data-anneescolaire="{$anneeScolaire}">
					<a href="#tab{$anneeScolaire}"
						data-anneescolaire="{$anneeScolaire}"
						data-toggle="tab">
						{$anneeScolaire}
					</a>
				</li>
				{/foreach}
			</ul>
			<!-- Tabs -->
		</div>
	</div>

	<div class="row">

		<div class="col-md-10 col-sm-10">

			<!-- Tabs fiches disciplinaires -->
			<div class="tab-content">
				{assign var=tour value=0}

				{foreach from=$listeTousFaits key=anneeScolaire item=listeFaits}

				<div class="tab-pane{if $tour == 0} active{assign var=tour value=$tour+1}{else} hidden-print{/if}" id="tab{$anneeScolaire}">

					<h3>
						<button type="button" id="openAll" class="btn btn-success btn-xs"><i class="fa fa-arrow-down"></i></button>
						{$anneeScolaire}
						<a target="_blank" href="inc/printFicheCourante.php?matricule={$eleve.matricule}&amp;anScol={$anneeScolaire}" class="btn btn-primary btn-xs pull-right">
							<i class="fa fa-print"></i> Imprimer
						</a>
					</h3>
					{foreach from=$listeTypesFaits key=typeFait item=descriptionTypeFait}
					{* si un fait de ce type figure dans la fiche disciplinaire *}
					{if isset($listeFaits[$typeFait])}
					{* on se trouve dans le contexte "tableau" *}
					{assign var=contexte value='tableau'}

					{* on indique le titre de ce type de faits *}
					<h3 style="clear:both;background-color: {$descriptionTypeFait.couleurFond}; color: {$descriptionTypeFait.couleurTexte}">
						<button type="button" class="btn btn-warning btn-xs openThis"><i class="fa fa-arrow-right"></i></button>
							{$descriptionTypeFait.titreFait}
							{if $descriptionTypeFait.print == 1}<i class="fa fa-print pop" title="Ce type de fait sera imprimé dans la fiche disciplinaire PDF"></i>{/if}
							<span class="badge pull-right" style="background:red"> {$listeFaits.$typeFait|@count}</span>
					</h3>

					<div class="table-responsive">

						<table class="table table-striped table-condensed tableauBull">
							{* ----------------- ligne de titre du tableau -------------------------- *}
							<tr>
								<th>&nbsp;</th>
								{strip}
								{if $descriptionTypeFait.typeRetenue != 0}
									<th style="width:1em">&nbsp;</th>
									<th style="width:1em">&nbsp;</th>
								{/if}
								{* on examine chacun des champs qui décrivent le fait *}
								{foreach from=$descriptionTypeFait.listeChamps item=champ}
								{* si le champ intervient dans le contexte (ici, "tableau"), on écrit le label corredpondant *}
									{if in_array($contexte, $descriptionChamps.$champ.contextes)}
										<th>{$descriptionChamps.$champ.label}</th>
									{/if}
								{/foreach}
								{/strip}
								<th style="width:16px">&nbsp;</th>
							</tr>
							{* // ----------------- ligne de titre du tableau -------------------------- *}

							{* ------------------ description du fait -------------------------------- *}

							{foreach from=$listeFaits.$typeFait key=idfait item=unFaitDeCeType}
							<tr data-idfait="{$idfait}">
								<td style="width:1em">
									{if ($userStatus == 'educ') || ($userStatus == 'admin')}
									<button type="button" class="btn btn-danger btn-xs delete" data-idfait="{$idfait}" title="Supprimer ce fait">
										<i class="fa fa-times"></i>
									</button>
									{else}
									&nbsp;
									{/if}
								</td>

								{if $descriptionTypeFait.typeRetenue != 0}
								<td style="width:1em">
									{if ($userStatus == 'educ') || ($userStatus == 'admin')}
									<a href="inc/retenues/printRetenue.php?idfait={$idfait}"
										target="_blank"
										class="btn btn-info btn-xs">
										<i class="fa fa-print"></i>
									</a>
									{else}&nbsp;
									{/if}
								</td>

								<td style="width:1em">
									{if ($userStatus == 'educ') || ($userStatus == 'admin')}
									<button type="button"
										class="btn btn-success btn-xs send-eDoc"
										data-idfait="{$idfait}"
										data-matricule="{$matricule}"
										title="Mail aux parents">
										<i class="fa fa-mail-forward"></i>
									</button>
									{else}
										&nbsp;
									{/if}
								</td>
								{/if}

								{foreach from=$descriptionTypeFait.listeChamps item=champ}
									{strip}
									{if in_array($contexte, $descriptionChamps.$champ.contextes)}
									<td>
										{* s'il s'agit d'une retenue, les informations suivantes se trouvent dans la liste des retenues de cet élève *}
										{assign var=type value=$descriptionTypeFait.type}
										{if ($listeTypesFaits.$type.typeRetenue > 0) && (in_array($champ,array('dateRetenue','heure','duree','local')))}
											{assign var=idretenue value=$unFaitDeCeType.idretenue}
											{$listeRetenuesEleve.$idretenue.$champ}
										{else}
											{$unFaitDeCeType.$champ|default:'&nbsp;'}
										{/if}
									</td>
									{/if}
									{/strip}
								{/foreach}

								<td style="width:16px">
									{if ($userStatus == 'educ') || ($userStatus == 'admin')}
									<button type="button" class="btn btn-success btn-xs edit" data-matricule="{$eleve.matricule}" data-idfait="{$idfait}" data-typefait="{$typeFait}" title="Modifier ce fait">
										<i class="fa fa-edit"></i>
									</button>

									{else}&nbsp;
									{/if}
								</td>
							</tr>
							{/foreach} {* // ------------------ description du fait -------------------------------- *}

						</table>
					</div>
					<!-- table -->
					{/if}
					{/foreach}
				</div>
				<!-- tab-pane -->

				{/foreach}

			</div>
			<!-- tab-content (fiches disciplinaires -->
		</div>
		<!-- col-md... -->

		<div class="col-md-2 col-sm-2 hidden-print">

			<img src="../photos/{$eleve.photo}.jpg" alt="{$eleve.matricule}" class="photo img-responsive thumbnail" title="{$eleve.prenom} {$eleve.nom}">

		</div>

	</div>
	<!-- row -->
</div>
<!-- container -->
