class Exception
  def hint
    "#{self.class}: #{message}\n" \
    "from #{backtrace.first}"
  end
end
