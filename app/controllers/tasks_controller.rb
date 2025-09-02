require "json"
require "open-uri"

class TasksController < ApplicationController
  def random
    url = "https://bored.api.lewagon.com/api/activity"
    activity_serialized = URI.parse(url).read
    activity = JSON.parse(activity_serialized)
  end
end
