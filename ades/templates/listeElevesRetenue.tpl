<div class="container">
	
<h3>{$infosRetenue.jourSemaine|ucfirst}, le {$infosRetenue.dateRetenue}</h3>

<div class="table-responsive">
	
	<table class="table table-hover table-bordered">
		<caption>
			<h4>{$infosRetenue.titrefait}: {$infosRetenue.local} {$infosRetenue.heure} durée: {$infosRetenue.duree}h</h4>
			<p>Nombre d'élèves {$infosRetenue.occupation} / {$infosRetenue.places}</p>
		</caption>
		<thead>
			<tr>
				<th>&nbsp;</th>
				<th>Nom de l'élève</th>
				<th>Classe</th>
				<th>Travail à effectuer</th>
				<th>Professeur</th>
				<th>Présent</th>
				<th>Signé</th>
			</tr>
		</thead>
		{assign var=n value=1}
		{foreach from=$listeEleves key=matricule item=unEleve}
			<tr>
			<th>{$n}</th>
			<td class="pop"
				data-toggle="popover"
				data-content="<img src='../photos/{$unEleve.photo}.jpg' style='width:100px' alt='{$matricule}' class='noprint'>"
				data-container="body"
				data-html="true"
				data-placement="right"
				data-original-title="<span class='noprint'>{$unEleve.nom|cat:' '|cat:$unEleve.prenom|truncate:15:''}</span>">
			{$unEleve.nom} {$unEleve.prenom}
			</td>
			<td>{$unEleve.groupe|default:'&nbsp;'}</td>
			<td>{$unEleve.travail|default:'&nbsp;'}</td>
			<td>{$unEleve.professeur|default:'&nbsp;'}</td>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			{assign var=n value=$n+1}
			</tr>
		{/foreach}
		
	</table>

</div>

</div>

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