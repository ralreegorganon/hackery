#!/usr/bin/env ruby
%w{rubygems trollop net/http gnomedo-ruby}.each { |lib| require lib}
class TinyUrlAction < GnomeDo::Action
  def initialize(json=nil)
    super :name => "Send to TinyUrl", 
          :description => "Shortens a URL using TinyUrl"    
    @items = json.nil? ? {} : ActiveSupport::JSON.decode(json) 
  end
  
  def get_shortened_url_item(url)
    http = Net::HTTP.start("tinyurl.com", 80)
    response = http.get("/api-create.php?url=#{url}")
    tinyurl = response.read_body
    url_item = GnomeDo::TextItem.new :text => tinyurl, :description => url
  end
  
  def ensure_urls_are_valid!(urls)
    urls.map! { |url| url.include?("://") ? url : "http://" + url }
  end
  
  def tinyurl_items
    urls = item_values_for_key("Text")
    ensure_urls_are_valid!(urls)
    urls.map {|url| get_shortened_url_item(url)}
  end
end

if __FILE__ == $0
  opts = Trollop::options do
    opt :do_action_def, "Print GNOME Do Action definition"
  end

  if opts[:do_action_def]
    puts TinyUrlAction.new.to_json
  else
    puts TinyUrlAction.new(ARGV[0]).tinyurl_items.to_json
  end
end
