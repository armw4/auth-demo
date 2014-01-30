describe 'authorization', ->
  whiteList = null

  beforeEach ->
    whiteList = ['ROLES_User', 'ROLES_Admin', 'ROLES_Anonymous']

  it "should return false if none of user's current roles exists in whitelist", ->
    result = Authorizer.authorize whiteList

    expect(result).toBe(false)

  it "should return true if at least of user's current roles exists in whitelist", ->
    result = Authorizer.authorize whiteList

    expect(result).toBe(true)
