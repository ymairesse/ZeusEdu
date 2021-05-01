<div class="container-fluid">

	<div class="row">

		<div class="col-md-12 col-sm-12">
			{assign var=module value="bullTQ"}
			{include file="$INSTALL_DIR/widgets/flashInfo/templates/index.tpl"}
		</div>

	</div>
	<!-- row -->

</div>
<!-- container -->


<script type="text/javascript">
	$(document).ready(function() {

		$("a.delInfo").click(function() {
			var id = $(this).attr('id');
			var titre = $("#titre" + id).text();
			$("#newsId").val(id);
			$("#newsTitle").text(titre);
			$("#modalDel").modal('show');
		})

	})
</script>
