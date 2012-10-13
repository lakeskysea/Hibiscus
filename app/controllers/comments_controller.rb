class CommentsController < ApplicationController
  before_filter :authenticate_user!, :load_post

  def create
    @comment = @post.comments.build(params[:comment])
    @comment.user = current_user

    if @comment.save
      redirect_to(@post, :notice => 'Thank you for your comment.')
    else
      redirect_to(@post, :flash => { :alert => 'Your comment could not be saved.' })
    end
  end

  def edit
    @comment = @post.comments.find(params[:id])
  end

  def update
    @comment = @post.comments.find(params[:id])
    if @comment.update_attributes(params[:comment])
      redirect_to(@post, :notice => 'Thank you for the update in your comment.')
    else
      render :action => "edit"
    end
  end

  def destroy
    @comment = @post.comments.find(params[:id])
    if @comment.user == current_user
      @comment.destroy
      respond_to do |format|
        format.html { redirect_to(posts_url, :notice => 'Your comment has been deleted') }
        format.xml  { head :ok }
      end
    else
      respond_to do |format|
        format.html { redirect_to(posts_url, :notice => "You can't delete someone else's comment") }
      end
    end
  end

private
  # preload the variable @post that the current comment belongs to
  def load_post
    # the request url will be in this format: "/katas/kata-title/comments/5078b2b5f1d37f2a3a000064"
    resource, id = request.path.split('/')[1, 2]  # retrieve the 2nd and 3rd element in the url
    @post = resource.singularize.classify.constantize.find(id)   # find the right post/kata the comment belongs to
  end

end



