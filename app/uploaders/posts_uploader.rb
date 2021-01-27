require "image_processing/mini_magick"
require "streamio-ffmpeg"

class PostsUploader < Shrine
  plugin :refresh_metadata
  plugin :backgrounding
  plugin :derivatives
  plugin :validation_helpers
  plugin :determine_mime_type
  IMAGE_TYPES = %w[image/jpeg image/png image/webp]
  VIDEO_TYPES = %w[video/mp4 video/quicktime video/MOV video/wmv]
  PDF_TYPES   = %w[application/pdf]


  Attacher.promote_block do |attacher|
    PromoteJob.perform_async(
      attacher.class.name,
      attacher.record.class.name,
      attacher.record.id,
      attacher.name,
      attacher.file_data,
    )
  end

  Attacher.destroy_block do |attacher|
    DestroyJob.perform_async(
      attacher.class.name,
      attacher.data,
    )
  end
 
  Attacher.validate do
    validate_mime_type IMAGE_TYPES + VIDEO_TYPES + PDF_TYPES
  end

  Attacher.derivatives do |original|
    case file.mime_type
    when *IMAGE_TYPES then process_derivatives(:image, original)
    when *VIDEO_TYPES then process_derivatives(:video, original)
    when *PDF_TYPES   then process_derivatives(:pdf,   original)
    end
  end
 
  Attacher.derivatives :image do |original|
    magick = ImageProcessing::MiniMagick.source(original)
    { 
      medium: magick.resize_to_limit!(650, 650)
    }
  end
 
  Attacher.derivatives :video do |original|
    transcoded = Tempfile.new ["transcoded", ".mp4"]
    screenshot = Tempfile.new ["screenshot", ".jpg"]
 
    movie = FFMPEG::Movie.new(original.path)
    movie.transcode(transcoded.path)
    movie.screenshot(screenshot.path)
    magick = ImageProcessing::MiniMagick.source(transcoded)
    transcoded = magick.resize_to_limit!(650, 650)
 
    { transcoded: transcoded, screenshot: screenshot }
  end
 
  Attacher.derivatives :pdf do |original|
    # ... 
  end

end