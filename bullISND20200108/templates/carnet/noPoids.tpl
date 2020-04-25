<div class="alert alert-danger alert-dismissable">
	<button type="button" class="close" data-dismiss="alert">&times;</button>
	<h3>Le transfert vers le bulletin n'est pas possible</h3>
	<p><img src="images/sorryDave.png" alt="Sorry Dave" style="float:left; padding: 0 2em 0 0"><strong>I'm sorry, Dave. I'm afraid I can't do that.</strong></p>
	<p>Vous devez préciser un "poids" pour les compétences suivantes:</p>
	<ul>
		{foreach from=$erreursPoids key=formCert item=erreurs}
			{if $formCert == 'form'}
				{foreach from=$erreurs key=idComp item=erreur}
					{if !$erreur.poidsOK}
						<li><a href="index.php?action=carnet&mode=poidsCompetences">Formatif: {$erreur.competence}</a></li>
					{/if}
				{/foreach}
			{/if}
			{if $formCert == 'cert'}
				{foreach from=$erreurs key=idComp item=erreur}
					{if !$erreur.poidsOK}
						<li><a href="index.php?action=carnet&mode=poidsCompetences">Certificatif: {$erreur.competence}</a></li>
					{/if}
				{/foreach}
			{/if}

		{/foreach}
	</ul>
</div>
