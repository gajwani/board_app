require "board"
require "board_test_support/doubles/gui_spy"
require "support/board_test_dsl"
require "support/common_assertions"


describe "USE CASE: updateing an interesting" do
  include CommonAssertions
  include BoardTestDSL

  context "Given an interesting already exists" do
    before do
      @whiteboard = create_whiteboard
      @interesting = create_interesting(whiteboard_id: @whiteboard.id, observer: gui)
    end

    context "When I update it" do
      context "And I try to blank out the date" do
        before do
          update_interesting(interesting_id: @interesting.id, observer: gui, date: nil)
        end
        
        it "informs the observer that a date is required" do
          assert_observer_got_one_error(gui, :date, :required)
        end
      end

      context "And I try to blank out the title" do
        before do
          update_interesting(interesting_id: @interesting.id, observer: gui, title: nil)
        end

        it "informs the observer that a title is required" do
          assert_observer_got_one_error(gui, :title, :required)
        end
      end

      context "And I try to blank out the whiteboard_id" do
        before do
          update_interesting(interesting_id: @interesting.id, observer: gui, whiteboard_id: nil)
        end

        it "informs the observer that a whiteboard_id is required" do
          assert_observer_got_one_error(gui, :whiteboard_id, :required)
        end
      end

      context "And I provide a valid date, title, and whiteboard_id" do
        before do
          @new_date = valid_interesting_attributes[:date].next_day
          @new_title = rand.to_s

          update_interesting(interesting_id: @interesting.id, observer: gui, date: @new_date, title: @new_title)
        end

        it "sends a interesting back to the gui with the requested attributes" do
          expect(gui.spy_updated_interesting.attributes).to include({date: @new_date, title: @new_title})
        end

        it "doesn't send any validation errors" do
          expect(gui.spy_validation_errors).not_to be
        end
      end
    end
  end

  context "When I try to update an interesting that doesn't exist" do
    before do
      update_interesting(interesting_id: "bogus_id", observer: gui)
    end

    specify "Then the use case should notify the observer that the interesting is not found" do
      expect(gui.spy_entity_not_found).to be(true)
    end
  end

  let(:gui) { GuiSpy.new }
end
