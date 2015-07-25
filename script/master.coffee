
$ ->
	
	hide_section = (section) ->
		$(section).animate {
			opacity: 0
		}, 200, ->
			$(section).css 'display', 'none'
	show_section = (section) ->
		$(section).css 'display', 'block'
		$(section).animate {
			opacity:1
		}, 200


	unless $('body').hasClass 'backup'
		$('#main nav li a').removeAttr 'href'
	

	$('#photo1, #photo2').click ->
		$('.charles').click()


	$('.charles').click ->
		unless $(this).hasClass 'disabled'
			$(this).addClass 'disabled'
			if $(this).hasClass 'clicked'
				$(this).removeClass 'clicked'
				hide_section("#photo")
				# $('.pipin, .chamberlain').css 'left',
				# 	($(window).width() + 750)
				$('.charles').animate {
					top: 0
				}, 500
				$('.pipin, .chamberlain').animate {
					left: 0
				}, 500, ->
					$('.charles').removeClass 'disabled'
					$('.charles span').text 'Etc'
			else
				$(this).addClass 'clicked'
				$('.pipin, .chamberlain').animate {
					left: -$(window).width() - 750
				}, 500
				$('.charles').animate {
					top: (-1 * $(window).height() * 0.10)
				}, 500, ->
					show_section('#photo')
					$('.charles').removeClass 'disabled'
					$('.charles span').text 'Home'
		    	
		
	$('.pipin').click ->
		unless $(this).hasClass 'disabled'
			$(this).addClass 'disabled'
			if $(this).hasClass 'clicked'
				$(this).removeClass 'clicked'
				hide_section('#contact')
				# $('#contact').animate {
# 					opacity:0
# 				}, 200, ->
# 					$('#contact').css 'display', 'none'
				$('.charles, .chamberlain').animate {
					left:0
					opacity:1
				}, 500
				$('.pipin').animate {
					top:0
				}, 500, ->
					$('.pipin span').text('Contact')
					$('.pipin').removeClass 'disabled'
			else
				$(this).addClass 'clicked'
				$('.charles, .chamberlain').animate {
					left:-2000
					opacity:0
				}, 500
				$('.pipin').animate {
					top: (-1 * $(window).height() * 0.25)
				}, 500, ->
					show_section('#contact')
					# $('#contact').css 'display', 'block'
					# $('#contact').animate {
					# 	opacity:1
					# }, 200
					$('.pipin span').text('Home')
					$('.pipin').removeClass 'disabled'
				
	$('.chamberlain').click ->
		unless $(this).hasClass 'disabled'
			$(this).addClass 'disabled'
			if $(this).hasClass 'clicked'
				$(this).removeClass 'clicked'
				hide_section "#portfolio"
				$('.charles, .pipin').animate {
					left:0
					opacity:1
				}, 500
				$('.chamberlain').animate {
					top:0
				}, 500, ->
					$('.chamberlain span').text('Blog')
					$('.chamberlain').removeClass 'disabled'
			else
				$(this).addClass 'clicked'
				$('.charles, .pipin').animate {
					left:-2000
					opacity:0
				}, 500
				$('.chamberlain').animate {
					top: (-1 * $(window).height() * 0.38)
				}, 500, ->
					show_section '#portfolio'
					$('.chamberlain span').text('Home')
					$('.chamberlain').removeClass 'disabled'
	
