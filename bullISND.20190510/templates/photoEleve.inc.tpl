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
	<figure class="EBS">
		<img class="photoEleve" src="../photos/{$unEleve.photo}.jpg" width="100px" alt="{$matricule}" title="{$matricule}">
		{if isset($listeEBS[$matricule])}
		<figcaption class="EBS" title="Élève à besoin spécifique">
			<a href="../trombiEleves/index.php?action=parEleve&matricule={$matricule}" target="_blank">
				<i class="fa fa-user-circle-o"></i>
			</a>
		</figcaption>
		{/if}
	</figure>

	<p><strong>Classe: {$unEleve.classe}</strong></p>

	<button type="submit" class="btn btn-primary noprint enregistrer" id="{$matricule}"	title="Enregistre l'ensemble des modifications de la page" >Enregistrer tout</button>
	<span></span>

<!-- photo de l'élève et liens divers -->
