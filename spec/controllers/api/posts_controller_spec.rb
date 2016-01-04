require 'rails_helper'
RSpec.describe Api::PostsController, type: :controller do

  before(:each) do
    request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials("bandit","smokey")
    load_building_with_one_post
    sign_in(@user)
  end

  it 'GET index' do
    get :index, building_id: @building.to_param, format: :json
    expect(response.status).to eq 200
  end

  it 'GET tips' do
    create_valid_tip
    get :tips, building_id: @building.to_param, format: :json
    expect(response.status).to eq 200
  end

  describe 'GET show' do
    it 'finds' do
      get :show, building_id: @building.to_param, id: @post.id, format: :json
      expect(response.status).to eq 200
    end

    it 'rescues not found ' do
      get :show, building_id: @building.to_param, id: -1, format: :json
      expect(response.status).to eq 404
      expect(response.body).to be_json_eql({ error: "not found" }.to_json)
    end

  end

  describe 'POST create' do
    it 'success' do
      expect{ post :create, building_id: @building.slug, post: valid_post_params, format: :json }.to change(Post, :count).by(1)
    end

    it 'response code' do
      post :create, building_id: @building.slug, post: valid_post_params, format: :json
      expect(response.status).to eq 201
      expect(response.body).to be_json_eql({post: PostSerializer.new(Post.last).serializable_hash}.to_json)
    end


    it 'failure' do
      expect{ post :create, building_id: @building.slug, post: {title: nil, starts: nil, body: nil}, format: :json }.to change(Post, :count).by(0)
    end

    it 'response code' do
      post :create, building_id: @building.slug, post: {title: nil}, format: :json
      expect(response.status).to eq 400
    end

    it 'response body renders error messages' do
      post :create, building_id: @building.slug, post: {title: nil, body: nil, severity: nil, status: nil }, format: :json
      expect(response.body).to be_json_eql({
          errors:[
          "Title can't be blank",
          "Category can't be blank"
         ]
       }.to_json)
    end

  end

  describe 'PUT update' do
    it 'success' do
      expect(@post.title).to eq 'title'
      post :update, building_id: @building.slug, id: @post.id,  post: valid_post_params.merge(title: 'updated title'), format: :json
      @post.reload
      expect(@post.title).to eq 'updated title'
    end

    it 'response code success' do
      post :update, building_id: @building.slug, id: @post.id, post: valid_post_params.merge(title: 'updated title'), format: :json
      expect(response.status).to eq 200
      @post.reload
      expect(response.body).to be_json_eql({post: PostSerializer.new(@post).serializable_hash}.to_json)
    end

    it 'response code failure' do
      post :update, building_id: @building.slug, id: @post.id, post: {title: nil}, format: :json
      expect(response.status).to eq 400
      @post.reload
    end

    it 'response body' do
      post :update, building_id: @building.slug, id: @post.id, post: {title: nil}, format: :json
      expect(response.body).to be_json_eql({errors:["Title can't be blank"]}.to_json)
    end
  end

  describe 'DELETE destroy' do

    it 'deletes' do
      Post.any_instance.stub(:destroy).and_return(true)
      delete :destroy, building_id: @building.slug, id: @post.id, format: :json
      expect(response.status).to eq 200
      expect(response.body).to be_json_eql({post: PostSerializer.new(@post).serializable_hash}.to_json)
    end

    it 'fails to delete' do
      Post.any_instance.stub(:destroy).and_return(false)
      delete :destroy, building_id: @building.slug, id: @post.id, format: :json
      expect(response.status).to eq 400
      expect(response.body).to be_json_eql({post: PostSerializer.new(@post).serializable_hash}.to_json)
    end

  end

end
