require "#{Rails.root}/app/helpers/application_helper"
include ApplicationHelper

namespace :walltaker do
  task porn_bot_round: :environment do
    pornbot = User.find_by(username: 'PornBot')

    unless pornbot
      puts "PornBot is missing! The account could not be found, are migrations run correctly?"
      return
    end

    puts "PornBot has awoken"
    links = Link.with_ability_to('can_be_set_by_porn_bot').all

    puts "Found #{links.count} links to set this round"

    set_count = 0

    links.each do |link|
      controller = ApplicationController.new
      results = controller.get_tag_results 'order:random score:>100', nil, nil, link, 1
      if results[0]
        result = link.update(
          HashWithIndifferentAccess.new(
            {
              post_url: results[0]['file']['url'],
              post_thumbnail_url: results[0]['preview']['url'],
              post_description: results[0]['description'],
              set_by_id: pornbot.id,
              response_type: nil,
              response_text: nil
            }
          )
        )

        if result
          set_count += 1
          PastLink.log_link(link).save
          pornbot.set_count = pornbot.set_count.to_i + 1
          pornbot.save
        end
      end
    end

    puts "Done! Set #{set_count} links in the end"
  end
end
