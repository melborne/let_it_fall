require "let_it_fall/code"
require "let_it_fall/cli"
require "let_it_fall/version"

module LetItFall
  class Render
    def self.run(mark, screen, color:nil, interval:0.1)
      new(mark, screen, color:color, interval:interval).run
    end

    def initialize(mark, screen, color:nil, interval:0.1)
      @y, @x = screen
      if [nil, *31..37].include?(color)
        @color = color
      else
        raise ArgumentError, "color should be 31-37 or nil"
      end
      @marks = build_marks(mark)
      @interval = interval
      @screen = {}
      $stdout.sync = true
    end

    def build_marks(mark)
      marks =
        case mark
        when Array then mark.map { |m| m.to_i(16) }
        else CODESET[mark.intern] || CODESET[:snow]
        end
      Array(marks).map { |code| code.chr("UTF-8") }.cycle
    end

    def run
      clear_screen
      loop do
        trap(:INT) do
          print "\e[?25h\e[0;0H" # show cursor and set 0,0 pos
          exit(0)
        end
        print_marks(rand(@x), 0, @marks)
        sleep @interval
      end
    end

    private
    def clear_screen
      print "\e[?25l\e[2J"
    end

    def print_marks(pos_x, pos_y, marks)
      @screen[pos_x] = pos_y
      @screen.each do |x, y|
        if @screen[x] <= @y*0.95
          @screen[x] += 1
          clear_prev_mark(x, y)
          color = @color || [*31..37].sample
          draw_mark(x, @screen[x], marks.next, color)
        else
          next
        end
      end
    end
  
    def clear_prev_mark(x, y)
      draw_mark(x, y, " ", 37)
    end

    def draw_mark(x, y, mark, color)
      print "\e[%dm \e[%d;%dH%s \e[0;0H \e[0m" % [color, y, x, mark]
    end
  end
end
