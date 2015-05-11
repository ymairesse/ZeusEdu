<!-- photo de l'élève et liens divers -->
	
	<span id="el{$matricule}"></span>
	<div class="pull-right">
		{if isset($listeElevesSuivPrec.$matricule.prev) && ($listeElevesSuivPrec.$matricule.prev != Null)}
			<a href="#el{$listeElevesSuivPrec.$matricule.prev}">
				<span class="glyphicon glyphicon-chevron-up" title="Précédent"></span>
			</a>
		{/if}
		{if isset($listeElevesSuivPrec.$matricule.next) && ($listeElevesSuivPrec.$matricule.next != Null)}
			<a href="#el{$listeElevesSuivPrec.$matricule.next}">
				<span class="glyphicon glyphicon-chevron-down" title="Suivant"></span>
			</a>
		{/if}
	</div>
	
	<p><strong>{$unEleve.nom} {$unEleve.prenom}</strong></p>
	<img class="photoEleve" src="../photos/{$unEleve.photo}.jpg" width="100px" alt="{$matricule}" title="{$matricule}">
	<p><strong>Classe: {$unEleve.classe}</strong></p>

	<button type="submit" class="btn btn-primary noprint enregistrer" id="{$matricule}"	title="Enregistre l'ensemble des modifications de la page" >Enregistrer tout</button>
	<span></span>

<!-- photo de l'élève et liens divers -->