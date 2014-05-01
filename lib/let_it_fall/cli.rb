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

    desc "rand", "Let something fall randomly"
    option :speed, aliases:'-s', default:1, type: :numeric
    def rand
      code = LetItFall::CODESET.keys.sample
      run(code, options[:speed], options[:color])
      
    end

    desc "code [CODE]", "Let specific character fall"
    option :speed, aliases:'-s', default:1, type: :numeric
    option :color, aliases:'-c', default:true, type: :boolean
    option :range, aliases:'-r', default:false, type: :boolean
    def code(*code)
      if options[:range]
        st, ed = code.minmax
        code = Range.new(st.to_i(16), ed.to_i(16))
                    .to_a.map { |i| i.to_s(16) }
      end
      run(code, options[:speed], options[:color])
    end

    desc "version", "Show LetItFall version"
    def version
      puts "LetItFall #{LetItFall::VERSION} (c) 2014 kyoendo"
    end
    map "-v" => :version

    no_tasks do
      def run(name, speed, color)
        speed = 0.1 if speed < 0.1
        interval = 0.05 / speed
        Render.run(name, IO.console.winsize, interval:interval, colorize:color)
      end
    end
  end
end
