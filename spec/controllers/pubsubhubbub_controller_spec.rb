require "spec_helper"

app_require "controllers/pubsubhubbub_controller"

describe "PubsubhubbubController" do
  context "when a user has not configured pubsubhubbub" do
    before do
      UserRepository.stub(:has_pubsubhubbub?).and_return(false)
    end

    describe "GET /config/pubsubhubbub" do
      it "displays a form to enter pubsubhubbub username/password" do
        get "/config/pubsubhubbub"

        page = last_response.body
        page.should have_tag("form#add-pubsubhubbub-setup")
        page.should have_tag("input#pubsubhubbub_username")
        page.should have_tag("input#pubsubhubbub_password")
        page.should have_tag("input#submit")
      end
    end

    describe "POST /config/pubsubhubbub" do
      it "rejects empty pubsubhubbub username/password" do
        post "/config/pubsubhubbub"

        page = last_response.body
        page.should have_tag("div.error")
      end

      it "accepts confirmed pubsubhubbub username/password and redirects to next step" do
        post "/config/pubsubhubbub", {pubsubhubbub_username: "demo", pubsubhubbub_password: "demo"}

        last_response.status.should be 302
        URI::parse(last_response.location).path.should eq "/"
      end
    end
  end

  context "when a user has configured pubsubhubbub" do
    before do
      UserRepository.stub(:has_pubsubhubbub?).and_return(true)
    end

    it "delete pubsubhubbub username/password and redirects to next step" do

      post "/delete/pubsubhubbub", {remove_pubsubhubbub_username: "demo"}

      last_response.status.should be 302
      URI::parse(last_response.location).path.should eq "/"
    end

  end
end