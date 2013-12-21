<div id="messageErreur" title="Le transfert vers le bulletin a échoué" style="display:none">
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
