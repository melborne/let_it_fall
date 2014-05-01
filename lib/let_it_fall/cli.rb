require "thor"
require "io/console"

module LetItFall
  class CLI < Thor
    desc "faces", "Let it fall faces"
    def faces
      Render.run(:faces, IO.console.winsize)
    end
  end
end