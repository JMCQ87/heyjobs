require_relative 'callable'

class LoadAdStates
  include Callable

  def initialize(sync_ad)
    @local_path = sync_ad.local_path
    @campaign_url = sync_ad.campaign_url
  end

  def call
    local_state, remote_state = load_local_state, retrieve_remote_state
  end

  private

  def load_local_state
    file = File.read(@local_path)
    data = JSON.parse(file)
    data['ads']
  end

  def retrieve_remote_state
    response = Faraday.get(@campaign_url)
    data = JSON.parse(response.body)
    data['ads']
  end

end
