class CommentsController < ApplicationController
  before_filter :commentable

  authorization_filter [ :create, :comment ], :commentable, :only => [ :new, :create ]
  authorization_filter :update, :comment, :only => [ :edit, :update ]
  authorization_filter :delete, :comment, :only => [ :destroy ]

  # GET /comments/new
  # GET /comments/new.xml
  def new
    @comment = Comment.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @comment }
    end
  end

  # GET /comments/1/edit
  def edit
  end

  # POST /comments
  # POST /comments.xml
  def create
    @comment = commentable.comments.build(params[:comment])
    @comment.author = current_agent

    respond_to do |format|
      if @comment.save
        flash[:notice] = t('comment.created')
        format.html { redirect_to(polymorphic_path([ commentable.container, commentable ], :anchor => dom_id(@comment))) }
        format.xml  { render :xml => @comment, :status => :created, :location => @comment }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @comment.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /comments/1
  # PUT /comments/1.xml
  def update
    respond_to do |format|
      if comment.update_attributes(params[:comment])
        flash[:notice] = t('comment.updated')
        format.html { redirect_to(polymorphic_path([ commentable.container, commentable ], :anchor => dom_id(@comment))) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @comment.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /comments/1
  # DELETE /comments/1.xml
  def destroy
    comment.destroy

    respond_to do |format|
      format.html { redirect_to(polymorphic_path([@commentable.container, @commentable], :anchor => 'comments')) }
      format.xml  { head :ok }
    end
  end

  private
  
  def comment
    @comment ||= Comment.find(params[:id])
  end

  def commentable
    @commentable ||= record_from_path(:acts_as => :resource)
  end
end
