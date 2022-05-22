require 'rails_helper'
begin
  require "review"
rescue LoadError
end

if defined?(Review)
  RSpec.describe "Review", :type => :model do
    let(:valid_attributes) do
      {
        content: "This is a great restaurant!",
        rating: 5,
        restaurant_id: restaurant.id
      }
    end
    let(:restaurant) do
      Restaurant.create!({
        name: "La Tour d'Argent",
        address: "15 Quai de la Tournelle, 75005 Paris",
        phone_number: "01 43 54 23 31",
        category: "french"
      })
    end

    it "has a content" do
      review = Review.new(content: "This is a great restaurant")
      expect(review.content).to eq("This is a great restaurant")
    end

    it "has a rating (stored as integer)" do
      review = Review.new(rating: 5)
      expect(review.rating).to eq(5)
    end

    it "content cannot be blank" do
      attributes = valid_attributes
      attributes.delete(:content)
      review = Review.new(attributes)
      expect(review).not_to be_valid
    end

    it "rating cannot be blank" do
      attributes = valid_attributes
      attributes.delete(:rating)
      review = Review.new(attributes)
      expect(review).not_to be_valid
    end

    it "parent restaurant cannot be nil" do
      attributes = valid_attributes
      attributes.delete(:restaurant_id)
      review = Review.new(attributes)
      expect(review).not_to be_valid
    end

    it "rating should be an integer" do
      attributes = valid_attributes
      attributes[:rating] = "five"
      review = Review.new(attributes)
      expect(review).not_to be_valid
    end

    it "rating should be a number between 0 and 5" do
      attributes = valid_attributes
      (0..5).each do |rating|
        attributes[:rating] = rating
        review = Review.new(attributes)
        expect(review).to be_valid
      end

      expect(Review.new(attributes.merge(rating: -1))).not_to be_valid
      expect(Review.new(attributes.merge(rating: 6))).not_to be_valid
    end
  end
else
  describe "Review" do
    it "should exist" do
      expect(defined?(Review)).to eq(true)
    end
  end
end