class PostsController < ApplicationController

  def new
    @post = Post.new
  end

  def show
  end

  def create
    if params[:files].present?
      new_photos_attributes = params[:files].inject({}) do |hash, file|
        hash.merge!(SecureRandom.hex => { image: file })
      end
      photos_attributes = post_params[:photos_attributes].to_h.merge(new_photos_attributes)
      post_attributes  = post_params.merge(photos_attributes: photos_attributes)
      # new したタイミングで画像がcacheにアップロードされる
      @post = Post.new(post_attributes)
      if @post.save
        # save成功するとDBに書き込みされる
        flash[:notice] = '画像も一緒に投稿しました。'
        redirect_to root_path
      else
        Rails.logger.error @post.errors.inspect
        flash[:alert] = '投稿に失敗しました'
        render 'new'
      end

    else
      @post = Post.new(post_params)
      if @post.save
        flash[:notice] = '投稿しました。'
        redirect_to root_path
      else
        flash[:alert] = '投稿に失敗しました'
        render 'new'
      end
    end
  end

  def edit
    @post = Post.find(params[:id])
  end

  def update
    @post = Post.find(params[:id])
    if params[:files].present?
      @post.photos.destroy_all
      new_photos_attributes = params[:files].inject({}) do |hash, file|
        hash.merge!(SecureRandom.hex => { image: file })
      end
      photos_attributes = post_params[:photos_attributes].to_h.merge(new_photos_attributes)
      post_attributes  = post_params.merge(photos_attributes: photos_attributes)
      @post.update(post_attributes)
      #redirect_to @post
      redicect_to edit_post_path
    else
      @post.update(post_params)
      #redirect_to @post
      redirect_to edit_post_path
    end
  end

  private

    def post_params
      params.require(:post).permit(:title,:content,
                                  :image,
                                  photos_attributes: [:id, :post_id, :image])
    end
end
