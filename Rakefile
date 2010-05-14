require "rubygems"
require "rake"

require "choctop"
require 'highline/import'

class ChocTop
  def user
    @user ||= ask("User for server please: ")
  end
end

ChocTop.new do |s|
  # Remote upload target (set host if not same as Info.plist['SUFeedURL'])
  s.remote_dir = '/home/mosphere/www/applications.huesler-informatik.ch/downloads/TweetScreen'
  # Custom DMG
  s.build_target = 'Release'
  s.background_file = "dmg.png"
  # s.app_icon_position = [100, 90]
  # s.applications_icon_position =  [400, 90]
  # s.volume_icon = "dmg.icns"
  # s.applications_icon = "appicon.icns" # or "appicon.png"
end