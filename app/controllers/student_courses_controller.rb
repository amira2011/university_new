class StudentCoursesController < ApplicationController


    def create

        course_to_add= Course.find(params[:course_id])
        StudentCourse.create(course: course_to_add, student: current_user)
        flash[:notice]="Your have Successfully enrolled in #{course_to_add.name}"
        redirect_to courses_path
    end

    def enrolled
        @sc= StudentCourse.includes(:student, :course)
    end

end