class NodesController < ApplicationController
  before_filter :login_required

  def index
    # assume the first entry of Node is always root.
    @root = Node.first
  end

  def show
    @node = Node.find(params[:id])
  end

  def create
    @node = Node.new(params[:node])
    @node.parent = Node.find(params[:node][:parent_id])

    respond_to do |format|
      if @node.save
        flash[:notice] = 'Node was successfully created.'
        format.html { redirect_to @node }
      else
        format.html { render :index }
      end
    end
  end

  def update
    @node = Node.find(params[:id])
    @node.parent = Node.find(params[:node][:parent_id])

    respond_to do |format|
      if @node.update_attributes(params[:node]) and @node.save
        flash[:notice] = 'Node was successfully updated.'
        format.html { redirect_to @node }
      else
        format.html { redner :show }
      end
    end
  end

  def destroy
    @node = Node.find(params[:id])
    @node.destroy

    respond_to do |format|
      format.html { redirect_to nodes_url }
    end
  end
end
