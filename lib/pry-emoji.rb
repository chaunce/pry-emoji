require 'pry-emoji/version'
require 'emoji'

module PryEmoji

  class Config
    cattr_accessor(:emoji_array) { ['octopus', 'blowfish', 'space_invader', 'skull', 'smiling_imp', 'imp', 'smile_cat', 'joy_cat', 'heart_eyes_cat', 'pouting_cat', 'scream_cat', 'cherry_blossom', 'blossom', 'mushroom', 'bird', 'penguin', 'hatching_chick', 'hatched_chick', 'cat', 'dragon', 'snake', 'tomato', 'eggplant', 'grapes', 'watermelon', 'tangerine', 'lemon', 'apple', 'green_apple', 'pear', 'peach', 'cherries', 'strawberry', 'pizza', 'ramen', 'oden', 'dango', 'fish_cake', 'beer', 'tea', 'cake', 'musical_note', 'pill', 'beginner', 'diamond_shape_with_a_dot_inside', 'recycle', 'bomb', 'poop', 'sushi'].collect{ |a| ::Emoji.find_by_alias(a) } }
    attr_accessor :prompt_config
    attr_accessor :prompt

    def initialize(prompt = :Base)
      @prompt_config = PromptConfig.const_get(prompt.to_s.titleize.to_sym).new(self)
      @prompt = [
        proc { |obj, nest_level, pry| prompt_config.prompt(obj, nest_level, pry) },
        proc { |obj, nest_level, pry| prompt_config.indent(obj, nest_level, pry) }
      ]
      # Pry.config.prompt = prompt
    end

    def new_emoji(play = true)
      case mode
      when 'slots'
        emoji = 3.times.inject([]) { |a| a << random_emoji(a*4) }
        announce_winner(print_emoji(emoji).strip) if emoji_array.length > 1 && emoji.uniq.length == 1
      when 'match', 'standard'
        emoji = random_emoji
        announce_winner(([print_emoji(emoji)]*3).join(' ')) if mode == 'match' && emoji_array.length > 1 && emoji == current_emoji
      end
      self.current_emoji = emoji
    end

    def random_emoji(advantage = [])
      random_emoji_array = emoji_array + advantage
      emoji = random_emoji_array[Random.rand(random_emoji_array.length)]
    end
  end

  module PromptConfig
  
    class Base
      attr_accessor :config
      attr_accessor :emoji
      attr_accessor :emoji_array
      attr_accessor :title

      def initialize(config)
        @config = config
        @emoji_array = PryEmoji::Config.emoji_array
        @title = 'irb'
        randomize_emoji
      end
      
      def randomize_emoji
        @emoji = emoji_array[Random.rand(emoji_array.length)]
      end

      def line_number(pry)
        # config.pry.input_array.size
      end

      def indent(obj, nest_level, pry)
        "#{' ' * title.length} #{emoji} | "
      end

      def prompt(obj, nest_level, pry)
        randomize_emoji
        "#{title} #{print_emoji} > "
      end

      def emoji_string(use_last = false)
        print_emoji(use_last ? current_emoji : new_emoji)
      end

      def announce_winner(message)
        puts "\033[1L\033[34m\033[1m  #{::Emoji.find_by_alias('boom').raw}  WINNER #{message} WINNER  #{::Emoji.find_by_alias('boom').raw}\033[0m\033[39m"
      end

      def print_emoji
        "#{emoji.raw} "
      end
    end
  
    class Slots < Base
      # include PryEmoji::PromptConfig::Game
      attr_accessor :advantage
      attr_accessor :slot_size
      
      def initialize(config)
        @slot_size = 3
        @advantage = 4
        super(config)
      end
      
      def randomize_emoji
        @emoji = slot_size.times.inject([]) { |a| a << one_random_emoji_with_advantage(a*advantage) }
        # announce_winner(print_emoji(emoji).strip) if emoji_array.length > 1 && emoji.uniq.length == 1
      end
      
      def one_random_emoji_with_advantage_array(advantage_array)
        (emoji_array + emoji.*(advantage).split(//))[Random.rand(random_emoji_array.length + advantage)]
      end

      def print_emoji(emoji)
        "|#{emoji.raw.join(' |')} |"
      end
    end
  
    class Match < Base
      # include PryEmoji::PromptConfig::Game
      attr_accessor :advantage

      def initialize(config)
        @advantage = 10
        super(config)
      end

      def randomize_emoji
        @emoji = (emoji_array + emoji.*(advantage).split(//))[Random.rand(random_emoji_array.length + advantage)]
      end
    end

    module Game
      attr_accessor :advantage
    end
  end
end


pry_emoji = PryEmoji::Config.new
Pry.config.prompt = pry_emoji.prompt