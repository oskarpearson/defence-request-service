class CustodySuite::DefenceRequestsController < BaseController

  include DefenceRequestConcern

  before_action :find_defence_request, except: [:new, :create]

  before_action :authorise_action_access, except: [:create, :update]

  helper_method :custody_suite_defence_request_path_with_tab

  def show
    @defence_request_form = DefenceRequestForm.new(defence_request)
    @tab = tab_param_value(:tab)

    if @defence_request.draft?
      render :show_draft
    else
      render :show
    end
  end

  def new
    @defence_request_form = DefenceRequestForm.new(defence_request)
  end

  def create
    @defence_request_form = DefenceRequestForm.new(defence_request, defence_request_params)

    authorize_defence_request_access(:create, @defence_request_form.defence_request)

    if @defence_request_form.submit
      redirect_to([:custody_suite, @defence_request_form.defence_request], notice: flash_message(:create, DefenceRequestForm))
    else
      render :new
    end
  end

  def edit
    @defence_request_form = DefenceRequestForm.new(defence_request)
    @part = tab_param_value(:part)

    render edit_template
  end

  def update
    @defence_request_form = DefenceRequestForm.new(defence_request, defence_request_params)
    @part = tab_param_value(:part)

    authorize_defence_request_access(:edit, @defence_request_form.defence_request)

    if @defence_request_form.submit
      redirect_to(custody_suite_defence_request_path_with_tab(@part), notice: flash_message(:update, DefenceRequest))
    else
      render edit_template
    end
  end

  private

  def authorise_action_access
    authorize_defence_request_access(action_name)
  end

  def defence_request_id
    :id
  end

  def defence_request_params
    params.require(:defence_request).permit(
      :solicitor_name,
      :solicitor_firm,
      :solicitor_email,
      { solicitor: :email },
      :scheme,
      :phone_number,
      :detainee_name,
      :gender,
      :adult,
      { date_of_birth: %i[day month year] },
      :appropriate_adult,
      :appropriate_adult_reason,
      :interpreter_required,
      :interpreter_type,
      :detainee_address,
      :custody_number,
      :offences,
      :circumstances_of_arrest,
      :fit_for_interview,
      :unfit_for_interview_reason,
      :custody_address,
      :investigating_officer_name,
      :investigating_officer_shoulder_number,
      :investigating_officer_contact_number,
      :comments,
      { interview_start_time: %i[date hour min] },
      { time_of_arrival: %i[date hour min] },
      { time_of_arrest: %i[date hour min] },
      { time_of_detention_authorised: %i[date hour min] },
      :dscc_number,
      :reason_aborted,
      { solicitor_time_of_arrival: %i[date hour min] },
      :detainee_name_not_given,
      :detainee_address_not_given,
      :date_of_birth_not_given)
  end

  def accept_and_save_defence_request
    @defence_request.accept && @defence_request.save
  end

  def edit_template
    if @defence_request.draft?
      :edit_draft
    else
      :edit
    end
  end
  def tab_param_value(param_name)
    params[param_name] && %(interview case-details).include?(params[param_name]) ?  params[param_name] : nil
  end

  def custody_suite_defence_request_path_with_tab(tab)
    if tab.present?
      custody_suite_defence_request_path(tab: tab)
    else
      custody_suite_defence_request_path
    end
  end
end
