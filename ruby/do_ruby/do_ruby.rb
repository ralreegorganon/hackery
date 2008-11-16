require "rubygems"
require "json"

module DoRuby
  class TextItem
    attr_accessor :name, :description, :icon, :text
    
    def initialize(options = {})
      options = {
        :name => "Text Item", 
        :description => "New text item.",
        :icon => "gnome-mime-text",
        :text => "No text provided."
      }.merge(options)
      
      options.each do |k,v|
        instance_variable_set("@#{k.to_s}", v)
      end
    end
    
    def to_json(*a)
      {
        "__type" => "ScriptActions.TextItem",
        "Name" => name,
        "Description" => description,
        "Icon" => icon,
        "Text" => text
      }.to_json(*a)
    end
  end
  
  class ActionDefinition
    attr_accessor :name, :description, :icon, :supported_item_types
    
    def initialize(options = {})
      options = {
        :name => "Undefined Action", 
        :description => "An action that hasn't been defined yet.",
        :icon => "text-x-script",
        :supported_item_types => ["Do.Universe.ITextItem"]
      }.merge(options)
      
      options.each do |k,v|
        instance_variable_set("@#{k.to_s}", v)
      end
    end
    
    def to_json(*a)
      {
        "Name" => name,
        "Description" => description,
        "Icon" => icon,
        "SupportedItemTypes" => supported_item_types
      }.to_json(*a)
    end
  end
end