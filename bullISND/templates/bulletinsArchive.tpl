<div class="container">

	<h3>Archives des bulletins</h3>

	<h4>Bulletins de <strong>{$nomEleve}</strong> en classe de <strong>{$classeArchive}</strong> (année scolaire {$anneeScolaire})</h4>


	<p>Le bulletin de <strong>{$nomEleve}</strong> se trouve dans l'archive de sa classe (<strong>{$classeArchive}</strong>)</p>
	<ul>
	{foreach $periodes item=bulletin}
		{if $bulletin > 0}
		<li>
			<a href="archives/{$anneeScolaire}/{$bulletin}/{$classeArchive}-{$bulletin}.pdf"
				target="_blank"
				title="Tous les bulletins de {$classeArchive}">Bulletin numéro {$bulletin}
			</a>
		</li>
		{/if}
	{/foreach}
	</ul>

</div>
