WebMock.disable_net_connect! if Rails.env.test?
GITHUB_TOKEN = Rails.env.test? ? "TEST_GITHUB_TOKEN" : "REPLACE_TOKEN"
ITEMS_PER_PAGE = 5
API_PER_PAGE = 100