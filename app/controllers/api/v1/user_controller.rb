module Api
  module V1
    class UserController < V1Controller

      skip_before_action :verify_authenticity_token, :only => [:add_request, :answer_request]

      def show
        user = get_user(params[:id])
        if user
          if params[:relationships] == "true"
            user.get_relatives
          end
          answer(true, render_user(user, params[:study] == "true" ? true : false, params[:work] == "true" ? true : false))
        else
          not_found
        end
      end

      def edit
        @user = get_user(params[:id])
        # TODO test
        if @token_id.nil? == false && (@token_id == @user.id || @token_id == @user.owner_id)
          @pi   = @user.personal_info
          @user.studies.destroy_all
          @user.works.destroy_all

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

          # personal info save
          if params[:user] || params[:personal]
            if @user.update(user_params) && @pi.update(pi_params)
              answer(true, "Data save")
            else
              render json: @user.errors, status: :unprocessable_entity
            end
          else
            answer(false, "No data change")
          end
        else
          answer(false, "You not owner user")
        end
      end

      def change_login
        @user = get_user(params[:id])
        if @token_id.nil? == false && @token_id == @user.id
          if params['type']
            if params['type'] == 'email'
              if params['old_email'] == @user.email && params['new_email']
                if User.find_by_email(params['new_email'])
                  answer(false, 'Email already use')
                else
                  @user.generate_code(1, params['new_email'])
                  answer(true, "challenge_login")
                end
              else
                wrong_params(['email'])
              end
            else
              if params['type'] == 'phone'
                if params['old_phone'].to_i == @user.tel && params['new_phone']
                  if User.find_by_tel(params['new_phone'])
                    answer(false, 'Number already use')
                  else
                    @user.generate_code(2, params['new_phone'])
                    answer(true, "challenge_login")
                  end
                else
                  wrong_params(['phone'])
                end
              else
                wrong_params
              end
            end
          else
            wrong_params
          end
        else
          answer(false, "You not owner user")
        end
      end

      def challenge_login
        @user = get_user(params[:id])
        if @token_id.nil? == false && @token_id == @user.id
          if @user.time_code >= Time.now
            if params[:code] == @user.code
              if @user.code_type == 1
                @user.email = @user.new_value
                @user.new_value = nil
                @user.save
              end
              if @user.code_type == 2
                @user.tel = @user.new_value
                @user.new_value = nil
                @user.save
              end
              answer(true, "Data save")
            else
              answer(false, "Invalide code")
            end
          else
            answer(false, "Code time out")
          end
        end
      end

      def get_inbox_request
        rel = RelationshipRequest.where('user2_id=?', @token_id)
        inbox = []
        rel.each do |user|
            pi = User.find_by_id(user.user1_id).personal_info
            pi.user   = user.user2_id
            inbox.push({
              'id' => user.id,
              'created_at' => user.created_at,
              'updated_at' => user.updated_at,
              'status' => user.status,
              'type' => user.type1.id,
              'user' => pi.as_json(
                :methods => [:user],
                :except => [:created_at, :updated_at, :country, :city, :address, :hobbies]
            )})
        end
        rel.each do |request|
          request.status = 1
          request.save
        end
        answer(true, inbox)
      end

      def get_outbox_request
        rel = RelationshipRequest.where('user1_id=?', @token_id)
        outbox = []
        rel.each do |user|
          pi = User.find_by_id(user.user2_id).personal_info
          pi.user   = user.user2_id
          outbox.push({'status' => user.status, 'type' => user.type2.name, 'user' => pi.as_json(
              :methods => [:user],
              :except => [:created_at, :updated_at, :id, :country, :city, :address, :hobbies]
          )})
        end
        answer(true, outbox)
      end

      def search
        if params[:phone]
          user = User.includes(:personal_info).find_by_tel(params[:phone])
          answer(true, render_user(user))
        elsif params[:lastname]
          search_param = params.permit(:lastname, :firstname, :secondname)
          pi = PersonalInfo.select(:id).where(search_param)
          if pi
            users = User.where(:personal_info_id => pi)
            answer(true, render_user(users))
          else
            answer(true, [])
          end
        else
          wrong_params
        end
      end

      def add_request
        if params[:phone] && params[:type]
          type = RelationshipType.find_by_id(params[:type])
          if type
            user = User.find_by_tel(params[:phone])
            if user
              if user.id == @token_id
                answer(false, "It's you")
              else
                if user.check_relationship(@token_id)
                  answer(false, "You already in relationship")
                else
                  if user.check_relationship_request(@token_id)
                    answer(false, "You has relationship request")
                  else
                    @request = RelationshipRequest.new(:user1_id => @token_id, :user2_id => user.id, :type1_id => params[:type], :type2_id => type.ratio)
                    # render json: @request
                    if @request.save
                      answer(true, "saved")
                    else
                      render json: @request.errors
                    end
                  end
                end
              end
            elsif params[:personal] && params[:personal[:gender]] && pi_params
              pi = PersonalInfo.new(pi_params)
              if pi.save
                user = User.new(:tel => params[:phone], :personal_info_id => pi.id, :owner_id => @token_id, :is_user => 0)
                if user.save
                  @request = RelationshipRequest.new(:user1_id => @token_id, :user2_id => user.id, :type1_id => params[:type], :type2_id => type.ratio)
                  # render json: @request
                  if @request.save
                    answer(true, "saved")
                  else
                    render json: @request.errors
                  end
                else
                  render json: user.errors
                end
              else
                render json: pi.errors
              end
            else
              wrong_params(['personal'])
            end
          else
            wrong_params(['type'])
          end
        else
          wrong_params(['phone', 'type'])
        end
      end

      def answer_request
        if params[:id] && params[:type] && (params[:type].to_i == 2 || params[:type].to_i == 3)
          @user = get_user(@token_id)
          if @user
            @request = RelationshipRequest.where('user2_id=? AND id=?', @user.id, params[:id]).take
            if @request
              if @request.status == 0 || @request.status == 1
                saved_rel = true
                if params[:type].to_i == 2
                  @relation = Relationship.new(
                      :user1_id => @request.user1_id,
                      :user2_id => @request.user2_id,
                      :type1_id => @request.type1_id,
                      :type2_id => @request.type1_id)
                  if @relation.save
                    saved_rel
                  else
                    !saved_rel
                    answer(false, @relation.errors)
                  end
                end

                if saved_rel
                  @request.status = params[:type]
                  if @request.save
                    answer(true, "saved")
                  else
                    answer(false, @request.errors)
                  end
                end
              else
                answer(false, "Relationship already done")
              end
            else
              answer(false, "Relationship not found")
            end
          else
            not_found
          end
        else
          wrong_params
        end
      end

      def get_groups
        gu = GroupUser.where('user_id=?', @token_id)

        groups = []
        gu.each do |user|
          group = Group.find_by_id(user.group_id)
          if params[:users] == "true"
            group.get_users
          end
          if params[:feed] == "true"
            group.get_feed
          end
          groups.push(render_group(group))
        end
        answer(true, groups)
      end

      private
      # Получаем пользователя из базы
      def get_user(id)
        User.includes(:studies).find_by_id(id)
      end

      def not_found
        answer(false, "User not found")
      end

      def render_user(user, study = false, work = false)
        include = [:personal_info => {:except => [:created_at, :updated_at, :id]}]
        if study
          include.push(:studies => {:except => [:created_at, :updated_at, :user_id]})
        end
        if work
          include.push(:works => {:except => [:created_at, :updated_at, :user_id]})
        end
        user.as_json(
            :include => include,
            :methods => [:relationships],
            :except => [:token, :time_token, :code, :time_code, :personal_info_id, :created_at, :updated_at, :id, :is_user, :is_reg, :code_type, :new_value]
        )
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
      ############
    end
  end
end
