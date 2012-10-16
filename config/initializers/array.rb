class Array
  def avg
    result = inject{ |sum, el| sum + el}.to_f / length
    result.nan? ? 0 : result
  end
end