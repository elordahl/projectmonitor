class TeamCityRestProject < Project

  validates_presence_of :team_city_rest_build_type_id, :team_city_rest_base_url, unless: ->(project) { project.webhooks_enabled }
  validates :team_city_rest_build_type_id, format: {with: /\Abt\d+\Z/, message: 'must begin with bt'}, unless: ->(project) { project.webhooks_enabled }

  alias_attribute :build_status_url, :feed_url
  alias_attribute :project_name, :feed_url

  def feed_url
    url_with_scheme "#{team_city_rest_base_url}/app/rest/builds?locator=running:all,buildType:(id:#{team_city_rest_build_type_id}),personal:false,branch:(default:any)"
  end

  def fetch_payload
    TeamCityXmlPayload.new(self)
  end

  def webhook_payload
    TeamCityJsonPayload.new
  end

  def has_dependencies?
    true
  end

end
