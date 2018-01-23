<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>titre</title>

{include file='../../javascript.js'}
{include file='../../styles.sty'}

</head>
<body>


<div class="container">

    <button type="button" class="btn btn-default" id="calendrier" name="button">Calendrier</button>

    <div id="calendar">

    </div>

</div>

<script type="text/javascript">

$(document).ready(function() {

    $('#calendrier').click(function(){
        $.post('inc/getCalendar.inc.php', {
        },
        function (resultat){
            $('#calendar').html(resultat);
        })
    })

});

</script>

</body>
</html>
