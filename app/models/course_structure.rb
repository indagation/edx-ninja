class CourseStructure < ActiveResource::Base
  self.site = "https://edge.edx.org/api/course_structure/v0"
  self.element_name = "course_structures"
  self.include_format_in_path = false

  def self.sturdy_find(id)
    self.find(id)
    retried = false
  rescue ActiveResource::Redirection => ex
    unless retried
      require 'net/http'
      require 'json'
      domain = URI.parse(ex.response['Location']).host
      url = ex.response['Location']
      uri = URI(url)
      response = Net::HTTP.get(uri)
      p JSON.parse(response)
      retried = true and retry # retry operation
    end
  end
end