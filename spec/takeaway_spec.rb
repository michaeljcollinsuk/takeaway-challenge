require 'takeaway.rb'

describe Takeaway do
  let(:menu) { double :menu, dishes: {'prawn crackers' => 2} }
  let(:menu_klass) { double :menu_klass, new: menu }
  let(:text) { double :text, send_text: nil }
  let(:text_klass) { double :text_klass, new: text }
  subject(:takeaway) { described_class.new(menu_klass, text_klass) }

  describe '#menu' do
    it 'returns a copy of the menu' do
      expect(takeaway.menu).to eq ({'prawn crackers' => 2})
    end
  end

  describe '#order' do
    it 'allows user to order from the menu' do
      expect(takeaway).to respond_to(:order).with(2).argument
    end

    it 'updates the basket with the item and quantity' do
      takeaway.order('prawn crackers', 2)
      expect(takeaway.basket).to eq ({'prawn crackers' => 2, "Total" => "£4"})
    end

    it 'checks the ordered item is on the menu and returns an error if not' do
      expect{takeaway.order('potato')}.to raise_error 'Sorry, that item is not on the menu'
    end

  end

  describe '#basket' do
    it 'returns the items in the basket' do
      takeaway.order('prawn crackers', 2)
      expect(takeaway.basket).to eq Hash ({'prawn crackers' => 2, "Total" => "£4"})
    end
  end

  describe '#confirm_order' do
    it 'raises an error if the total given does not match the total of the order' do
      takeaway.order('prawn crackers', 3)
      expect{takeaway.confirm_order(5)}.to raise_error 'Total is not correct, please try again'
    end

    it 'sends a confirmation text' do
      takeaway.order('prawn crackers')
      expect(text).to receive(:send_text)
      takeaway.confirm_order(2)
    end
  end

  describe '#calculate_total' do
    it 'calculates the total of the items in the basket' do
      takeaway.order('prawn crackers', 3)
      expect(takeaway.calculate_total).to eq 6
    end
  end
end
