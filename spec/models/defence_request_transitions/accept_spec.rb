require_relative "../../../app/models/defence_request_transitions/accept"
require "transitions"

RSpec.describe DefenceRequestTransitions::Accept, "#complete" do
  it "transitions the defence request to accept state" do
    defence_request = spy(:defence_request)
    user = spy(:user)
    transition_to = "accept"

    DefenceRequestTransitions::Accept.new(
      defence_request: defence_request,
      transition_to: transition_to,
      user: user,
    ).complete

    expect(defence_request).to have_received(:cco=).with(user)
    expect(defence_request).to have_received(:accept)
    expect(defence_request).to have_received(:save!)
  end

  it "returns false if the defence_request could not be transitioned" do
    defence_request = spy(:defence_request)
    user = spy(:user)
    transition_to = "accept"

    allow(defence_request).to receive(:accept).and_raise(Transitions::InvalidTransition)

    transition = DefenceRequestTransitions::Accept.new(
      defence_request: defence_request,
      transition_to: transition_to,
      user: user,
    ).complete

    expect(defence_request).to have_received(:cco=).with(user)
    expect(defence_request).not_to have_received(:save!)
    expect(transition).to eq false
  end
end
