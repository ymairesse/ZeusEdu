<!DOCTYPE html>
<head>
<meta charset="utf-8">
<title>{$titre}</title>
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet" href="menu.css" type="text/css" media="screen">
<link type="text/css" media="all" rel="stylesheet" href="bootstrap/css/bootstrap.css">
  
<script type="text/javascript" src="js/jquery-1.10.2.min.js"></script>
<script type="text/javascript" src="bootstrap/js/bootstrap.min.js"></script>
<script type="text/javascript" src="js/jquery.validate.js"></script>

<link rel="stylesheet" href="screen.css" type="text/css" media="screen">
<link rel="stylesheet" href="print.css" type="text/css" media="print">

</head>
<body>
<div class="container">
<h1>Page d'informations</h1>

<h3>Licence du logiciel</h3>
<p>Le logiciel ZEUS est un logiciel libre et gratuit distribué selon les termes de la Licence publique générale GNU dont le texte est disponible dans le fichier gpl.txt qui doit figurer dans le fichier d'archive qui a été mis à votre disposition.</p>
<p>Le texte original de cette licence peut être trouvé à l'adresse http://www.gnu.org/licenses/gpl-3.0.txt (en anglais) et une traduction non officielle se trouve à l'adresse http://www.rodage.org/gpl-3.0.fr.html.</p>
<p>Le logiciel ZEUS est fourni dans l'état et sans aucune garantie d'aucune sorte. Chacun est libre de consulter le code source et de vérifier qu'il correspond à ses besoins, voire de le modifier pour l'adapter à ses besoins.</p>
<hr>
<p>Le logiciel utilise un certain nombre d'utilitaires et des images qui sont eux-mêmes sous leur propre licence libre.</p>
<ul>
	<li>Smarty: <a href="http://www.smarty.net/">http://www.smarty.net/</a> (licence LGPL)</li>
	<li>jQuery: <a href="http://jquery.com/">http://jquery.com/</a> et <a href="http://jqueryui.com/">jQuery UI</a> (licence MIT)</li>
	<li>Bootstrap: <a href="http://getbootstrap.com/">La librairie Twitter Bootstrap</a> (licence MIT)</li>
	<li>fPdf: <a href="http://www.fpdf.org/">http://www.fpdf.org/</a> </li>
	<li>ckEditor: <a href="http://ckeditor.com/">http://ckeditor.com/</a> (licences GPL, LGPL et MPL)</li>
	<li>des images de la librairie Nuvola: <a href="http://www.icon-king.com/projects/nuvola/">http://www.icon-king.com/projects/nuvola/</a> (licence LGPL)</li>
</ul>
<p>Il a été développé sur une plate-forme entièrement libre Linux avec les outils libres tels que Geany, Komodo Edit, Gimp, Firefox, Apache2, PHP, MySQL,...</p>

<h3>Mais pourquoi ZEUS?</h3>
<p>La mythologie grecque avait déjà inspiré un nom pour une application dédiée à l'Administration de la Discipline dans les Établissements Scolaires (ADES) qui pourrait renaître dans une nouvelle mouture.</p>
<p>Quel nom donner à cette nouvelle application, plus multifonctionnelle et toujours dédiée à bien plus de questions liées à la gestion de questions scolaires? Cette fois, nous ne pouvions convoquer que ZEUS lui-même. Vive ZEUS et la mégalomanie.</p>

<h3 id="ip">L'dresse IP</h3>	
<p>L'adresse IP d'un ordinateur, dans un réseau, peut être comparée à un numéro de téléphone qui permet d'atteindre un poste unique.</p>
<p>Une adresse IP est formée d'un ensemble de quatre nombres compris entre 0 et 255 séparés par des ".". Votre adresse IP actuelle est <strong>{$ip}</strong>. Elle correspond très probablement à l'adrese du modem ou du routeur qui vous relie à l'Internet.</p>
<p>Les mathématiciens calculeront aisément qu'il y a, théoriquement, plus de 4 milliards d'adresses IP différentes possibles.</p>
<p>Sur l'Internet, l'adresse IP est attribuée par votre fournisseur de services (Belgacom, Numéricable, Scarlet,...). Avec l'avènement des connexions permanentes par le câble, les adresses IP ont tendance à être fixes.</p>
<p>Dans certains cas, le fournisseur d'accès vous attribue une adresse IP pour une période limitée; et vous la perdez lors de votre déconnexion du réseau. Ce n'est pas gênant pour l'utilisateur moyen de l'Internet.</p>
<p>Il est toujours possible de retrouver l'origine d'un accès à l'Internet sur base de l'adresse IP. En cas de fraude informatique (utilisation d'un mot de passe volé, par exemple) et suite au dépôt d'une plainte à la police, les autorités judiciaires peuvent demander aux fournisseurs de service à qui était attribuée telle adresse IP à tel moment. Ce qui rend possible les poursuites en Justice.</p>
<p>Notre école poursuit toujours les auteurs d'accès ou de tentatives d'accès frauduleux. Les sanctions possibles sont prévues par <a href="http://www.ejustice.just.fgov.be/cgi_loi/change_lg.pl?language=fr&la=F&table_name=loi&cn=1867060801">l'article 550 bis du Code Pénal</a>.</p>
<p>Si vous constatez une tentative d'accès frauduleux avec votre nom d'utilisateur (vous serez prévenu par mail), n'hésitez pas à contacter les administrateurs pour savoir les suites qui sont données.</p>
<p>Pour plus d'informations sur la notion d'adresse IP, voyez <a href="http://fr.wikipedia.org/wiki/Adresse_IP" target="_blank">http://fr.wikipedia.org/wiki/Adresse_IP</a></p>

</div>  <!-- container -->
{include file="footer.tpl"}


</body>
</html>
