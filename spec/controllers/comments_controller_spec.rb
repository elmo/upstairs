require 'rails_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.

RSpec.describe CommentsController, type: :controller do
  # This should return the minimal set of attributes required to create a valid
  # Comment. As you add validations to Comment, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) { { body: 'body' } }
  let(:invalid_attributes) { { body: nil } }

  before(:each) do
    Post.any_instance.stub(:create_notifications).and_return(true)
    request.env['HTTP_REFERER'] = 'http://'
    load_valid_building
    load_user
    @commentable = create(:post, user: @user, postable: @building)
    @post = create(:post, user: @user, postable: @building)
    sign_in(@user)
    request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials('bandit', 'smokey')
  end

  describe 'GET index' do
    it 'assigns all comments as @comments' do
      comment = create(:comment, commentable: @commentable, user: @user)
      get :index, post_id: @post.id
      expect(assigns(:comments)).to eq([comment])
    end
  end

  describe 'GET show' do
    it 'assigns the requested comment as @comment' do
      comment = create(:comment, commentable: @commentable, user: @user)
      get :show, id: comment.to_param, post_id: @post.id
      expect(assigns(:comment)).to eq(comment)
    end
  end

  describe 'GET new' do
    it 'assigns a new comment as @comment' do
      get :new, post_id: @post.id
      expect(assigns(:comment)).to be_a_new(Comment)
    end
  end

  describe 'GET edit' do
    it 'assigns the requested comment as @comment' do
      comment = create(:comment, commentable: @commentable, user: @user)
      get :edit, post_id: @post.id, id: comment.to_param, post_id: @post.id
      expect(assigns(:comment)).to eq(comment)
    end
  end

  describe 'POST create' do
    describe 'with valid params' do
      it 'creates a new Comment' do
        expect do
          post :create, post_id: @post.id, comment: valid_attributes
        end.to change(Comment, :count).by(1)
      end

      it 'assigns a newly created comment as @comment' do
        post :create, post_id: @post.id, comment: valid_attributes
        expect(assigns(:comment)).to be_a(Comment)
        expect(assigns(:comment)).to be_persisted
      end

      it 'redirects to the created comment' do
        post :create, post_id: @post.id, comment: valid_attributes
        expect(response).to redirect_to(building_post_path(@building, @post))
      end
    end

    describe 'with invalid params' do
      it 'assigns a newly created but unsaved comment as @comment' do
        post :create, post_id: @post.id, comment: invalid_attributes
        expect(assigns(:comment)).to be_a_new(Comment)
      end

      it "re-renders the 'new' template" do
        post :create, post_id: @post.id, comment: invalid_attributes
        expect(response).to render_template('new')
      end
    end
  end

  describe 'PUT update' do
    describe 'with valid params' do
      let(:new_attributes) do
        { body: 'a new body' }
      end

      it 'updates the requested comment' do
        comment = create(:comment, commentable: @commentable, user: @user)
        put :update, post_id: @post.id, id: comment.to_param, comment: new_attributes
        expect(response).to redirect_to(building_post_path(@building, @post))
      end

      it 'assigns the requested comment as @comment' do
        comment = create(:comment, commentable: @commentable, user: @user)
        put :update, post_id: @post.id, id: comment.to_param, comment: valid_attributes
        expect(assigns(:comment)).to eq(comment)
      end

      it 'redirects to the comment' do
        comment = create(:comment, commentable: @commentable, user: @user)
        put :update, post_id: @post.id, id: comment.to_param, comment: valid_attributes
        expect(response).to redirect_to(building_post_path(@building, @post))
      end
    end

    describe 'with invalid params' do
      it 'assigns the comment as @comment' do
        comment = create(:comment, commentable: @commentable, user: @user)
        put :update, post_id: @post.id, id: comment.to_param, comment: invalid_attributes
        expect(assigns(:comment)).to eq(comment)
      end

      it "re-renders the 'edit' template" do
        comment = create(:comment, commentable: @commentable, user: @user)
        put :update, post_id: @post.id, id: comment.to_param, comment: invalid_attributes
        expect(response).to render_template('edit')
      end
    end
  end

  describe 'DELETE destroy' do
    it 'destroys the requested comment' do
      comment = create(:comment, commentable: @commentable, user: @user)
      expect do
        delete :destroy, post_id: @post.id, id: comment.to_param
      end.to change(Comment, :count).by(-1)
    end

    it 'redirects to the comments list' do
      comment = create(:comment, commentable: @commentable, user: @user)
      delete :destroy, post_id: @post.id, id: comment.to_param
      expect(response).to redirect_to(comments_url)
    end
  end
end
