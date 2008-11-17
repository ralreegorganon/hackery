$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

%w[rubygems json activesupport].each { |f| require f }

module GnomeDo
  VERSION = '0.0.1'
  
  module DoObject
    attr_accessor :name, :description, :icon
    def initialize(options = {})
      options = {
        :name => "New object",
        :description => "A new object.",
        :icon => "gnome-mime-text"
      }.merge(options)
      options.each do |k,v|
        instance_variable_set("@#{k.to_s}", v)
      end
    end
    
    def hash_for_json
      h = {}
      instance_variables.each do |v|
        h[v.gsub(/@/,"").camelize] = instance_variable_get(v)
      end
      h
    end
  end
  
  module DoTextItem
    include DoObject
    attr_accessor :text
    def initialize(options = {})
      super
      options = {
        :text => "No text provided."
      }.merge(options)
      options.each do |k,v|
        instance_variable_set("@#{k.to_s}", v)
      end
    end
  end 
  
  module DoAction
    include DoObject
    attr_accessor :supported_item_types
    def initialize(options = {})
      super
      options = {
        :icon => "text-x-script",
        :supported_item_types => ["Do.Universe.ITextItem"]
      }.merge(options)
      options.each do |k,v|
        instance_variable_set("@#{k.to_s}", v)
      end
    end
  end
  
  class TextItem
    include DoTextItem
    DO_TYPE = "ScriptActions.TextItem"   
    def initialize(options = {})
      super
    end
    def to_json(*a)
      hash_for_json.merge
      {
        "__type" => DO_TYPE
      }.to_json(*a)
    end
  end
  
  class Action
    include DoAction  
    def initialize(options = {})
      super
    end  
    def to_json(*a)
      hash_for_json.to_json(*a)
    end
  end
end