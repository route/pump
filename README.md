# yippee

Yippee is a Pow–like gem for Ruby–lovers (or maybe Javascript–haters).

### Only Mac OS X is supported now.

## Installation

### Without RVM

    $ gem install yippee
    $ sudo yippee --install

### With RVM

    $ rvm use 1.9.3@somegemset
    $ gem install yippee
    $ rvmsudo yippee --install

## Usage

After `yippee --install`, some magic will happen. Yippee's not just like Pow, it's just Powder, too. So, you can manage your projects with ease. 

    $ cd ~/code/my_project
    $ yippee link

This will create symlink to your project in `~/.yippee`, just like Pow does it.

## Configuration

You can set up your own domain name when you create a symlink. It's simple, let's see:

    $ cd ~/.yippee && ln -s /path-to-app domain.name

And that's it, yes.

## Uninstall

If you dislike yippee, you can uninstall it whenever you want. Just type this:

    $ sudo yippee --uninstall

or if you using rvm:

    $ rvmsudo yippee --uninstall

## You are welcome with your pull requests.