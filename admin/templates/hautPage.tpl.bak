<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta content="text/html; charset=UTF-8" http-equiv="content-type">
<META HTTP-EQUIV="Pragma" CONTENT="no-cache">
<META HTTP-EQUIV="Expires" CONTENT="-1">
<title>{$titre}</title>
<script type="text/javascript" src="../js/jquery.js"></script>
<script type="text/javascript" src="../js/menuBas.js"></script>
<script type="text/javascript" src="../js/jquery.validate.js"></script>
<script type="text/javascript" src="../js/jquery.livequery.js"></script>
<link rel="stylesheet" href="../screen.css" type="text/css" media="screen">
<link rel="stylesheet" href="../print.css" type="text/css" media="print">
<link rel="stylesheet" href="../menu.css" type="text/css" media="screen">
<style type="text/css">
{literal}
.menu ul {display: none;}
.menu {cursor:pointer}

.cadreMenu {
	border: 1px solid red;
	width: 30%;
	float: left;
	margin: 1em;
}
#patienter {
	display: none;
	clear:both;
	display: block;
	font-size: 300%;
	position: absolute;
	top: 30%;
	left: 50%;
	background-color: red;
	color:white;
}
</style>
<script type="text/javascript">
$(document).ready(function(){
	$(".menu li").click(function(){
		$(this).contents("ul").toggle();
		})
	$(".menu li li").click(function(){
		$("#patienter").toggle();
		})
	})
{/literal}
</script>
</head>
<body>
<div id="patienter" style="display:none; clear:both;">Un instant svp</div>
