class StudentsController < ApplicationController

def index
@students= Student.all
end

def new

@student= Student.new


end

def show

    @student= Student.find(params[:id])
end


def edit

@student= Student.find(params[:id])
end


def update

    @student= Student.find(params[:id])
    if @student.update(student_params)
        redirect_to student_path(@student)
    else 
        render 'edit'
    end

end


def delete


end


def destroy
    @student= Student.find(params[:id])
    if  @student.destroy
        redirect_to students_path
    end

end

def create
 
@student= Student.new(student_params)
    if @student.save 
        flash[:success]="You have Successfully Signed Up"
        redirect_to root_path

     else
        render 'new', status: :unprocessable_entity
     end   
end

private

def student_params

    params.require(:student).permit(:name, :email, :password)

end


end