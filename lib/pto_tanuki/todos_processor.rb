# frozen_string_literal: true

module PtoTanuki
  class TodosProcessor
    def initialize(gitlab, group_names)
      @gitlab = gitlab
      @group_names = group_names
      @current_user = gitlab.user
    end

    def process
      schedule = Schedule.new(@gitlab)

      unless schedule.pto_status_set?
        warn("Status doesn't match pto-tanuki format")
      end

      if schedule.out_of_office?
        process_group_todos
      else
        warn('Not OOO today')
      end
    end

    def process_group_todos
      group_ids.each do |group_id|
        @gitlab.todos(group_id: group_id).auto_paginate do |todo|
          @gitlab.mark_todo_as_done(todo.id)
        end
      end
    end

    def group_ids
      @group_names.map do |name|
        @gitlab.group(name).id
      end
    end
  end
end
