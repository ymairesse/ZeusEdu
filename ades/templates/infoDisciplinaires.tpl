<img style="float:right; height:150px; position: relative; top: -150px; margin-bottom: -150px" src="../photos/{$eleve.photo}.jpg" alt="{$eleve.matricule}" class="photo draggable" title="{$eleve.prenom} {$eleve.nom} {$eleve.matricule}">

{if ($userStatus == 'educ') || ($userStatus == 'admin')}
{* boutons pour ajouter un fait disciplinaire *}
<ul class="boutonFait" style="height: 3em">
{foreach from=$listeTypesFaits item=unTypeFait}
	<li style="background-color:#{$unTypeFait.couleurFond};" class="photo">
		<a href="index.php?action=fait&mode=new&amp;matricule={$eleve.matricule}&amp;type={$unTypeFait.type}" style="color:#{$unTypeFait.couleurTexte}">{$unTypeFait.titreFait}</a>
	</li>
{/foreach}
</ul>
{/if}

{assign var=listeFaitsAnnees value=$ficheDisc->laListeFaits()}
{assign var=listeRetenues value=$ficheDisc->laListeRetenues()}

{* des onglets pour les différentes années scolaires *}
{if count($listeFaitsAnnees)>0}
<div id="tabsDisc">
	<ul>
		{foreach from=$listeFaitsAnnees key=anneeScolaire item=wtf}
			<li><a href="#tab{$anneeScolaire}">{$anneeScolaire}</a></li>
		{/foreach}
	</ul>

{foreach from=$listeFaitsAnnees key=anneeScolaire item=listeFaits}
<div id="tab{$anneeScolaire}">
{* on prend tous les types de faits disponibles et on les évalue *}
{* pour chaque type de fait, on considère ses caractéristiques propres (titre, couleurs, liste des champs,...) *}
	{foreach from=$listeTypesFaits key=typeFait item=descriptionTypeFait}
		{* si un fait de ce type figure dans la fiche disciplinaire *}
		{if isset($listeFaits[$typeFait])}
		{* on se trouve dans le contexte "tableau" *}
		{assign var=contexte value='tableau'}
		{* on indique le titre de ce type de faits *}
		<h3 style="clear:both;background-color: #{$descriptionTypeFait.couleurFond}; color: #{$descriptionTypeFait.couleurTexte}">
			{$descriptionTypeFait.titreFait}</h3>

		<table class="tableauBull">
			{* ----------------- ligne de titre du tableau  -------------------------- *}
			<tr>
				<th>&nbsp;</th>
				{strip}
				{if $descriptionTypeFait.imprimable == 1}
				<th style="width:16px">&nbsp;</th>
				{/if}
			{* on examine chacun des champs qui décrivent le fait *}
			{foreach from=$descriptionTypeFait.listeChamps item=champ}
				{* si le champ intervient dans le contexte (ici, "tableau"), on écrit le label corredpondant*}
				{if in_array($contexte, $descriptionChamps.$champ.contextes)}
				<th>{$descriptionChamps.$champ.label}</th>
				{/if}
			{/foreach}
				<th style="width:16px">&nbsp;</th>
				{/strip}
			</tr>
			{* ----------------- ligne de titre du tableau  -------------------------- *}

			{foreach from=$listeFaits.$typeFait key=idfait item=unFaitDeCeType}
			<tr>
				{strip}
				<td style="width:16px">
					<a class="delete" href="index.php?action=fait&amp;mode=suppr&amp;idfait={$idfait}&amp;matricule={$eleve.matricule}" title="Supprimer ce fait">
						<img src="../images/suppr.png" alt="X"></a>
				</td>
				{if $descriptionTypeFait.imprimable == 1}
				<td style="width:16px">
					{if ($userStatus == 'educ') || ($userStatus == 'admin')}
					<a href="index.php?action=print&amp;mode=retenue&amp;idfait={$idfait}&amp;matricule={$matricule}"><img src="../images/print.png" alt="P" title="Imprimer"></a>
					{else}&nbsp;
					{/if}
				</td>
				{/if}
				{foreach from=$descriptionTypeFait.listeChamps item=champ}
					{if in_array($contexte, $descriptionChamps.$champ.contextes)}
					<td>
						{strip}
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
						{/strip}
					</td>
					{/if}
				{/foreach}
				<td style="width:16px">
					{strip}
					{if ($userStatus == 'educ') || ($userStatus == 'admin')}
					<a href="index.php?action=fait&amp;mode=edit&amp;idfait={$idfait}&amp;matricule={$eleve.matricule}"  title="Modifier ce fait"><img src="../images/edit.png" alt="E"></a>
					{else}&nbsp;
					{/if}
					{/strip}
				</td>
				{/strip}
			</tr>
			{/foreach}

		</table>
		{/if}
	{/foreach}
</div>
{/foreach}

</div> <!-- tabsDisc -->
{/if}

<script type="text/javascript">
$(document).ready(function(){
	$("#tabsDisc").tabs({ heightStyle: "auto" });
	})
</script>
