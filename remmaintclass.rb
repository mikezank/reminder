require 'fox16'
require 'fox16/calendar'
require 'byebug'
require 'date'
require 'csv'
require_relative 'remdataclass'

include Fox

class MaintWindow < FXMainWindow
  
  def initialize(app)
    @rem = ReminderList.new
    #@rem.test_load
    super(app, "Reminder", width: 400, height: 600)
    add_menu_bar
    vframe = FXVerticalFrame.new(self, opts: LAYOUT_FILL_X)
    
    @remlist = FXList.new(vframe, opts: LIST_EXTENDEDSELECT|LAYOUT_FILL)
    @rem.each_reminder {|er| @remlist.appendItem(er.format)}
    @remlist.connect(SEL_RIGHTBUTTONRELEASE) do |sender, sel, event|
      unless event.moved?
        item = sender.getItemAt(event.win_x, event.win_y)
        unless item.nil?
          p item
          FXMenuPane.new(self) do |menu_pane|
            dele = FXMenuCommand.new(menu_pane, "Delete")
            dele.connect(SEL_COMMAND) {delete_reminder(item)}
            add = FXMenuCommand.new(menu_pane, "Add")
            add.connect(SEL_COMMAND) {add_reminder}
            menu_pane.create
            menu_pane.popup(nil, event.root_x, event.root_y)
            app.runModalWhileShown(menu_pane)
          end
        end
      end
      
      hframe = FXHorizontalFrame.new(vframe)
      groupbox = FXGroupBox.new(hframe, "Options", 
        opts: GROUPBOX_NORMAL|FRAME_GROOVE|LAYOUT_FILL_X|LAYOUT_FILL_Y)
      exit_button = FXButton.new(groupbox, "Exit", opts: BUTTON_NORMAL|LAYOUT_CENTER_X)
      other_button = FXButton.new(groupbox, "Other", opts: BUTTON_NORMAL|LAYOUT_CENTER_X)
      exit_button.connect(SEL_COMMAND) do |sender, sel, data|
        self.close
      end
      other_button.connect(SEL_COMMAND) do |sender, sel, data|
        self.close
      end
    end
      
=begin      
    @radchoice = FXDataTarget.new(0)
    radio1 = FXRadioButton.new(groupbox, "Good", target: @radchoice, selector: FXDataTarget::ID_OPTION)
    radio2 = FXRadioButton.new(groupbox, "Better", target: @radchoice, selector: FXDataTarget::ID_OPTION+1)
    radio3 = FXRadioButton.new(groupbox, "Best", target: @radchoice, selector: FXDataTarget::ID_OPTION+2)
    @radchoice.connect(SEL_COMMAND) do
      puts "New value is #{@radchoice.value}"
      @blabel.text = ["Good","Better","Best"][@radchoice.value]
    end
    
    @calendar = FXCalendar.new(hframe)
    @calendar.connect(SEL_COMMAND) do
      puts "New date is #{@calendar.selected.to_s}"
      @dlabel.text = @calendar.selected.to_s
    end
    
    @dlabel = FXLabel.new(vframe, nil, opts: FRAME_LINE)
    @blabel = FXLabel.new(vframe, nil, opts: FRAME_LINE)
