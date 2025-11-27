class Article < ApplicationRecord

  def formatted_content
    sentences = text.split(/(?<=[.!?])\s*/)
    grouped = sentences.each_slice(3).map { |slice| slice.join(' ') }
    grouped.map { |g| "<p>#{g.strip}</p>" }.join.html_safe
  end

end
