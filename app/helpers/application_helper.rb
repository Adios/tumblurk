# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def logged_in?
    return true if session[:user_id]
    nil
  end
  
  def post_type args
    a = [nil, 'text', 'photo', 'link', 'blurk', 'audio', 'video']
    if args.class == String
      a.index(args)
    elsif args.class == Fixnum
      a.at(args)
    end
  end
end
