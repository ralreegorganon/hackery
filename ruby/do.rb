#!/usr/bin/env ruby
require 'rubygems'
require 'json'
require 'trollop'

do_action_def = { 
  :Name => 'Get Current Time', 
  :Description => 'Gets the current time from a script.', 
  :Icon => 'text-x-script',
  :SupportedItemTypes => ['Do.Universe.ITextItem', 'Do.Universe.IFileItem', 'OpenSearch.IOpenSearchItem']
}

opts = Trollop::options do
  opt :do_action_def, "Print GNOME Do Action definition"
end

if opts[:do_action_def]
  puts do_action_def.to_json
else 
  items_json = ARGV[0]
  #items_json = File.read(ARGV[0])
  
  foo = ""
  items = JSON.parse(items_json)
  items.each do |item|
    if item.has_key? 'Text'
      foo = item['Text']
    end
  end
  
  return_items = [
    { :__type => 'Do.Universe.TextItem',
      :Name => 'Text From Script',
      :Description => 'Description From Script',
      :Icon => 'gnome-mime-text',
      :Text => foo
      }
    ]
    
  puts return_items.to_json
end

