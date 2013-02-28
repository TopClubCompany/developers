module Utils
  class LetterParser

    class << self

      def parse_params opts={}
        letter_id = opts.delete(:letter_type)
        letter = Letter.with_kind(letter_id).first
        content = letter.content
        topic = letter.topic
        if letter
          opts.each do |key, value|
            content = content.gsub("{#{key.to_s}}", value.to_s) if content.present?
            topic = topic.gsub("{#{key.to_s}}", value.to_s) if topic.present?
          end
        end
        [content, topic]
      end
    end
  end
end