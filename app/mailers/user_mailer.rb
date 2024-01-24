class UserMailer < ApplicationMailer
    def welcome_email(student)
        @student = student
        mail(to: @student.email, subject: 'Welcome to My Email App')
      end
end
