<div id="footer">
	Nous sommes le {$smarty.now|date_format:"%A, %e %b %Y"} à {$smarty.now|date_format:"%Hh%M"} 
	Votre adresse IP: <strong>{$identification.ip}</strong> {$identification.hostname} Votre passage est enregistr&eacute;
	<span style="float:right">{if $executionTime}Temps d'exécution du script: {$executionTime}s{/if}</span>
</div>