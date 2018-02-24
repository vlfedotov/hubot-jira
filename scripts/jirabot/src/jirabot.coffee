CONSTS = require('./constants.coffee')


class Jirabot

  constructor: (@robot) ->
    @robot.respond /hello/i, @hello
    @robot.respond /link/i, @link
    @robot.respond /PM-tickets TODO/i, @myPMs
    @robot.respond /detailed PM-tickets TODO/i, @myDetailedPMs

  link: (msg) ->
    msg.send 'So does this one: <http://www.foo.com|www.foo.com>'

  hello: (msg) ->
    msg.reply 'Hello to you'

  myPMs: (msg) ->
    options =
      headers:
        authorization: "Basic #{process.env.TOKEN}"

    msg.http(CONSTS.URL + CONSTS.SEARCH_URL + CONSTS.SEARCH_PATTERN, options)
      .get() (err, res, body) ->
         if err
           msg.send 'Encountered an error :('
           # msg.send res.statusCode
           msg.send err
           return
         if res.statusCode is 401
           msg.send "Error: #{body}"
           msg.send 'Pls. Specify your username and password'
           return
         msg.send issue.key for issue in JSON.parse(body).issues


  myDetailedPMs: (msg) ->
    msg.send 'performing...'

    makeSCRUM = (issue) ->
      if issue.outwardIssue
        issue_link = CONSTS.URL + CONSTS.ISSUE_LINK + issue.outwardIssue.key
        result_link = "<#{issue_link}|#{issue.outwardIssue.key}>"
        return "\n\t#{result_link} #{issue.outwardIssue.fields.summary}"
      issue_link = CONSTS.URL + CONSTS.ISSUE_LINK + issue.inwardIssue.key
      result_link = "<#{issue_link}|#{issue.inwardIssue.key}>"
      return "\n\t#{result_link} #{issue.inwardIssue.fields.summary}"
    makePM = (issue) ->
      issue_link = CONSTS.URL + CONSTS.ISSUE_LINK + issue.key
      result = "<#{issue_link}|#{issue.key}>"
      issue = issue.fields
      result += " #{issue.summary}"
      result += makeSCRUM(li) for li in issue.issuelinks
      return result

    options =
      headers:
        authorization: "Basic #{process.env.TOKEN}"

    msg.http(CONSTS.URL + CONSTS.SEARCH_URL + CONSTS.SEARCH_PATTERN, options)
      .get() (err, res, body) ->
        if err
          msg.send 'Encountered an error :('
          # msg.send res.statusCode
          msg.send err
          return
        if res.statusCode is 401
          msg.send "Error: #{body}"
          msg.send 'Pls. Specify your username and password'
          return

        msg.send makePM(issue) for issue in JSON.parse(body).issues

  makePMaa = (issue) ->
    issue.key
    #result = ''
    #result += issue.key
    #console.log(result)
    #return result

module.exports = (robot) -> new Jirabot(robot)
