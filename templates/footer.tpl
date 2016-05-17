<div style="padding-bottom: 60px"></div>
<div class="hidden-print navbar-xs navbar-default navbar-fixed-bottom" style="padding-top:10px">
	<span class="hidden-xs">
		Le {$smarty.now|date_format:"%A, %e %b %Y"} à {$smarty.now|date_format:"%Hh%M"}
		Adresse IP: <strong>{$identification.ip}</strong> {$identification.hostname}
		Votre passage est enregistré
			<span id="execTime">{if $executionTime}Temps d'exécution du script: {$executionTime}s{/if}</span>
	</span>

	<span class="visible-xs">
		{$identification.ip} {$identification.hostname} {$smarty.now|date_format:"%A, %e %b %Y"} {$smarty.now|date_format:"%Hh%M"}
	</span>

</div>  <!-- navbar -->
