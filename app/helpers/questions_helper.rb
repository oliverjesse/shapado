module QuestionsHelper
  def microblogging_message(question)
    message = "#{h(question.title)}"
    message += " "
    message += question_path(current_category, question, :only_path =>false)
    message
  end

  def share_url(question, service)
    url = ""
    case service
      when :twitter
        url = "http://twitter.com/?status=#{microblogging_message(question)}"
      when :identica
        url = "http://identi.ca/notice/new?status_textarea=#{microblogging_message(question)}"
      when :facebook
        url = "http://www.facebook.com/sharer.php?u=#{question_path(current_category, question, :only_path =>false)}&t=TEXTO"
    end
    URI.escape(url)
  end
end
