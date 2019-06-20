# frozen_string_literal: true

module PtoTanuki
  class TodosProcessor
    def initialize(gitlab, group_names)
      @gitlab = gitlab
      @group_names = group_names
      @current_user = gitlab.user
      @mentioned_users = MentionedUsers.new
    end

    def process
      schedule = Schedule.new(@gitlab)

      if schedule.out_of_office?
        process_group_todos(Notifier.new(@gitlab, schedule))
      end
    end

    def process_group_todos(notifier)
      group_ids.each do |group_id|
        @gitlab.todos(group_id: group_id).auto_paginate do |todo|
          if notify?(todo)
            notifier.notify(todo)

            @mentioned_users.add(todo.author.username)
          end

          @gitlab.mark_todo_as_done(todo.id)
        end
      end
    ensure
      @mentioned_users.save
    end

    def group_ids
      @group_names.map do |name|
        @gitlab.group(name).id
      end
    end

    def notify?(todo)
      return false if @mentioned_users.mentioned?(todo.author.username)

      case todo.action_name
      when 'assigned', 'directly_addressed'
        true
      when 'mentioned'
        username = "@#{@current_user.username}"

        todo.body.include?(username) ||
          todo.target.description.include?(username)
      else
        false
      end
    end
  end
end
