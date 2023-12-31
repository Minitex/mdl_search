require 'rails_helper'

describe ParamsHelper do
  let(:context) do
    Class.new { include ParamsHelper }.new
  end
  subject { context.hidden_fields_hash(parameters) }

  describe '#hidden_fields_hash' do
    context 'with nested parameters' do
      let(:parameters) do
        ActionController::Parameters.new(
          f: ActionController::Parameters.new(
            collection_name: ['Bethel University', 'Northfield Public Library']
          )
        )
      end

      it 'generates the expected hash' do
        expect(subject).to eq(
          'f[collection_name][]' => ['Bethel University', 'Northfield Public Library']
        )
      end
    end

    context 'with flat parameters' do
      let(:parameters) do
        ActionController::Parameters.new(
          foo: 'bar',
          baz: 'qux'
        )
      end

      it 'generates the expected hash' do
        expect(subject).to eq(
          'foo' => 'bar',
          'baz' => 'qux'
        )
      end
    end

    context 'with a mix of flat and nested parameters' do
      let(:parameters) do
        ActionController::Parameters.new(
          f: ActionController::Parameters.new(
            collection_name: ['Bethel University', 'Northfield Public Library']
          ),
          q: ActionController::Parameters.new(
            r: ActionController::Parameters.new(
              s: ['t', 'u', 'v']
            ),
            w: 'x'
          ),
          widgets: ['Widget1', 'Widget2'],
          limit: 20
        )
      end

      it 'generates the expected hash' do
        expect(subject).to eq(
          'f[collection_name][]' => ['Bethel University', 'Northfield Public Library'],
          'q[r][s][]' => ['t', 'u', 'v'],
          'q[w]' => 'x',
          'widgets[]' => ['Widget1', 'Widget2'],
          'limit' => 20
        )
      end
    end

    context 'with a mix of nested depths' do
      let(:parameters) do
        ActionController::Parameters.new(
          q: ActionController::Parameters.new(
            r: ActionController::Parameters.new(
              s: ['t', 'u', 'v']
            ),
            w: 'x'
          )
        )
      end

      it 'generates the expected hash' do
        expect(subject).to eq(
          'q[r][s][]' => ['t', 'u', 'v'],
          'q[w]' => 'x'
        )
      end
    end
  end
end
