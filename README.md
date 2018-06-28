pry-emoji
===========

Clutter up your shell with some emoji. Why not? You already have all that pry crap mucking everything up.


Usage
--------

add `pry-emoji` to your gemfile

    group :development do
      gem 'pry-emoji'
    end

set your `Pry.config.prompt` customization setting to use the `pry-emoji` prompt in your `.pryrc` file, or wherever you do your customization

    Pry.config.prompt = PryEmoji::Prompt.new


Configuration
--------

use some different emoji, because some jerks are offended when the two men holding hands or the beer emoji appears in their console

    Pry.config.prompt = PryEmoji::Prompt.new(emoji: %i[roll_eyes middle_finger -1 ng])


Games
--------

play a game with `pry-emoji`, because working in the console is boring and a bunch of extraneous characters all over the place is certain to not be disruptive. You should know, you're already using pry.

    Pry.config.prompt = PryEmoji::Prompt.slots

    Pry.config.prompt = PryEmoji::Prompt.match


faq
===========

### My console announced I was a winner, please explain

You're not.


### This gem is fantastic! When can I expect new games to be added?

Idk. Never? Tomorrow? Don't hold your breath. Or do. Whatever floats your boat.


### How can I add even more emoji to my console? I know Pry already makes everything less readable, but I don't think it goes too far enough.

Great question! I'll work on adding some more options to accommodate your masochistic desires.


### Can I use this gem in production?

My production configuration uses only the `racing_car` emoji.


### This gem isn't fun at all

You will never be happy if you continue to search for what happiness consists of. You will never live if you are looking for the meaning of life.


### Everything is broken

I think I fixed that now.


### Your gem is stupid

Alright.


### Stop making fun of Pry

As soon as it stops sucking.


### A different question

No, you.

