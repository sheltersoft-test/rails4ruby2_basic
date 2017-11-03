module Subdomain
  class Brand
    def self.matches?(request)
      request.subdomain.empty? or not [:admin].include? request.subdomain.split('.')[0].to_sym
    end
  end
end
