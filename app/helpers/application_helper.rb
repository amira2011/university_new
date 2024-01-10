module ApplicationHelper


    def session_link

        if ( current_user ) 
        
        link_to "logout", logout_path , method: :delete , :class => "nav-link "
        
        else 
        
         link_to('login', login_path , :class => "nav-link ")
        
        end 
    end

    
end
