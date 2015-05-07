module PostsHelper

  def post_thumbnail(post)
    content_tag(:li, id: "post_#{post.id}" ) do
      content_tag(:h2) do
        post.title
      end +
      content_tag(:div) do
        post.body[0..200]
      end
    end
  end

end
