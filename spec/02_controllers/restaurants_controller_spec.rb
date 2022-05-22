require 'rails_helper'
begin
  require "restaurants_controller"
rescue LoadError
end

if defined?(RestaurantsController)
  RSpec.describe RestaurantsController, :type => :controller do

    let(:valid_attributes) do
      {
        name: "La Tour d'Argent",
        address: "15 Quai de la Tournelle, 75005 Paris",
        phone_number: "01 43 54 23 31",
        category: "french"
      }
    end

    let(:invalid_attributes) do
      { name: "" }
    end

    let(:valid_session) { {} }

    describe "GET index" do
      it "routes to #index" do
        expect(:get => "/restaurants").to route_to("restaurants#index")
      end
      it "assigns all restaurants as @restaurants" do
        restaurant = Restaurant.create! valid_attributes
        get :index, params: {}, session: valid_session
        expect(assigns(:restaurants)).to eq([restaurant])
      end
    end

    describe "GET show" do
      it "routes to #show" do
        expect(:get => "/restaurants/1").to route_to("restaurants#show", :id => "1")
      end
      it "assigns the requested restaurant as @restaurant" do
        restaurant = Restaurant.create! valid_attributes
        get :show, params: {:id => restaurant.to_param}, session: valid_session
        expect(assigns(:restaurant)).to eq(restaurant)
      end
      it "assigns a new review as @review", :refactored => true do
        restaurant = Restaurant.create! valid_attributes
        get :show, params: {:id => restaurant.to_param}, session: valid_session
        expect(assigns(:review)).to be_a_new(Review)
      end
    end

    describe "GET new" do
      it "routes to #new" do
        expect(:get => "/restaurants/new").to route_to("restaurants#new")
      end
      it "assigns a new restaurant as @restaurant" do
        get :new, params: {}, session: valid_session
        expect(assigns(:restaurant)).to be_a_new(Restaurant)
      end
    end

    describe "POST create" do
      it "routes to #create" do
        expect(:post => "/restaurants").to route_to("restaurants#create")
      end
      describe "with valid params" do
        it "creates a new Restaurant" do
          expect {
            post :create, params: {:restaurant => valid_attributes}, session: valid_session
          }.to change(Restaurant, :count).by(1)
        end

        it "assigns a newly created restaurant as @restaurant" do
          post :create, params: {:restaurant => valid_attributes}, session: valid_session
          expect(assigns(:restaurant)).to be_a(Restaurant)
          expect(assigns(:restaurant)).to be_persisted
        end

        it "redirects to the created restaurant" do
          post :create, params: {:restaurant => valid_attributes}, session: valid_session
          expect(response).to redirect_to(Restaurant.last)
        end
      end

      describe "with invalid params" do
        it "assigns a newly created but unsaved restaurant as @restaurant" do
          post :create, params: {:restaurant => invalid_attributes}, session: valid_session
          expect(assigns(:restaurant)).to be_a_new(Restaurant)
        end

        it "re-renders the 'new' template" do
          post :create, params: {:restaurant => invalid_attributes}, session: valid_session
          expect(response).to render_template("new")
        end
      end
    end
  end
else
  describe "RestaurantsController" do
    it "should exist" do
      expect(defined?(RestaurantsController)).to eq(true)
    end
  end
end
