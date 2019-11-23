class StaticPagesController < ApplicationController

  def test
    flash.now[:danger] = "Test flash Test flash Test flash Test flash Test flash Test flash Test flash Test flash Test flash "
  end

end
