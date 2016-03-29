require 'rails_helper'

RSpec.describe BallotsController, type: :controller do
  authorize_and_login
  let(:user) { FactoryGirl.create :user }
  let!(:beer) { FactoryGirl.create :beer }
  let(:ballot) { FactoryGirl.create :ballot }

  describe "POST #create" do
    subject { post :create, { beer_id: beer.id } }
    let!(:poll) { FactoryGirl.create :poll }

    it "creates a new ballot" do
      expect { subject }.to change { Ballot.count }.by(1)
    end

    it "assigns a new ballot to the current poll" do
      expect(Ballot.last).to eq(Poll.current.ballots.last)
    end

    it "displays a success message" do
      subject
      expect(flash[:success]).to be_present
    end

    it { is_expected.to redirect_to root_path }

    context "when the user has already voted on the poll" do
      let(:another_beer) { FactoryGirl.create :beer }
      before(:each) do
        post :create, { beer_id: another_beer.id }
      end

      it "does not create a new ballot" do
        expect { subject }.to change { Ballot.count }.by(0)
      end

      it "displays an error message" do
        subject
        expect(flash[:danger]).to be_present
      end

      it "re-renders the #new action" do
        expect(subject).to render_template(:new)
      end
    end
  end

  describe "GET #new" do
    let!(:poll) { FactoryGirl.create :poll }
    subject { get :new }

    it "assigns beers to @beers" do
      subject
      expect(assigns(:beers)).to eq(Beer.all)
    end

    it "assigns a new ballot to @ballot" do
      subject
      expect(assigns(:ballot)).to be_a_new(Ballot)
    end
  end

  describe "PATCH update"do
    subject { put :update, id: ballot.to_param, beer_id: another_beer.id }
    let(:another_beer) { FactoryGirl.create :beer, name: "Corona" }

    it "updates the ballot" do
      expect { subject }.to change { ballot.reload.beer.name}.to("Corona")
    end

    it { is_expected.to redirect_to root_path }
  end

  describe "DELETE #destroy" do
    subject { delete :destroy, id: ballot.to_param }

    let!(:ballot) { FactoryGirl.create :ballot }

    it "deletes a beer" do
      expect { subject }.to change { Ballot.count }.by(-1)
    end

    it { is_expected.to redirect_to root_path }
  end
end
