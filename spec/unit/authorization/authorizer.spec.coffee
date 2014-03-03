Authorizer = require '../../../lib/authorization/authorizer'
sinon      = require 'sinon'

describe 'authorization', ->
  whiteList = null

  describe "none of current user's roles exist in whitelist", ->
    beforeEach ->
      whiteList = ['ROLES_User', 'ROLES_Admin', 'ROLES_Anonymous']

      sinon.stub User, 'current', ->
        roles: ['ROLES_None']

    afterEach ->
      User.current.restore()

    it "should return false", ->
      result = Authorizer.authorize whiteList

      expect(result).toBe false

  describe "at least of current user's roles exist in whitelist", ->
    beforeEach ->
      whiteList = ['ROLES_User', 'ROLES_Admin', 'ROLES_Anonymous']

      sinon.stub User, 'current', ->
        roles: ['ROLES_User']

    afterEach ->
      User.current.restore()

    it "should return true", ->
      result = Authorizer.authorize whiteList

      expect(result).toBe true
