# frozen_string_literal: true

module PtoTanuki
  class Schedule
    STATUS_PATTERN =
      /\AOOO from (?<start>\d+-\d+-\d+)\s+\w+\s+(?<stop>\d+-\d+-\d+)\z/.freeze

    DATE_FORMAT = '%Y-%m-%d'

    attr_reader :start_date, :end_date

    def initialize(gitlab)
      @gitlab = gitlab
      @start_date = nil
      @end_date = nil

      retrieve_status
    end

    def pto_status_set?
      @start_date && @end_date
    end

    def out_of_office?
      return false unless pto_status_set?

      (@start_date..@end_date).cover?(Date.today)
    end

    def retrieve_status
      status = @gitlab.get('/user/status')

      return if status&.message.nil?

      matches = status.message.match(STATUS_PATTERN)

      return if matches.nil? || !matches[:start] || !matches[:stop]

      @start_date = Date.strptime(matches[:start], DATE_FORMAT)
      @end_date = Date.strptime(matches[:stop], DATE_FORMAT)
    end
  end
end
