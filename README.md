# Buff

Buff is a Buffer API Wrapper written in Ruby.  It provides more thorough API coverage than the existing gem.

Since the gem is currently in ALPHA development, the interface is prone to change.  Please wait until v0.1.0 is released to become reliant on interface. As it stands, all of the basic API calls in BufferApp's spec are available.  Some of the optional params are yet to be implemented.


## Installation

[![Coverage Status](https://coveralls.io/repos/zph/buff/badge.png?branch=master)](https://coveralls.io/r/zph/buff?branch=master) [![Build Status](https://travis-ci.org/zph/buff.png?branch=master)](https://travis-ci.org/zph/buff) [![Code Climate](https://codeclimate.com/github/zph/buff.png)](https://codeclimate.com/github/zph/buff)

For now please `git clone git@github.com:bufferapp/buffer-ruby.git` the repo

Or

Add this line to your application's Gemfile to include HEAD code:

`gem 'buff', :github => 'bufferapp/buffer-ruby'`

And then execute:

`$ bundle`

Or install RubyGems version, which will receive more attention to stability:

`$ gem install buff`

## Usage

  * All methods are tested with Rspec and WebMock. Most methods do not have integration tests that reach out to the live Buffer API servers.  Proceed with caution until Buff reaches v0.1.0 and submit issues on Github Issues tab.
  * Authentication is not included in this gem (Try OAuth-buffer2) or use the single API key given when registering your own Buffer Dev credentials.
  * Commandline bin is provided to enable posting of updates:
    `buff Super witty stuff that fits in 140 chars`
    Will post to your first account when setup following instructions below.
    _A more convenient setup is planned in future releases._
  * For convenience load credentials into `~/.bufferapprc` in the following layout.  This allows the `ACCESS_TOKEN` to be loaded into `Buff::ACCESS_TOKEN`:


```
    ---
    ACCESS_TOKEN: (BufferApp OAuth Access Token)
    PROFILE_INDEX: (default of 0)
    VERSION: (Do not alter)

```

## Access Token Instructions

#### How to Get Started:

* Create a Developer API Token here: http://bufferapp.com/developers/apps/create.
* Fill in Stuff. Your answers don't matter much for the purpose of this rudimentary setup.
* Submit that form and wait a short period (~2 min )
* Visit: http://bufferapp.com/developers/apps
* Gather Access Token and place it after the word "access_token"
* Copy this file to the root of your user's home folder:
* Set Line 2 to 0 if you only have one account to post to. Otherwise it's more complicated ;). Find me on Twitter and I can explain [@_ZPH](https://twitter.com/_ZPH).
*   - ~/.bufferapprc

## TODO:

* Improve instructions

#### Future versions will integrate with Buffer-OAuth system.
* Determine if there is a way to use a single Application rather than creating unique ones per user.
* Integrate Launchy for the purpose of launching browser window.
* Possible to model behavior on [ t.gem ](https://github.com/sferik/t/blob/master/lib/t/cli.rb#L56-L113)

#### Raise error if message is beyond the character limit.
* Accomplish this via [ Twitter Text library ](https://github.com/twitter/twitter-text-rb)
* Refactor to simplify use of default params

## API Coverage

#### Implemented

* User
* Profiles (:get, :post)
* Updates (:get, :post)
* Links
* Info
* Error Codes

Further Details [API Coverage](API_COVERAGE.md)

#### Not Implemented

* Caching

## Supported Ruby Implementations
- MRI 2.0.0
- Others likely work but are not included in CI Server

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

Issues, refactoring, and feedback are all welcome.

Also, this project is newcomer friendly!! We'd love to be your first Open Source Software contribution and would be happy to assist in that process.

Crafted with care by Zander. Reach out and say hi at [@_ZPH](http://twitter.com/_ZPH) or [civet.ws](http://www.civet.ws)
