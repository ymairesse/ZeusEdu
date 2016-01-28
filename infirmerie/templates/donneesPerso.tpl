<div class="row">
	
	<div class="col-md-5 col-sm-5">
		<div class="panel panel-default">
			<div class="panel-body">
				<dl>
					<dt>Commune de naissance</dt>
						<dd>{$eleve.commNaissance|default:'&nbsp;'}</dd>
					<dt>Classe</dt>
						<dd>{$eleve.groupe} {if $titulaires} [{", "|implode:$titulaires}]{/if}</dd>
					<dt>Date de naissance</dt>
						<dd>{$eleve.DateNaiss} 
						<small>[Âge approx. {$eleve.age.Y} ans {if !($eleve.age.m == 0)}{$eleve.age.m} mois{/if} 
						{if !($eleve.age.d == 0)}{$eleve.age.d} jour(s){/if}]</small></dd>
					<dt>Sexe</dt>
						<dd>{$eleve.sexe}</dd>
				</dl>
			</div>
		</div>
	</div>  <!-- col-md-... -->
	
	<div class="col-md-5 col-sm-5">
		<div class="panel panel-default">
			<div class="panel-body">		
				<dl>
					<dt>Adresse</dt>
						<dd>{$eleve.adresseEleve}</dd>
					<dt>Code Postal</dt>
						<dd>{$eleve.cpostEleve}</dd>
					<dt>Commune</dt>
						<dd>{$eleve.localiteEleve}</dd>
				</dl>
			</div>
		</div>
	</div>  <!-- col-md-... -->
		
	<div class="col-md-2 col-sm-2">
		
		<img src="../photos/{$eleve.photo}.jpg" alt="{$matricule}" class="draggable photo img-responsive thumbnail" title="{$eleve.prenom} {$eleve.nom}">

	</div>
		
</div>   <!-- row -->