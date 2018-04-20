require 'rails_helper'

RSpec.describe Order, "assocations" do
  let(:order) { create(:order) }

  describe "line items" do
    let!(:product) { create(:product) }
    let(:quantity) { 10 }

    it "allows to create line items with a product and quantity" do
      order.line_items_attributes = {
        '0' => {
          'product_id' => product.id,
          'quantity' => quantity
        }
      }

      expect { order.save }.to change(LineItem, :count).by(1)

      line_item = LineItem.last!
      expect(line_item.product_id).to eq product.id
      expect(line_item.quantity).to eq quantity
    end

    it "doesn't allow to create line items without a product" do
      order.line_items_attributes = { '0' => { 'quantity' => quantity } }

      expect { order.save }.to_not change(LineItem, :count)
    end

    it "doesn't allow to create line items without a quantity" do
      order.line_items_attributes = { '0' => { 'product_id' => product.id } }

      expect { order.save }.to_not change(LineItem, :count)
    end

    it "doesn't allow to create line items with a negative" do
      order.line_items_attributes = { '0' => { 'product_id' => product.id, 'quantity' => '-1' } }

      expect { order.save }.to_not change(LineItem, :count)
    end

    it "allows to update a line item with an ID and a quantity" do
      line_item = create(:line_item, order: order, quantity: 10)
      order.line_items_attributes = { '0' => { 'id' => line_item.id, 'quantity' => '20' } }
      order.save

      expect(line_item.reload.quantity).to eq 20
    end

    it "allows to destroy a line item" do
      line_item = create(:line_item, order: order, quantity: 10)
      order.line_items_attributes = { '0' => { 'id' => line_item.id, '_destroy' => '1' } }

      expect { order.save }.to change(LineItem, :count).by(-1)
    end

    it "adds some quantity to an existing line item based on product ID" do
      line_item = create(:line_item, order: order, quantity: 10)

      order.line_items_attributes = {
        '0' => {
          'product_id' => line_item.product_id,
          'quantity' => 10
        }
      }

      expect { order.save }.to_not change(LineItem, :count)
      expect(line_item.reload.quantity).to eq 20
    end
  end
end

RSpec.describe Order, "class methods" do
  describe ".next_number" do
    it "starts with 00001" do
      expect(described_class.next_number).to eq '00001'
    end

    it "calculates the next number if there are already orders in the database" do
      create(:order, number: '00010')

      expect(described_class.next_number).to eq '00011'
    end

    context "when an offset is set in the environment" do
      before { ENV['ORDER_NUMBERS_OFFSET'] = '00004' }
      after { ENV.delete('ORDER_NUMBERS_OFFSET') }

      it "startes with the correct number" do
        expect(described_class.next_number).to eq '00005'
      end

      it "ignores the offset if there are already orders in the database" do
      create(:order, number: '00010')

      expect(described_class.next_number).to eq '00011'
      end
    end
  end
end

RSpec.describe Order, "instance methods" do
  describe "#accept" do
    let(:customer_id) { '1234-1234' }
    subject(:order) { create(:order, :placed) }

    it "sets the accepted_at datetime" do
      order.accept(customer_id: customer_id)

      expect(order.accepted_at).to be_within(1.second).of(Time.current)
    end

    it "updates the order with the given attributes" do
      order.accept(customer_id: customer_id)

      expect(order.customer_id).to eq customer_id
    end

    context "order numbers" do
      it "sets the number for the first order" do
        order.accept(customer_id: customer_id)

        expect(order.number).to eq '00001'
      end

      it "sets the number for a subsequent order" do
        previous_order = create(:order, :accepted)
        previous_order.update_column(:number, '00005')

        order.accept(customer_id: customer_id)

        expect(order.number).to eq '00006'
      end
    end

    context "when the order is already accepted" do
      subject(:order) { create(:order, :placed, :accepted) }

      it "doesn't update the order" do
        expect { order.accept(customer_id: customer_id) }.to_not change { [order.accepted_at, order.customer_id] }
      end
    end
  end
end
