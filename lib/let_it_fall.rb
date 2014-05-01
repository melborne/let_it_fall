require "let_it_fall/version"
require "let_it_fall/cli"

module CoreExt
  refine Fixnum do
    def chr
      super("UTF-8")
    end
  end
end

module LetItFall
  using CoreExt
  class Render
    CODESET = {
      faces: [*0x1F600..0x1F64F] - [*0x1F641..0x1F644],
      kanjis: (0x4E00..0x4F00),
      # star: [0x1F506],
      times: (0x1F550..0x1f567),
      animals: (0x1F40C..0x1F43C),
      star: [0x2736],
      ruby: [0x1F48E],
      python: [0x1F40D],
      beer: [0x1F37A],
    }

    def self.run(mark, screen, colorize:false, interval:0.1)
      new(mark, screen, colorize:colorize, interval:interval).run
    end

    def initialize(mark, screen, colorize:false, interval:0.1)
      @y, @x = screen
      @colorize = colorize
      marks = CODESET[mark.intern] || CODESET[:star]
      @marks = marks.map { |code| code.chr }.cycle
      @interval = interval
      @screen = {}
      $stdout.sync = true
    end

    def run
      clear_screen
      loop do
        trap(:INT) do
          print "\e[?25h\e[0;0H" # show cursor and set 0,0 pos
          exit(0)
        end
        print_marks
        sleep @interval
      end
    end

    private
    def clear_screen
      print "\e[?25l\e[2J"
    end

    def print_marks
      @screen[rand @x] = 0
      @screen.each do |x, y|
        @screen[x] += 1 if @screen[x] <= @y*0.9
        clear_prev_mark(x, y)
        color = @colorize ? [*31..37].sample : 37
        draw_mark(x, @screen[x], @marks.next, color)
      end
    end
  
    def clear_prev_mark(x, y)
      draw_mark(x, y, " ")
    end

    def draw_mark(x, y, mark, color=37)
      print "\e[%dm \e[%d;%dH%s \e[0;0H \e[0m" % [color, y, x, mark]
    end
  end
end

if __FILE__ == $0
  begin
    require "io/console"
    mark = ARGV[0] || 'star'
    colorize = ARGV[1].to_s.match(/^c/i) ? true : false
    interval = ARGV[2].to_f    
    screen = IO.console.winsize
    LetItFall::Render.run(mark, screen, colorize:colorize, interval:interval)
  rescue Exception => e
    puts "Error: Run in terminal."
    exit(0)
  end
end