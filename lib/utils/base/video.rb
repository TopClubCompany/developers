# -*- encoding : utf-8 -*-
module Utils
  module Base
    module Video
      extend self

      def convert(path_from, path_to, options={})
        video = WebVideo::Adapters::FfmpegAdapter.new(path_from)
        resolution = video.streams.detect { |s| s.video? }.try(:resolution) || "480x360"
        options = {:resolution => resolution}.update(options)
        opts = options.delete(:command) || {}
        opts.reverse_merge!(:vcodec => 'mp4')


        transcoder = WebVideo::Transcoder.new(video)

        begin
          transcoder.convert(path_to, options) do |command|
            #command << "-ar 22050"
            #command << "-ab 128k"
            #command << "-acodec libmp3lame"
            command << "-vcodec #{opts[:vcodec]}"
            #command << "-r 25"
            command << "-y"
          end
        rescue WebVideo::CommandLineError => e
          WebVideo.logger.error("Unable to transcode video: #{e.class} - #{e.message}")
        end
      end

    end
  end
end
