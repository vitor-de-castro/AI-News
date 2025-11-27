  module ArticlesHelper
  def paragraphs_every_3_sentences(text)
    return "" if text.blank?

    sentences = text.split(/(?<=[.!?])\s+/) # coupe après ., !, ?

    groups = sentences.each_slice(3).map do |group|
      "<p>#{group.join(' ')}</p>"
    end

    groups.join("\n").html_safe
  end
end
