module CustomValidation
	mattr_accessor :name_regex, :bad_name_message, :email_name_regex, :domain_head_regex, :domain_tld_regex, :email_regex, :bad_email_message

	self.name_regex        = /\A[^[:cntrl:]\\<>\/&$\*~`!@#%^()_+=:";?{}|]*\z/              # Unicode, permissive
  self.bad_name_message  = "cannot accept special characters excluding space, dot( . ), apostrophe( ' ) and hyphen( - )".freeze

  self.email_name_regex  = '[\w\.%\+\-]+'.freeze
  self.domain_head_regex = '(?:[A-Z0-9\-]+\.)+'.freeze
  self.domain_tld_regex  = '(?:[A-Z]{2}|com|org|net|edu|gov|mil|biz|info|mobi|name|aero|jobs|museum)'.freeze
  self.email_regex       = /\A#{email_name_regex}@#{domain_head_regex}#{domain_tld_regex}\z/i
  self.bad_email_message = "should look like an email address.".freeze
end

ActiveRecord::Base.extend(CustomValidation)