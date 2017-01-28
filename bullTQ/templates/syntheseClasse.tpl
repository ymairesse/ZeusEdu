<div class="container">

<div class="table-responsive">

	<table class="tableauAdmin table table-hover" style="width:100%">
	<tr>
		<th><h2>Classe: {$classe}</h2></th>

		{foreach from=$listeCours key=cours item=detailsCours}
			<th style="text-align:center"
				class="pop"
				data-toggle="popover"
				data-content="{$detailsCours.dataCours.libelle} {$detailsCours.dataCours.nbheures}h <br />{$detailsCours.dataCours.statut}"
				data-html="true"
				data-placement="bottom"
				data-container="body">
			<img src="imagesCours/{$cours}.png" alt="{$cours}">
			</th>
		{/foreach}

	</tr>
	{foreach from=$listeEleves key=matricule item=dataEleve}
	<tr>
		{assign var=nomPrenom value=$dataEleve.nom|cat:' '|cat:$dataEleve.prenom}
		<td class="pop"
			data-toggle="popover"
			data-content = "<img src='../photos/{$dataEleve.photo}.jpg' alt='{$matricule}' width='100px'><br><span class='micro'{$nomPrenom|truncate:18}<br>{$matricule}</span>"
			data-html = "true"
			data-placement="right"
			data-container = "body">

			{$dataEleve.nom} {$dataEleve.prenom}

		</td>
		{foreach from=$listeCours key=cours item=detailsCours}
			{assign var=data value=$listeSituations.$matricule.$cours.$bulletin|default:''}

			{if isset($listeCoursEleves.$matricule.$cours)}
				{assign var=coursGrp value=$listeCoursEleves.$matricule.$cours.coursGrp}
				{assign var=nomCours value=$listeCours.$cours.dataCours.libelle}
				{assign var=texte value=$listeCours.$cours.profs.$coursGrp|implode:', '|default:''|cat:'<br>'|cat:$nomCours}
				{else}
				{assign var=texte value=Null}
			{/if}

			<td	class="pop {if isset($data.cote) && (($data.cote =='I') || ($data.cote == 'TI'))} echec{/if}"
				data-toggle="popover"
				data-content="{$texte}"
				data-html="true"
				data-placement="bottom"
				data-original-title="{$nomPrenom}"
				data-container="body">

			{if isset($listeCoursEleves.$matricule.$cours)}
				{$data.cote|default:'-'}
			{else}
				X
			{/if}

			</td>
		{/foreach}
	</tr>
	{/foreach}
	</table>

	</div>  <!-- table-responsive -->

</div>  <!-- container -->


<script type="text/javascript">

	$('document').ready(function(){

		$(".popover-eleve").mouseover(function(){
		$(this).popover('show');
		})

	$(".popover-eleve").mouseout(function(){
		$(this).popover('hide');
		})

	})


</script>
