class TagsController < ApplicationController
  before_filter :login_required, :only => %w(create destroy)
  
  def index
    @tags = Tag.all
  end
  
  def show
  end
  
  def create
    @tag = params[:tag][:name]
    
    respond_to do |format|
      format.html
    end
  end
  
  def destroy
  end
end
