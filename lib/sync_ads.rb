require_relative 'callable'
require 'pry'
require 'json'
require 'faraday'

class SyncAds
  include Callable

  def initialize(local_path: 'campaigns/local.json', campaign_url: "https://mockbin.org/bin/fcb30500-7b98-476f-810d-463a0b8fc3df")
    # The Sync object consists of a URL to get the remote version and a local to compare to
    @local_path = local_path
    @campaign_url = campaign_url
  end

  def call
    local_state = load_local_state()
    remote_state = retrieve_remote_state()

    comparison = compare_states(local_state, remote_state)
  end

  private

  def compare_states(local_state, remote_state)
    # [
    #   {
    #     "remote_reference": "1",
    #     "discrepancies": {
    #       "status": {
    #         "remote": "disabled",
    #         "local": "active"
    #       },
    #       "description": {
    #         "remote": "Rails Engineer",
    #         "local": "Ruby on Rails Developer"
    #       }
    #     }
    #   }
    # ]
    differences = []

    local_state.each do |campaign|
      reference = campaign['reference']
      remote_campaign = remote_state.detect { |c| c['reference'] == reference }

      difference = {remote_reference: reference, discrepancies: {}}

      if remote_campaign
        next if remote_campaign == campaign

        campaign.each do |k, v|
          # Generically check and record differences for all other keys in hash,
          # except the key reference itself
          remote_value = remote_campaign[k]

          if remote_value == v
            next
          else
            difference[:discrepancies][k] = {remote: remote_value, local: v}
          end
        end

        differences << difference
      else
        differences << {remote_reference: reference, error: "Campaign missing from Remote!"}
      end
    end

    # TODO take care of campaigns that are present on remote but not locally
    differences
  end

  def retrieve_remote_state
    response = Faraday.get(@campaign_url)
    data = JSON.parse(response.body)
    data['ads']
  end

  def load_local_state
    file = File.read(@local_path)
    data = JSON.parse(file)
    data['ads']
  end
end
