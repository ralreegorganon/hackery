#!/usr/bin/env ruby
%w{rubygems trollop gnomedo-ruby}.each { |lib| require lib}
class ExampleAction < GnomeDo::Action
  
  def initialize(json=nil)
    super :name => "Example Action", 
          :description => "Run an example action",
          :icon => "text-x-script",
          :supported_item_types => ["Do.Universe.ITextItem"]
    
    @items = json.nil? ? {} : ActiveSupport::JSON.decode(json) 
  end
  
  def perform
    text = item_values_for_key "Text"
    reverse = text.map { |t| GnomeDo::TextItem.new :text => t.reverse }
  end

end

if __FILE__ == $0
  opts = Trollop::options do
    opt :do_action_def, "Print GNOME Do Action definition"
  end

  if opts[:do_action_def]
    puts ExampleAction.new.to_json
  else
    puts ExampleAction.new(ARGV[0]).perform.to_json
  end
end
