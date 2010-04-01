class NodesController < ApplicationController
  before_filter :login_required

  include Protocols

  def index
    @tree = treeify
  end

  def edit
    @node = Node.find(params[:id])
    render :layout => false
  end

  def create
    @node = Node.new(params[:node])
    @node.parent = Node.find(params[:parent_id])

    respond_to do |format|
      if @node.save
        format.json { render :json => Protocols.json_ok(:data => node_path(@node)) }
      else
        format.json { render :json => Protocols.json_oops }
      end
    end
  end

  def update
    @node = Node.find(params[:id])
    @node.parent = Node.find(params[:parent_id])

    respond_to do |format|
      if @node.update_attributes(params[:node]) and @node.save
        format.json { render :json => Protocols.json_ok }
      else
        format.html { render :json => Protocols.json_oops }
      end
    end
  end

  def destroy
    @node = Node.find(params[:id])
    @node.destroy

    respond_to do |format|
      format.json { render :json => Protocols::json_ok }
    end
  end

  private

  def treeify(node = Node.first)
    hash = Hash.new

    hash[:data] = {
      :title => node.name,
      :attributes => {
        :href => node_path(node)
      }
    }
    hash[:attributes] = {
      :id => 'tree-node-' + node.name,
    }

    if node.children.count > 0
      children = []
      node.children.each do |n|
        children << treeify(n)
      end
      hash[:children] = children
    end

    return hash
  end
end
