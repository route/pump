# yippee

Yippee is a Pow–like gem for Ruby–lovers (or maybe Javascript–haters).

### Only Mac OS X is supported now.

## Installation

### Without RVM

    $ gem install yippee
    $ install-yippee-for-me

### With RVM

If you are using RVM, you should install `yippee` for every Ruby version you have. Sorry for this. It would be better to install it to `global` gemset.

    $ rvm use 1.9.2@global
    $ gem install yippee
    $ install-yippee-for-me

## Usage

After `install-yippee-for-me`, some magic will happen. Yippee's not just like Pow, it's just Powder, too. So, you can manage your projects with ease. 

    $ cd ~/code/my_project
    $ yippee link

This will create symlink to your project in `~/.yippee`, just like Pow does it.

## Configuration

You can set up your own domain name while installing. It's simple, let's see:

    $ install-yippee-for-me --domain dev

And that's it, yes.

## Uninstall

If you dislike yippee, you can uninstall it whenever you want. Just type this:

    $ uninstall-yippee-now

## You are welcome with your pull requests.