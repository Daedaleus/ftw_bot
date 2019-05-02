class StringBuilder

  DATETIME_OUTPUT = '%H:%M %d.%m.%y'.freeze
  TIME_OUTPUT = '%H:%M'.freeze

  def self.help
    ''"
    Usage

    !help
    This message :)

    !add Airplane: LEG1-LEG2-LEG3 HH:MM-HH:MM
    This files a new flight for today in the flight plan
    Example: !add Saab340: EDDS-EDFH 17:00-18:30

    !future Airplane: LEG1-LEG2-LEG3 dd.mm.YYYY HH:MM-HH:MM
    This files a new flight for a defined date in the flight plan
    Example: !future Saab340: EDDS-EDFH 31.12.2022 17:00-18:30

    !delete id
    This deletes a filed flight by id
    Example !delete 1

    !id
    This shows all flights for your account with ID

    !plan
    This shows the actual flight plan for all pilots

    !hello
    Say hello to me :-)
    (To check if I am not sleeping)
    "''
  end

  def self.hello(user = 'Unbekannter')
    "Hello #{user}!"
  end

  def self.echo(content = 'No content')
    content
  end

  def self.add_help
    "Pattern: \"Aircraft: LEG1-LEG2-LEG3 HH:MM-HH:MM\""
  end

  def self.show_plan(user, aircraft, legs, start, finish, today)
    if today
      "#{user}: :airplane: #{aircraft} :map: #{legs} :clock: #{start.strftime(TIME_OUTPUT)} - #{finish.strftime(TIME_OUTPUT)}"
    else
      "#{user}: :airplane: #{aircraft} :map: #{legs} :clock: #{start.strftime(DATETIME_OUTPUT)} - #{finish.strftime(DATETIME_OUTPUT)}"
    end
  end

  def self.id(id, aircraft, legs)
    "#{id}: #{aircraft} - #{legs}\n"
  end

end
