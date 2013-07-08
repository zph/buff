module Buff
  RC_VERSION = "0.0.1"
  class Setup

    def initialize(args="~/.bufferapprc")
      @path = Pathname.new(args)
      if exists?
        @content = YAML.load_file(File.expand_path path)
      else
        raise Buff::Error::ConfigFileMissing
      end
    end

    def path
      @path.to_s
    end

    def exists?
      File.exists?(File.expand_path path)
    end

  end
end
