require 'ostruct'

module ControllerMethods
  def request
    OpenStruct.new(raw_post: "", headers: {})
  end

  def head(*args)
  end
end
