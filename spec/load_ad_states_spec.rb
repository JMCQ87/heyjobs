require_relative '../lib/load_ad_states'

describe 'Load Ad campaigns Service' do
  let!(:sync_ad) { SyncAds.new() }

  # Unit test
  it "should load local state" do
    local_state = LoadAdStates.new(sync_ad).send(:load_local_state)
    expect(local_state.length).to eq(4)
  end

  # Integration test, with external service
  it "should load remote state" do
    remote_state = LoadAdStates.new(sync_ad).send(:retrieve_remote_state)
    expect(remote_state.length).to eq(3)
  end

end
