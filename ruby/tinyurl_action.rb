#!/usr/bin/env ruby
%w{rubygems trollop net/http gnomedo-ruby}.each { |lib| require lib}
class TinyUrlAction < GnomeDo::Action
  def initialize()
    super :name => "Send to TinyUrl", 
          :description => "Shortens a URL using TinyUrl",
          :icon => "text-x-script",
          :supported_item_types => ["Do.Universe.ITextItem"]
  end
  
  def get_shortened_url_item(url)
    http = Net::HTTP.start("tinyurl.com", 80)
    response = http.get("/api-create.php?url=#{url}")
    tinyurl = response.read_body
    url_item = GnomeDo::TextItem.new :text => tinyurl, :description => url
  end
  
  def get_urls_from_json(json)
    items = ActiveSupport::JSON.decode(json)
    urls = items.map { |item| item.select {|k,v| k=="Text" }.flatten[1].gsub(/\n/,"") }
  end
  
  def ensure_urls_are_valid!(urls)
    urls.map! { |url| url.include?("://") ? url : "http://" + url }
  end
  
  def print_tinyurl_json(json)
    urls = get_urls_from_json(json)
    ensure_urls_are_valid!(urls)
    puts urls.map {|url| get_shortened_url_item(url)}.to_json
  end
end

if __FILE__ == $0
  action = TinyUrlAction.new

  opts = Trollop::options do
    opt :do_action_def, "Print GNOME Do Action definition"
  end

  if opts[:do_action_def]
    puts action.to_json
  else
    action.print_tinyurl_json ARGV[0]
  end
end
