<div class="container">
	
<h2>Profil personnel</h2>

	<ul class="nav nav-tabs" data-tabs="tabs">
		<li class="active"><a href="#tabs-1" data-toggle="tab">Informations personnelles</a></li>
		<li><a href="#tabs-2" data-toggle="tab">Vos connexions</a></li>
	</ul>
	
<div id="my-tab-content" class="tab-content">
	
	<div class="tab-pane active" id="tabs-1">
		
		<div class="row">
			
			<div class="col-md-5 col-xs-12">

				<h4>Informations personnelles</h4>

				<dl>
				<dt>Nom d'utilisateur</dt>
					<dd> {$identite.acronyme}</dd>
				<dt>Nom</dt>
					<dd> {$identite.nom}</dd>
				<dt>Prénom</dt>
					<dd> {$identite.prenom}</dd>
				<dt>Sexe</dt>
					<dd> {$identite.sexe}</dd>
				</dl>
			
			</div> <!-- col-md... -->
			
			<div class="col-md-5 col-xs-12">

				<h4>Informations de contact</h4>

				<dl>
					<dt>Adresse *</dt>
						<dd>{$identite.adresse|default:'-'}</dd>
					<dt>Commune *</dt>
						<dd>{$identite.commune|default:'-'}</dd>
					<dt>Code Postal*</dt>
						<dd>{$identite.codePostal|default:'-'}</dd>
					<dt>Pays *</dt>
						<dd>{$identite.pays|default:'-'}</dd>
					<dt>Mail *</dt>
						<dd>
							{if isset($identite.mail) && ($identite.mail != '')}
							<a href="mailto:{$identite.mail}">{$identite.mail}</a>
							{else}
							-
							{/if}
						</dd>
					<dt>Téléphone *</dt>
						<dd> {$identite.telephone|default:'-'}</dd>
					<dt>GSM *</dt>
						<dd> {$identite.GSM|default:'-'}</dd>
				</dl>

				<a class="btn btn-primary" href="index.php?action=perso">Modifier</a>
				<p>* = information librement modifiable</p>	
				
			</div> <!-- col-md... -->
			
			<div class="col-md-2 col-xs-12">
		
				<a href="index.php?action=photo" title="Cliquer pour changer la photo" alt="{$identite.acronyme}">
				<div class="img-responsive">
					{if isset($photo)}
					{* ?rand=$smarty.now = astuce pour forcer la mise à jour de l'image après upload *}
						<img src="../photosProfs/{$identite.acronyme}.jpg?rand={$smarty.now}" width="150px"/>
					{else}
						{if $identite.sexe == 'M'}
						<img src="../images/profMasculin.jpg" alt="M">
							{else}
							<img src="../images/profFeminin.jpg" alt="F">
						{/if}
					{/if}
				</div>
				</a>
				<br>
				<a type="button" class="btn btn-primary" href="index.php?action=photo">
					Changer la photo
				</a>
		
			</div>  <!-- col-md... -->
		
		</div>  <!-- row -->
		
	</div>  <!-- tabs-1 -->


	<div class="tab-pane" id="tabs-2">

		<div class="row">

			<h3>Vos connexions</h3>

			<div class="col-md-8 col-sm-12">

				<div class="table-responsive">
					
					<table class="table table-condensed table-striped table-hover">
						<thead>
							<tr>
								<th width="100">Date</th>
								<th width="100">Heure</th>
								<th width="150">Adresse IP *</th>
								<th>Hôte</th>
							</tr>
						</thead>
						{foreach from=$logins item=unLogin}
						<tr>
							<td>{$unLogin.date}</td>
							<td>{$unLogin.heure}</td>
							<td>{$unLogin.ip}</td>
							<td>{$unLogin.host}</td>
						</tr>
						{/foreach}
					</table>
					
				</div>
		
			</div>  <!-- col-md-.. -->

			<div class="col-md-4 col-sm-12">
			
				<div class="notice">
				
				<p>* L'adresse IP est une adresse unique dans le monde, un peu semblable à un numéro de téléphone, et qui identifie une connexion à l'Internet.<br>
				Plusieurs ordinateurs peuvent partager la même adresse IP s'ils sont connectés au même modem (cas d'une école, par exemple).<br>
				Il peut arriver que l'adresse IP qui vous est attribuée change d'un jour à l'autre. Mais le nom du fournisseur d'accès reste fixe si vous gardez le même contrat.</p>
				<p>Si vous constatez des connexions qui ne sont manifestement pas de votre fait, modifiez immédiatement votre mot de passe et prévenez les administrateurs</p>

				</div>  <!-- notice -->
			
			</div>  <!-- col-md-...  -->

		</div>  <!-- row -->

	</div>  <!-- tabs-2 -->

</div>  <!-- my-tab-content... -->

</div>  <!-- container -->

