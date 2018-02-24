# Helper = require('hubot-test-helper')
expect = require('chai').expect

Issue = require('./../scripts/jirabot/src/Issue')
CONSTS = require('./../scripts/jirabot/src/constants.coffee')


# helper = new Helper('./../scripts/issue.coffee')


describe 'parsing issue ticket', ->
  it 'ticket toString', ->
    issueData =
      key: 'SCRUM-1',
      fields:
        summary: 'Find dishes'

    issue = new Issue(issueData)

    issueLink = "<#{CONSTS.URL}#{CONSTS.ISSUE_LINK}SCRUM-1|SCRUM-1>"
    expect(issue.toString()).to.eql "#{issueLink} Find dishes"

