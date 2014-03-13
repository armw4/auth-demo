auth-demo
---------

Authorization sample in node.js

Folder Structure
----------------

Convention for folders is:

`lib/<feature-name>`

Typically up to 4 components will reside in this directory:

* `lib/<feature-name>/<feature-name>.js`  - contains domain/business logic
* `lib/<feature-name>/model.js`           - persistence/queries (wrapper on top of mongodb, mongoose, etc.)
* `lib/<feature-name>/schema.js`          - mongoose schema definition
* `lib/<feature-name>/service.js`         - rest service that communicates with external systems (gateway)

#### Examples

* `lib/market-summary/market-summary.js`
* `lib/market-summary/model.js`
* `lib/market-summary/schema.js`
* `lib/market-summary/service.js`

Running Tests
-------------

requires `jasmine-node@1.13.1`. `jasmine-node@2.0.0` has been released and of course comes cloaked with
breaking changes. I'll work to upgrade us to `jasmine-node@2.0.0` as apart of a separate effort.

Integration tests also require a local instance of mongodb (`jasmine:integraton:development` grunt target).

#### Initial Setup

```shell
$ git clone repourl && cd checkout-dir
$ npm install
$ npm install -g grunt
$ npm install -g jasmine-node@1.13.1
```

#### Unit Tests (development environment)

> **NOTE:** The `jasmine:unit` target is a blocking operation.

```shell
$ cd checkout-dir
$ grunt jasmine:unit --verbose
```

If you don't want to do TDD (`jasmine:unit` blocks and auto runs tests after a source file change),
then you can trigger a one time run via `jasmine:unit:ci`.

#### Unit Tests (build agent)

```shell
$ grunt jasmine:unit:ci --verbose
```

#### Integration Tests (development environment)

```shell
$ cd checkout-dir
$ grunt jasmine:integraton:development --verbose
```

#### Integration Tests (build agent)

```shell
$ grunt jasmine:integraton:ci --verbose
```

The `jasmine:integraton:ci` target assumes that `mongod` is running on a remote computer and does
not attempt to trigger the `mongo:start` and `mongo:stop` targets.

Outstanding Issues
------------------

#### Completed

* resolve crazy `User.current()` guy (want to keep business/domain layer away from expressjs) ✔
* read mongo environment configuration from gruntjs config ✔
* add test case to ensure at least exactly 1 to 4 preferences are selected ✔

#### Pending

* revamp start/stop server logic ✗
* break grunt tasks into separate files ✗
* make live call to external web service to replace fake array of preferences (007 may have already done this guy) ✗
* default selections for user if none saved in database ✗
* port to branch inside github ✗

Nice To Haves
-------------

#### Completed

* remove global references to mongoose and User ✔

#### Pending

* upgrade to jasmine-node 2.0.0 (fix all breaking changes, beforeAll, afterAll hooks) ✗
