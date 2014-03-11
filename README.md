auth-demo
---------

Authorization sample in node.js

## Folder Structure
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

## Running Tests
-------------

requires `jasmine-node@1.13.1`. `jasmine-node@2.0.0` has been released and of course comes cloaked with
breaking changes. I'll work to upgrade us to `jasmine-node@2.0.0` as apart of a separate effort.

Integration tests also require a local instance of mongodb (`jasmine:integraton:development` grunt target).
