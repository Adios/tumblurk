class NodeMappingsController < ApplicationController
  before_filter :login_required

  def index
    @mappings = NodeMapping.find_all_by_node_id(params[:node_id])

    respond_to do |format|
      format.json { render :json => Protocols::json_ok(:data => @mappings) }
    end
  end

  def edit
    @mapping = NodeMapping.find(params[:id])

    respond_to do |format|
      format.json { render :json => Protocols::json_ok(:data => @mapping) }
    end
  end

  def create
    @mapping = NodeMapping.new
    @mapping.node = Node.find(params[:node_id])
    @mapping.blog = Blog.find(params[:node_mapping][:blog_id])
    @mapping.tag = Tag.find(params[:node_mapping][:tag_id]) if not params[:node_mapping][:tag_id].blank?

    respond_to do |format|
      if @mapping.save
        format.json { render :json => Protocols::json_ok(:data => @mapping) }
      else
        format.json { render :json => Protocols::json_oops(:data => @mapping.errors) }
      end
    end
  end

  def destroy
    @mapping = NodeMapping.find(params[:id])
    @mapping.destroy

    respond_to do |format|
      format.json { render :json => Protocols::json_ok }
    end
  end

  def update
    @mapping = NodeMapping.find(params[:id])
    @mapping.node = Node.find(params[:node_id])
    @mapping.blog = Blog.find(params[:node_mapping][:blog_id])
    @mapping.tag = Tag.find(params[:node_mapping][:tag_id]) if not params[:node_mapping][:tag_id].blank?

    respond_to do |format|
      if @mapping.save
        format.json { render :json => Protocols::json_ok }
      else
        format.json { render :json => Protocols::json_oops }
      end
    end
  end
end
