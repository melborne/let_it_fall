require "let_it_fall/code"
require "let_it_fall/cli"
require "let_it_fall/version"

module LetItFall
  class Render
    def self.run(mark, screen, color:nil, interval:0.1, matrix:false, auto:nil)
      new(mark, screen, color:color, interval:interval, matrix:matrix, auto:auto).run
    end

    # auto: nil or interval time(Integer)
    def initialize(mark, screen, color:nil, interval:0.1, matrix:false, auto:nil)
      @y, @x = screen
      if [nil, *31..37].include?(color)
        @color = color
      else
        raise ArgumentError, "color should be 31-37 or nil"
      end
      @mark = mark
      @interval = interval
      @screen = {}
      @matrix = matrix
      @auto = auto
      $stdout.sync = true
    end

    def run
      clear_screen
      marks = build_marks(@mark)
      Thread.new do
        while STDIN.getc # hit return
          marks = select_next_marks(@mark)
        end
      end

      trap(:INT) do
        exit(0)
      end

      t = Time.now
      loop do
        if @auto && Time.now - t > @auto
          marks = select_next_marks(@mark)
          t = Time.now
        end

        print_marks(rand(@x), 0, marks)
        sleep @interval
      end
    ensure
      reset_screen
    end

    private
    def build_marks(mark)
      marks =
        case mark
        when Array then mark.map { |m| m.to_i(16) }
        else CODESET[mark.intern] || CODESET[:snow]
        end
      Array(marks).map { |code| code.chr("UTF-8") }.cycle
    end

    def select_next_marks(mark)
      unless @_markset
        keys = CODESET.keys
        @_markset = keys.rotate(keys.index(@mark)+1).cycle
      end
      build_marks(@_markset.next)
    end

    def clear_screen
      print "\e[?25l\e[2J" # hide cursor and clear screen
    end

    def reset_screen
      print "\e[?25h\e[0;0H" # show cursor and set 0,0 pos
    end

    def print_marks(pos_x, pos_y, marks)
      @screen[pos_x] = pos_y
      @screen.each do |x, y|
        if @screen[x] <= @y*0.95
          @screen[x] += 1
          clear_prev_mark(x, y) unless @matrix && [true, true, false][rand 3]
          color = @color || [*31..37].sample
          draw_mark(x, @screen[x], marks.next, color)
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
