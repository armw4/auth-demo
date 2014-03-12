describe 'authorizer', ->
  describe 'authorize', ->
    Authorizer = require '../../../lib/authorization/authorizer'
    sinon      = require 'sinon'

    whiteList  = ['ROLES_User', 'ROLES_Admin', 'ROLES_Anonymous']

    describe "none of current user's roles exist in whitelist", ->
      it "should return false", ->
        result = Authorizer.authorize ['ROLES_None'], whiteList

        expect(result).toBe false

    describe "at least one of current user's roles exist in whitelist", ->
      it "should return true", ->
        result = Authorizer.authorize ['ROLES_User'], whiteList

        expect(result).toBe true
