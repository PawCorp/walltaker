class AddPornLizardsToUsersTable < ActiveRecord::Migration[7.0]
  def up
    ki = User.new({
                         username: 'PornLizardKi',
                         password: 'youcantloginaspornbotdoofus',
                         password_confirmation: 'youcantloginaspornbotdoofus',
                         email: 'ki@invalidemail.com',
                         details: "Latex is hufffff but dont be too weird ok? (slime though, thats not weird)",
                         admin: false
                       })

    puts "Made Ki" if ki.valid?
    puts "DID NOT make Ki. #{ki.errors.map {|error| error.full_message }.join(', ')}" unless ki.valid?

    ki.save


    warren = User.new({
                    username: 'PornLizardWarren',
                    password: 'youcantloginaspornbotdoofus',
                    password_confirmation: 'youcantloginaspornbotdoofus',
                    email: 'warren@invalidemail.com',
                    details: "HORSE COCK HORSE COCK HORSE COCK HORSE COCK HORSE COCK! I don't know what to put here lol. Not paid nearly enough to pick wallpapers for you pervs. FAT COCK FAT TITS PEACE OUT, going to go cum on my 6th big titty sex doll.",
                    admin: false
                  })

    puts "Made warren" if warren.valid?
    puts "DID NOT make warren. #{warren.errors.map {|error| error.full_message }.join(', ')}" unless warren.valid?

    warren.save


    taylor = User.new({
                        username: 'PornLizardTaylor',
                        password: 'youcantloginaspornbotdoofus',
                        password_confirmation: 'youcantloginaspornbotdoofus',
                        email: 'taylor@invalidemail.com',
                        details: "✨whats up people!✨<br/><h4>Welcome to my Walltaker Page!</h4><br/>Have a look at all the posts I've made to get a sense of my general vibe. It's a little bit cum slut, a little bit bad bitch. I'll set you up right~ 😈<br/><br/>(also like, you can plow my cunt no questions asked, just show me your Walltaker account if we meet sometime and my womb is all yours. 😽)",
                        admin: false
                      })

    puts "Made taylor" if taylor.valid?
    puts "DID NOT make taylor. #{taylor.errors.map {|error| error.full_message }.join(', ')}" unless taylor.valid?

    taylor.save
  end

  def down
    ki = User.find_by(username: 'PornLizardKi', admin: false)
    ki.delete if ki

    warren = User.find_by(username: 'PornLizardWarren', admin: false)
    warren.delete if warren

    taylor = User.find_by(username: 'PornLizardTaylor', admin: false)
    taylor.delete if taylor
  end
end
