module Methods

	BSP_URL = 'http://www.ishayoga.org/Schedule/index.php?option=com_program&task=filter&Itemid=&cat=110&program=0&rejuvenation=0&advance_program=7&children_program=0&event=0&country=India&country=0&city=0&locale=0&date=0&start=&end=&Submit=Search&IREFERRER=http%253A%2F%2Fwww.ishafoundation.org%2Findex.php%253Foption%253Dcom_program%2526task%253Ddetails%2526program_id%253D11560&LREFERRER=https%253A%2F%2Fwww.google.co.in%2F&ILANDPAGE=http%253A%2F%2Fwww.ishayoga.org%2Findex.php%253Foption%253Dcom_program%2526program_id%253D11560%2526task%253Dpreregister&VISITS=15'
	BSP_STRING = '(Ladies, English)'
	SHOONYA_URL = 'http://www.ishayoga.org/Schedule/index.php?option=com_program&task=filter&Itemid=&cat=110&program=0&rejuvenation=0&advance_program=13&children_program=0&event=0&country=India&country=0&city=0&locale=0&date=0&start=&end=&Submit=Search&IREFERRER=http%253A%2F%2Fwww.ishafoundation.org%2Findex.php%253Foption%253Dcom_program%2526task%253Ddetails%2526program_id%253D11560&LREFERRER=https%253A%2F%2Fwww.google.co.in%2F&ILANDPAGE=http%253A%2F%2Fwww.ishayoga.org%2Findex.php%253Foption%253Dcom_program%2526program_id%253D11560%2526task%253Dpreregister&VISITS=15'
	SHOONYA_STRING = '(English)'

	def scrape_bsp
		page = Nokogiri::HTML(RestClient.get(BSP_URL)) 	
		elements  = page.search "[text()*='#{BSP_STRING}']"
		return !elements.empty?
	end

	def scrape_shoonya
		page = Nokogiri::HTML(RestClient.get(SHOONYA_URL)) 	
		elements  = page.css("span.hov_brackets").map(&:text)
		return elements.include?(SHOONYA_STRING)
	end

	def generate_html(bsp:, shoonya:)
		html = Tilt.new("mails/email.html.slim").render(nil, bsp: bsp, shoonya: shoonya)
		css = File.open("mails/email.scss").read
		document = Roadie::Document.new(html)
		document.add_css(css)
		document.transform
	end


	RECIPIENTS = ['rushil.agrawal@gmail.com']
	SENDER = 'rushil.agrawal@gmail.com'

	def send_email(content:, recipients:RECIPIENTS)
		recipients.each do |r|
					mg_client = Mailgun::Client.new ENV['MAILGUN_API_KEY']
					message_params =  { from: SENDER,
					                    to:   r,
					                    subject: 'Hooray!!!',
					                    html: content
					                    # text:    content
					                  }
			     	mg_client.send_message ENV['MAILGUN_SENDER'], message_params
		end
	end
end