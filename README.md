## Pump

Zero-configuration Rack server written on pure ruby.

### Installation
Only Mac OS X is supported now.

without rvm:

    $ gem install pump
    $ sudo pump install

with rvm:

We recommend you to use individual gem set for pump. Don't worry pump will be available for all gem sets and rubies.

    $ rvm use 1.9.3@pump --create
    $ gem install pump
    $ rvmsudo pump install

NOTE: If you have installed pow and you don't want uninstall it that I have good news.
You can install pump and remove ipfw rule:

    sudo ipfw list | grep 20559
    sudo delete NUM

Where NUM is first column of command output.
Note that if you restart system you should repeat steps again.

### Usage

After `pump install`, you should create symbol link to your project.

    $ cd ~/.pump
    $ ln -s /path-to-app/dirname

By default your project will be available as dirname.pump
You can set up your own domain name when you create a symlink. It's simple, let's see:

    $ cd ~/.pump && ln -s /path-to-app/dirname domain.name

And that's it, yes.

### Uninstall

You can uninstall it whenever you want.

without rvm:

    $ sudo pump uninstall
    $ gem uninstall pump

with rvm:

    $ rvmsudo pump uninstall
    $ gem uninstall pump
