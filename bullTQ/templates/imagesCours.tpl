<div class="container">

	<h2 style="clear:both">Images générées</h2>
	{foreach from=$listeImages item=uneImage}
		<img src="imagesCours/{$uneImage.nomImage}.png" title="{$uneImage.nomImage}.png">
	{/foreach}

</div>