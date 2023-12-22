namespace :walltaker do
  task porn_bot_round: :environment do
    pornbot = User.find_by(username: 'PornBot')

    unless pornbot
      puts "PornBot is missing! The account could not be found, are migrations run correctly?"
      return
    end

    puts "PornBot has awoken"
    links = Link.with_ability_to('can_be_set_by_porn_bot').is_online.order(Arel.sql('RANDOM()')).limit(60)

    puts "Found #{links.count} links to set this round"

    set_count = 0

    links.each do |link|
      controller = ApplicationController.new
      results = controller.get_tag_results 'order:random score:>100 -nightmare_fuel -nazi rating:e', nil, nil, link, 1
      begin
        if results[0] && results[0]['file']['url']
          result = link.update(
            HashWithIndifferentAccess.new(
              {
                post_url: results[0]['file']['url'],
                post_thumbnail_url: results[0]['sample']['url'] || results[0]['preview']['url'],
                post_description: results[0]['description'],
                set_by_id: pornbot.id,
                response_type: nil,
                response_text: nil
              }
            )
          )

          if result
            puts "Set link_id=#{link.id} to #{results[0]['file']['url']}"
            set_count += 1
            PastLink.log_link(link).save
            pornbot.set_count = pornbot.set_count.to_i + 1
            pornbot.save
          end
        end
      rescue
        puts "bad post selected, moving on"
      end
      sleep(1.second)
    end

    puts "Done! Set #{set_count} links in the end"
  end

  task ki_round: :environment do
    pornbot = User.find_by(username: 'PornLizardKi')

    unless pornbot
      puts "Ki is missing! The account could not be found, are migrations run correctly?"
      return
    end

    puts "Ki has awoken"
    links = Link.with_ability_to('can_be_set_by_lizard').is_online.joins(:user).where(user: { mascot: 'ki' }).order(Arel.sql('RANDOM()')).limit(20)

    puts "Found #{links.count} links to set this round"

    set_count = 0

    links.each do |link|
      is_user_perverted = link.user.pervert

      tags = '~massage romantic ~embrace ~cuddle ~hug ~hand_holding score:>90' unless is_user_perverted
      tags = '~latex ~rubber glistening_body ~bdsm ~goo_creature ~slime score:>50' if is_user_perverted

      controller = ApplicationController.new
      results = controller.get_tag_results "order:random #{tags} -nightmare_fuel", nil, nil, link, 1
      begin
        if results[0] && results[0]['file']['url']
          result = link.update(
            HashWithIndifferentAccess.new(
              {
                post_url: results[0]['file']['url'],
                post_thumbnail_url: results[0]['sample']['url'] || results[0]['preview']['url'],
                post_description: results[0]['description'],
                set_by_id: pornbot.id,
                response_type: nil,
                response_text: nil
              }
            )
          )

          if result
            puts "Set link_id=#{link.id} to #{results[0]['file']['url']}"
            set_count += 1
            PastLink.log_link(link).save
            pornbot.set_count = pornbot.set_count.to_i + 1
            pornbot.save
          end
        end
      rescue
        puts "bad post selected, moving on"
      end
      sleep(1.second)
    end

    puts "Done! Set #{set_count} links in the end"
  end

  task warren_round: :environment do
    pornbot = User.find_by(username: 'PornLizardWarren')

    unless pornbot
      puts "Warren is missing! The account could not be found, are migrations run correctly?"
      return
    end

    puts "Warren has awoken"
    links = Link.with_ability_to('can_be_set_by_lizard').is_online.joins(:user).where(user: { mascot: 'warren' }).order(Arel.sql('RANDOM()')).limit(20)

    puts "Found #{links.count} links to set this round"

    set_count = 0

    links.each do |link|
      is_user_perverted = link.user.pervert

      tags = '~big_penis ~big_balls close_up ~big_breasts ~plump_labia ~crotch_shot -obese -hyper ~huge_balls score:>50' unless is_user_perverted
      tags = 'hyper ~huge_breasts ~huge_penis ~himbo ~bimbofication ~horsecock ~hyper_breasts ~udders -obese score:>70' if is_user_perverted

      controller = ApplicationController.new
      results = controller.get_tag_results "order:random #{tags} -nightmare_fuel", nil, nil, link, 1
      begin
        if results[0] && results[0]['file']['url']
          result = link.update(
            HashWithIndifferentAccess.new(
              {
                post_url: results[0]['file']['url'],
                post_thumbnail_url: results[0]['sample']['url'] || results[0]['preview']['url'],
                post_description: results[0]['description'],
                set_by_id: pornbot.id,
                response_type: nil,
                response_text: nil
              }
            )
          )

          if result
            puts "Set link_id=#{link.id} to #{results[0]['file']['url']}"
            set_count += 1
            PastLink.log_link(link).save
            pornbot.set_count = pornbot.set_count.to_i + 1
            pornbot.save
          end
        end

      rescue
        puts "bad post selected, moving on"
      end
      sleep(1.second)
    end

    puts "Done! Set #{set_count} links in the end"
  end

  task taylor_round: :environment do
    pornbot = User.find_by(username: 'PornLizardTaylor')

    unless pornbot
      puts "Taylor is missing! The account could not be found, are migrations run correctly?"
      return
    end

    puts "Taylor has awoken"
    links = Link.with_ability_to('can_be_set_by_lizard').is_online.joins(:user).where(user: { mascot: 'taylor' }).order(Arel.sql('RANDOM()')).limit(20)

    puts "Found #{links.count} links to set this round"

    set_count = 0

    links.each do |link|
      is_user_perverted = link.user.pervert

      tags = 'public ~public_sex ~penis_milking ~public_masturbation ~free_use ~leaking_cum ~cum_on_face ~cum_on_butt ~cum_on_clothing score:>100' unless is_user_perverted
      tags = '~impregnation ~impregnation_request excessive_cum ~presenting_hindquarters ~cum_in_pussy ~cum_in_ass ~cum_pool score:>80' if is_user_perverted

      controller = ApplicationController.new
      results = controller.get_tag_results "order:random #{tags} -nightmare_fuel", nil, nil, link, 1
      begin
        if results[0] && results[0]['file']['url']
          result = link.update(
            HashWithIndifferentAccess.new(
              {
                post_url: results[0]['file']['url'],
                post_thumbnail_url: results[0]['sample']['url'] || results[0]['preview']['url'],
                post_description: results[0]['description'],
                set_by_id: pornbot.id,
                response_type: nil,
                response_text: nil
              }
            )
          )

          if result
            puts "Set link_id=#{link.id} to #{results[0]['file']['url']}"
            set_count += 1
            PastLink.log_link(link).save
            pornbot.set_count = pornbot.set_count.to_i + 1
            pornbot.save
          end
        end
      rescue
        puts "bad post selected, moving on"
      end
      sleep(1.second)
    end

    puts "Done! Set #{set_count} links in the end"
  end
end
