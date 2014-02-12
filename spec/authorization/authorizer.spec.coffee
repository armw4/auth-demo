Authorizer = require '../../lib/authorization/authorizer'
User       = require '../../lib/user'

describe 'authorization', ->
  whiteList = null

  beforeEach ->
    whiteList = ['ROLES_User', 'ROLES_Admin', 'ROLES_Anonymous']

  it "should return false if none of current user's roles exists in whitelist", ->
    result = Authorizer.authorize whiteList

    expect(result).toBe false

  it "should return true if at least one of current user's current roles exists in whitelist", ->
    result = Authorizer.authorize whiteList

    expect(result).toBe true
