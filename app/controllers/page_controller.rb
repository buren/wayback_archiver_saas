class PageController < ApplicationController
  def home
    @archivation = Archivation.new(strategy: :auto)
  end
end
