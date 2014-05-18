# LetItFall

Let it snow or something in the Mac terminal.

## Installation

Add this line to your application's Gemfile:

    gem 'let_it_fall'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install let_it_fall

## Usage

Open the Mac terminal, then try following command.

    $ let_it_fall beer

You also enjoy over 800 commands other than `beer` like `sunflower`, `faces` or `moons`.

During the fall running, hitting a return key will change the character to fall.

Also `let_it_fall go` command let them fall in rotation automatically without the key hitting.

`code` command is a special. It takes one or more unicodes which specify characters to fall.

    $ let_it_fall code 0x2660 0x2666 -r # code command with --range option

Or try `matrix` command.

    $ let_it_fall matrix

If you prefer another character rather than latin one, pass it to the command.

    $ let_it_fall matrix kanjis

These command takes `--speed` option(ex. -s=2), and some also takes `--color` option(ex. -c=31). `let_it_fall -h` for more info.

## Contributing

1. Fork it ( https://github.com/[my-github-username]/let_it_fall/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
