class AllDomainsField < CustomFieldBase
	def initialize
		@regex = /^[^@]+@(.*)$/
	end	

	def name
		return "All Domains"
	end

	def tool_tip
		return "Exports a delimited list of all email domains when available"
	end

	def decorate(profile)
		return profile.addMetadata(self.name) do |item|
			begin
				com = item.getCommunication
				if !com.nil?
					domains = {}
					addresses = com.getTo.to_a + com.getFrom.to_a+ com.getCc.to_a + com.getBcc.to_a
					addresses.each do |address|
						if @regex.match(address.getAddress)
							domain = address.getAddress.gsub(@regex, '\\1') 
							domains[domain] = true if !domain.nil?
						end
					end
					
					next domains.keys.sort.join(CustomFieldBase.delimiter)
				else
					next ""
				end
			rescue Exception => exc
				next "Error: #{exc.message}"
			end
		end
	end
end