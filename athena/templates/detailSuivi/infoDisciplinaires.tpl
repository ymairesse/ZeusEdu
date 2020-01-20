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

		<div class="col-sm-12">

			<!-- Tabs fiches disciplinaires -->
			<div class="tab-content">
				{assign var=tour value=0}

				{foreach from=$listeTousFaits key=anneeScolaire item=listeFaits}

				<div class="tab-pane{if $tour == 0} active{assign var=tour value=$tour+1}{else} hidden-print{/if}" id="tab{$anneeScolaire}">
				{if $listeFaits != Null}
					{foreach from=$listeTypesFaits key=typeFait item=descriptionTypeFait}
					{* si un fait de ce type figure dans la fiche disciplinaire *}
					{if isset($listeFaits[$typeFait])}
					{* on se trouve dans le contexte "tableau" *}
					{assign var=contexte value='tableau'}

					{* on indique le titre de ce type de faits *}
					<h3 style="clear:both;background-color: {$descriptionTypeFait.couleurFond}; color: {$descriptionTypeFait.couleurTexte}">
						<button type="button" class="btn btn-warning btn-xs openThis"><i class="fa fa-arrow-right"></i></button>
							{$descriptionTypeFait.titreFait}
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
								<td style="width:1em">&nbsp;</td>

								{if $descriptionTypeFait.typeRetenue != 0}
								<td style="width:1em">&nbsp;</td>
								<td style="width:1em">&nbsp;</td>
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

								<td style="width:16px">&nbsp;</td>
							</tr>
							{/foreach} {* // ------------------ description du fait -------------------------------- *}

						</table>
					</div>
					<!-- table -->
					{/if}
					{/foreach}
					{else}
					<p class="avertissement">Pas de rapport de comportement pour cette année scolaire</p>
				{/if}
				</div>
				<!-- tab-pane -->
				{/foreach}

			</div>
			<!-- tab-content (fiches disciplinaires -->
		</div>
		<!-- col-md... -->

	</div>
	<!-- row -->
</div>
<!-- container -->
