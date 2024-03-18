class ApplicationController < ActionController::Base



    protect_from_forgery with: :exception   
  
    private   
  def current_user   
    Student.where(id: session[:student_id]).first  
  end  
  
  
  helper_method :current_user   



     
end
