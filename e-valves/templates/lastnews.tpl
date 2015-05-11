<div class="container">

	<div class="row">
		
		<div class="col-md-9 col-sm-12">
			<h2 id="anchor0">Les 15 dernières nouvelles</h2>

				{assign var=n value=1}

				<div class="ombre">
					{foreach from=$listeNews key=id item=news}
					<div class="table-responsive">
						<table>
							<tr>
								<td>
									<h3 id="anchor{$n}" style="float:left; width:60%; clear:both;">{$news.post_title}</h3>
									<div class="micro ombre" style="float:right; padding-top:1em;">
										Le {$news.post_date|date_format:'%d %B %Y'} à {$news.post_date|date_format:'%kh%M'}
									</div>
									<div style="clear:both; padding-top:1em;">
									{$news.post_content|nl2br}
									</div>
								</td>
							</tr>
						</table>
					{assign var=n value=$n+1}
					</div>
					{/foreach}
				</div>
				
		</div>  <!-- col-md-... -->
		
		<div class="col-md-3 col-sm-12">
			<h4>Table des matières</h4>
			<p class="notice">Les e-valves complètes doivent être consultées sur <a href="http://isnd.be/e-valves">http://isnd.be/e-valves</a></p>
			<p style="text-align:center"><a href="http://isnd.be/e-valves"><img src="../images/evalves.png" alt="e-valves"></a></p>
			{assign var=n value=1}
			{foreach from=$listeNews key=id item=news}
			<p><a href="#anchor{$n}"
				   class="pop"
				   data-content="Le {$news.post_date|date_format:'%d %B %Y'} à {$news.post_date|date_format:'%kh%M'}"
				   data-placement="top"
				   >
				{$news.post_date|date_format:'%d/%m'}
				{$news.post_title|truncate:30:'...':true}
				</a>
			</p>
			{assign var=n value=$n+1}
			{/foreach}
	
		</div>  <!-- col-md-... -->

	</div>  <!-- row -->
	
</div>	<!-- container -->
	
	<script type="text/javascript">
		{literal}
		$(document).ready(function() {
			$().UItoTop({ easingType: 'easeOutQuart' });
		});
		{/literal}
	</script>
