class PostsController < ApplicationController
  before_filter :postable

  authorization_filter [ :create, :post ], :postable, :only => [ :new, :create ]
  authorization_filter :update, :post, :only => [ :edit, :update ]
  authorization_filter :delete, :post, :only => [ :destroy ]

  # GET /posts/new
  # GET /posts/new.xml
  def new
    @post = Post.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @post }
    end
  end

  # GET /posts/1/edit
  def edit
  end

  # POST /posts
  # POST /posts.xml
  def create
    @post = postable.posts.build(params[:post])
    @post.author = current_agent

    respond_to do |format|
      if @post.save
        flash[:notice] = t('post.created')
        format.html { redirect_to(polymorphic_path([ postable.container, postable ], :anchor => dom_id(@post))) }
        format.xml  { render :xml => @post, :status => :created, :location => @post }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @post.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /posts/1
  # PUT /posts/1.xml
  def update
    respond_to do |format|
      if post.update_attributes(params[:post])
        flash[:notice] = t('post.updated')
        format.html { redirect_to(polymorphic_path([ postable.container, postable ], :anchor => dom_id(@post))) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @post.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.xml
  def destroy
    post.destroy

    respond_to do |format|
      format.html { redirect_to(polymorphic_path([@postable.container, @postable], :anchor => 'posts')) }
      format.xml  { head :ok }
    end
  end

  private
  
  def post
    @post ||= Post.find(params[:id])
  end

  def postable
    @postable ||= record_from_path(:acts_as => :resource)
  end
end
