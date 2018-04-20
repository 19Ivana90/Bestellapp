require 'rails_helper'

RSpec.describe Product, "class methods" do
  describe ".search" do
    let!(:product_1) { create(:product, name: "Podravka Vegeta 250 g", available: { 'AT' => '1001', 'DE' => '61001' }) }
    let!(:product_2) { create(:product, name: "Podravka Vegeta 500 g", available: { 'AT' => '1002', 'DE' => '61002' }) }
    let!(:product_3) { create(:product, name: "Podravka Ajvar 370 ml scharf", available: { 'AT' => '1019', 'DE' => '61019' }) }
    let!(:product_4) { create(:product, name: "Podravka Ajvar 370 ml scharf", available: { 'AT' => '1027a' }) }

    it "finds products with the given search string in the name" do
      expect(described_class.search('vegeta')).to match_array [product_1, product_2]
    end

    it "finds products with the given search string as the SKU" do
      expect(described_class.search('1001')).to eq [product_1]
    end

    context "when given a country code" do
      it "only finds product which are available in the given country" do
        expect(described_class.search('ajvar', country_code: 'AT')).to match_array [product_3, product_4]
        expect(described_class.search('ajvar', country_code: 'DE')).to eq [product_3]
      end
    end
  end
end
