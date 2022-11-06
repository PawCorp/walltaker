class AddPornbotToUsersTable < ActiveRecord::Migration[7.0]
  def up
    pornbot = User.new({
                         username: 'PornBot',
                         password: 'youcantloginaspornbotdoofus',
                         password_confirmation: 'youcantloginaspornbotdoofus',
                         email: 'fake@email.com',
                         details: "<h3>I am a horny robot 🤖</h3>\nWallpapers set by me are selected at random. I try to keep high standards, but sometimes I don't pick great wallpapers. Please don't yell at me, even though my heart is a panametric transreactive retroencabulator, I still feel pain.\n\n<strong>ℹ️ You can toggle if I can set wallpapers on your links under the Abilities section on your link settings.</strong>",
                         admin: true
                       })

    puts "Made admin user PornBot" if pornbot.valid?
    puts "DID NOT make admin user PornBot. #{pornbot.errors.map {|error| error.full_message }.join(', ')}" unless pornbot.valid?

    pornbot.save
  end

  def down
    pornbot = User.find_by(username: 'PornBot', admin: true)
    pornbot.delete if pornbot

    puts "Deleted admin user PornBot" if pornbot
    puts "Could not find an admin user named PornBot to delete, moving on" unless pornbot
  end
end
