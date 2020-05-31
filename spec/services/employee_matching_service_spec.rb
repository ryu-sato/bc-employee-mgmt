require 'rails_helper'

RSpec.describe EmployeeMatchingService, type: :service do
    describe '#compatibility' do
        context 'when valid employees specified' do
            let(:emp_a) { create :employee, name: '日本 太郎' }
            let(:emp_b) { create :employee, name: '日本 次郎' }

            it 'return valid compatibility' do
                compatibility = EmployeeMatchingService.instance.compatibility(emp_a, emp_b)
                expect(compatibility).to be >= 0
                expect(compatibility).to be <= 100
            end
        end

        context 'when invalid employees specified' do
            it 'return invalid compatibility' do
                compatibility = EmployeeMatchingService.instance.compatibility(nil, nil)
                expect(compatibility).to be_nil
            end
        end
    end
end
