class AudiosController < ApplicationController
  include ActionController::StationResources
  include CommonContents

  def show
    respond_to do |format|
      format.all {
        send_data audio.__send__(:current_data),
                  :filename => audio.filename,
                  :type => audio.content_type,
                  :disposition => audio.class.resource_options[:disposition].to_s
      }

      format.__send__(audio.mime_type.to_sym) {
        send_data audio.__send__(:current_data),
                  :filename => audio.filename,
                  :type => audio.content_type,
                  :disposition => audio.class.resource_options[:disposition].to_s
      }


      format.html # show.html.erb
      format.flv { 
        send_data audio.current_data_flv, :filename => audio.filename_flv
      }
    end
  end

end
