#!/usr/bin/env ruby
%w{rubygems trollop gnomedo-ruby find fileutils}.each { |lib| require lib}
class InstallPluginAction < GnomeDo::Action
  
  def initialize(json=nil)
    super :name => "Install Plugin", 
          :description => "Installs a plugin from your hackery folder.",
          :icon => "text-x-script",
          :supported_item_types => ["Do.Universe.ITextItem"]
    
    @items = json.nil? ? {} : ActiveSupport::JSON.decode(json) 
  end
  
  def perform
    working_directory = "/home/jj/code/do-plugins/"
    plugin_directory = "/home/jj/.local/share/gnome-do/plugins-0.7.0/"

    plugins = item_values_for_key "Text"
    
    Dir.chdir(working_directory)
    system("#{working_directory}repo.py --make --build") 
   
    plugins.each do |plugin|
      Find.find(working_directory + "repo") do |path|
        FileUtils::cp(path,plugin_directory) if path =~ /#{plugin}.*mpack/i
      end
    end
    system("killall gnome-do")
    system("gnome-do")

    []
  end

end

if __FILE__ == $0
  opts = Trollop::options do
    opt :do_action_def, "Print GNOME Do Action definition"
  end

  if opts[:do_action_def]
    puts InstallPluginAction.new.to_json
  else
    puts InstallPluginAction.new(ARGV[0]).perform.to_json
  end
end
