require "thor"
require "io/console"

module LetItFall
  class CLI < Thor
    LetItFall::CODESET.keys.each do |command|
      desc "#{command}", "Let #{command} fall"
      option :speed, aliases:'-s', default:1, type: :numeric
      if [:snow, :kanji].include?(command)
        option :color, aliases:'-c', default:true, type: :boolean
      end
      define_method(command) do
        run(command, options[:speed], options[:color])
      end
    end


    no_tasks do
      def run(name, speed, color)
        speed = 0.1 if speed < 0.1
        interval = 0.05 / speed
        Render.run(name, IO.console.winsize, interval:interval, colorize:color)
      end
    end
  end
end
