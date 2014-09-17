require 'date'
require 'ice_cube'
require 'pstore'
require 'uuidtools'
include IceCube

class Task
  
  attr_reader :duedate, :short_text, :long_text, :parent, :completed
  
  def initialize(duedate, short_text, long_text, parent, completed)
    @duedate, @short_text, @long_text, @parent, @completed = duedate, short_text, long_text, parent, completed
  end
  
  def set_completed
    @completed = true
  end
  
  def pprint #pretty printer
    line1 = "Duedate: #{@duedate}; Completed: #{@completed}; Parent: #{@parent}"
    line2 = "SText: #{@short_text}; LText: #{@long_text};"
    puts line1, line2
  end
  
end

class SavedTaskList
  
  TASKSTORE = 'taskstore.pstore'
  
  #
  # savedtasks is a hash indexed by date containing an array of all saved tasks on that corresponding date
  #
  #    savedtasks[date] = [task1, task2, task3, ...]
  # 
  def initialize
    @pstore = PStore.new(TASKSTORE)
    @pstore.transaction do
      @savedtasks = @pstore.fetch(:savedtasks, {})
    end
  end
  
  def add_task(task)
    @pstore.transaction do
      @savedtasks[task.duedate] = [] unless @savedtasks.has_key?(task.duedate)
      @savedtasks[task.duedate] << task
      @pstore[:savedtasks] = @savedtasks
    end
  end
  
  def tasks_for_date(date)
    if @savedtasks.has_key?(date)
      @savedtasks[date]
    else
      []
    end
  end
  
  def task_already_saved?(task)
    # find if a task already exists in the SavedTaskList (same duedate and parent)
    return false unless @savedtasks.has_key?(task.duedate)
    return true if @savedtasks[task.duedate].find { |tsk| tsk.parent == task.parent}
    false
  end
  
  def pprint #pretty printer
    @savedtasks.each do |date, tasks|
      puts "#{date} tasks:"
      tasks.each {|task| task.pprint}
      puts " "
    end
  end
  
end

class Reminder
  
  MAX_YEARS_AHEAD = 5 # date limit on future tasks
  SINGLE_MAP = {'D'=>'Day', 'W'=>'Week', 'M'=>'Month'}
  MULTIPLE_MAP = {'D'=>'Days', 'W'=>'Weeks', 'M'=>'Months'}
  
  attr_accessor :start_date, :freq_type, :freq_amount, :end_date, :short_text, :long_text, :uuid
  
  #
  # If end_date == nil, then the Reminder is perpetual (no end date).
  #
  def initialize(start_date, freq_type, freq_amount, end_date, short_text, long_text)
    max_end_date = Date.new(Date.today.year + MAX_YEARS_AHEAD, Date.today.month, Date.today.day)
    @start_date , @freq_type, @freq_amount, @end_date = start_date, freq_type, freq_amount, end_date
    @short_text, @long_text = short_text, long_text
    @uuid = UUIDTools::UUID.random_create.to_str
    
    # set up schedule based on frequency type and frequency amount
    @schedule = Schedule.new(start_date)
    if @end_date then
      if @end_date > max_end_date then
        rule_end_date = max_end_date
      else
        rule_end_date = end_date
      end
    else
      rule_end_date = max_end_date
    end
    case freq_type
    when "D"
      @schedule.rrule(Rule.daily(freq_amount).until(rule_end_date))
    when "M"
      @schedule.rrule(Rule.monthly(freq_amount).until(rule_end_date))
    when "W"
      @schedule.rrule(Rule.weekly(freq_amount).until(rule_end_date))
    when "O" #treat it as a one day only task
      @schedule.rrule(Rule.daily(1).until(@start_date))
      @end_date = @start_date
      @freq_amount = 1
    else
      print "Illegal freq_type = #{freq_type}"
    end
  end
  
  def each_task
    @schedule.all_occurrences.each do |duedate|
      yield Task.new(duedate.to_date, @short_text, @long_text, self.uuid, false)
    end
  end
  
  def freq_format
    if @freq_type == "O" then
      return 'One Time'
    else
      if @freq_amount > 1 then
        return "Every #{@freq_amount} #{MULTIPLE_MAP[@freq_type]}"
      else
        return "Every #{SINGLE_MAP[@freq_type]}"
      end
    end
  end
  
  def find_prior_tasks
    #
    # Find all tasks associated with this Reminder with duedates from start_date through today
    #
    putasks = []
    each_task do |t| 
      break if t.duedate > Date.today
      putasks << t
    end
    putasks
  end
  
  def pprint #pretty printer
    line1 = "Start: #{@start_date}; FrType: #{@freq_type}; FrAmount: #{@freq_amount}; End: #{@end_date}; "
    line2 = "SText: #{@short_text}; LText: #{@long_text}; UUID: #{@uuid}"
    puts line1, line2
  end
  
end

