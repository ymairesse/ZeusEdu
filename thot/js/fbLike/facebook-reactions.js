/*!
 @package Facebook-Reactions-JS - A jQuery Plugin to generate Facebook Style Reactions.
 @version version: 1.0
 @developer github: https://github.com/99points/Facebook-Reactions-JS

 @developed by: Zeeshan Rasool. [Founder @ http://www.99points.info & http://wallscriptclone.com]

 @license Licensed under the MIT licenses: http://www.opensource.org/licenses/mit-license.php
*/

(function($) {

	$.fn.facebookReactions = function(options) {

		var settings = $.extend( {

			postUrl: false, // once user will select an emoji, lets save this selection via ajax to DB.
			defaultText: "Like" // default text for button

		}, options);

		var emoji_value;

		var _react_html = '<div style="position:absolute; z-index: 1;" class="_bar" data-status="hidden"><div class="_inner">';

		var faces 	= '<img src="js/fbLike/emojis/like.svg" class="emoji" data-emoji-value="like" style="" />';

		faces = faces + '<img src="js/fbLike/emojis/love.svg" class="emoji" data-emoji-value="love" style="" />';

		faces = faces + '<img src="js/fbLike/emojis/haha.svg" class="emoji" data-emoji-value="haha" style="" />';

		faces = faces + '<img src="js/fbLike/emojis/wow.svg" class="emoji" data-emoji-value="wow" style="" />';

		faces = faces + '<img src="js/fbLike/emojis/sad.svg" class="emoji" data-emoji-value="sad" style="" />';

		faces = faces + '<img src="js/fbLike/emojis/angry.svg" class="emoji" data-emoji-value="angry" style="" />';

		_react_html = _react_html + faces;

		_react_html = _react_html + '<br clear="all" /></div></div>';

		$(_react_html).appendTo($('body'));

		var _bar = $('._bar');
		var _inner = $('._inner');

		// on click emotions
		$('.emoji').on("click",function (e) {

			if(e.target !== e.currentTarget) return;

			var base = $(this).parent().parent().parent();
			var move_emoji = $(this);

			// on complete reaction
			emoji_value = move_emoji.data('emoji-value');

			if (move_emoji) {

				var cloneemoji = move_emoji.clone().offset({
					top: move_emoji.offset().top,
					left: move_emoji.offset().left
				}).css({
					'height': '40px',
					'width': '40px',
					'opacity': '0.9',
					'position': 'absolute',
					'z-index': '99'
				}).appendTo($('body')).animate({
						'top': base.offset().top+5,
						'left': base.offset().left + 10,
						'width': 30,
						'height': 30
				}, 300, 'easeInBack');

				cloneemoji.animate({
					'width': 27,
					'height': 27
				},100, function () {

					var _imgicon = $(this);

					_imgicon.fadeOut(100, function(){ _imgicon.detach();
						 // add icon class
						base.attr("data-emoji-class", emoji_value);
						// change text
						base.find('span').html(emoji_value);

						if ( settings.postUrl ) {

							__ajax(base.attr("data-unique-id"), emoji_value);
						}
					});
				});
			}

			return false;
		});

		// ajax
		function __ajax(control_id, value){

			// here we have control id and value. We need to save them into db. You can change it according to yours requirements.
			var formData = "control_id="+control_id+"&value="+value;

			$.ajax({
				type	:	'POST', // define the type of HTTP verb we want to use (POST for our form)
				url		:	settings.postUrl, // the url where we want to POST // ici, forums/saveLike.inc.php
				data	:	formData, // our data object
				success	:	function(data){
					var dataJson = JSON.parse(data);

					var emoji = dataJson['emoji'];
					var postId = dataJson['postId'];
					var idCategorie = dataJson['idCategorie'];
					var idSujet = dataJson['idSujet'];

					// mise à jour des statistiques pour ce post
					$.post('inc/forum/getFBstats4postId.inc.php', {
						idCategorie: idCategorie,
						idSujet: idSujet,
						postId: postId
					}, function(resultat){
						$('.listeFBlikes[data-postid="' + postId + '"]').html(resultat);
					})

				},
				error: function() {

					alert('<p>An error has occurred</p>');
				}
			});
		}

		return this.each(function() {

			var _this = $(this);
			window.tmr;
			window.selector = _this.get(0).className;

			$(this).find('span').click(function(e) {

				if(e.target !== e.currentTarget) return;
				var isLiked = $(this).parent().attr("data-emoji-class");
				var control_id = $(this).parent().attr("data-unique-id");

				$(this).html(settings.defaultText);

				if(isLiked)
				{
					$(this).parent().attr("data-emoji-class", "");

					if ( settings.postUrl )
						__ajax(control_id, null);
				}
				else
				{
					$(this).parent().attr("data-emoji-class", "like");

					if ( settings.postUrl )
						__ajax(control_id, "like");
				}
			});

			$(this).hover(function (){

				if ( $(this).hasClass("emoji") ){
					return false;
				}

				if($(this).hasClass("open") === true)
				{
					clearTimeout(window.tmr);
					return false;
				}

				$('.'+window.selector).each(function() {

					__hide(this);
				});

				if( _bar.attr('data-status') != 'active' ) {

					__show(this);
				}
			},function ()
				{
					var _this = this;

					window.tmr = setTimeout( function(){

					   __hide(_this);

                   }, 50);  // 1000 est beaucoup trop long
				}
			);

			// functions
			function __hide(_this) {

				_bar.attr('data-status', 'hidden');

				_bar.hide();

				$('.open').removeClass("open");

				_inner.removeClass('ov_visi');
			}

			function __show(_this) {

				clearTimeout(window.tmr);

				$(_this).append(_bar.fadeIn());

				_bar.attr('data-status', 'active');

				_inner.addClass('ov_visi');

				$(_this).addClass("open");

				// vertical or horizontal
				var position = $(_this).data('reactions-type');

				if( position == 'horizontal' )
				{
					_inner.css('width', '250px');  // 240px est insuffisant YM
					// Set main bar position top: -50px; left:0px;
					_bar.css({'top': '-50px', 'left': '0px', 'right': 'auto' });
				}
				else
				{
					_inner.css('width', '41px');
					_bar.css({'top': '-6px', 'right': '-48px', 'left': 'auto' });
				}
			}
		});
	};

})(jQuery);
