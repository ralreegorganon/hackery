#!/usr/bin/env ruby

require 'rubygems'
require 'camping'

Camping.goes :Dotsync

module Dotsync::Models
  class Client < Base
    has_many :deployments
    has_many :dotfiles, :through => :deployments
  end
  
  class Dotfile < Base
    has_many :deployments
    has_many :clients, :through => :deployments
  end
  
  class Deployment < Base
    belongs_to :client
    belongs_to :dotfile
  end
  
  class InitialSchema < V 0.1
    def self.up
      create_table :dotsync_dotfiles do |t|
        t.column :name, :string, :limit => 255
        t.column :content, :text
      end  
      create_table :dotsync_clients do |t|
        t.column :host, :string, :limit => 255
        t.column :username, :string, :limit => 255
        t.column :password, :string, :limit => 255
      end
      create_table :dotsync_deployments do |t|
        t.column :dotfile_id, :integer, :null => false
        t.column :client_id, :integer, :null => false
      end
    end
      
    def self.down
      drop_table :dotsync_dotfiles
      drop_table :dotsync_clients
      drop_table :dotsync_deployments
    end
  end 
end

module Dotsync::Controllers
  class Index < R '/'
    def get
      @clients = Client.find :all
      @dotfiles = Dotfile.find :all
      render :index
    end
  end
  
  class AddClient
    def get
      @client = Client.new
      render :add_client
    end
    
    def post
      client = Client.create :host => input.client_host,
                             :username => input.client_username,
                             :password => input.client_password
      redirect Index
    end
  end
  
  class EditClient < R '/edit_client/(\d+)', '/edit_client'
    def get client_id
      @client = Client.find client_id
      render :edit_client
    end
    
    def post
      @client = Client.find input.client_id
      @client.update_attributes :host => input.client_host,
                                :username => input.client_username,
                                :password => input.client_password
      redirect Index
    end
  end   
  
  class AddDotfile
    def get
      @dotfile = Dotfile.new
      render :add_dotfile
    end
    
    def post
      dotfile = Dotfile.create :name => input.dotfile_name,
                               :content => input.dotfile_content
      redirect Index
    end
  end
  
  class EditDotfile < R '/edit_dotfile/(\d+)', '/edit_dotfile'
    def get dotfile_id
      @dotfile = Dotfile.find dotfile_id
      render :edit_dotfile
    end
    
    def post
      @dotfile = Dotfile.find input.dotfile_id
      @dotfile.update_attributes :name => input.dotfile_name,
                                 :content => input.dotfile_content
      redirect Index
    end
  end
end

module Dotsync::Views
  def layout
    html do
      head do
        title 'dotsync'
      end
      body do
        div.header do 
          h1 { a 'dotsync', :href => R(Index) }
        end
        div.content do
          self << yield
        end
      end
    end
  end
  def index
    h2 'Clients'
    if @clients.empty?
      p 'No clients.'
    else
      table.varlist do
        for client in @clients
          _client(client)
        end
      end
    end
    p { a 'Add', :href => R(AddClient) }
    
    h2 'Dotfiles'
    if @dotfiles.empty?
      p 'No dotfiles.'
    else
      table.varlist do
        for dotfile in @dotfiles
          _dotfile(dotfile)
        end
      end
    end
    p { a 'Add', :href => R(AddDotfile) }
  end
  
  def add_client
    _client_form(@client, :action => R(AddClient))
  end
  
  def edit_client
    _client_form(@client, :action => R(EditClient))
  end
  
  def _client(client)
    tr do
      td { client.username + "@" + client.host }
      td { a("Edit", :href => R(EditClient, client)) }
    end
  end
  
  def _client_form(client, opts)
    form({:method => 'post'}.merge(opts)) do
      label 'Host', :for => 'client_host'; br
      input :name => 'client_host', :type => 'text', :value => client.host; br

      label 'Username', :for => 'client_username'; br
      input :name => 'client_username', :type => 'text', :value => client.username; br
      
      label 'Password', :for => 'client_password'; br
      input :name => 'client_password', :type => 'text', :value => client.password; br  
      
      input :type => 'hidden', :name => 'client_id', :value => client.id
      input :type => 'submit'        
    end
  end

  def add_dotfile
    _dotfile_form(@dotfile, :action => R(AddDotfile))
  end
  
  def edit_dotfile
    _dotfile_form(@dotfile, :action => R(EditDotfile))
  end
  
  def _dotfile(dotfile)
    tr do
      td { dotfile.name }
      td { a("Edit", :href => R(EditDotfile, dotfile)) }
    end
  end
  
  def _dotfile_form(dotfile, opts)
    form({:method => 'post'}.merge(opts)) do
      label 'Name', :for => 'dotfile_name'; br
      input :name => 'dotfile_name', :type => 'text', :value => dotfile.name; br

      label 'Content', :for => 'dotfile_content'; br
      textarea dotfile.content, :name => 'dotfile_content'; br
      
      input :type => 'hidden', :name => 'dotfile_id', :value => dotfile.id
      input :type => 'submit'        
    end
  end

end

def Dotsync.create
  Dotsync::Models.create_schema
end
