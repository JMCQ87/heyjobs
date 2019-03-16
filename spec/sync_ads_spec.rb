require_relative '../lib/sync_ads'

describe 'Sync Ad Service' do
  # Unit tests
  it "should load local state" do
    local_state = SyncAds.new().send(:load_local_state)
    expect(local_state.length).to eq(4)
  end

  it "should find no differences if there are none" do
    mock_state = [
      {
        "reference": "1",
        "status": "enabled",
        "description": "Description for campaign 11"
      }
    ]
    differences = SyncAds.new().send(:compare_states, mock_state, mock_state)
    expected_differences = []
    expect(differences).to eq(expected_differences)
  end

  # Integration test, with external service
  it "should load remote state" do
    remote_state = SyncAds.new().send(:retrieve_remote_state)
    expect(remote_state.length).to eq(3)
  end

  # End-to-End tests
  it "should record differences" do
    differences = SyncAds.call()
    expected_differences = [{:remote_reference=>"3", :discrepancies=>{"description"=>{:remote=>"Description for campaign 13", :local=>"NoScription"}, "options"=>{:remote=>nil, :local=>"broadcast"}}},
      {:remote_reference=>"404", :error=>"Campaign missing from Remote!"}]
    expect(differences).to eq(expected_differences)
  end

  it "should record no differences if there are none" do
    differences = SyncAds.call(local_path: 'campaigns/remote.json')
    expected_differences = []
    expect(differences).to eq(expected_differences)
  end




end