class ReminderList
  
  REMSTORE = 'remstore.pstore'
  
  def initialize
    @pstore = PStore.new(REMSTORE)
    @pstore.transaction do
      @reminders = @pstore.fetch(:reminders, {})
      #@reminders_by_uuid = @pstore.fetch(:reminders_by_uuid, {})
    end
  end
  
  def add_reminder(reminder)
    @pstore.transaction do
      @reminders[reminder.uuid] = reminder
      @pstore[:reminders] = @reminders
      #@reminders_by_uuid[reminder.uuid] = reminder
      #@pstore[:reminders_by_uuid] = @reminders_by_uuid
    end
  end
  
  def clear_reminders
    @pstore.transaction do
      #@reminders_by_uuid = {}
      @reminders = {}
      @pstore[:reminders] = @reminders
      #@pstore[:reminders_by_uuid] = @reminders_by_uuid
    end
  end
  
  # Each time the program starts and ReminderList is populated, Reminders are created once again, so 
  # their object ids won't match up to what's in the PStore.  So any references to ReminderList must be
  # made by referencing each member's UUID (hash key), not the reminder object itself (hash value).
  #
  # Practically this means that a simple hash reference, reminder_list(uuid), will work fine. But
  # any has function that looks for the value (reminder object) will fail.  So special care
  # must be taken to find by value or to delete by value.
  #
  # Affected methods are:  delete_reminder    change_reminder
  #
  def delete_reminder(reminder)
    @pstore.transaction do
      #@reminders_by_uuid.delete(@reminders_by_uuid.key(reminder))
      @reminders.delete(reminder.uuid)
      @pstore[:reminders] = @reminders
      #@pstore[:reminders_by_uuid] = @reminders
    end
  end
  
  def change_reminder(old_rem, new_rem)
    @pstore.transaction do
      #index = get_by_uuid(old_rem.uuid)
      @reminders.delete(old_rem.uuid)
      @reminders[new_rem.uuid] = new_rem
      @pstore[:reminders] = @reminders
      #@reminders_by_uuid.delete(old_rem)
      #@reminders_by_uuid[new_rem.uuid] = new_rem
      #@pstore[:reminders_by_uuid] = @reminders_by_uuid
    end
  end
  
  def get_reminder(uuid)
    @reminders[uuid]
  end
  
  def test_load
    if @reminders.length == 0
      a = Reminder.new(Date.new(2013,1,1), 'W', 2, nil, 'jan 1 short', 'jan 1 long')
      b = Reminder.new(Date.new(2014,5,15), 'M', 1, Date.new(2014,10,15), 'may 15 short', 'may 15 long')
      c = Reminder.new(Date.new(2014,6,1), 'D', 1, nil, 'june 1 short', 'june 1 long')
      self.add_reminder(a)
      self.add_reminder(b)
      self.add_reminder(c)
    end
  end
  
  def pprint #pretty printer
    puts "Reminder list has #{length} entries:"
    each_reminder {|r| r.pprint}
  end
  
  def first_rem
    hashkeys = @reminders.keys
    @reminders[hashkeys[0]]
  end
  
  def last_rem
    hashkeys = @reminders.keys
    @reminders[hashkeys[-1]]
  end
  
  def length
    @reminders.length
  end
  
  def each_reminder
    @reminders.each_value {|rem| yield rem}
  end
  
  def each_task(start_range, end_range)
    @reminders.each_value do |rem|
      rem.each_task do |task|
        if task.duedate.between?(start_range, end_range) then
          yield task
        end
      end
    end
  end
       
end

class CalendarDay
  
  attr_accessor :cal_tasks
  
  def initialize
    @cal_tasks = []
  end
  
  def add_task(task)
    # check to see if task is already in the cal_task list, in the case of a SavedTask
    duplicate = false
    @cal_tasks.each { |caltask| duplicate = true if caltask.parent == task.parent }
    @cal_tasks << task unless duplicate
  end
  
  def formatted
    form = ""
    @cal_tasks.each { |task| form += "- " + task.short_text + "\n" }
    form
  end
      
end

class Calendar
  
  def initialize(remlist, cal_start, cal_end)
    @calendar_days = {}
    # load all SavedTasks first so they take precedence over any newly generated Tasks
    saved_list = SavedTaskList.new
    cal_start.upto(cal_end) do |date|
      saved_list.tasks_for_date(date).each do |task|
        @calendar_days[task.duedate] = CalendarDay.new unless @calendar_days.has_key?(task.duedate)
        @calendar_days[task.duedate].add_task(task)
      end
    end
    # load new generated Tasks
    remlist.each_task(cal_start, cal_end) do |task|
      @calendar_days[task.duedate] = CalendarDay.new unless @calendar_days.has_key?(task.duedate)
      @calendar_days[task.duedate].add_task(task)
    end
  end
  
  def has_day?(date)
    @calendar_days.has_key?(date)
  end
  
  def get_day(date)
    @calendar_days[date]
  end
  
  def pprint
    @calendar_days.each {|date, cday| puts cday.formatted}
  end
  
end

  