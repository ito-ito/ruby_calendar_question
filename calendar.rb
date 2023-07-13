# Usage
# run irb
# irb > require './calendar'
# irb > puts Calendar.new(year: 2023, month: 7).display

class Calendar
  require "date"

  def initialize(year:, month:)
    @begining_of_month = Date.new(year, month, 1)
    @end_of_month = Date.new(year, month, -1)
  rescue Date::Error, TypeError => e
    STDERR.puts "ERROR : 日付が正しくありません"
  end

  def display
    if !@begining_of_month || !@end_of_month
      STDERR.puts "ERROR : 日付が設定されていません"
      return
    end

    calendar = ""
    column_size = header.map { |h| h.length }.max # 1マスの最大サイズ

    calendar << title
    calendar << "\n"
    calendar << header.map { |h| h.center(column_size) }.join(" ")
    calendar << "\n"
    details.each do |detail|
      calendar << detail
        .map do |d|
          d ? d.strftime("%e").rjust(column_size) : d.to_s.rjust(column_size)
        end
        .join(" ")
      calendar << "\n"
    end

    calendar
  end

  private

  def title
    @begining_of_month.strftime("%B %Y")
  end

  def header
    return @_header if @_header

    header = {}
    (@begining_of_month..@end_of_month).each do |date|
      header[date.wday] = date.strftime("%a")
    end
    @_header = header.sort.to_h.values
  end

  def details
    return @_details if @_details

    details =
      Array.new(weeks_of_month(@end_of_month) + 1) { Array.new(6) { nil } } # 一月分のnilの配列を作成
    (@begining_of_month..@end_of_month).each do |date|
      details[weeks_of_month(date)][date.wday] = date
    end
    @_details = details
  end

  # 対象日の月の週数を返す
  def weeks_of_month(date)
    weeks = date.cweek - @begining_of_month.cweek
    weeks += 1 if date.sunday? # cweekが月曜始まりのため、日曜の場合は+1
    weeks
  end
end
