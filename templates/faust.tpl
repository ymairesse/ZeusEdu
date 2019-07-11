<script type="text/javascript">

function refresh() {
	if (refreshOn == 1) {
		$.post('../inc/faust.inc.php', {}, function(){});
		setTimeout(refresh, 5000);
		}
	}

var time = new Date().getTime();
refresh();

</script>
