


{assign var=listeFaitsAnnees value=$ficheDisc->laListeFaits()}
{assign var=listeRetenues value=$ficheDisc->laListeRetenues()}

<div class="container">

	<!-- Tabs différentes années scolaires -->
    <ul class="nav nav-tabs navbar-right hidden-print" id="tabsDisc">
		{foreach from=$listeFaitsAnnees key=anneeScolaire item=wtf}
			<li><a href="#tab{$anneeScolaire}" data-toggle="tab">{$anneeScolaire}</a></li>
		{/foreach}
    </ul>
    <!-- Tabs -->

	<div class="row">

		<div class="col-md-10 col-sm-10">

			<!-- Tabs fiches disciplinaires -->
			<div class="tab-content">
			{assign var=tour value=0}
			{foreach from=$listeFaitsAnnees key=anneeScolaire item=listeFaits}

			<div class="tab-pane{if $tour == 0} active{assign var=tour value=$tour+1}{else} hidden-print{/if}" id="tab{$anneeScolaire}">
				<h3>{$anneeScolaire}</h3>
					{foreach from=$listeTypesFaits key=typeFait item=descriptionTypeFait}
						{* si un fait de ce type figure dans la fiche disciplinaire *}
						{if isset($listeFaits[$typeFait])}
						{* on se trouve dans le contexte "tableau" *}
						{assign var=contexte value='tableau'}

						{* on indique le titre de ce type de faits *}
						<h3 style="clear:both;background-color: #{$descriptionTypeFait.couleurFond}; color: #{$descriptionTypeFait.couleurTexte}">
							{$descriptionTypeFait.titreFait}</h3>

						<div class="table-responsive">
							<table class="table table-striped table-condensed tableauBull">
								{* ----------------- ligne de titre du tableau  -------------------------- *}
								<tr>
									{strip}
									{* on examine chacun des champs qui décrivent le fait *}
									{foreach from=$descriptionTypeFait.listeChamps item=champ}
										{* si le champ intervient dans le contexte (ici, "tableau"), on écrit le label corredpondant*}
										{if in_array($contexte, $descriptionChamps.$champ.contextes)}
											<th>{$descriptionChamps.$champ.label}</th>
										{/if}
									{/foreach}
									{/strip}
								</tr>
								{* // ----------------- ligne de titre du tableau  -------------------------- *}

								{* ------------------ description du fait -------------------------------- *}
								{foreach from=$listeFaits.$typeFait key=idfait item=unFaitDeCeType}
								<tr>


									{foreach from=$descriptionTypeFait.listeChamps item=champ}
										{strip}
										{if in_array($contexte, $descriptionChamps.$champ.contextes)}
										<td>
											{* s'il s'agit d'une retenue (typeFait 4, 5 ou 6), les informations suivantes se trouvent dans la liste des retenues de cet élève *}
											{if in_array($typeFait,array('4','5','6')) && (in_array($champ,array('dateRetenue','heure','duree','local')))}

												{assign var=idretenue value=$unFaitDeCeType.idretenue}
												{if isset($listeRetenues.$idretenue)}
													{assign var=typeRetenue value=$listeRetenues.$idretenue}
													{if $descriptionChamps.$champ.typeDate == '1'}
														{$listeRetenues.$idretenue.$champ|default:'&nbsp;'}
														{else}
														{$listeRetenues.$idretenue.$champ|default:'&nbsp;'}
													{/if}
												{/if}
											{else}
											{$unFaitDeCeType.$champ|default:'&nbsp;'}
											{/if}
										</td>
										{/if}
										{/strip}
									{/foreach}

								</tr>
								{/foreach}
								{* // ------------------ description du fait -------------------------------- *}

							</table>
						</div>  <!-- table -->
						{/if}
					{/foreach}
			</div>  <!-- tab-pane -->

			{/foreach}

			</div>  <!-- tab-content (fiches disciplinaires -->
		</div>  <!-- col-md... -->

		<div class="col-md-2 col-sm-2 hidden-print">
			<img src="../photos/{$eleve.photo}.jpg" alt="{$matricule}" class="draggable photo img-responsive thumbnail" title="{$eleve.prenom} {$eleve.nom}">

		</div>


	</div>  <!-- row -->
</div>  <!-- container -->
