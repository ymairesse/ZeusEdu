<div class="container">
	
<h4 style="clear:both">Contenu actuel de la table <strong>"{$table}"</strong></h4>

{assign var=nbBlocs value=$tableau|@count/20}
{assign var=nbBlocs value=$nbBlocs|round:0}

{section name=liste loop=$nbBlocs}
  <span class="fauxBouton" id="showBloc_{$smarty.section.liste.index}" style="cursor:pointer">{$smarty.section.liste.index+1}</span> 
{/section}

<div class="table-responsive">
	
	<table class="table table-striped">
		<thead>
			<tr>
			{foreach from=$entete item=element}
				<th>{$element.Field}</th>
			{/foreach}		
			</tr>
		</thead>
		{assign var=bloc value=0}
		{assign var=n value=0}
		{foreach from=$tableau item=ligne}
			<tr class="bloc{$bloc} bloc">
				{foreach from=$ligne item=element}
					<td>{$element|default:'&nbsp;'}</td>
				{/foreach}
			</tr>
			{assign var=n value=$n+1}
			{if ($n == 20)}
				{assign var=n value=0}
				{assign var=bloc value=$bloc+1}
			{/if}
		{/foreach}
	</table>

</div>

</div>  <!-- container -->

<script type="text/javascript">

	$(document).ready(function(){
		$(".bloc").hide();
		$(".bloc0").show();
		
		$(".fauxBouton").click(function(){
			$(".fauxBouton").removeClass("active");
			$(this).addClass("active");
			var reg=new RegExp("_", "g");
			var tableau = $(this).attr("id").split(reg);
			var indice = tableau[1];
			$(".bloc").hide();
			$(".bloc"+indice).show();
			})
		})

</script>
