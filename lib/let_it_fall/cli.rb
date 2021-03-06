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
    option :color, aliases:'-c', default:nil, type: :numeric
    def rand
      code = LetItFall::CODESET.keys.sample
      run(code, options[:speed], options[:color], false)
    end

    desc "matrix [MARK]", "Let it matrix"
    option :speed, aliases:'-s', default:1, type: :numeric
    option :color, aliases:'-c', default:32, type: :numeric
    def matrix(mark=:latins)
      run(mark, options[:speed], options[:color], true)
    end

    desc "go", "Let it fall in rotation"
    option :speed, aliases:'-s', default:2, type: :numeric
    option :color, aliases:'-c', default:nil, type: :numeric
    option :interval, aliases:'-i', default:3, type: :numeric
    def go
      code = LetItFall::CODESET.keys.sample
      run(code, options[:speed], options[:color], false, options[:interval])
    end
    map "auto" => :go

    desc "code CODE", "Let specific character fall by unicode(s)"
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

    desc "list", "List of all commands"
    def list
      puts "Commands:"
      puts "  let_it_fall MARK             # Let any of following MARKs fall"
      LetItFall::CODESET.keys.sort.each_with_index do |mark, i|
        print "\n    " if i%8==0
        print mark, " "
      end
      puts "\n\n"
      puts "  let_it_fall matrix [MARK]   # Let it matrix!"
      puts "  let_it_fall rand            # Let something fall randomly"
      puts "  let_it_fall go              # Let them Go!"
      puts "  let_it_fall code CODE       # Let specific character fall by unicode(s) ex. code 0x2660"
      puts "  let_it_fall help [COMMAND]  # Describe available commands or one specific command"
      puts "  let_it_fall version         # Show LetItFall version"
    end
    map "commands" => :list
    default_task :list
    map "-h" => :list

    desc "version", "Show LetItFall version"
    def version
      puts "LetItFall #{LetItFall::VERSION} (c) 2014 kyoendo"
    end
    map "-v" => :version

    no_tasks do
      def run(name, speed, color, matrix, auto=nil)
        speed = 0.1 if speed < 0.1
        interval = 0.05 / speed
        Render.run(name, IO.console.winsize, interval:interval, color:color, matrix:matrix, auto:auto)
      end
    end
  end
end
