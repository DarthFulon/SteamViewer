class WelcomeController < ApplicationController

  def make_uid_string freinds
    result = ""
    freinds.each do |f|
      result += (f["steamid"].to_str + ",")
    end
    result[0..result.length-1]
    return result
  end
  def news

    url = "http://api.steampowered.com/ISteamNews/GetNewsForApp/v0002/?appid=440&count=3&maxlength=300&format=json"
    uri = URI.parse(url)
    response = Net::HTTP::get(uri)
    result = JSON.load(response)["appnews"]["newsitems"]|| []
    p result
    result.each do |res|
      @news << {:title => res["title"], :news => res["contents"].html_safe, :url => res["url"]}   
    end
  end
  def index
    @news = []
    @app_name = "Team Fortress 2"
    @friends = Array.new
    @max_freinds_to_show = 2
    if session.key? :current_user
      url = "http://api.steampowered.com/ISteamUser/GetFriendList/v0001/?key=#{ENV['STEAM_WEB_API_KEY']}&steamid=#{session[:current_user][:uid]}&relationship=friend"
      uri = URI.parse(url)
      response = Net::HTTP::get(uri)
      friends_uids = JSON.load(response)["friendslist"]["friends"] || []
      url = "http://api.steampowered.com/ISteamUser/GetPlayerSummaries/v0002/?key=#{ENV['STEAM_WEB_API_KEY']}&steamids=#{make_uid_string(friends_uids)}"
      uri = URI.parse(url)
      response = Net::HTTP::get(uri)
      result = JSON.load(response)["response"]["players"]
      result.each do |res|
        @friends << {:friendnick => res["personaname"], :friendavatar => res["avatar"], :personastate => res["personastate"]}
      end
    end
  end

end
