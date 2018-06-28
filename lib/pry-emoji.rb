require 'pry-emoji/version'
require 'emoji'

module PryEmoji
  module PromptConfig
    class Base
      attr_accessor :config, :emoji, :title

      def initialize(config)
        @config = config
        @title = 'irb'
        randomize_emoji
      end

      def emoji_array
        config.emoji_array
      end

      def randomize_emoji
        @emoji = random_emoji
      end
      
      def random_emoji(advantage = [])
        advantage_emoji_array = emoji_array + Array(advantage)
        advantage_emoji_array.shuffle[Random.rand(advantage_emoji_array.length)]
      end

      def line_number(pry)
        # config.pry.input_array.size
      end

      def indent(obj, nest_level, pry)
        "#{' ' * title.length} #{print_emoji} | "
      end

      def prompt(obj, nest_level, pry)
        randomize_emoji
        "#{title} #{print_emoji} > "
      end

      def print_emoji
        emoji.raw.strip
      end
    end
  
    class Game < Base
      attr_accessor :advantage, :winner_emoji

      def initialize(config)
        @winner_emoji = :boom
        super(config)
      end

      def randomize_emoji
        announce_winner if winner?
      end

      def announce_winner
        puts "\033[1L\033[34m\033[1m  #{print_winner_emoji}  WINNER #{print_winner_message} WINNER  #{print_winner_emoji}\033[0m\033[39m"
      end

      def winner?
        false
      end

      def print_winner_message
        print_emoji
      end

      def print_winner_emoji
        ::Emoji.find_by_alias(winner_emoji.to_s).raw.strip
      end
    end

    class Slots < Game
      attr_accessor :slot_size
      
      def initialize(config)
        @slot_size = 3
        @advantage = 4
        super(config)
      end

      def randomize_emoji
        @emoji = slot_size.times.inject([]) { |a| a << random_emoji(a*advantage) }
        super
      end

      def print_emoji
        "|#{emoji.collect{ |e| e.raw.strip }.join('|')}|"
      end

      def winner?
        emoji.length > 1 && emoji.uniq.length == 1
      end
    end
  
    class Match < Game
      attr_accessor :last_emoji

      def initialize(config)
        @advantage = 10
        super(config)
      end

      def randomize_emoji
        @last_emoji = emoji
        @emoji = random_emoji
        super
      end

      def winner?
        last_emoji == emoji
      end
    end
  end

  class Prompt < Array
    cattr_accessor(:types) { PryEmoji::PromptConfig.constants.select{ |constant| PryEmoji::PromptConfig.const_get(constant).is_a? Class } }

    def initialize(type = :base, configuration = nil)
      super(PryEmoji::Config.new(type, configuration).prompt)
    end

    def self.method_missing(method_id, *arguments, &block)
      self.new(normalize_type(method_id), *arguments)
    end

    private

    def self.normalize_type(type)
      play_type = (types & Array(type.to_s.titleize.to_sym)).first
      puts "I don't know how to play #{type}" unless play_type
      play_type || :base
    end
  end

  class Config
    attr_accessor :prompt_config, :prompt, :configuration

    def initialize(prompt = :base, configuration = nil)
      @configuration = Hash(configuration).with_indifferent_access
      %i[emoji].each { |option| parse_configuration_option(option) }

      @prompt_config = PromptConfig.const_get(prompt.to_s.titleize.to_sym).new(self)
      @prompt = [
        proc { |obj, nest_level, pry| prompt_config.prompt(obj, nest_level, pry) },
        proc { |obj, nest_level, pry| prompt_config.indent(obj, nest_level, pry) }
      ]
      # Pry.config.prompt = prompt
    end

    def emoji
      @emoji ||= %i[octopus blowfish space_invader skull smiling_imp imp smile_cat joy_cat heart_eyes_cat pouting_cat scream_cat cherry_blossom blossom mushroom bird penguin hatching_chick hatched_chick cat dragon snake tomato eggplant grapes watermelon tangerine lemon apple green_apple pear peach cherries strawberry pizza ramen oden dango fish_cake beer tea cake musical_note pill beginner diamond_shape_with_a_dot_inside bomb poop sushi]
    end

    def emoji=(emoji)
      @emoji_array = nil
      @emoji = Array(emoji)
    end

    def emoji_array
      @emoji_array ||= emoji.collect { |e| ::Emoji.find_by_alias(e.to_s) }
    end

    private

    def parse_configuration_option(option)
      self.instance_variable_set(:"@#{option}", configuration[option]) if configuration.include?(option)
    end
  end
end
