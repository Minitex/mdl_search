class UvController < ApplicationController
  def iframe
    render template: 'uv/iframe', layout: false
  end
end
