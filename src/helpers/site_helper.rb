module SiteHelper
  attr_accessor :content_hash
  def content_hash
    @content_hash ||= {}
  end
  
  def yield_for(index)
    output = self.content_hash[index.to_sym]
    output = "" if output.nil?
    output
  end
end