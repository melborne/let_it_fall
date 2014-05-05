require "thor"
require "io/console"

module LetItFall
  class CLI < Thor
    LetItFall::CODESET.keys.each do |command|
      desc "#{command}", "Let #{command} fall"
      option :speed, aliases:'-s', default:1, type: :numeric
      option :color, aliases:'-c', default:nil, type: :numeric
      option :matrix, aliases:'-m', default:false, type: :boolean
      define_method(command) do
        run(command, options[:speed], options[:color], options[:matrix])
      end
    end

    desc "rand", "Let something fall randomly"
    option :speed, aliases:'-s', default:1, type: :numeric
    def rand
      code = LetItFall::CODESET.keys.sample
      run(code, options[:speed], options[:color], false)
    end

    desc "matrix [MARK]", "Let it matrix"
    option :speed, aliases:'-s', default:1, type: :numeric
    option :color, aliases:'-c', default:32, type: :numeric
    def matrix(mark=:latin)
      run(mark, options[:speed], options[:color], true)
    end

    desc "code [CODE]", "Let specific character fall"
    option :speed, aliases:'-s', default:1, type: :numeric
    option :color, aliases:'-c', default:nil, type: :numeric
    option :range, aliases:'-r', default:false, type: :boolean
    option :matrix, aliases:'-m', default:false, type: :boolean
    def code(*code)
      if options[:range]
        st, ed = code.minmax
        code = Range.new(st.to_i(16), ed.to_i(16))
                    .to_a.map { |i| i.to_s(16) }
      end
      run(code, options[:speed], options[:color], options[:matrix])
    end

    desc "version", "Show LetItFall version"
    def version
      puts "LetItFall #{LetItFall::VERSION} (c) 2014 kyoendo"
    end
    map "-v" => :version

    no_tasks do
      def run(name, speed, color, matrix)
        speed = 0.1 if speed < 0.1
        interval = 0.05 / speed
        Render.run(name, IO.console.winsize, interval:interval, color:color, matrix:matrix)
      end
    end
  end
end
