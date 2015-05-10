require "support/common_assertions"
require "board"
require "board_test_support/doubles/gui_spy"
require "board_test_support/doubles/fake_interesting_repo"
require "board_test_support/test_attributes"
require "board_test_support/doubles/fake_team_repo"


describe "USE CASE: creating a interesting" do
  include CommonAssertions
  include TestAttributes

  let(:attributes) { valid_interesting_attributes }

  context "Given a team exists" do
    before do
      @team_id = create_team.id
    end

    context "when the attributes are invalid" do
      context "because the date is blank" do
        let(:attributes) { valid_interesting_attributes.merge(date: nil) }

        it "informs the observer that a date is required" do
          create_interesting(@team_id)
          assert_gui_got_one_error(:date, :required)
        end
      end

      context "because the title is blank" do
        let(:attributes) { valid_interesting_attributes.merge(title: nil) }

        it "informs the observer that a description is required" do
          create_interesting(@team_id)
          assert_gui_got_one_error(:title, :required)
        end
      end

      context "because I don't give it a team_id" do
        let(:team_id) { nil }

        it "informs the observer that a team_id is required" do
          create_interesting(team_id)
          assert_gui_got_one_error(:team_id, :required)
        end
      end
    end

    context "when the attributes are valid" do
      let(:attributes) { valid_interesting_attributes }

      it "sends a interesting back to the gui with the requested attributes" do
        create_interesting(@team_id)
        expect(gui.spy_created_interesting.attributes).to include(attributes)
      end

      it "doesn't send any validation errors" do
        create_interesting(@team_id)
        expect(gui.spy_validation_errors).not_to be
      end
    end
  end

  let(:gui) { GuiSpy.new }
  let(:fake_interesting_repo) { FakeInterestingRepo.new }
  let(:fake_team_repo) { FakeTeamRepo.new }
  let(:team_id) { @team_id }

  def create_interesting(team_id)
    Board.create_interesting(
      observer: gui,
      attributes: attributes,
      interesting_repo: fake_interesting_repo,
      team_id: team_id,
    ).execute
  end

  def create_team
    Board.create_team(
      observer: gui,
      attributes: valid_team_attributes,
      team_repo: fake_team_repo,
    ).execute

    gui.spy_created_team
  end
end
