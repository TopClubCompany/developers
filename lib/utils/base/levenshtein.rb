module Utils
  module Base
    module Levenshtein
      def self.distance(s1, s2)
        s = s1.unpack('U*')
        t = s2.unpack('U*')
        m = s.length
        n = t.length

        # matrix initialization
        d = []
        0.upto(m) { |i| d << [i] }
        0.upto(n) { |j| d[0][j] = j }

        # distance computation
        1.upto(m) do |i|
          1.upto(n) do |j|
            cost = s[i] == t[j] ? 0 : 1
            d[i][j] = [
                d[i-1][j] + 1,      # deletion
                d[i][j-1] + 1,      # insertion
                d[i-1][j-1] + cost, # substitution
            ].min
          end
        end

        # all done
        return d[m][n]
      end

      def self.distance_in_procents(s1, s2)
        distance_size = self.distance(s1, s2)
        s = s1.unpack('U*')
        t = s2.unpack('U*')
        m = s.length
        n = t.length
        if m.zero?
          if s1.length.zero?
            100
          else
            0
          end
        else

          if distance_size.zero?
            100
          else
            if n > m
              (distance_size - n).to_f/n*100
            else
              (distance_size - m).to_f/m*100
            end #((m - distance_size).to_f/m * 100  + (n - distance_size).to_f/n*100)/2
          end
        end
      end

    end
  end
end