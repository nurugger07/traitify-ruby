require "spec_helper"

describe Traitify::Client do
  before do
    Traitify.configure do |tom|
      tom.secret = "secret"
      tom.api_host = "https://example.com"
      tom.api_version = "v1"
    end
  end

  let(:tom) { Traitify.new }

  describe ".find_results" do
    context "without an image pack" do
      let(:result) { tom.find_results("assessment-uuid") }

      before(:each) do
        stub_it(:get, "/assessments/assessment-uuid/personality_types", "result")
      end

      it "returns a result" do
        expect(result.personality_types.first.personality_type.name).to eq("Analyzer")
      end
    end

    context "with an image pack" do
      context "set in the configurations" do
        let(:tom) { Traitify.new(image_pack: "full-color") }
        let(:result) { tom.find_results("assessment-uuid") }

        before(:each) do
          stub_it(:get, "/assessments/assessment-uuid/personality_types?image_pack=full-color", "result")
        end

        it "returns a result" do
          expect(result.personality_blend.personality_type_1.badge.image_large).to eq("https://traitify-api.s3.amazonaws.com/traitify-api/badges/analayzer/full-color/large")
        end
      end

      context "set in the call" do
        let(:result) { tom.find_results("assessment-uuid", "full-color") }

        before(:each) do
          stub_it(:get, "/assessments/assessment-uuid/personality_types?image_pack=full-color", "result")
        end

        it "returns a result" do
          expect(result.personality_blend.personality_type_1.badge.image_large).to eq("https://traitify-api.s3.amazonaws.com/traitify-api/badges/analayzer/full-color/large")
        end
      end
    end
  end

  describe ".assessment_personality_type" do
    context "with a personality type" do
      let(:personality_traits) { tom.assessment_personality_traits("assessment-uuid", "personality-type-uuid") }

      before(:each) do
        stub_it(:get, "/assessments/assessment-uuid/personality_types/personality-type-uuid/personality_traits", "personality_traits")
      end

      it "returns a result" do
        expect(personality_traits.first.personality_trait.name).to eq("Imaginative")
      end
    end

    context "without a personality type" do
      let(:personality_traits) { tom.assessment_personality_traits("assessment-uuid") }

      before(:each) do
        stub_it(:get, "/assessments/assessment-uuid/personality_traits", "personality_traits")
      end

      it "returns a result" do
        expect(personality_traits.first.personality_trait.name).to eq("Imaginative")
      end
    end
  end
end
