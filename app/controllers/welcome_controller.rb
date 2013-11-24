class WelcomeController < ApplicationController
  def index
  end
  def auth_callback
    auth = request.env['omniauth.auth']
    session[:current_user] = { :nickname => auth.info['nickname'],
                                          :image => auth.info['image'],
                                          :uid => auth.uid }
    url = "http://api.steampowered.com/ISteamUser/GetPlayerSummaries/v0002/?key=" + ENV["STEAM_WEB_API_KEY"] + "&steamids=" + auth.uid
    uri = URI(url)
    response = Net::HTTP.get_response(uri)
    result = JSON.parse(response.body)
    redirect_to root_url
  end
end
