<div class="row">

	<div class="col-md-5 col-sm-5">
		<div class="panel panel-default">
			<div class="panel-body">
				<dl>
					<dt>Commune de naissance</dt>
						<dd>{$dataEleve.commNaissance|default:'&nbsp;'}</dd>
					<dt>Classe</dt>
						<dd>{$dataEleve.groupe} {if $titulaires} [{", "|implode:$titulaires}]{/if}</dd>
					<dt>Date de naissance</dt>
						<dd>{$dataEleve.DateNaiss} 
						<small>[Âge approx. {$dataEleve.age.Y} ans {if !($dataEleve.age.m == 0)}{$dataEleve.age.m} mois{/if} 
						{if !($dataEleve.age.d == 0)}{$dataEleve.age.d} jour(s){/if}]</small></dd>
					<dt>Sexe</dt>
						<dd>{$dataEleve.sexe}</dd>
				</dl>
			</div>
		</div>
	</div>  <!-- col-md-... -->

	<div class="col-md-5 col-sm-5">
		<div class="panel panel-default">
			<div class="panel-body">
				<dl>
					<dt>Adresse</dt>
						<dd>{$dataEleve.adresseEleve}</dd>
					<dt>Code Postal</dt>
						<dd>{$dataEleve.cpostEleve}</dd>
					<dt>Commune</dt>
						<dd>{$dataEleve.localiteEleve}</dd>
				</dl>
			</div>
		</div>
	</div>  <!-- col-md-... -->

	<div class="col-md-2 col-sm-2">

		<img src="../photos/{$dataEleve.photo}.jpg" alt="{$matricule}" class="draggable photo img-responsive thumbnail" title="{$dataEleve.prenom} {$dataEleve.nom}">

	</div>

</div>   <!-- row -->
