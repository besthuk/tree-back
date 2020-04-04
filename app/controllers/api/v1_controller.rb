module Api
  class V1Controller < ApplicationController
    # TODO test
    before_action :authenticate, except: [:login, :challenge_required]
    include ActionController::HttpAuthentication::Token::ControllerMethods

    skip_before_action :verify_authenticity_token, :only => [:login, :challenge_required, :register]

    def login
      login = params[:login]
      if login
        @user = User.find_by_tel(login)

        if @user
          if @user.time_code.nil? || @user.time_code < Time.now
            @user.generate_code(0)
            answer(true, "challenge_required")
          end
        else
          if login.to_i.is_a? Integer
            @pi = PersonalInfo.new
            if @pi.save
              @user = User.new(:tel => login, :is_user => 1, :personal_info => @pi)
              if @user.save
                @user.generate_code(0)
                answer(true, "challenge_required")
              else
                render json: answer(false, @user.errors), status: :unprocessable_entity
              end
            else
              render json: answer(false, @pi.errors), status: :unprocessable_entity
            end
          else
            answer(false, login.to_i.is_a?)
          end
        end
      else
        answer(false, 'Login not found')
      end
    end

    def challenge_required
      if params[:login]
        @user = User.find_by_tel(params[:login])
      end
      if @user
        if @user.time_code >= Time.now
          if params[:code].to_i.is_a? Integer
            if params[:code].to_i == @user.code
              answer(true, {"token" =>  @user.generate_token, "user_id" => @user.id})
            else
              answer(false, "Invalide code")
            end
          else
            answer(false, "Invalide code")
          end
        else
          answer(false, "Code time out")
        end
      else
        answer(false, "User not exist")
      end
    end

    def register
      if params[:id]
        @user = User.find_by_id(params[:id])
        @pi   = @user.personal_info
        if @token_id.nil? == false && (@token_id == @user.id)
         if   params[:personal] &&
              params[:personal][:firstname] && (params[:personal][:firstname].is_a? String) &&
              params[:personal][:secondname] && (params[:personal][:secondname].is_a? String) &&
              params[:personal][:gender] && (params[:personal][:gender].to_i.is_a? Integer) &&
              params[:user] &&
              params[:user][:email] && (params[:user][:email].is_a? String)

                # study save
                if params[:study]
                  study = params[:study]
                  study.each do |study|
                    if study[:name]
                      model = Study.new(study_params(study))
                      model.user = @user
                      model.save
                    end
                  end
                end
                # work save
                if params[:work]
                  study = params[:work]
                  study.each do |work|
                    if work[:name]
                      model = Work.new(work_params(work))
                      model.user = @user
                      model.save
                    end
                  end
                end

                if @user.update(user_params) && @pi.update(pi_params)
                  @user.update(:is_reg => 1)
                  answer(true, "Data save")
                else
                  render json: @user.errors, status: :unprocessable_entity
                end
         else
           answer(false, "Not all required fields are filled")
         end
        else
          answer(false, "Not you login")
        end
      else
        answer(false, "Not have id")
      end

    end

    private
    def answer(ok, data)
      (ok == true) ?
          (render json: {"ok" => ok, "data" => data}) :
          (render json: {"ok" => ok, "error" => data})
    end

    def wrong_params(params = nil)
      text = "Wrong parameters"
      if params
        params_text = ""
        params.each do |param|
          params_text += params_text == "" ? param : ", " + param
        end
        text += ": " + params_text
      end
      answer(false, text)
    end

    def user_params
      params.require(:user).permit(:email)
    end
    def pi_params
      params.require(:personal).permit(:firstname, :secondname, :lastname, :gender, :dob, :country, :city, :address, :hobbies)
    end

    def study_params(study)
      study.permit(:name)
    end
    def work_params(study)
      study.permit(:name)
    end

    def authenticate
      authenticate_or_request_with_http_token do |token, options|
        user =  User.select(:id, :is_reg).where("token = ?", token).take
        if user.is_reg == 0 && params[:action] != "register"
          answer(false, "Need register")
        end
        @token_id = user.id
      end
    end

  end
end
