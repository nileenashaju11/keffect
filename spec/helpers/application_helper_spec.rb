# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  describe '#bulma_flash_class' do
    it 'casts a string to a symbol' do
      expect(helper.bulma_flash_class('string')).to eq(:string)
    end

    it 'returns :danger when :error is given' do
      expect(helper.bulma_flash_class(:error)).to eq(:danger)
    end

    it 'returns :success when :notice is given' do
      expect(helper.bulma_flash_class(:notice)).to eq(:success)
    end

    it 'returns the key when nothing special is happening' do
      non_special_keys = [
        :success,
        :warning,
        :timeout,
        :special,
        :anything
      ]
      non_special_keys.each do |key|
        expect(helper.bulma_flash_class(key)).to eq(key)
      end
    end
  end

  describe '#format_phone_number' do
    it 'formats for a standard 10 digit number' do
      expect(helper.format_phone_number('1234567890')).to eq('(123) 456-7890')
      expect(helper.format_phone_number('a1b2c3d4e5f6g7h8i9j0k')).to eq('(123) 456-7890')
      expect(helper.format_phone_number('///1--2345..6>>7890')).to eq('(123) 456-7890')
    end

    it 'returns whatever is sent if not 10 digits' do
      expect(helper.format_phone_number('123456789')).to eq('123456789')
      expect(helper.format_phone_number('a1b2c3d4e5f6g7h8i9jk')).to eq('a1b2c3d4e5f6g7h8i9jk')
      expect(helper.format_phone_number('///1--2345..6>>789')).to eq('///1--2345..6>>789')
    end
  end
end
