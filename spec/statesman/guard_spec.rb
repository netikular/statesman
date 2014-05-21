require "spec_helper"

describe Statesman::Guard do
  let(:callback) { -> {} }
  let(:guard) { Statesman::Guard.new(from: nil, to: nil, message: 'Guard Error', callback: callback) }

  specify { expect(guard).to be_a(Statesman::Callback) }

  describe "#call" do
    subject { guard.call }

    context "success" do
      let(:callback) { -> { true } }

      it "does not raise an error" do
        expect { guard.call }.to_not raise_error
      end
    end

    context "error" do
      let(:callback) { -> { false } }

      it "raises an error" do
        expect { guard.call }.to raise_error(Statesman::GuardFailedError)
      end

      it "raises an error with a custom message" do
        expect { guard.call }.to raise_error(Statesman::GuardFailedError)
        expect { guard.call }.to raise_error("Guard Error")
      end
    end
  end
end
