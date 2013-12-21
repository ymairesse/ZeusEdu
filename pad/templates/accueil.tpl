<h2>Bloc Notes</h2>
<fieldset class="cadreGauche">	
	<legend>Actuellement</legend>
	<img src="../images/pad.png" style="float:left; margin: 2em; padding: 1em;" class="photoEleve" alt="Bloc Notes">
	<div style="margin-left: 10em;">
	<p>Nous sommes le <strong>{$smarty.now|date_format:'%d/%m/%Y'}</strong> et il est déjà <strong>{$smarty.now|date_format:'%Hh%M'}</strong></p>
	<p>A l'heure qu'il est, nous avons</p>
	<ul>
		<li><strong>{$nbClasses}</strong> Classes</li>
		<li><strong>{$nbEleves}</strong> Élèves</li>
	</ul>
	</div>
</fieldset>

<fieldset class="cadreGauche">
	<legend>Prochains anniversaires</legend>
	<div id="accordion">
		<h3>Aujourd'hui: le <strong>{$smarty.now|date_format:"%A"} {$smarty.now|date_format:"%d/%m"}</strong></h3>
		<div>
			{assign var=jour value=$statAccueil.listeAnniv[1]}
			<ul>
				{foreach from=$jour item=day}
				{assign var=matricule value=$day.matricule}
				{assign var=nomPrenom value=$day.nomPrenom}
				<li>
					<a href="index.php?action=parEleve&amp;matricule={$matricule}">{$day.groupe} <strong>{$day.nomPrenom}</strong></a>
				</li>
				{/foreach}
			</ul>
		</div>
		
		<h3>Demain: le <strong>{"+1 days"|date_format:"%A"} {"+1 days"|date_format:"%d/%m"}</strong></h3>
		<div>
			{assign var=jour value=$statAccueil.listeAnniv[2]}
			<ul>
				{foreach from=$jour item=day}
				{assign var=matricule value=$day.matricule}
				{assign var=nomPrenom value=$day.nomPrenom}
				<li><a href="index.php?action=parEleve&amp;matricule={$matricule}">{$day.groupe} <strong>{$day.nomPrenom}</strong></a></li>
				{/foreach}
			</ul>
		</div>
		
		<h3>Dans deux jours: le <strong>{"+2 days"|date_format:"%A"} {"+2 days"|date_format:"%d/%m"}</strong></h3>
		<div>
			{assign var=jour value=$statAccueil.listeAnniv[3]}
			<ul>
				{foreach from=$jour item=day}
				{assign var=matricule value=$day.matricule}
				{assign var=nomPrenom value=$day.nomPrenom}			
				<li><a href="index.php?action=parEleve&amp;matricule={$matricule}">{$day.groupe} <strong>{$day.nomPrenom}</strong></a></li>
				{/foreach}
			</ul>
		</div>
		
		<h3>Dans trois jours: le <strong>{"+3 days"|date_format:"%A"} {"+3 days"|date_format:"%d/%m"}</strong></h3>
		<div>
			{assign var=jour value=$statAccueil.listeAnniv[4]}
			<ul>
				{foreach from=$jour item=day}
				{assign var=matricule value=$day.matricule}
				{assign var=nomPrenom value=$day.nomPrenom}			
				<li><a href="index.php?action=parEleve&amp;matricule={$matricule}">{$day.groupe} <strong>{$day.nomPrenom}</strong></a></li>
				{/foreach}
			</ul>
		</div>
		
	</div> <!-- accordion -->
</fieldset>

<script type="text/javascript">
	{literal}
	$(document).ready(function(){
		$("#accordion").accordion()
		})
	{/literal}
</script>