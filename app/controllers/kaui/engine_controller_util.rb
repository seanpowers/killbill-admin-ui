module Kaui::EngineControllerUtil

  protected

  def get_layout
    layout ||= Kaui.config[:layout]
  end

  def as_string(e)
    if e.is_a?(KillBillClient::API::ResponseError)
      "Error #{e.response.code}: #{as_string_from_response(e.response.body)}"
    else
      e.message
    end
  end

  def as_string_from_response(response)
    error_message = response
    begin
      # BillingExceptionJson?
      error_message = JSON.parse response
    rescue => e
    end

    if error_message.respond_to? :[] and error_message['message'].present?
      # Likely BillingExceptionJson
      error_message = error_message['message']
    end
    # Limit the error size to avoid ActionDispatch::Cookies::CookieOverflow
    error_message[0..1000]
  end

end