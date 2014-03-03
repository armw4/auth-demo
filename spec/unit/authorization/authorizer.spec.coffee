describe 'authorizer', ->
  describe 'authorize', ->
    Authorizer = require '../../../lib/authorization/authorizer'
    sinon      = require 'sinon'

    whiteList = ['ROLES_User', 'ROLES_Admin', 'ROLES_Anonymous']

    describe "none of current user's roles exist in whitelist", ->
      beforeEach ->
        sinon.stub User, 'current', ->
          roles: ['ROLES_None']

      afterEach ->
        User.current.restore()

      it "should return false", ->
        result = Authorizer.authorize whiteList

        expect(result).toBe false

    describe "at least one of current user's roles exist in whitelist", ->
      beforeEach ->
        sinon.stub User, 'current', ->
          roles: ['ROLES_User']

      afterEach ->
        User.current.restore()

      it "should return true", ->
        result = Authorizer.authorize whiteList

        expect(result).toBe true
