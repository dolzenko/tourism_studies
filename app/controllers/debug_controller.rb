class DebugController < ApplicationController
  def test
    r Rails.public_path
  end
end