=end
  end
  
  def add_menu_bar
    menu_bar = FXMenuBar.new(self, LAYOUT_SIDE_TOP|LAYOUT_FILL_X)
    file_menu = FXMenuPane.new(self)
    FXMenuTitle.new(menu_bar, "File", popupMenu: file_menu)
    import_cmd = FXMenuCommand.new(file_menu, "Import...")
    import_cmd.connect(SEL_COMMAND) do
      dialog = FXFileDialog.new(self, "Import Reminders")
      dialog.patternList = ["CSV file (*.csv)"]
      dialog.selectMode = SELECTFILE_EXISTING
      if dialog.execute != 0
        import_reminders(dialog.filename)
      end
    end
    export_cmd = FXMenuCommand.new(file_menu, "Export...")
    export_cmd.connect(SEL_COMMAND) do
      dialog = FXFileDialog.new(self, "Export Reminders")
      dialog.patternList = ["CSV file (*.csv)"]
      if dialog.execute != 0
        export_reminders(dialog.filename)
      end
    end
    exit_cmd = FXMenuCommand.new(file_menu, "Exit")
    exit_cmd.connect(SEL_COMMAND) do
      exit
    end
    calendar_cmd = FXMenuCommand.new(file_menu, "Calendar")
    calendar_cmd.connect(SEL_COMMAND) do
      calwin = CalendarWindow.new(app)
      calwin.create
      calwin.show
      app.runModalFor(calwin)
    end
  end
  
  def import_reminders(filename)
    p "Importing from #{filename}"
    @rem.clear_reminders
    @remlist.clearItems
    CSV.foreach(filename) do |row|
      start_date, end_date, freq_type, freq_amount, short_text, long_text = row[0].split("|")
      edate = end_date ? Date.parse(end_date) : end_date
      r = Reminder.new(Date.parse(start_date), freq_type, freq_amount.to_i, edate,
                       short_text, long_text)
      @rem.add_reminder(r)
    end
    @rem.each_reminder {|er| @remlist.appendItem(er.format)}
  end
  
  def export_reminders(filename)
    p "Exporting to #{filename}"
    CSV.open(filename, "wb", col_sep: "|") do |csv|
      @rem.each_reminder do |r|
        csv << [r.start_date.to_s, r.end_date.to_s, r.freq_type, r.freq_amount.to_s,
          r.short_text, r.long_text]
      end
    end
  end
  
  def delete_reminder(item)
    p "Delete reminder called for item #{item}"
  end
  
  def add_reminder
    p "Add reminder called"
    newrem = NewReminderWindow.new(app)
    newrem.create
    newrem.show
    app.runModalFor(newrem)
    #newrem.show
    p newrem.start_date, newrem.end_date, newrem.freq_type, newrem.freq_amount, newrem.short_text
    if newrem.do_the_add
      r = Reminder.new(newrem.start_date, newrem.freq_type, newrem.freq_amount, newrem.end_date, 
                       newrem.short_text, newrem.short_text)
      @rem.add_reminder(r)
      @remlist.appendItem(r.format)
    end
  end
  
  def create
    super
    show(PLACEMENT_SCREEN)
  end
end

class NewReminderWindow < FXMainWindow
  
  FREQ_OPTIONS = " DMW"
  
  attr_reader :start_date, :end_date, :freq_type, :freq_amount, :short_text, :long_text, :do_the_add
  
  def initialize(app)
    @do_the_add = false
    super(app, "Create New Reminder", width: 600, height: 600)
    vframe = FXVerticalFrame.new(self)
    matrix = FXMatrix.new(vframe, 2, opts: MATRIX_BY_COLUMNS)
    FXLabel.new(matrix, "Start date:")
    @sdate_text = FXTextField.new(matrix, 10)
    FXLabel.new(matrix, "End Date:")
    @edate_text = FXTextField.new(matrix, 10)
    FXLabel.new(matrix, "Frequency")
    @freq_text = FXListBox.new(matrix, opts: LISTBOX_NORMAL|FRAME_SUNKEN|FRAME_THICK|LAYOUT_FILL_X)
    FREQ_OPTIONS.chars.each {|char| @freq_text.appendItem(char)}
    @freq_text.numVisible = 4
    FXLabel.new(matrix, "Amount")
    @amount_text = FXTextField.new(matrix, 3, opts: TEXTFIELD_INTEGER)
    FXLabel.new(matrix, "Short text")
    @stext = FXTextField.new(matrix, 25)
    
    hframe = FXHorizontalFrame.new(vframe)
    add_button = FXButton.new(hframe, "Add", opts: BUTTON_NORMAL|LAYOUT_CENTER_X)
    cancel_button = FXButton.new(hframe, "Cancel", opts: BUTTON_NORMAL|LAYOUT_CENTER_X)
    add_button.connect(SEL_COMMAND) do |sender, sel, data|
      if no_input_errors?
        set_reminder_values
        @do_the_add = true
        self.close
        app.stopModal
      end
    end
    cancel_button.connect(SEL_COMMAND) do |sender, sel, data|
      self.close
      app.stopModal
    end
    
    FXLabel.new(vframe, "")
    @error_text = FXTextField.new(vframe, 50, opts: TEXTFIELD_READONLY)
    @error_text.textColor = Fox.FXRGB(255,0,0)
  end
  
  def good_date?(date)
    Date.parse(date)
  rescue
    false
  else
    true
  end
  
  def no_input_errors?
    errmsg = ""
    if @sdate_text.text == ""
      errmsg += " ** Must specify a start date"
    end
    if not good_date?(@sdate_text.text)
      errmsg += " ** Bad start date"
    end
    if (@edate_text.text != "") and not good_date?(@edate_text.text)
      errmsg += " ** Bad end date"
    end
    if errmsg != ""
      @error_text.text = errmsg
      false
    else
      true
    end  
  end
     
  def set_reminder_values
    @start_date = Date.parse(@sdate_text.text)
    @end_date = Date.parse(@edate_text.text) if @edate_text.text != ""
    @freq_type = FREQ_OPTIONS[@freq_text.currentItem]
    @freq_amount = @amount_text.text.to_i
    @short_text = @stext.text
  end
end