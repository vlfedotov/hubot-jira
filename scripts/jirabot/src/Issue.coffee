
CONSTS = require('./constants.coffee')


class Issue
  constructor: (issue) ->
    @key = issue.key
    @summary = if issue.fields then issue.fields.summary else ''

  toString: () ->
    issueUrl = CONSTS.URL + CONSTS.ISSUE_LINK + @key
    issueLink = "<#{issueUrl}|#{@key}>"
    return "#{issueLink} #{@summary}"


class PMIssue extends Issue


module.exports = Issue


