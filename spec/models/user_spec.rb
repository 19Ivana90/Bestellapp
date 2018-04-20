require 'rails_helper'

RSpec.describe User, "instance methods" do
  let(:user) { create(:user) }

  describe "#update_and_confirm" do
    it "updates the given attributes and confirms the user" do
      user.update_and_confirm(first_name: 'Bugs', last_name: 'Bunny')

      expect(user.first_name).to eq 'Bugs'
      expect(user.last_name).to eq 'Bunny'
      expect(user).to be_confirmed
    end

    it "doesn't confirm the user if the update fails" do
      user.update_and_confirm(last_name: nil)

      expect(user).to_not be_confirmed
    end
  end
end
