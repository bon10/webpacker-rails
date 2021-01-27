class PagesController < ApplicationController
  def top
    @posts = Post.all.reverse
  end
end
