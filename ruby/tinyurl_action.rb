#!/usr/bin/env ruby
%w{rubygems json trollop net/http gnomedo-ruby}.each { |lib| require lib}
class TinyUrlAction
  attr_accessor :action_definition
  
  def initialize()
    @action_definition = GnomeDo::Action.new :name => "Send to TinyUrl", 
                                             :description => "Shortens a URL using TinyUrl"
  end
  
  def print_action_definition
   puts @action_definition.to_json
  end
  
  def get_shortened_url_item(url)
    http = Net::HTTP.start("tinyurl.com", 80)
    response = http.get("/api-create.php?url=#{url}")
    tinyurl = response.read_body
    url_item = GnomeDo::TextItem.new :name => "TinyUrl Item", :description => url, :text => tinyurl
  end
  
  def get_urls_from_json(json)
    items = JSON.parse(json)
    items.map { |item| item.select {|k,v| k=="Text" }.flatten[1] }
  end
  
  def ensure_urls_are_valid!(urls)
    urls.map! { |url| url.include?("://") ? url : "http://" + url }
  end
  
  def print_tinyurl_json(json)
    urls = get_urls_from_json(json)
    ensure_urls_are_valid!(urls)
    print urls.map {|url| get_shortened_url_item(url)}.to_json
  end
  
end

action = TinyUrlAction.new

opts = Trollop::options do
  opt :do_action_def, "Print GNOME Do Action definition"
end

if opts[:do_action_def]
  action.print_action_definition
else
  action.print_tinyurl_json ARGV[0]
end