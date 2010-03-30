class NodePermissionsController < ApplicationController
  before_filter :login_required

  def index
    @permissions = NodePermissions.find_all_by_node_id(params[:node_id])

    respond_to do |format|
      format.json { render :json => Protocols::json_ok(:data => @permissions) }
    end
  end

  def show
    @permission = NodePermission.find(params[:id])

    respond_to do |format|
      format.json { render :json => Protocols::json_ok(:data => @permission) }
    end
  end

  def create
    @permission = NodePermission.new
    @permission.node = Node.find(params[:node_id])
    @permission.user = User.find(params[:node_permission][:user_id])

    respond_to do |format|
      if @permission.save
        format.json { render :json => Protocols::json_ok(:data => @permission) }
      else
        format.json { render :json => Protocols::json_oops(:data => @permission.errors) }
      end
    end
  end

  def destroy
    @permission = NodePermission.find(params[:id])
    @permission.destroy

    respond_to do |format|
      format.json { render :json => Protocols::json_ok }
    end
  end

  def update
    @permission = NodePermission.find(params[:id])
    @permission.node = Node.find(params[:node_id])
    @permission.user = User.find(params[:node_permission][:user_id])

    respond_to do |format|
      if @permission.save
        format.json { render :json => Protocols::json_ok }
      else
        format.json { render :json => Protocols::json_oops }
      end
    end
  end
end
