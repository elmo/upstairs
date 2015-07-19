def create_valid_post
  @post = create(:post, postable: @building, user: @user, title: "title", body: "body")
end
