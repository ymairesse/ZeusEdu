(function($)
{ 
	$.fn.tooltip=function() {
		
		$(".tip").css({"display":"none"});
		var tipIsTitle;
		var oldTitle;
		var tip='';
		
		return this.each(function() {
		 
		$(this).mouseover(function(e) {
		// on choisit le contenu du "title" ou le contenu d'un ".tip" contenu dans l'objet ".tooltip"
		var tip = $(this).attr('title');
		if ((tip != null) && (tip != '')) {
			// on a un "title" à conserver en mémoire
			oldTitle = tip;
			// supprimer le contenu de l'attribut pour éviter l'apparition du tooltip du navigateur
			$(this).attr('title','');
			tipIsTitle = true;
			// voir si un tag "|" est présent; on utilise ce qui précède comme titre
			var posTag = tip.indexOf('|');
			if (posTag > 0) {
				var titre = tip.substring(0,posTag);
				tip = "<h3>"+titre+"</h3><p>"+tip.substr(posTag+1)+"</p>";
				}
			}
			else {
			// on prend éventuellement le contenu du conteneur ".tip" dans l'objet ".tooltip"
			tipIsTitle = false;
			tip = $(this).find(".tip").html();
			}
		
		if ((tip != '') && (tip != null)) {
			// introduire le contenu du tooltip dans le conteneur qui va bien.
			$("body").append('<div id="tooltip">' + tip + '</div>');		
			// positionner le tooltip
			var posY = e.pageY; var posX = e.pageX;
			var windowWidth = $(window).width();
			var windowHeight = $(window).height();
			var tooltipWidth = $("#tooltip").width();
			var tooltipHeight = $("#tooltip").height();
			if ((posX + tooltipWidth) > windowWidth-50)
				posX = posX - tooltipWidth;
			if ((posY + tooltipHeight) > windowHeight-20)
				posY = posY - tooltipHeight;
			$('#tooltip').css('top', posY + 10 ).css('left', posX + 20 );
			
			// Montrer le tooltip 
			$('#tooltip').show();
			$("#width").html("window:"+windowWidth+" posX:"+posX+" Tooltip:"+tooltipWidth);
			}
			
		}).mousemove(function(e) {
				// déplacement du tooltip avec la souris
				var posY = e.pageY; var posX = e.pageX;
				var windowWidth = $(window).width();
				var windowHeight = $(window).height();			
				var tooltipWidth = $("#tooltip").width();
				var tooltipHeight = $("#tooltip").height();
				if ((posX + tooltipWidth) > windowWidth-50)
					posX = posX - tooltipWidth;
				if ((posY + tooltipHeight) > windowHeight-20)
					posY = posY - tooltipHeight;
				$('#tooltip').css('top', posY + 10 ).css('left', posX + 20 );
				
		}).mouseout(function() {
			$("#tooltip").fadeOut(500);
			// Si nécessaire, remettre le titre en place
			if (tipIsTitle === true)
				$(this).attr('title',oldTitle);
			// supprimer le conteneur "#tooltip" introduit
			$("body").children('div#tooltip').remove();
			});
	});						   
	};
})(jQuery);
