<div class="container">
	
	<h3>Suppression des anciens élèves</h3>
	
	{if $rubriquesErreurs != Null}
		{if in_array('fileType', $rubriquesErreurs)}
			{include file='pageFileType.tpl'}
		{/if}
	
		{if in_array('utf8', $rubriquesErreurs)}
			{include file='pageUTF8.tpl'}
			{include file='formConfirmSuppr.tpl'}
			{include file='pageTableauImport.tpl'}
		{/if}
	
		{if in_array('hiatus', $rubriquesErreurs)}
			{include file='pageHiatus.tpl'}
		{/if}
		
		{if in_array('no file',$rubriquesErreurs)}
			{include file='nofile.tpl'}
		{/if}
	{else}
		{include file='formConfirmSuppr.tpl'}
		{include file='pageTableauImport.tpl'}
	{/if}

</div>  <!-- container -->
