def create_valid_post
  @post = create(:post, postable: @building, user: @user, title: 'title', body: 'body')
end

def create_valid_tip
  category = Category.create(name: 'Tips', color: 'red')
  @post = create(:post, postable: @building, user: @user, title: 'title', body: 'body', category: category)
end
