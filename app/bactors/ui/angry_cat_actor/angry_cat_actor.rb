class Ui::AngryCatActor::AngryCatActor
  UNIT_ID = 1
  EXT_BY_CONTENT_TYPE = {
    "image/jpeg": "jpg",
    "image/jpg": "jpg",
    "image/png": "png",
    "image/gif": "gif",
    "video/mp4": "mp4"
  }
  def upload_chunk(inputs)
    chunk            = inputs.fetch('chunk')
    is_end           = inputs.fetch('isEnd')
    sequence_num     = inputs.fetch('sequenceNum')
    file_chunks_size = inputs.fetch('fileChunksSize')
    file_path        = Pathname.new("#{Dir.home}/queue_chunks/#{UNIT_ID}.json")
    type             = inputs.fetch('type')
    File.open(file_path, "a") { |f| f.write({sequenceNum: sequence_num,chunk: chunk}.to_json + "\n") }
    percent = ((sequence_num.to_f / file_chunks_size.to_f) * 100).round
    
    if is_end
      lines = File.readlines(file_path)
      chunks = lines.map { |line| JSON.parse(line) }
      chunks.sort_by! { |chunk| chunk.dig("sequenceNum") }
      unit_path = Pathname.new("#{Dir.home}/queue_us/unit_#{UNIT_ID}.#{EXT_BY_CONTENT_TYPE.dig(type.to_sym)}")
      File.open(unit_path, "wb") do |f|
        chunks.each{ |chunk| f.write(chunk.dig("chunk").pack("C*")) }
      end
      File.delete(file_path)
      return { ok: true, message: "File Delivered", outputs: { percent: 100, isEnd: is_end } }
    else
      return { ok: true, message: "Chunk uploaded", outputs: { percent: percent, isEnd: is_end } }
    end
  end
end