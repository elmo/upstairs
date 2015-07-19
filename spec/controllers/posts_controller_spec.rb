require 'rails_helper'
RSpec.describe PostsController, :type => :controller do
  let(:valid_attributes) { {title: "title", body: "body"} }
  let(:invalid_attributes) { {title: nil, body: nil} }

  before(:each) do
    load_valid_building
    load_user
    sign_in(@user)
    @category = create(:category, name: "Free")
  end

  describe "GET index" do
    it "assigns all posts as @posts" do
      create_valid_post
      get :index, building_id: @building.to_param
      expect(assigns(:posts)).to eq([@post])
    end
  end

  describe "GET show" do
    it "assigns the requested post as @post" do
      create_valid_post
      get :show, building_id: @building.to_param ,id: @post.to_param
      expect(assigns(:post)).to eq(@post)
    end
  end

  describe "GET new" do
    it "assigns a new post as @post" do
      get :new,  building_id: @building.to_param
      expect(assigns(:post)).to be_a_new(Post)
    end
  end

  describe "GET edit" do
    it "assigns the requested post as @post" do
      create_valid_post
      get :edit, building_id: @building.to_param, id: @post.to_param
      expect(assigns(:post)).to eq(@post)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Post" do
        expect {
          post :create,  building_id: @building.to_param, post: valid_attributes.merge(category_id: @category.id)
        }.to change(Post, :count).by(1)
      end

      it "assigns a newly created post as @post" do
        post :create,  building_id: @building.to_param, post: valid_attributes.merge(category_id: @category.id)
        expect(assigns(:post)).to be_a(Post)
        expect(assigns(:post)).to be_persisted
      end

      it "redirects to the created post" do
        post :create,  building_id: @building.to_param, post: valid_attributes.merge(category_id: @category.id)
        expect(response).to redirect_to building_post_path(@building, Post.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved post as @post" do
        post :create,  building_id: @building.to_param, post:  invalid_attributes.merge(category_id: @category.id)
        expect(assigns(:post)).to be_a_new(Post)
      end

      it "re-renders the 'new' template" do
        post :create,  building_id: @building.to_param, post: invalid_attributes.merge(category_id: @category.id)
        expect(response).to render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do

      let(:new_attributes) { { title: "new title",  body: "new body" } }

      it "updates the requested post" do
        create_valid_post
        put :update, { building_id: @building.slug , id:  @post.to_param, :post => new_attributes}
        @post.reload
        expect(response).to redirect_to(building_post_path(@building, @post))
      end

      it "assigns the requested post as @post" do
        create_valid_post
        put :update, {id: @post.to_param,  building_id: @building.slug , :post => valid_attributes.merge(category_id: @category.id)}
        expect(assigns(:post)).to eq(@post)
      end

      it "redirects to the post" do
        create_valid_post
        put :update, {id: @post.to_param,  building_id: @building.slug , :post => valid_attributes.merge(category_id: @category.id)}
        expect(response).to redirect_to(building_post_path(@building, @post))
      end
    end

    describe "with invalid params" do
      it "assigns the post as @post" do
        create_valid_post
        put :update, { building_id: @building.slug, id: @post.to_param, :post => invalid_attributes.merge(category_id: @category.id)}
        expect(assigns(:post)).to eq(@post)
      end

      it "re-renders the 'edit' template" do
        create_valid_post
        put :update, { building_id: @building.slug, id: @post.to_param, :post => invalid_attributes.merge(category_id: @category.id)}
        expect(response).to render_template("edit")
      end
    end
  end
end
