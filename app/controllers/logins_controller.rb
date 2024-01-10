class LoginsController < ApplicationController

def new

end

def create

    student= Student.find_by(email: params[:logins][:email].downcase)
    if student && student.authenticate(params[:logins][:password])

        session[:student_id]=student.id
       
        
        flash[:notice]="Your have Successfully Logged in"
        redirect_to  courses_path

    else
       flash.now[:notice]="Something was wrong with your information"
       render 'new' 
    end

end

def destroy
   session[:student_id]=nil
   flash[:notice]="Your have Successfully Logged Out"
   redirect_to root_path
end


end