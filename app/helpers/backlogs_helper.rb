module BacklogsHelper

  def class_color(min, avg, max, num_sprints, cumulative_sum)
    cumulative_sum = cumulative_sum.to_i

    min = min * num_sprints
    avg = avg * num_sprints
    max = max * num_sprints

    if cumulative_sum <= min
      return 'green_tr'
    elsif cumulative_sum <= avg
      return 'light_green_tr'
    elsif cumulative_sum <= max
      return 'yellow_tr'
    else
      return 'red_tr'
    end
  end

end
