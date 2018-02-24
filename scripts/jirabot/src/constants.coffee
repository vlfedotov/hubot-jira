URL = 'https://b2bpolis.atlassian.net'
ISSUE_LINK = '/browse/'
SEARCH_URL = '/rest/api/2/search?jql='
SEARCH_PATTERN = 'project = PM and TLBackend = "vf@cmios.ru" and Sprint = 716 and status = "Development" ORDER BY Rank'

CONSTS =
  URL: URL
  ISSUE_LINK: ISSUE_LINK
  SEARCH_URL: SEARCH_URL
  SEARCH_PATTERN: SEARCH_PATTERN

module.exports = CONSTS
