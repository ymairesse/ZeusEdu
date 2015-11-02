<!DOCTYPE html>
<head>
	<title>Avec titre</title>
	<meta http-equiv="content-type" content="text/html;charset=utf-8">
	<script  type="text/javascript" src='../js/jquery-2.1.3.min.js'></script>
	<script type="text/javascript" src="../bootstrap/js/bootstrap.js"></script>
	<link rel="stylesheet" href="../bootstrap/css/bootstrap.css">
    <link rel='stylesheet' href='fullcalendar.css'>
	<script type="text/javascript" src='../js/moment-with-locales.js'></script>
	<script type="text/javascript" src='../fc/fullcalendar.js'></script>
	<script src='lang/fr.js'></script>
<style type="text/css">
.urgent {border-color: #f00;}
</style>

	</head>

<body>

<div class="container">
	<div class="row">
		<div class="col-md-8">
			<div id='calendar'></div>
		</div>
		<div class="col-md-4">
			<h3>test</h3>
		</div>

	</div>
</div>


<script type="text/javascript">

function today(){
	var today = new moment();
	var dd = today.date();
	var mm = today.month()+1; //January is 0!
	var yyyy = today.year();
	if(dd<10)
    	dd='0'+dd
	if(mm<10)
    	mm='0'+mm
	return  dd+'/'+mm+'/'+yyyy;
	}

$(document).ready(function() {


});
</script>
</body>
</html>
