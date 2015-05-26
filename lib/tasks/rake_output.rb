module RakeOutput
  extend self

  def finish(task_message)
    puts "#{task_message} finished at #{I18n.localize(Time.current, format: :full)}"
  end

  def succeed(task_message)
    puts "#{task_message} succeeded at #{I18n.localize(Time.current, format: :full)}"
  end

  def fail(task_message)
    puts "#{task_message} failed at #{I18n.localize(Time.current, format: :full)}".colorize(:red)
  end
end
