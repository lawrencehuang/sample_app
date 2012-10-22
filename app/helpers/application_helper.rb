module ApplicationHelper

  # return a title on a per-page basis
  def title 
    base_title = "Rails Adventure "
    if @title.nil?
      base_title
    else
      "#{base_title} | #{@title}"
    end
  end

  # use 'content_for'' to save ':title' block, and use it with 'yield' in other layouts. Find this in Railscasts.
#  def title(page_title)
#    content_for(:title) {  page_title }
#  end
end
