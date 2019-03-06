<div class="container-fluid">

<h2>Trombinoscope des élèves</h2>
<div class="row">

	<div class="col-md-4 col-sm-12">

		<h4>Synthèse</h4>

		<img src="../images/eleves.png" style="float:left; margin: 2em; padding: 1em;" class="photoEleve" alt="trombinoscope">

		<p>Nous sommes le <strong>{$smarty.now|date_format:'%d/%m/%Y'}</strong> et il est déjà <strong>{$smarty.now|date_format:'%Hh%M'}</strong></p>
		<p>A l'heure qu'il est, nous avons</p>
		<ul>
			<li><strong>{$nbClasses}</strong> Classes</li>
			<li><strong>{$nbEleves}</strong> Élèves</li>
		</ul>

	</div>  <!-- col-md... -->

	<div class="col-md-8 col-sm-12">

		<h4><i class="fa fa-birthday-cake"></i> Prochains Anniversaires</h4>

		<ul id="tabs" class="nav nav-tabs" data-tabs="tabs">
			<li class="active"><a href="#tabs-1" data-toggle="tab">Aujourd'hui <span class="glyphicon glyphicon-arrow-right"></span> {"+0 days"|date_format:"%d/%m"}</a></li>
			<li><a href="#tabs-2" data-toggle="tab">Demain <span class="glyphicon glyphicon-arrow-right"></span> {"+1 days"|date_format:"%d/%m"}</a></li>
			<li><a href="#tabs-3" data-toggle="tab">+2 jours <span class="glyphicon glyphicon-arrow-right"></span> {"+2 days"|date_format:"%d/%m"}</a></li>
			<li><a href="#tabs-4" data-toggle="tab">+3 jours <span class="glyphicon glyphicon-arrow-right"></span> {"+3 days"|date_format:"%d/%m"}</a></li>
		</ul>

		<div id="my-tab-content" class="tab-content">

			<div class="tab-pane active" id="tabs-1">
				<h3>Aujourd'hui {"+0 days"|date_format:"%d/%m"}</h3>
				{assign var=jour value=$statAccueil.listeAnniv[1]}
				<ul>
					{foreach from=$jour item=day}
					{assign var=matricule value=$day.matricule}
					{assign var=nomPrenom value=$day.nomPrenom}
						<li><a href="index.php?action=parEleve&amp;matricule={$matricule}">{$day.groupe} <strong>{$day.nomPrenom}</strong></a></li>
					{/foreach}
				</ul>
			</div>

			<div class="tab-pane" id="tabs-2">

				<h3>Demain: le <strong>{"+1 days"|date_format:"%A"} {"+1 days"|date_format:"%d/%m"}</strong></h3>
				{assign var=jour value=$statAccueil.listeAnniv[2]}
				<ul>
					{foreach from=$jour item=day}
						{assign var=matricule value=$day.matricule}
						{assign var=nomPrenom value=$day.nomPrenom}
						<li><a href="index.php?action=parEleve&amp;matricule={$matricule}">{$day.groupe} <strong>{$day.nomPrenom}</strong></a></li>
					{/foreach}
				</ul>

			</div>

			<div class="tab-pane" id="tabs-3">

				<h3>Dans deux jours: le <strong>{"+2 days"|date_format:"%A"} {"+2 days"|date_format:"%d/%m"}</strong></h3>
				{assign var=jour value=$statAccueil.listeAnniv[3]}
				<ul>
					{foreach from=$jour item=day}
						{assign var=matricule value=$day.matricule}
						{assign var=nomPrenom value=$day.nomPrenom}
						<li><a href="index.php?action=parEleve&amp;matricule={$matricule}">{$day.groupe} <strong>{$day.nomPrenom}</strong></a></li>
					{/foreach}
				</ul>

			</div>

			<div class="tab-pane" id="tabs-4">

				<h3>Dans trois jours: le <strong>{"+3 days"|date_format:"%A"} {"+3 days"|date_format:"%d/%m"}</strong></h3>
				{assign var=jour value=$statAccueil.listeAnniv[4]}
				<ul>
					{foreach from=$jour item=day}
						{assign var=matricule value=$day.matricule}
						{assign var=nomPrenom value=$day.nomPrenom}
						<li><a href="index.php?action=parEleve&amp;matricule={$matricule}">{$day.groupe} <strong>{$day.nomPrenom}</strong></a></li>
					{/foreach}
				</ul>

			</div>

		</div> <!-- my-tab-content -->

	</div>  <!-- col-md... -->

</div>  <!-- row -->

</div>  <!-- container -->
