Helper = require('hubot-test-helper')
expect = require('chai').expect
nock = require('nock')

CONSTS = require('./../scripts/jirabot/src/constants.coffee')


helper = new Helper('./../scripts/jira.coffee')


describe 'get PM-tickets by authorized person', ->
  room = null

  beforeEach ->
    room = helper.createRoom()
    nock.disableNetConnect()
    nock(CONSTS.URL, {
      reqheaders: {
        'Authorization': /Basic.*/
      }
    })
      .filteringPath( (path) -> return CONSTS.SEARCH_URL)
      .get(CONSTS.SEARCH_URL)
      .reply 200, { issues: [
          {key: "PM-123"},
          {key: "PM-156"},
          {key: "PM-189"},
        ] }

  afterEach ->
    room.destroy()
    nock.cleanAll()

  context 'user says "PM-tickets TODO" to hubot', ->
    beforeEach (done) ->
      room.user.say 'vf', '@hubot PM-tickets TODO'
      setTimeout done, 100

    it 'should reply with user\'s PM-tickets', ->
      expect(room.messages).to.eql [
        ['vf', '@hubot PM-tickets TODO'],
        ['hubot', 'PM-123'],
        ['hubot', 'PM-156'],
        ['hubot', 'PM-189'],
      ]


describe 'unathorized user may not get PM-tickets', ->
  room = null

  beforeEach ->
    room = helper.createRoom()
    nock.disableNetConnect()
    nock(CONSTS.URL)
      .filteringPath( (path) -> return CONSTS.SEARCH_URL)
      .get(CONSTS.SEARCH_URL)
      .reply 401, 'Unauthorized user'

  afterEach ->
    room.destroy()
    nock.cleanAll()

  context 'user says "PM-tickets TODO" to hubot', ->
    beforeEach (done) ->
      room.user.say 'vf', '@hubot PM-tickets TODO'
      setTimeout done, 100

    it 'should reply with user\'s PM-tickets', ->
      expect(room.messages).to.eql [
        ['vf', '@hubot PM-tickets TODO'],
        ['hubot', 'Error: Unauthorized user'],
        ['hubot', 'Pls. Specify your username and password'],
      ]


describe 'get detailed PM-tickets', ->
  room = null

  beforeEach ->
    room = helper.createRoom()
    nock.disableNetConnect()
    nock(CONSTS.URL, {
      reqheaders: {
        'Authorization': /Basic.*/
      }
    })
      .filteringPath( (path) -> return CONSTS.SEARCH_URL)
      .get(CONSTS.SEARCH_URL)
      .reply 200, { issues: [
              {
                key: "PM-123",
                fields: {
                  summary: 'Wash dishes',
                  issuelinks: [
                    {
                      outwardIssue: {
                        key: 'SCRUM-1',
                        fields: {
                          summary: 'Find dishes'
                        }
                      }
                    },
                    {
                      outwardIssue: {
                        key: 'SCRUM-2',
                        fields: {
                          summary: 'Wash dishes'
                        }
                      }
                    },
                    {
                      outwardIssue: {
                        key: 'SCRUM-3',
                        fields: {
                          summary: 'Dry dishes'
                        }
                      }
                    }
                  ]
                }
              },
              {
                key: "PM-45",
                fields: {
                  summary: 'Watch movie',
                  issuelinks: [
                    {
                      outwardIssue: {
                        key: 'SCRUM-4',
                        fields: {
                          summary: 'Find movie'
                        }
                      }
                    },
                    {
                      outwardIssue: {
                        key: 'SCRUM-5',
                        fields: {
                          summary: 'Watch movie'
                        }
                      }
                    }
                  ]
                }
              }
            ]}

  afterEach ->
    room.destroy()
    nock.cleanAll()

  context 'user says "detailed PM-tickets TODO" to hubot', ->
    beforeEach (done) ->
      room.user.say 'vf', '@hubot detailed PM-tickets TODO'
      setTimeout done, 100

    it 'should reply with user\'s detailed PM-tickets', ->
      expect(room.messages).to.eql [
        ['vf', '@hubot detailed PM-tickets TODO'],
        ['hubot', 'performing...'],
        ['hubot', "<#{CONSTS.URL}#{CONSTS.ISSUE_LINK}PM-123|PM-123> Wash dishes\n\t<#{CONSTS.URL}#{CONSTS.ISSUE_LINK}SCRUM-1|SCRUM-1> Find dishes\n\t<#{CONSTS.URL}#{CONSTS.ISSUE_LINK}SCRUM-2|SCRUM-2> Wash dishes\n\t<#{CONSTS.URL}#{CONSTS.ISSUE_LINK}SCRUM-3|SCRUM-3> Dry dishes"],
        ['hubot', "<#{CONSTS.URL}#{CONSTS.ISSUE_LINK}PM-45|PM-45> Watch movie\n\t<#{CONSTS.URL}#{CONSTS.ISSUE_LINK}SCRUM-4|SCRUM-4> Find movie\n\t<#{CONSTS.URL}#{CONSTS.ISSUE_LINK}SCRUM-5|SCRUM-5> Watch movie"],
      ]
