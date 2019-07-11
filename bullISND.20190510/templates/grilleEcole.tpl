<div class="container">

	<h2>Ecole: {$detailsEcole.nomEcole}</h2>
	<h3>{$detailsEcole.adresse} {$detailsEcole.cpostal} {$detailsEcole.commune}</h3>
	
	<div class="table-responsive">
	
	<table class="table table-hover table-condensed">
		<tr>
			<th>
				<p style="clear:both; padding-top: 2em;">Nom de l'élève</p>
			</th>
			{foreach from=$listeCoursEleves key=cours item=unCours}
				<th title="[{$cours}]| {$unCours.libelle}" data-container="body">
					<img src="imagesCours/{$cours}.png" ><br />{$unCours.nbheures}h {$unCours.statut}
				</th>
			{/foreach}
		</tr>
		{foreach from=$listeEleves key=matricule item=unEleve}
		<tr>
			<td>
				<span style="cursor:pointer"
					  class="popover-eleve"
					  data-toggle="popover"
					  data-content="<img src='../photos/{$unEleve.photo}.jpg' alt='{$matricule}' style='width:100px'>"
					  data-html="true"
					  data-container="body"
					  data-original-title="{$unEleve.identite}"
					  >
				{$unEleve.identite|truncate:25:'...'}
				</span>
			</td>
			{foreach from=$listeCoursEleves key=cours item=unCours}
				{if isset($listeSituations.$matricule.$cours.sit100)}
					<td{if isset($listeSituations.$matricule.$cours)} 
						class="mention{$listeSituations.$matricule.$cours.mention}"
						title="{$cours}" data-container="body"
						{/if}>
					{$listeSituations.$matricule.$cours.sit100|default:'&nbsp;'}
					</td>
					{else}
					<td>&nbsp;</td>
				{/if}
			{/foreach}
		</tr>
		{/foreach}
	
	</table>

	</div>	
	
	<table class="table">
	
	<tr>
		<td colspan="6">Code de couleurs</td>
	</tr>
	<tr>
		<td style="width:4em" class="mentionI">< 50</td>
		<td style="width:4em" class="mentionF">50</td>
		<td style="width:4em" class="mentionS">60</td>
		<td style="width:4em" class="mentionAB">65</td>
		<td style="width:4em" class="mentionB">70</td>
		<td style="width:4em" class="mentionTB">> 80</td>
	</tr>
	</table>

</div>  <!-- container -->


<script type="text/javascript">
	
	$(document).ready(function(){
		
	$(".popover-eleve").mouseenter(function(event){
		$(this).popover('show');
		})
	
	$(".popover-eleve").mouseout(function(event){
		$(this).popover('hide');
		})
		
		})
	
	
</script>