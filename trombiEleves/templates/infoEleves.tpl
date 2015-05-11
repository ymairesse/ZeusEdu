<div class="container">

<h2 title="{$eleve.matricule}">{$eleve.nom} {$eleve.prenom}: {$eleve.groupe}</h2>

<div class="row">
	
	<div class="col-md-9 col-sm-9">
		
		<ul id="tabs" class="nav nav-tabs" data-tabs="tabs">
			<li class="active"><a href="#tabs-1" data-toggle="tab">Coordonnées de l'élève</a></li>
			<li><a href="#tabs-2" data-toggle="tab">Personne responsable</a></li>
			<li><a href="#tabs-3" data-toggle="tab">Père de l'élève</a></li>
			<li><a href="#tabs-4" data-toggle="tab">Mère de l'élève</a></li>
		</ul>
		
		<div id="my-tab-content" class="tab-content">
			
			<div class="tab-pane active" id="tabs-1">
		
				<h3>Coordonnées de l'élève</h3>

				<div class="row">
					
					<div class="col-md-6 col-sm-12">
				
						<div class="input-group">
							<label>Classe</label>
							<p class="form-control-static">{$eleve.classe}</p>
							<div class="help-block">{if $eleve.classe != $eleve.groupe} - <small>{$eleve.groupe}{/if} [Titulaire(s): {", "|implode:$titulaires}]</small></div>
						</div>
		
						<div class="input-group">
							<label>Date de naissance</label>
							<p class="form-control-static">{$eleve.DateNaiss}</p>
							<div class="help-block"><small>[Âge approx. {$eleve.age.Y} ans
							{if !($eleve.age.m == 0)}{$eleve.age.m} mois{/if}
							{if !($eleve.age.d == 0)}{$eleve.age.d} jour(s){/if}]</small></div>
						</div>
						
						<div class="input-group">
							<label>Commune de naissance</label>
							<p class="form-control-static">{$eleve.commNaissance|default:'-'}</p>
						</div>
						
					</div>  <!-- col-md-... -->
					
					<div class="col-md-6 col-sm-12">
				
						<div class="input-group">
							<label>Adresse</label>
							<p class="form-control-static">{$eleve.adresseEleve}</p>
						</div>
						
						<div class="input-group">
							<label>Code Postal</label>
							<p class="form-control-static">{$eleve.cpostEleve}</p>
						</div>
						
						<div class="input-group">
							<label>Commune</label>
							<p class="form-control-static">{$eleve.localiteEleve}</p>
						</div>
						
						<div class="input-group">
							<label>Mail</label>
							<p class="form-control-static"><a href="mailto:{$eleve.user}@{$eleve.mailDomain}">{$eleve.user}@{$eleve.mailDomain}</a></p>
						</div>
					</div>  <!-- col-md-... -->
				
				</div>  <!-- row -->
			
			</div>  <!-- tabs-1 -->
			
			<div class="tab-pane" id="tabs-2">
				
				<h3>Coordonnées de la personne responsable</h3>
				
					<div class="row">
				
						<div class="col-md-6 col-sm-12">
				
							<div class="input-group">
								<label>Responsable</label>
								<p class="form-control-static">{$eleve.nomResp}</p>
							</div>
							
							<div class="input-group">
								<label>e-mail</label>
								<p class="form-control-static"><a href="mailto:{$eleve.courriel}">{$eleve.courriel}</a></p>
							</div>
							
							<div class="input-group">
								<label>Adresse</label>
								<p class="form-control-static">{$eleve.adresseResp}</p>
							</div>												
	
							<div class="input-group">
								<label>Code Postal</label>
								<p class="form-control-static">{$eleve.cpostResp} {$eleve.localiteResp}</p>
							</div>
						
						</div>  <!-- col-md-... -->
						
						<div class="col-md-6 col-sm-12">
							
							<div class="input-group">
								<label>Téléphone</label>
								<p class="form-control-static">{$eleve.telephone1}</p>
							</div>
							
							<div class="input-group">
								<label>GSM</label>
								<p class="form-control-static">{$eleve.telephone2}</p>
							</div>
							
							<div class="input-group">
								<label>Téléphone bis</label>
								<p class="form-control-static">{$eleve.telephone3}</p>
							</div>
							
						</div>  <!-- col-md-... -->
																
					</div>  <!-- row -->
			</div>
			
			<div class="tab-pane" id="tabs-3">
			
				<h3>Coordonnées du père de l'élève</h3>
				
					<div class="row">				
				
						<div class="col-md-6 col-sm-12">
							
							<div class="input-group">
								<label>Nom</label>
								<p class="form-control-static">{$eleve.nomPere}</p>
							</div>
							
							
							<div class="input-group">
								<label>e-mail</label>
								<p class="form-control-static"><a href="mailto:{$eleve.mailPere}">{$eleve.mailPere}</a></p>
							</div>
					
						</div>  <!-- col-md-... -->
						
						<div class="col-md-6 col-sm-12">
							
							<div class="input-group">
								<label>Téléphone</label>
								<p class="form-control-static">{$eleve.telPere}</p>
							</div>
							
							<div class="input-group">
								<label>GSM</label>
								<p class="form-control-static">{$eleve.gsmPere}</p>
							</div>
						
						</div>  <!-- col-md- ... -->
						
					</div>  <!-- row -->
			
			</div>
			
			<div class="tab-pane" id="tabs-4">
		
				<h3>Coordonnées de la mère de l'élève</h3>
				
					<div class="row">
				
						<div class="col-md-6 col-sm-12">
	
							<div class="input-group">
								<label>Nom</label>
								<p class="form-control-static">{$eleve.nomMere}</p>
							</div>
		
							<div class="input-group">
								<label>e-mail</label>
								<p class="form-control-static"><a href="mailto:{$eleve.mailMere}">{$eleve.mailMere}</a></p>
							</div>
						
						</div>  <!-- col-md-... -->
						
						<div class="col-md-6 col-sm-12">
	
							<div class="input-group">
								<label>Téléphone</label>
								<p class="form-control-static">{$eleve.telMere}</p>
							</div>
		
							<div class="input-group">
								<label>GSM</label>
								<p class="form-control-static">{$eleve.gsmMere}</p>
							</div>
						
						</div>  <!-- col-md-... -->
						
					</div>  <!-- row -->
			
			</div>
			
		</div>
		
		</div>  <!-- col-md-... -->

		<div class="col-md-3 col-sm-3">
			
		<img src="../photos/{$eleve.photo}.jpg" alt="{$eleve.prenom} {$eleve.nom}" title="{$eleve.prenom} {$eleve.nom}" id="photo" style="width:150px;" class="photoEleve draggable">					
			
		</div>

</div>  <!-- row -->

</div>  <!-- container -->
