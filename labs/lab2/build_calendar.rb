#!/usr/bin/env ruby
# encoding: UTF-8
require 'date'

class CalendarBuilder
  GAME_DAYS = [5, 6, 0] # Friday, Saturday, Sunday
  GAME_TIMES = ['12:00', '15:00', '18:00']
  MAX_SIMULTANEOUS_GAMES = 2

  def initialize(teams_file, start_date, end_date, output_file)
    @teams_file = teams_file
    @start_date = parse_date(start_date)
    @end_date = parse_date(end_date)
    @output_file = output_file
    @teams = []
    @games = []
  end

  def build 
    validate_inputs
    load_teams
    generate_games
    schedule_games
    write_calendar
    puts "Календарь успешно создан в файле #{@output_file}"
  end

  private

  def parse_date(date_str)
    Date.strptime(date_str, '%d.%m.%Y')
  rescue ArgumentError
    raise "Неверный формат даты: #{date_str}. Используйте формат ДД.ММ.ГГГГ"

  end

  def validate_inputs
    raise "Файл с командами не существует: #{@teams_file}" unless File.exist?(@teams_file)
    raise "Начальная дата должна быть раньше конечной даты" if @start_date >= @end_date

    days_diff = (@end_date - @start_date).to_i
    raise "Слишком короткий период для проведения всех игр" if days_diff < 7
  end

  def load_teams
    File.readlines(@teams_file, chomp: true, encoding: 'UTF-8').each do |line|
      next if line.strip.empty?

      if line =~ /^\d+\.\s*(.+?)\s*[—-]\s*(.+)$/
        team_name = $1.strip
        city = $2.strip
        @teams << { name: team_name, city: city }
      else
        raise "Неверный формат строки: #{line}"
      end
    end

    raise "Недостаточно команд (минимум 2)" if @teams.size < 2
    puts "Загружено команд: #{@teams.size}"
  end

  def generate_games
  # Генерируем матчи (каждый с каждым)
  @teams.combination(2).each do |team1, team2|
    @games << { home: team1, away: team2 }
    @games << { home: team2, away: team1 } # Ответная игра
  end
  puts "Всего игр для проведения: #{@games.size}"
  end

  def schedule_games
    # Находим все доступные слоты 
    slots = find_available_slots

    raise "Недостаточно слотов для всех игр" if slots.size < @games.size

    # Равномерно распределяем игры по слотам
    games_per_slot = (@games.size.to_f / slots.size).ceil

    @scheduled_games = []
    game_index = 0

    slots.each do |slot|
      games_in_slot = 0
      
      while game_index < @games.size && games_in_slot < MAX_SIMULTANEOUS_GAMES 
        @scheduled_games << {
          date: slot[:date],
          time: slot[:time],
          game: @games[game_index]
        }
        game_index += 1
        games_in_slot += 1

        # Равномерное распределение - не заполняем все слоты полностью 
      break if game_index >= (slot[:index] + 1) * games_per_slot
      end
      break if game_index >= @games.size
    end

  end

  def find_available_slots
    slots = []
    current_date = @start_date
    index = 0

    while current_date <= @end_date
      if GAME_DAYS.include?(current_date.wday)
        GAME_TIMES.each do |time|
          slots << { date: current_date, time: time, index: index }
          index += 1
        end
      end
      current_date += 1
    end

    slots
  end

  def write_calendar
    File.open(@output_file, 'w:UTF-8') do |f|
      f.puts "=" * 80
      f.puts "СПОРТИВНЫЙ КАЛЕНДАРЬ".center(80)
      f.puts "Период: #{format_date(@start_date)} - #{format_date(@end_date)}".center(80)
      f.puts "=" * 80
      f.puts
      
      current_date = nil
      
      @scheduled_games.sort_by { |sg| [sg[:date], sg[:time]] }.each do |scheduled_game|
        if current_date != scheduled_game[:date]
          current_date = scheduled_game[:date]
          f.puts
          f.puts "-" * 80
          f.puts format_date_full(current_date)
          f.puts "-" * 80
        end
        
        game = scheduled_game[:game]
        f.puts sprintf("  %s | %-30s vs %-30s",
                      scheduled_game[:time],
                      "#{game[:home][:name]} (#{game[:home][:city]})",
                      "#{game[:away][:name]} (#{game[:away][:city]})")
      end
      
      f.puts
      f.puts "=" * 80
      f.puts "Всего игр: #{@scheduled_games.size}".center(80)
      f.puts "=" * 80
    end
  end

  def format_date(date)
    date.strftime('%d.%m.%Y')
  end

  def format_date_full(date)
    days = ['Воскресенье', 'Понедельник', 'Вторник', 'Среда', 'Четверг', 'Пятница', 'Суббота']
    months = ['', 'января', 'февраля', 'марта', 'апреля', 'мая', 'июня', 'июля',
              'августа', 'сентября', 'октября', 'ноября', 'декабря']

    "#{days[date.wday]}, #{date.day} #{months[date.month]} #{date.year}" 
  end
end

# Проверка аргументов командной строки
if ARGV.size != 4
  puts "Использование: ruby build_calendar.rb teams.txt ДД.ММ.ГГГГ ДД.ММ.ГГГГ calendar.txt"
  puts "Пример: ruby build_calendar.rb teams.txt 01.08.2026 01.06.2027 calendar.txt"
  exit 1
end

begin
  builder = CalendarBuilder.new(ARGV[0], ARGV[1], ARGV[2], ARGV[3])
  builder.build
rescue => e
  puts "Ошибка: #{e.message}"
  exit 1
end
