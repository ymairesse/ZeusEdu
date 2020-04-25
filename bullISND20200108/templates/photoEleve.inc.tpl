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

	<figure  title="{$matricule}">
		{if isset($listeEBS[$matricule])}
		<figcaption
			class="EBS"
			data-matricule="{$matricule}">
				<i class='fa fa-user-circle-o'></i>
			{* </a> *}
		</figcaption>
		{/if}
		{if isset($listeEBS[$matricule])}
			<a href="../trombiEleves/index.php?action=parEleve&matricule={$matricule}" target="_blank">
			<img class="photoEleve pop"
				src="../photos/{$unEleve.photo}.jpg"
				width="100px"
				alt="{$matricule}"
				{assign var=troubles value=', '|implode:$listeEBS.$matricule.troubles}
				{assign var=amenagements value= ', '|implode:$listeEBS.$matricule.amenagements}
				data-content = "<h5><i class='fa fa-hand-o-right'></i><b> Troubles</b></h5><p>{$troubles}</p><h5><i class='fa fa-hand-o-right'></i><b> Aménagements</b></h5><p>{$amenagements}</p>{if $listeEBS.$matricule.memo != Null}<p class='pull-right'><b>Clic <i class='fa fa-long-arrow-right'></i>
 plus d'infos</b></p>{/if}"
 				data-toggle="popover"
				data-trigger="focus"
				data-html="true"
				data-container="body"
				data-placement="right"
				data-animation="true"
				data-original-title="Élève à Besoins Spécifiques">
			</a>
		{else}
			<img class="photo"
			 	src="../photos/{$unEleve.photo}.jpg"
				width="100px"
				alt="{$matricule}">
		{/if}
	</figure>

	<p><strong>Classe: {$unEleve.classe}</strong></p>

	<button type="submit" class="btn btn-primary noprint enregistrer" id="{$matricule}"	title="Enregistre l'ensemble des modifications de la page" >Enregistrer tout</button>
	<span></span>

<!-- photo de l'élève et liens divers -->
