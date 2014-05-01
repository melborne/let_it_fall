require "let_it_fall/code"
require "let_it_fall/cli"
require "let_it_fall/version"

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

    def self.run(mark, screen, colorize:false, interval:0.1)
      new(mark, screen, colorize:colorize, interval:interval).run
    end

    def initialize(mark, screen, colorize:false, interval:0.1)
      @y, @x = screen
      @colorize = colorize
      marks = Array( CODESET[mark.intern] || CODESET[:snow] )
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
      @screen[rand @x] = [0, @marks.dup]
      @screen.each do |x, (y,mark)|
        @screen[x][0] += 1 if @screen[x][0] <= @y*0.9
        clear_prev_mark(x, y)
        color = @colorize ? [*31..37].sample : 37
        draw_mark(x, @screen[x][0], mark.next, color)
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
