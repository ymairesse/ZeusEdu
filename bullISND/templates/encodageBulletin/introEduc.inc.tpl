<!-- introduction de la note de l'éducateur pour l'élève $matricule -->

<textarea name="note_{$matricule}" class="form-control" placeholder="Votre commentaire ici" rows="4">{$listeCommentaires.$matricule.$bulletin.$acronyme.commentaire|default:''}</textarea>

{* Notes des autres éducs pour la même période *}
{if isset($listeCommentaires.$matricule.$bulletin)}
	{foreach $listeCommentaires.$matricule.$bulletin key=acroEduc item=details}
		{if $acroEduc != $acronyme}
		{$details.commentaire}
		<br>
		<p style="text-align:right">
			{if $details.sexe == 'M'}M.{else}Mme{/if} {$details.nom} {$details.prenom}
			{if $details.titre != ''}(<small>{$details.titre})</small>{/if}</p>
		{/if}
	{/foreach}
{/if}

{* Notes toutes périodes *}
{if isset($listeCommentaires.$matricule)}
<div class="accordion-group">

	<div class="accordion-heading">
		<a class="accordion-toggle" data-toggle="collapse" href="#collapseRem{$matricule}" title="" data-original-title="Cliquer pour ouvrir" aria-expanded="true">
			<span class="glyphicon glyphicon-play"></span> Remarques de toutes les périodes
		</a>
	</div>

	<div id="collapseRem{$matricule}" class="accordion-body collapse expand" aria-expanded="true">
		<div class="accordion-inner">
			<ul>
				{foreach $listeCommentaires.$matricule key=noBulletin item=details}
				<li>{$noBulletin} =>
					{foreach $details key=acroEduc item=noteEduc}
						{if $noteEduc.commentaire != ''}
						{$noteEduc.acronyme}: {$noteEduc.commentaire}<br>
						{/if}
					{/foreach}
				</li>
				{/foreach}
			</ul>
		</div>
		<!-- accordion-inner -->
	</div>
</div>
 {/if}
