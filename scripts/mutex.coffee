# Description:
#   A mechanism for taking possession of the staging server,
#   and releasing it appropriately after you're done using it.

# Configuration:
#   STAGING_SERVER_NAMES = array of servers to keep track of.

# Commands:
#   hubot i am using staging - marks staging as yours.
#   hubot who is using staging - tells you who's using staging.
#   hubot i'm done with staging - releases staging.
#   hubot all (mutex|reservations) - lists all server reservations.

# Author:
#   brady@thewellinspired.com

STAGING_SERVER_NAMES = ['Staging']

module.exports = (robot) ->

  robot.respond /who (?:is using|has|haz) ([\w\-\s]+)\??/i, (res) ->
    serverReservation(res, robot)

  robot.respond /(?:i|im|i'm) (?:using|need|want) ([\w\-\s]+)/i, (res) ->
    mutexList = getMutexList(robot)
    serverName = STAGING_SERVER_NAMES.find((item) -> item.toLowerCase() == res.match[1].toLowerCase())
    if serverName?
      mutexList[serverName] = res.message.user.real_name
      robot.logger.debug "serverName: #{serverName}"
      robot.brain.set('mutexList', mutexList)
      res.send "#{res.message.user.real_name}, you now have #{serverName} reserved!"
    else # This server isn't in STAGING_SERVER_NAMES.
      res.send "Sorry, but that doesn't sound like one of our existing servers. Our existing servers are: #{STAGING_SERVER_NAMES.join(', ')}"

  robot.respond /(?:i|im|i.m) done with ([\w\-\s]+)/i, (res) ->
    mutexList = getMutexList(robot)
    serverName = STAGING_SERVER_NAMES.find((item) -> item.toLowerCase() == res.match[1].toLowerCase())
    if serverName?
      delete mutexList[serverName]
      robot.brain.set('mutexList', mutexList)
      res.send "#{serverName} has been released!"
    else # This server isn't in STAGING_SERVER_NAMES.
      res.send "Sorry, but that doesn't sound like one of our existing servers. Our existing servers include: #{STAGING_SERVER_NAMES.join(', ')}"

  robot.respond /(current|server)?.+?(current|server)?.+?reservations/i, (res) ->
    serverReservations(res, robot)

  robot.respond /(current|server)?.+?(current|server)?.+?list/i, (res) ->
    serverReservations(res, robot)

getMutexList = (robot) ->
  m = robot.brain.get('mutexList')
  m = {} unless typeof m == 'object' && m != null
  m

serverReservations = (res, robot) ->
  mutexList = getMutexList(robot)
  serverList = []
  for serverName, user in mutexList
    serverList += "#{serverName}: #{user}\n"
  res.send "Current server reservation list:\n#{serverList.join()}"

serverReservation = (res, robot) ->
  mutexList = getMutexList(robot)
  robot.logger.debug "mutexList: #{JSON.stringify(robot.brain.get('mutexList'))}"
  serverName = STAGING_SERVER_NAMES.find((item) -> item.toLowerCase() == res.match[1].toLowerCase())
  if mutexList[serverName]?
    res.send "#{res.message.user.real_name}, currently #{mutexList[serverName]} has #{serverName} reserved."
  else
    res.send "Nobody is using #{serverName} right now!"
