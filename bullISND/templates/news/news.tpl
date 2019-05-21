<div class="container-fluid">

	<div class="row">

		{if in_array($PERIODEENCOURS, $PERIODESDELIBES)}

			<div class="col-md-5 col-sm-12">
				{include file='news/situationsVides.tpl'}
				{include file='news/noSitDelibe.tpl'}
				{include file='news/noCommentDelibe.tpl'}
			</div>

			<div class="col-md-7 col-sm-12">
				{assign var=module value="bullISND"}
				{include file="$INSTALL_DIR/widgets/flashInfo/templates/index.tpl"}
			</div>

		{else}

			<div class="col-md-12 col-sm-12">
				{assign var=module value="bullISND"}
				{include file="$INSTALL_DIR/widgets/flashInfo/templates/index.tpl"}
			</div>

		{/if}

	</div>  <!-- row -->

</div>  <!-- container -->


{if $userStatus == 'admin'}
	{include file='news/modalDelNews.tpl'}
{/if}

<script type="text/javascript">

$(document).ready(function(){

	$("a.delInfo").click(function(){
		var id=$(this).attr('id');
		var titre = $("#titre"+id).text();
		$("#newsId").val(id);
		$("#newsTitle").text(titre);
		$("#modalDel").modal('show');
		})

	$("li.collapsible").click(function(){
		$('.collapsible ul').hide('slow');
        $(this).find('ul').toggle('slow');
    })

})

</script>
