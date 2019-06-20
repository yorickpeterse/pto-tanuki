# frozen_string_literal: true

module PtoTanuki
  class MentionedUsers
    def initialize
      @path = File.join(Dir.pwd, 'mentioned.json')

      @users =
        if File.file?(@path)
          JSON.parse(File.read(@path)).to_set
        else
          Set.new
        end
    end

    def add(user)
      @users << user
    end

    def mentioned?(user)
      @users.include?(user)
    end

    def save
      File.open(@path, 'w') do |file|
        file.write(JSON.generate(@users.to_a.sort))
      end
    end
  end
end
