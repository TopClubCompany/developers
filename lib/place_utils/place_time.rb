module PlaceUtils
  class PlaceTime
    class << self
      def find_available_time(i, time, array_time)
        if I18n.locale.to_sym == :en
          {:time => (time + i.minutes).strftime("%l:%M %p").sub(/^ /,''), :available => is_available?(time+i.minutes, array_time)}
        else
          {:time => (time + i.minutes).strftime("%H:%M"), :available => is_available?(time+i.minutes, array_time)}
        end
      end

      def is_available?(time, range_time)
        if range_time
          range_time.include?(time.strftime("%H").to_i)
        else
          false
        end
      end

      def wday wday
        case wday
          when 0
            7
          else
            wday
        end
      end
    end
  end
end
