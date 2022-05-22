require 'rails_helper'
begin
  require "restaurant"
rescue LoadError
end

if defined?(Restaurant)
  RSpec.describe "Restaurant", :type => :model do
    let(:valid_attributes) do
      {
        name: "La Tour d'Argent",
        address: "15 Quai de la Tournelle, 75005 Paris",
        phone_number: "01 43 54 23 31",
        category: "french"
      }
    end

    it "has a name" do
      restaurant = Restaurant.new(name: "La Tour d'Argent")
      expect(restaurant.name).to eq("La Tour d'Argent")
    end

    it "has an address" do
      restaurant = Restaurant.new(address: "15 Quai de la Tournelle, 75005 Paris")
      expect(restaurant.address).to eq("15 Quai de la Tournelle, 75005 Paris")
    end

    it "has a phone number" do
      restaurant = Restaurant.new(phone_number: "01 43 54 23 31")
      expect(restaurant.phone_number).to be_a(String)
      expect(restaurant.phone_number).to eq("01 43 54 23 31")
    end

    it "has a category" do
      restaurant = Restaurant.new(category: "french")
      expect(restaurant.category).to eq("french")
    end

    it "name cannot be blank" do
      attributes = valid_attributes
      attributes.delete(:name)
      restaurant = Restaurant.new(attributes)
      expect(restaurant).not_to be_valid
    end

    it "address cannot be blank" do
      attributes = valid_attributes
      attributes.delete(:address)
      restaurant = Restaurant.new(attributes)
      expect(restaurant).not_to be_valid
    end

    it "category cannot be blank" do
      attributes = valid_attributes
      attributes.delete(:category)
      restaurant = Restaurant.new(attributes)
      expect(restaurant).not_to be_valid
    end

    it "neptunian is not a valid category" do
      attributes = valid_attributes
      attributes[:category] = "neptunian"
      restaurant = Restaurant.new(attributes)
      expect(restaurant).not_to be_valid
    end

    %w(chinese italian japanese french belgian).each do |category|
      it "#{category} is a valid category" do
        attributes = valid_attributes
        attributes[:category] = category
        restaurant = Restaurant.new(attributes)
      expect(restaurant).to be_valid
      end
    end

    it "has many reviews" do
      restaurant = Restaurant.new(valid_attributes)
      expect(restaurant).to respond_to(:reviews)
    end

    it "should destroy child reviews when destroying self" do
      restaurant = Restaurant.create!(valid_attributes)
      3.times { restaurant.reviews.create! content: "great!", rating: 5 }
      expect { restaurant.destroy }.to change { Review.count }.from(3).to(0)
    end
  end

else
  describe "Restaurant" do
    it "should exist" do
      expect(defined?(Restaurant)).to eq(true)
    end
  end
end
