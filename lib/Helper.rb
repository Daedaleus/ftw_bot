class Helper

  def self.today_as_string
    today = DateTime.now
    today.strftime('%Y-%m-%d')
  end

  def self.get_token(path)
      raise FileNotFoundException unless File.exists? path
    File.open(path, &:readline).strip
  end

  def self.add_today(event,args)
    $logger.info "Adding today from #{event.user.name}"
    return StringBuilder.add_help unless args
    matches = args.join(' ').scan(REGEX_ADD_FLIGHT_TODAY)
    result = ''
    if matches[0].size == 4
      result = 'Got your flight pilot!'
      start = today_as_string + 'T' + matches[0][2]
      finish = today_as_string + 'T' + matches[0][3]
      Flight.create(user: event.user.name, aircraft: matches[0][0], start: start, finish: finish, legs: matches[0][1])
    else
      $logger.warn "Adding not possible due wrong syntax: #{args.join ' '}"
      result = 'What?'
    end
    result
  end

  def self.add_future(event,args)
    $logger.info "Adding future from #{event.user.name}"
    return "Pattern: \"Aircraft: LEG1-LEG2-LEG3 dd.mm.YYYY HH:MM-HH:MM\"" unless args || args.flatten = ['']
    matches = args.join(' ').scan(REGEX_ADD_FLIGHT_FUTURE)
    result = ''
    if matches[0].size == 5
      result = 'Got your flight pilot'
      date = matches[0][2]
      start = date + ' ' + matches[0][3]
      finish = date + ' ' + matches[0][4]
      Flight.create(user: event.user.name, aircraft: matches[0][0], start: start, finish: finish, legs: matches[0][1])
    else
      $logger.warn "Adding not possible due wrong syntax: #{args.join ' '}"
      result = 'What?'
    end
    result
  end

  def self.delete(event,args)
    $logger.info "Deleting from #{event.user.name}"
    result = ''
    if !!args.first
      Flight.find(args.first).delete
      return "Deleted flight with id #{args.first}"
    else
      Flight.where(user: event.user.name).each do |flight|
        result += "#{flight.id}: #{flight.aircraft} - #{flight.legs}\n"
      end
      return result
    end
    result
  end

  def self.show_plan
    $logger.info "Showing plan"
    result = ''
    flights = Flight.where('finish > ?', DateTime.now).order(finish: :asc)
    if flights.count > 0
      flights.each do |flight|
        result += StringBuilder.show_plan(flight.user,
                                          flight.aircraft,
                                          flight.legs,
                                          flight.start,
                                          flight.finish,
                                          is_today?(flight.finish)) + "\n"
      end
    else
      result = 'No flights in schedule'
    end
    result
  end

  def self.id(user)
    $logger.info "Showing ids from #{user}"
    result = ''
    Flight.where(user: user).where('finish >= ?', DateTime.now).each do |flight|
      result += StringBuilder.id(flight.id, flight.aircraft, flight.legs) + "\n"
    end
    result ? result : 'There are no flights'
  end

  def self.is_today?(date_time)
    date_time.to_date == Date.today
  end
end
