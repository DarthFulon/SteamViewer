class WelcomeController < ApplicationController
  def index
    @friends = []
    if session.key? :current_user
      url = "http://api.steampowered.com/ISteamUser/GetFriendList/v0001/?key=#{ENV['STEAM_WEB_API_KEY']}&steamid=#{session[:current_user][:uid]}&relationship=friend"
      uri = URI.parse(url)
      response = Net::HTTP::get(uri)
      @friends = JSON.load(response)["friendslist"]["friends"] || []
    end
  end
  def auth_callback
    auth = request.env['omniauth.auth']
    session[:current_user] = { :nickname => auth.info['nickname'],
                                          :image => auth.info['image'],
                                          :uid => auth.uid }
    redirect_to root_url
  end
end
