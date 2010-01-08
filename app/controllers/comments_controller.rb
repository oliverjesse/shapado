class CommentsController < ApplicationController
  before_filter :login_required
  before_filter :check_permissions, :except => [:create]

  def create
    comment = Comment.new
    comment.body = params[:body]
    comment.commentable_type = params[:commentable_type]
    comment.commentable_id = params[:commentable_id]
    comment.user = current_user

    if comment.save
      flash[:notice] = t("comments.create.flash_notice")
    else
      flash[:error] = comment.errors.full_messages.join(", ")
    end

    respond_to do |format|
      format.html{redirect_to params[:source]}
    end
  end


  def edit
    @comment = Comment.find(params[:id])
  end

  def update
    respond_to do |format|
      @comment = Comment.find(params[:id])
      @comment.body = params[:body]
      if @comment.valid? && @comment.save
        flash[:notice] = t(:flash_notice, :scope => "comments.update")
        format.html { redirect_to(params[:source]) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @answer.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy

    respond_to do |format|
      format.html { redirect_to(params[:source]) }
      format.xml  { head :ok }
    end
  end

  protected
  def check_permissions
    @comment = Comment.find(params[:id])
    if @comment.nil? || !(current_user.can_modify?(@comment) || current_user.mod_of?(current_group))
      flash[:error] = t("global.permission_denied")
      redirect_to params[:source]
    end
  end
end