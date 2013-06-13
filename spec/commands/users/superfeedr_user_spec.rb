require "spec_helper"

app_require "commands/users/pubsubhubbub_user"

describe PubsubhubbubUser do
  let(:user) { UserFactory.build }
  it "user with pubsubhubbub" do
    user.should_receive(:save).once

    result = PubsubhubbubUser.complete(user)
  end
end